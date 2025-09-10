use anyhow::Result;
use clap::{Parser, ValueEnum};
use indicatif::ProgressStyle;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;
use std::collections::HashMap;
use duct::cmd;
use tera::{Context, Tera, Value};
use sha2::{Digest, Sha256};
use chrono::{DateTime, Utc};
use futures_util::StreamExt;

mod cli;

#[derive(Debug, Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
struct Asset {
    url: String,
    download_count: i64,
    name: String,
    size: i64,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
struct Release {
    repo_name: String,
    tag_name: String,
    name: String,
    published_at: DateTime<Utc>,
    url: String,
    assets: Vec<Asset>,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
#[serde(rename_all = "camelCase")]
struct Project {
    owner: String,
    name: String,
    description: String,
    url: String,
    license: String,
    ignore_fetch_release: Option<bool>,
}

impl Project {
    fn is_match_repo(&self, repo_name: &str) -> bool {
        self.repo_name() == repo_name
    }

    pub fn ignore_fetch_release(&self) -> bool {
        self.ignore_fetch_release.unwrap_or(false)
    }

    pub fn repo_name(&self) -> String {
        format!("{}/{}", self.owner, self.name)
    }
}

#[derive(Clone, Debug)]
struct Artifact {
    pub project: Project,
    pub release: Option<Release>,
}

impl Artifact {
    pub fn new(project: Project) -> Self {
        Self { project, release: None }
    }

    pub fn new_with_release(project: Project, release: Release) -> Self {
        Self { project, release: Some(release) }
    }

    pub fn is_match_repo(&self, repo_name: &str) -> bool {
        self.project.is_match_repo(repo_name)
    }
}

#[derive(Debug, Serialize, Deserialize, ValueEnum, Clone)]
enum LogLevel {
    Trace,
    Debug,
    Info,
    Warn,
    Error,
}

fn read_from<T>(input: &mut dyn std::io::Read) -> Result<T>
where
    T: serde::de::DeserializeOwned,
{
    let data: T = serde_json::from_reader(input)?;
    Ok(data)
}

fn read_items<P: AsRef<Path>, T>(path: P) -> Result<T> 
where
    T: serde::de::DeserializeOwned,
{
    let content = fs::read_to_string(path)?;
    read_from(&mut content.as_bytes())
}

fn read_projects<P: AsRef<Path>>(path: P) -> Result<Vec<Project>> {
    read_items(path)
}

fn read_releases<P: AsRef<Path>>(path: P) -> Result<Vec<Release>> {
    read_items(path)
}

fn is_auth_ok() -> Result<()> {
    let args = vec!["auth", "status"];
    let output = cmd("gh", args).run()?;
    if !output.status.success() {
        let code = output.status.code().unwrap_or(-1);
        if code == 1 {
            return Err(anyhow::anyhow!("GitHub CLI is not authenticated. Please run `gh auth login` to authenticate."));
        } else {
            return Err(anyhow::anyhow!("GitHub CLI authentication check failed with exit code: {}", code));
        }
    } else {
        Ok(())
    }
}

fn get_latest(repo_name: String) -> Result<Release> {
    log::info!("Fetching latest release for repository: {}", repo_name);
    is_auth_ok()?;
    let args = vec!["release", "view", "-R", &repo_name, "--json", "assets,publishedAt,tagName,url,name"];
    let output = cmd("gh", args).read()?;
    let mut release: Release = serde_json::from_str(&output)?;
    release.repo_name = repo_name;
    Ok(release)
}

fn find_target_artifacts<'a>(artifacts: &'a [Artifact], names: &Vec<String>) -> Result<Vec<&'a Artifact>> {
    let mut errs = vec![];
    let mut result = vec![];
    for name in names {
        match find_project_and_release(name, artifacts) {
            Ok(artifact) => 
                result.push(artifact),
            Err(e) => errs.push(e),
        }
    }
    if !errs.is_empty() {
        single_err_or_errs_array(errs)
    } else {
        Ok(result)
    }
}

