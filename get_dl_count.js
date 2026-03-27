'use strict'

const update_dl_count = (owner, repo, releases) => {
    console.log(`Updating download count for ${owner}/${repo}`);
    console.log(releases);
}

const get_dl_count = (owner, repo, version = 'latest') => {
    const xhr = new XMLHttpRequest();
    if (version == undefined || version == null || version == "latest") {
        xhr.open('GET', `https://api.github.com/repos/${owner}/${repo}/releases/latest`, false);
    } else {
        xhr.open('GET', `https://api.github.com/repos/${owner}/${repo}/releases/tags/${version}`, false);
    }
    xhr.setRequestHeader('Accept', 'application/vnd.github+json')
    xhr.setRequestHeader("X-GitHub-Api-Version", "2022-11-28")
    xhr.onreadystatechange = () => {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            const status = xhr.status;
            if (status == 0 || status >= 200 && status < 400) {
                update_dl_count(owner, repo, JSON.parse(xhr.responseText));
            }
        }
    }
}
