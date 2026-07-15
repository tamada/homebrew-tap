use anyhow::{Context as AnyhowContext, Result};
use serde::Deserialize;

use crate::{Project, Release};

fn is_auth_ok() -> Result<()> {
    let args = vec!["auth", "status"];
    let output = duct::cmd("gh", args).run()?;
    if !output.status.success() {
        let code = output.status.code().unwrap_or(-1);
        if code == 1 {
            Err(anyhow::anyhow!("GitHub CLI is not authenticated. Please run `gh auth login` to authenticate."))
        } else {
            Err(anyhow::anyhow!("GitHub CLI authentication check failed with exit code: {}", code))
        }
    } else {
        Ok(())
    }
}

pub(crate) fn get_latest(repo_name: String) -> Result<Release> {
    log::debug!("get_latest: repo_name = {}", repo_name);
    log::info!("Fetching latest release for repository: {}", repo_name);
    is_auth_ok()?;
    let args = vec!["release", "view", "-R", &repo_name, "--json", "assets,publishedAt,tagName,url,name"];
    let output = duct::cmd("gh", args).read()?;
    let mut release: Release = match serde_json::from_str(&output) {
        Ok(r) => r,
        Err(e) => {
            println!("gh output: {}, error = {}", output, e);
            return Err(anyhow::anyhow!("Failed to parse release JSON for {}: {}", repo_name, e));
        }
    };
    release.repo_name = repo_name;
    log::debug!("get_latest: release = {:?}", release);
    Ok(release)
}

pub(crate) fn _owner_repo_to_project(name: String) -> Result<Project> {
    let (owner, repo) = name
        .split_once('/')
        .with_context(|| format!("Invalid repository name '{}': expected format owner/repo", name))?;
    if owner.is_empty() || repo.is_empty() {
        return Err(anyhow::anyhow!(
            "Invalid repository name '{}': expected format owner/repo",
            name
        ));
    }

    is_auth_ok()?;

    let query = "query($owner: String!, $name: String!) { repository(owner: $owner, name: $name) { owner { login } name description url homepageUrl licenseInfo { name } } }";
    let output = duct::cmd(
        "gh",
        vec![
            "api",
            "graphql",
            "-f",
            &format!("query={query}"),
            "-F",
            &format!("owner={owner}"),
            "-F",
            &format!("name={repo}"),
        ],
    )
    .read()
    .with_context(|| format!("Failed to fetch project metadata for {}/{}", owner, repo))?;

    #[derive(Deserialize)]
    #[serde(rename_all = "camelCase")]
    struct QueryRoot {
        data: QueryData,
    }

    #[derive(Deserialize)]
    struct QueryData {
        repository: Option<RepositoryNode>,
    }

    #[derive(Deserialize)]
    #[serde(rename_all = "camelCase")]
    struct RepositoryNode {
        owner: OwnerNode,
        name: String,
        description: Option<String>,
        url: String,
        homepage_url: Option<String>,
        license_info: Option<LicenseInfoNode>,
    }

    #[derive(Deserialize)]
    struct OwnerNode {
        login: String,
    }

    #[derive(Deserialize)]
    struct LicenseInfoNode {
        name: String,
    }

    let response: QueryRoot = serde_json::from_str(&output)
        .with_context(|| format!("Failed to parse GraphQL response for {}/{}", owner, repo))?;
    let repository = response
        .data
        .repository
        .ok_or_else(|| anyhow::anyhow!("Repository not found: {}/{}", owner, repo))?;

    let homepage = repository
        .homepage_url
        .as_ref()
        .map(|s| s.trim())
        .filter(|s| !s.is_empty())
        .map(std::string::ToString::to_string)
        .unwrap_or(repository.url);

    Ok(Project {
        owner: repository.owner.login,
        name: repository.name,
        description: repository.description.unwrap_or_default(),
        url: homepage,
        license: repository
            .license_info
            .map(|license| license.name)
            .unwrap_or_else(|| "No license".to_string()),
        ignore_fetch_release: None,
    })
}