fn fetch_new_releases<'a>(artifacts: &'a Vec<Artifact>, names: &Vec<String>) -> Result<Vec<Artifact>> {
    let targets = find_target_artifacts(artifacts, names)?;
    let mut results = vec![];
    let mut errs = vec![];
    for target in targets {
        if target.project.ignore_fetch_release() {
            log::info!("Skipping fetch for repository: {} (ignore-fetch-release is true)", target.project.repo_name());
            continue;
        }
        match get_latest(target.project.repo_name()) {
            Ok(new_release) => {
                let release = if let Some(current_release) = &target.release {
                    if current_release.tag_name != new_release.tag_name {
                        log::info!("New release found for {}: {} -> {}", target.project.repo_name(), current_release.tag_name, new_release.tag_name);
                        new_release
                    } else {
                        log::info!("No new release for {}: still at {}", target.project.repo_name(), current_release.tag_name);
                        current_release.clone()
                    }
                } else {
                    log::info!("Initial release found for {}: {}", target.project.repo_name(), new_release.tag_name);
                    new_release
                };
                // Update the release in the artifact
                let updated_artifact = Artifact::new_with_release(target.project.clone(), release);
                results.push(updated_artifact);
            },
            Err(e) => errs.push(e),
        }
    }
    Ok(results)
}

fn update_formula<'a>(artifact: &'a Artifact, tera: &Tera) -> Result<&'a Artifact> {
    log::info!("Updating formula for project: {}", artifact.project.name);
    let mut context = Context::new();
    context.insert("project", &artifact.project);
    if let Some(release) = &artifact.release {
        context.insert("release", release);
    };

    let template_name = format!("{}_template.rb", artifact.project.name);
    let to = format!("Formula/{}.rb", artifact.project.name);
    let rendered = tera.render(&template_name, &context)?;
    fs::write(to, rendered)?;
    Ok(artifact)
}

fn update_readme(artifacts: &Vec<Artifact>, tera: &Tera) -> Result<()> {
    log::info!("Updating README.md with project and release information");
    let mut vecp = vec![];
    let mut vecr = vec![];
    for artifact in artifacts {
        vecp.push(&artifact.project);
        vecr.push(artifact.release.as_ref());
    }
    let mut context = Context::new();
    context.insert("projects", &vecp);
    context.insert("releases", &vecr);
    let rendered = tera.render("README_template.md", &context)?;
    fs::write("README.md", rendered)?;
    Ok(())
}

fn write_releases<P: AsRef<Path>>(path: P, releases: &[Release]) -> Result<()> {
    let content = serde_json::to_string_pretty(releases)?;
    fs::write(path, content)?;
    Ok(())
}

async fn sha256(url: &str) -> Result<String> {
    let response = reqwest::Client::new()
        .get(url)
        .send()
        .await
        .or(Err(anyhow::anyhow!("Failed to fetch URL: {}", url)))?;
    let total_size = response.content_length()
        .ok_or_else(|| anyhow::anyhow!("Failed to get content length for URL: {}", url))?;
    let mut stream = response.bytes_stream();
    let mut hasher = Sha256::new();
    if log::log_enabled!(log::Level::Info) {
        let pb = indicatif::ProgressBar::new(total_size);
        pb.set_style(ProgressStyle::default_bar()
            .template("{msg}\n{spinner:.green} [{elapsed_precise}] [{wide_bar:.cyan/blue}] {bytes}/{total_bytes} ({bytes_per_sec}, {eta})")?
            .progress_chars("#>-")
        );
        pb.set_message(format!("Downloading {}", url));
        while let Some(item) = stream.next().await {
            let chunk = item.or(Err(anyhow::anyhow!("Error while downloading file")))?;
            hasher.update(&chunk);
            let current_pos = pb.position() + chunk.len() as u64;
            let now = if current_pos < total_size {
                current_pos
            } else {
                total_size
            };
            pb.set_position(now);
        }
        pb.finish_with_message("Download done");
    } else {
        while let Some(item) = stream.next().await {
            let chunk = item.or(Err(anyhow::anyhow!("Error while downloading file")))?;
            hasher.update(&chunk);
        }
    }
    let result = hasher.finalize();
    Ok(format!("{:x}", result))
}

