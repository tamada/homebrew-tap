use anyhow::Result;
use clap::{Parser, ValueEnum};
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;
use std::collections::HashMap;
use tera::{Context, Tera, Value};
use sha2::{Digest, Sha256};
use chrono::{DateTime, Utc};

mod cli;
mod github;

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
    #[serde(default)]
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
    license: String,
    url: String,
    #[serde(rename = "ignore-fetch-release", skip_serializing_if = "Option::is_none")]
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

    /// Base name of the template file and of the generated formula.
    /// It is the project name, except for `9rules`: a Ruby class name cannot
    /// start with a digit, so that formula has been `ninerules` from the start.
    pub fn formula_name(&self) -> String {
        match self.name.as_str() {
            "9rules" => String::from("ninerules"),
            name => String::from(name),
        }
    }

    pub fn template_name(&self) -> String {
        format!("{}.template", self.formula_name())
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

fn find_target_artifacts<'a>(artifacts: &'a [Artifact], names: &Vec<String>) -> Result<Vec<&'a Artifact>> {
    log::debug!("find_target_artifacts: names = {:?}", names);
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

fn should_update(config: &cli::Config, project: &Project) -> bool {
    if config.force_update {
        true
    } else {
        !project.ignore_fetch_release() && !config.disable_update
    }
}

fn fetch_new_release_of_artifact(target: &Artifact) -> Result<Artifact> {
    match github::get_latest(target.project.repo_name()) {
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
            Ok(updated_artifact)
        },
        Err(e) => Err(e),
    }
}

fn fetch_new_releases(artifacts: &[Artifact], names: &Vec<String>, config: &cli::Config) -> Result<Vec<Artifact>> {
    log::debug!("fetch_new_releases: names = {:?}", names);
    let targets = find_target_artifacts(artifacts, names)?;
    let mut results = vec![];
    let mut errs = vec![];
    for target in targets {
        if !should_update(config, &target.project) {
            log::info!("Skipping fetch for repository: {} (ignore-fetch-release is true)", target.project.repo_name());
        } else {
            log::info!("Fetching latest release for repository: {}", target.project.repo_name());
            match fetch_new_release_of_artifact(target) {
                Ok(artifact) => results.push(artifact),
                Err(e) => errs.push(e),
            }
        }
    }
    errs_vec_to_result(errs, results)
}

fn update_formula<'a>(artifact: &'a Artifact, tera: &Tera, config: &cli::Config) -> Result<&'a Artifact> {
    log::info!("Updating formula for project: {}", artifact.project.name);
    let mut context = Context::new();
    context.insert("project", &artifact.project);
    if let Some(release) = &artifact.release {
        log::info!("Release of the project: {:?}", release);
        context.insert("release", release);
    };

    let template_name = artifact.project.template_name();
    let to = format!("Formula/{}.rb", artifact.project.formula_name());
    let rendered = tera.render(&template_name, &context)?;
    if config.dry_run {
        if config.is_show_target(cli::ShowMode::Recipe) {
            println!("----- dry-run mode: {} -----\n{}", to, rendered);
        } 
    } else {
        fs::write(to, rendered)?;
    }
    Ok(artifact)
}

fn update_readme(artifacts_orig: &[Artifact], tera: &Tera, config: &cli::Config) -> Result<()> {
    log::info!("Updating README.md with project and release information");
    let mut vecp = vec![];
    let mut vecr = vec![];
    let mut artifacts = artifacts_orig.to_vec();
    artifacts.sort_by(|a, b| {
        let repo_a = a.release.as_ref().map(|r| r.published_at);
        let repo_b = b.release.as_ref().map(|r| r.published_at);
        repo_a.cmp(&repo_b)
    });
    artifacts.reverse();
    for artifact in artifacts.iter() {
        vecp.push(artifact.project.clone());
        vecr.push(artifact.release.as_ref());
    }
    let mut context = Context::new();
    context.insert("projects", &vecp);
    context.insert("releases", &vecr);
    let rendered = tera.render("README.template", &context)?;
    if config.dry_run {
        if config.is_show_target(cli::ShowMode::Readme) {
            println!("----- dry-run mode: README.md -----\n{}", rendered);
        }
    } else {
        fs::write("README.md", rendered)?;
    }
    Ok(())
}

fn write_projects<P: AsRef<Path>>(path: P, projects: &[Project], config: &cli::Config) -> Result<()> {
    log::info!("Writing projects to {}", path.as_ref().display());
    // data/projects.json is maintained by hand, and is indented by four spaces.
    let mut buffer = Vec::new();
    let formatter = serde_json::ser::PrettyFormatter::with_indent(b"    ");
    let mut serializer = serde_json::Serializer::with_formatter(&mut buffer, formatter);
    projects.serialize(&mut serializer)?;
    let content = format!("{}\n", String::from_utf8(buffer)?);
    if config.dry_run {
        if config.is_show_target(cli::ShowMode::ProjectJson) {
            println!("----- dry-run mode: {} -----\n{}", path.as_ref().display(), content);
        }
    } else {
        fs::write(path, content)?;
    }
    Ok(())
}

