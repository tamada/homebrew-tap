use anyhow::Result;
use clap::Parser;
use serde::{Deserialize, Serialize};
use std::fs;
use std::path::Path;
use std::time::SystemTime;
use duct::cmd;
use tera::{Context, Tera, Value, try_get_value};
use sha2::{Digest, Sha256};
use std::collections::HashMap;
use chrono::{DateTime, Utc};

#[derive(Debug, Serialize, Deserialize, Clone)]
struct Asset {
    url: String,
    #[serde(rename = "downloadCount")]
    download_count: i64,
    name: String,
    size: i64,
}

#[derive(Debug, Serialize, Deserialize, Clone)]
struct Release {
    #[serde(rename = "repoName")]
    repo_name: String,
    #[serde(rename = "tagName")]
    tag_name: String,
    name: String,
    #[serde(rename = "publishedAt")]
    published_at: SystemTime,
    url: String,
    assets: Vec<Asset>,
}

#[derive(Debug, Serialize, Deserialize)]
struct Project {
    owner: String,
    name: String,
    description: String,
    url: String,
    license: String,
    #[serde(rename = "ignore-fetch-release")]
    ignore_fetch_release: bool,
}

impl Project {
    fn is_match_repo(&self, repo_name: &str) -> bool {
        self.repo_name() == repo_name
    }

    pub fn repo_name(&self) -> String {
        format!("{}/{}", self.owner, self.name)
    }
}

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(default_value = "")]
    names: Vec<String>,

    #[arg(short, long, default_value_t = false, alias = "silent")]
    quiet: bool,
}

fn read_projects<P: AsRef<Path>>(path: P) -> Result<Vec<Project>> {
    let content = fs::read_to_string(path)?;
    let projects: Vec<Project> = serde_json::from_str(&content)?;
    Ok(projects)
}

fn read_releases<P: AsRef<Path>>(path: P) -> Result<Vec<Release>> {
    let content = fs::read_to_string(path)?;
    let releases: Vec<Release> = serde_json::from_str(&content)?;
    Ok(releases)
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
    is_auth_ok()?;
    let args = vec!["release", "view", "-R", &repo_name, "--json", "assets,publishedAt,tagName,url,name"];
    let output = cmd("gh", args).read()?;
    let release: Release = serde_json::from_str(&output)?;
    Ok(release)
}

fn update_formula<'a>(project: &'a Project, r: &'a Release, tera: &Tera) -> Result<(&'a Project, &'a Release)> {
    let mut context = Context::new();
    context.insert("project", project);
    context.insert("release", r);

    let template_name = format!("{}_template.rb", project.name);
    let to = format!("Formula/{}.rb", project.name);
    let rendered = tera.render(&template_name, &context)?;
    fs::write(to, rendered)?;
    Ok((project, r))
}

fn update_readme(projects: &[(Project, Release)], tera: &Tera) -> Result<()> {
    let mut context = Context::new();
    context.insert("projects", projects);
    let rendered = tera.render("README_template.md", &context)?;
    fs::write("README.md", rendered)?;
    Ok(())
}

fn write_releases<P: AsRef<Path>>(path: P, releases: &[Release]) -> Result<()> {
    let content = serde_json::to_string_pretty(releases)?;
    fs::write(path, content)?;
    Ok(())
}

fn sha256(url: &str) -> Result<String> {
    let response = reqwest::blocking::get(url)?;
    let content = response.bytes()?;
    let mut hasher = Sha256::new();
    hasher.update(&content);
    let result = hasher.finalize();
    Ok(format!("{:x}", result))
}

fn make_sha256_fn() -> impl tera::Function {
    move |args: &HashMap<String, Value>| -> tera::Result<Value> {
        let url = try_get_value!("sha256", "url", String, args.get("url").unwrap());
        Ok(serde_json::to_value(sha256(&url).unwrap_or_default()).unwrap())
    }
}

fn make_format_date_fn() -> impl tera::Function {
    move |args: &HashMap<String, Value>| -> tera::Result<Value> {
        let date = try_get_value!("format_date", "date", i64, args.get("date").unwrap());
        let dt = DateTime::<Utc>::from(SystemTime::UNIX_EPOCH + std::time::Duration::from_secs(date as u64));
        Ok(serde_json::to_value(dt.format("%Y-%m-%d").to_string()).unwrap())
    }
}

fn make_to_version_fn() -> impl tera::Function {
    move |args: &HashMap<String, Value>| -> tera::Result<Value> {
        let tag_name = try_get_value!("to_version", "tag_name", String, args.get("tag_name").unwrap());
        Ok(serde_json::to_value(tag_name.trim_start_matches('v')).unwrap())
    }
}

fn find_release<'a>(repo_name: &str, releases: &'a [Release]) -> Result<&'a Release> {
    releases.iter().find(|r| r.repo_name == repo_name)
        .ok_or_else(|| anyhow::anyhow!("Release not found for repository: {}", repo_name))
}

fn read_projects_and_releases() -> Result<Vec<(Project, Release)>> {
    let projects = read_projects("data/projects.json")?;
    let releases = read_releases("data/releases.json")?;

    let r = projects.into_iter()
        .map(|p| {
            match find_release(&p.repo_name(), &releases) {
                Ok(r) => Ok((p, r.clone())),
                Err(e) => {
                    if !p.ignore_fetch_release {
                        let r = get_latest(p.repo_name())?;
                        Ok((p, r))
                    } else {
                        Err(e)
                    }
                }
            }
        }).collect::<Result<Vec<_>>>()?;
    Ok(r)
}

fn find_project_and_release<'a>(name: &str, projects: &'a [(Project, Release)]) -> Result<&'a (Project, Release)> {
    projects.iter().find(|(p, _)| p.is_match_repo(name))
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
        Err(errs.iter().chain(std::iter::once(&anyhow::anyhow!("Multiple errors occurred:")))
            .fold(anyhow::anyhow!(""), |acc, e| acc.context(e.to_string())))
    }
}

fn main() -> Result<()> {
    let mut tera = Tera::new(".template/*")?;
    tera.register_function("sha256", make_sha256_fn());
    tera.register_function("formatDate", make_format_date_fn());
    tera.register_function("toVersion", make_to_version_fn());

    let args = Args::parse();
    let projects = read_projects_and_releases()?;

    let result = args.names.into_iter()
        .map(|name| {
            match find_project_and_release(&name, &projects) {
                Ok((p, r)) => {
                    update_formula(p, r, &tera)
                },
                Err(e) => Err(e),
            }
        }).collect::<Vec<Result<_>>>();
    let result = vec_result_to_result_vec(result);

    update_readme(result, &tera)?;

    let updated_releases: Vec<Release> = projects.iter().filter_map(|p| p.release.clone()).collect();
    write_releases("data/releases.json", &updated_releases)?;

    Ok(())
}