async fn make_sha256<'a, 'b>(value: &'a Value, _args: &'b HashMap<String, Value>) -> tera::Result<Value> {
    match value.as_str() {
        Some(c) => {
            match sha256(c).await {
                Ok(hash) => {
                    serde_json::to_value(hash)
                        .map_err(|e| tera::Error::msg(format!("Failed to convert sha256 hash to value: {}", e)))
                },
                Err(e) => {
                    Err(tera::Error::msg(format!("Failed to compute sha256: {}", e)))
                },
            }
        },
        None => Err(tera::Error::msg("Expected a string value for sha256 filter")),
    }
}

fn make_sha256_filter<'a, 'b>(value: &'a Value, args: &'b HashMap<String, Value>) -> tera::Result<Value> {
    futures::executor::block_on(make_sha256(value, args))
}

fn make_format_date<'a, 'b>(value: &'a Value, _args: &'b HashMap<String, Value>) -> tera::Result<Value> {
    let date_str = match value.as_str() {
        Some(s) => s,
        None => return Err(tera::Error::msg("Expected a string value for date formatting")),
    };
    let dt = match date_str.parse::<DateTime<Utc>>() {
        Ok(dt) => dt,
        Err(e) => return Err(tera::Error::msg(format!("Failed to parse date string '{}': {}", date_str, e))),
    };
    serde_json::to_value(dt.format("%Y-%m-%d").to_string())
        .map_err(|e| tera::Error::msg(format!("Failed to format date: {}", e)))
}

fn make_to_version<'a, 'b>(value: &'a Value, _args: &'b HashMap<String, Value>) -> tera::Result<Value> {
    match value.as_str() {
        Some(tag_name) => {
            serde_json::to_value(tag_name.trim_start_matches('v'))
                .map_err(|e| tera::Error::msg(format!("Failed to convert tag name to version: {}", e)))
        },
        None => Err(tera::Error::msg("Expected a string value for to_version filter")),
    }
}

fn find_release<'a>(repo_name: &str, releases: &'a [Release]) -> Result<&'a Release> {
    releases.iter().find(|r| r.repo_name == repo_name)
        .ok_or_else(|| anyhow::anyhow!("Release not found for repository: {}", repo_name))
}

fn read_artifacts() -> Result<Vec<Artifact>> {
    let projects = read_projects("data/projects.json")?;
    let releases = read_releases("data/releases.json")?;

    let r = projects.into_iter()
        .map(|p| {
            match find_release(&p.repo_name(), &releases) {
                Ok(r) => Ok(Artifact::new_with_release(p, r.clone())),
                Err(e) => {
                    log::warn!("warning: {}", e);
                    Ok(Artifact::new(p))
                }
            }
        }).collect::<Result<Vec<_>>>()?;
    Ok(r)
}

fn find_project_and_release<'a>(name: &str, projects: &'a [Artifact]) -> Result<&'a Artifact> {
    projects.iter().find(|p| p.is_match_repo(name))
        .ok_or_else(|| anyhow::anyhow!("Project not found for name: {}", name))
}

/// Convert `Vec<Result<T>>` to `Result<Vec<T>>`
/// If `Vec<Result<T>>` has the multiple errors,
/// `Result<Vec<T>>` returns `Err(Vec<Error>)`.
pub fn vec_result_to_result_vec<T>(result: Vec<Result<T>>) -> Result<Vec<T>> {
    let mut errs = vec![];
    let mut ok_results = vec![];
    for r in result {
        match r {
            Ok(ok) => ok_results.push(ok),
            Err(err) => errs.push(err),
        }
    }
    errs_vec_to_result(errs, ok_results)
}

pub fn errs_vec_to_result<T>(errs: Vec<anyhow::Error>, ok_result: T) -> Result<T> {
    if errs.is_empty() {
        Ok(ok_result)
    } else {
        single_err_or_errs_array(errs)
    }
}