fn write_releases<P: AsRef<Path>>(path: P, releases: &[Release], config: &cli::Config) -> Result<()> {
    log::info!("Writing releases to {}", path.as_ref().display());
    let content = serde_json::to_string_pretty(releases)?;
    if config.dry_run {
        if config.is_show_target(cli::ShowMode::ProjectJson) {
            println!("----- dry-run mode: {} -----\n{}", path.as_ref().display(), content);
        }
    } else {
        fs::write(path, content)?;
    }
    Ok(())
}

fn sha256(url: &str) -> Result<String> {
    log::info!("Calculating sha256 for URL: {}", url);
    let response = match reqwest::blocking::get(url) {
        Ok(resp) => resp,
        Err(e) => return Err(anyhow::anyhow!("Failed to fetch URL: {}: {}", url, e)),
    };
    if !response.status().is_success() {
        return Err(anyhow::anyhow!("Failed to fetch URL: {}: HTTP {}", url, response.status()));
    }
    response.bytes()
        .map_err(|e| anyhow::anyhow!("Failed to read response body from URL: {}: {}", url, e))
        .map(|bytes| {
            let mut hasher = Sha256::new();
            hasher.update(&bytes);
            let result = hasher.finalize();
            base16ct::lower::encode_string(&result)
        })
}

fn make_sha256(value: &Value, _args: &HashMap<String, Value>) -> tera::Result<Value> {
    match value.as_str() {
        Some(c) => {
            match sha256(c) {
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

fn make_sha256_filter(value: &Value, args: &HashMap<String, Value>) -> tera::Result<Value> {
    // futures::executor::block_on(make_sha256(value, args))
    make_sha256(value, args)
}

fn make_format_date(value: &Value, _args: &HashMap<String, Value>) -> tera::Result<Value> {
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

fn make_to_version(value: &Value, _args: &HashMap<String, Value>) -> tera::Result<Value> {
    match value.as_str() {
        Some(tag_name) => {
            serde_json::to_value(tag_name.trim_start_matches('v'))
                .map_err(|e| tera::Error::msg(format!("Failed to convert tag name to version: {}", e)))
        },
        None => Err(tera::Error::msg("Expected a string value for to_version filter")),
    }
}

fn make_to_class_name(value: &Value, _args: &HashMap<String, Value>) -> tera::Result<Value> {
    fn digit_word(ch: char) -> Option<&'static str> {
        match ch {
            '0' => Some("Zero"),
            '1' => Some("One"),
            '2' => Some("Two"),
            '3' => Some("Three"),
            '4' => Some("Four"),
            '5' => Some("Five"),
            '6' => Some("Six"),
            '7' => Some("Seven"),
            '8' => Some("Eight"),
            '9' => Some("Nine"),
            _ => None,
        }
    }

    let name = value
        .as_str()
        .ok_or_else(|| tera::Error::msg("Expected a string value for to_class_name filter"))?;

    let class_name = name
        .split(|c: char| !c.is_ascii_alphanumeric())
        .filter(|part| !part.is_empty())
        .map(|part| {
            let mut chars = part.chars();
            match chars.next() {
                Some(first) if first.is_ascii_digit() => {
                    let mut result = String::from(digit_word(first).unwrap_or(""));
                    result.push_str(chars.as_str().to_ascii_lowercase().as_str());
                    result
                },
                Some(first) => {
                    let mut result = String::new();
                    result.push(first.to_ascii_uppercase());
                    result.push_str(chars.as_str().to_ascii_lowercase().as_str());
                    result
                },
                None => String::new(),
            }
        })
        .collect::<String>();

    if class_name.is_empty() {
        Err(tera::Error::msg("Failed to derive a class name from the project name"))
    } else {
        serde_json::to_value(class_name)
            .map_err(|e| tera::Error::msg(format!("Failed to convert class name to value: {}", e)))
    }
}

/// The Homebrew condition selecting the asset of the given name.
/// Homebrew runs on macOS and on Linux only: it has no `OS.windows?`, and on
/// Windows it is used through WSL, where it is Linux and takes the Linux asset.
/// An asset of any other platform or architecture therefore has no condition,
/// and does not belong in a formula.
fn os_condition_of(asset_name: &str) -> Option<&'static str> {
    const CONDITIONS: [(&str, &str, &str); 4] = [
        ("darwin", "amd64", "OS.mac? && Hardware::CPU.intel?"),
        ("darwin", "arm64", "OS.mac? && Hardware::CPU.arm?"),
        ("linux", "amd64", "OS.linux? && Hardware::CPU.intel?"),
        ("linux", "arm64", "OS.linux? && Hardware::CPU.arm?"),
    ];
    CONDITIONS.iter()
        .find(|(os, arch, _)| asset_name.contains(os) && asset_name.contains(arch))
        .map(|(_, _, condition)| *condition)
}

/// Keeps the assets Homebrew can install, each with its `condition` added,
/// so that a template renders them without picking the platform apart itself.
fn make_supported_assets(value: &Value, _args: &HashMap<String, Value>) -> tera::Result<Value> {
    let assets = value.as_array()
        .ok_or_else(|| tera::Error::msg("Expected an array of assets for supported_assets filter"))?;
    let mut results = vec![];
    for asset in assets {
        let name = asset.get("name").and_then(|name| name.as_str())
            .ok_or_else(|| tera::Error::msg("Expected a string name in each asset"))?;
        if let Some(condition) = os_condition_of(name) {
            let mut asset = asset.clone();
            let object = asset.as_object_mut()
                .ok_or_else(|| tera::Error::msg("Expected an object in each asset"))?;
            object.insert(String::from("condition"), Value::String(String::from(condition)));
            results.push(asset);
        } else {
            log::info!("{}: no platform Homebrew supports, skipped.", name);
        }
    }
    Ok(Value::Array(results))
}

fn find_release<'a>(repo_name: &str, releases: &'a [Release]) -> Result<&'a Release> {
    releases.iter().find(|r| r.repo_name == repo_name)
        .ok_or_else(|| anyhow::anyhow!("Release not found for repository: {}", repo_name))
}

fn read_artifacts() -> Result<Vec<Artifact>> {
    artifacts_of(read_projects("data/projects.json")?)
}

fn artifacts_of(projects: Vec<Project>) -> Result<Vec<Artifact>> {
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
        .ok_or_else(|| anyhow::anyhow!("{name}: Project not found for name."))
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

fn init_tera() -> Result<Tera> {
    let mut tera = Tera::new(".templates/*")?;
    tera.register_filter("sha256", make_sha256_filter);
    tera.register_filter("format_date", make_format_date);
    tera.register_filter("to_version", make_to_version);
    tera.register_filter("to_class_name", make_to_class_name);
    tera.register_filter("supported_assets", make_supported_assets);
    Ok(tera)
}

fn update_recipes(names: Vec<String>, projects: &[Artifact], tera: &mut Tera, config: &cli::Config) -> Result<()> {
    log::info!("Updating recipes for projects: {:?}", names);
    let r = names.into_iter()
        .map(|name| {
            match find_project_and_release(&name, projects) {
                Ok(p) => 
                    update_formula(p, tera, config),
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

/// Builds the projects to be newly registered by asking GitHub about them.
/// The names already found in `projects` are skipped.
fn new_projects(names: &[String], projects: &[Project]) -> Result<Vec<Project>> {
    let mut results = vec![];
    let mut errs = vec![];
    for name in names {
        if projects.iter().any(|p| p.is_match_repo(name)) {
            log::info!("{}: already registered in data/projects.json", name);
            continue;
        }
        log::info!("Fetching the project metadata of {}", name);
        match github::owner_repo_to_project(name.clone()) {
            Ok(project) => results.push(project),
            Err(e) => errs.push(e),
        }
    }
    errs_vec_to_result(errs, results)
}

/// Creates the template of the given project from `.templates/template.template`,
/// and registers it in `tera` so that the following update can render it even in
/// the dry run mode, where nothing is written out.
fn create_template(project: &Project, tera: &mut Tera, config: &cli::Config) -> Result<()> {
    let template_name = project.template_name();
    let to = format!(".templates/{}", template_name);
    if Path::new(&to).exists() {
        log::info!("{}: already exists, keeping it as is.", to);
        return Ok(());
    }
    log::info!("Creating {} from .templates/template.template", to);
    let mut context = Context::new();
    context.insert("project", project);
    let rendered = tera.render("template.template", &context)?;
    if config.dry_run {
        if config.is_show_target(cli::ShowMode::Recipe) {
            println!("----- dry-run mode: {} -----\n{}", to, rendered);
        }
    } else {
        fs::write(&to, &rendered)?;
    }
    tera.add_raw_template(&template_name, &rendered)?;
    Ok(())
}

fn perform_register(names: Vec<String>, config: cli::Config, mut tera: Tera) -> Result<()> {
    let mut projects = read_projects("data/projects.json")?;
    let registered = new_projects(&names, &projects)?;
    for project in registered.iter() {
        create_template(project, &mut tera, &config)?;
    }
    if registered.is_empty() {
        log::info!("No project to register.");
    } else {
        projects.extend(registered);
        write_projects("data/projects.json", &projects, &config)?;
    }
    update_artifacts(names, artifacts_of(projects)?, config, tera)
}

fn perform_update(names: Vec<String>, config: cli::Config, tera: Tera) -> Result<()> {
    update_artifacts(names, read_artifacts()?, config, tera)
}

fn update_artifacts(names: Vec<String>, artifacts: Vec<Artifact>, config: cli::Config, mut tera: Tera) -> Result<()> {
    let new_artifact = fetch_new_releases(&artifacts, &names, &config)?;
    let mut updated = vec![];
    for artifact in artifacts {
        match new_artifact.iter().find(|a| a.is_match_repo(&artifact.project.repo_name())) {
            Some(a) => updated.push(a.clone()),
            None => updated.push(artifact.clone()),
        }
    }

    match update_recipes(names, &updated, &mut tera, &config) {
        Ok(_) => {
            update_readme(&updated, &tera, &config)?;
            let updated_releases: Vec<Release> = updated.iter().filter_map(|a| a.release.clone()).collect();
            write_releases("data/releases.json", &updated_releases, &config)?;
            Ok(())
        },
        Err(e) => Err(e),
    }
}

fn main() -> Result<()> {
    let args = cli::Args::parse();
    let (names, config) = args.init()?;

    let tera = init_tera()?;
    if config.register {
        perform_register(names, config, tera)
    } else {
        perform_update(names, config, tera)
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
        assert_eq!(projects[0].ignore_fetch_release, Some(false));
        Ok(())
    }

    fn project_of(name: &str) -> Project {
        Project {
            owner: String::from("tamada"),
            name: String::from(name),
            description: String::new(),
            license: String::new(),
            url: String::new(),
            ignore_fetch_release: None,
        }
    }

    #[test]
    fn test_formula_name() {
        assert_eq!(project_of("totebag").formula_name(), "totebag");
        assert_eq!(project_of("totebag").template_name(), "totebag.template");
        // 9rules is the exception: its formula cannot be named after a digit.
        assert_eq!(project_of("9rules").formula_name(), "ninerules");
        assert_eq!(project_of("9rules").template_name(), "ninerules.template");
    }

    #[test]
    fn test_os_condition_of() {
        // The two naming styles in use, and the '-' separated one of peripherals.
        assert_eq!(os_condition_of("lis-0.0.11_amd64_darwin.tar.gz"), Some("OS.mac? && Hardware::CPU.intel?"));
        assert_eq!(os_condition_of("gixor-0.5.2_darwin_arm64.tar.gz"), Some("OS.mac? && Hardware::CPU.arm?"));
        assert_eq!(os_condition_of("peripherals-1.0.1-linux-amd64.tar.gz"), Some("OS.linux? && Hardware::CPU.intel?"));
        assert_eq!(os_condition_of("heatman-0.1.1_linux_arm64.tar.gz"), Some("OS.linux? && Hardware::CPU.arm?"));
        // Homebrew has no OS.windows?, and does not serve 32bit or sources.
        assert_eq!(os_condition_of("oinkie-0.8.1_amd64_windows.zip"), None);
        assert_eq!(os_condition_of("wildcat-1.2.0_linux_386.tar.gz"), None);
        assert_eq!(os_condition_of("9rules-1.1.1-src.zip"), None);
    }

    #[test]
    fn test_supported_assets_filter_keeps_the_order() -> Result<()> {
        let assets = serde_json::json!([
            { "name": "x_darwin_amd64.tar.gz", "url": "https://example.com/1" },
            { "name": "x_windows_amd64.zip", "url": "https://example.com/2" },
            { "name": "x_linux_arm64.tar.gz", "url": "https://example.com/3" },
        ]);
        let filtered = make_supported_assets(&assets, &HashMap::new())
            .map_err(|e| anyhow::anyhow!("{}", e))?;
        let filtered = filtered.as_array().unwrap();
        assert_eq!(filtered.len(), 2);
        assert_eq!(filtered[0]["condition"], "OS.mac? && Hardware::CPU.intel?");
        assert_eq!(filtered[0]["url"], "https://example.com/1");
        assert_eq!(filtered[1]["condition"], "OS.linux? && Hardware::CPU.arm?");
        Ok(())
    }

    #[test]
    fn test_write_projects_keeps_the_hand_written_shape() -> Result<()> {
        let projects = vec![project_of("mosty")];
        let mut buffer = Vec::new();
        let formatter = serde_json::ser::PrettyFormatter::with_indent(b"    ");
        let mut serializer = serde_json::Serializer::with_formatter(&mut buffer, formatter);
        projects.serialize(&mut serializer)?;
        let content = String::from_utf8(buffer)?;
        assert!(content.contains("\n        \"owner\": \"tamada\""));
        // ignore-fetch-release is omitted while it is unset.
        assert!(!content.contains("ignore"));
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