pub fn single_err_or_errs_array<T>(errs: Vec<anyhow::Error>) -> Result<T> {
    if errs.len() == 1 {
        Err(errs.into_iter().next().unwrap())
    } else {
        let mut msg = String::from("Multiple errors occurred:\n");
        for (i, err) in errs.iter().enumerate() {
            msg.push_str(&format!("  {}: {}\n", i + 1, err));
        }
        Err(anyhow::anyhow!(msg))
    }
}

fn init_logger(level: LogLevel) -> Result<()> {
    let log_level = match level {
        LogLevel::Trace => log::LevelFilter::Trace,
        LogLevel::Debug => log::LevelFilter::Debug,
        LogLevel::Info => log::LevelFilter::Info,
        LogLevel::Warn => log::LevelFilter::Warn,
        LogLevel::Error => log::LevelFilter::Error,
    };

    let mut builder = env_logger::Builder::new();
    builder.filter(None, log_level);
    builder.init();
    Ok(())
}

fn init_tera() -> Result<Tera> {
    let mut tera = Tera::new(".template/*")?;
    tera.register_filter("sha256", make_sha256_filter);
    tera.register_filter("format_date", make_format_date);
    tera.register_filter("to_version", make_to_version);
    Ok(tera)
}

fn update_recipes(names: Vec<String>, projects: &[Artifact], tera: &mut Tera) -> Result<()> {
    log::info!("Updating recipes for projects: {:?}", names);
    let r = names.into_iter()
        .map(|name| {
            match find_project_and_release(&name, &projects) {
                Ok(p) => 
                    update_formula(&p, &tera),
                Err(e) => Err(e),
            }
        }).filter_map(|result| result.err())
        .collect::<Vec<_>>();
    if r.is_empty() {
        Ok(())
    } else {
        Err(anyhow::anyhow!("Failed to update some recipes: {:?}", r))
    }
}

fn main() -> Result<()> {
    let args = cli::Args::parse();
    init_logger(args.level)?;

    let mut tera = init_tera()?;
    let artifacts = read_artifacts()?;

    let new_artifact = fetch_new_releases(&artifacts, &args.names)?;
    let mut updated = vec![];
    for artifact in artifacts {
        match new_artifact.iter().find(|a| a.is_match_repo(&artifact.project.repo_name())) {
            Some(a) => updated.push(a.clone()),
            None => updated.push(artifact.clone()),
        }
    }

    match update_recipes(args.names, &updated, &mut tera) {
        Ok(_) => {
            update_readme(&updated, &mut tera)?;
            let updated_releases: Vec<Release> = updated.iter().filter_map(|a| a.release.clone()).collect();
            write_releases("data/releases.json", &updated_releases)?;
            Ok(())
        },
        Err(e) => Err(e),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::NamedTempFile;
    use std::io::Write;

    #[test]
    fn test_read_projects() -> Result<()> {
        let content = r#"[
            {
                "owner": "test_owner",
                "name": "test_repo",
                "description": "test description",
                "url": "https://example.com",
                "license": "MIT",
                "ignore-fetch-release": false
            }
        ]"#;
        let mut file = NamedTempFile::new()?;
        write!(file.as_file_mut(), "{}", content)?;
        let projects = read_projects(file.path())?;
        assert_eq!(projects.len(), 1);
        assert_eq!(projects[0].owner, "test_owner");
        assert_eq!(projects[0].name, "test_repo");
        Ok(())
    }

    #[test]
    fn test_read_releases() -> Result<()> {
        let content = r#"[
            {
                "repoName": "test_owner/test_repo",
                "tagName": "v1.0.0",
                "name": "v1.0.0",
                "publishedAt": "2025-07-31T12:00:00Z",
                "url": "https://example.com/release",
                "assets": []
            }
        ]"#;
        let mut file = NamedTempFile::new()?;
        write!(file.as_file_mut(), "{}", content)?;
        let releases = read_releases(file.path())?;
        assert_eq!(releases.len(), 1);
        assert_eq!(releases[0].repo_name, "test_owner/test_repo");
        assert_eq!(releases[0].tag_name, "v1.0.0");
        Ok(())
    }
}