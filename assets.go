package updater

import (
	"bytes"
	"encoding/json"
	"os"
	"os/exec"
	"strings"
	"time"
)

type Asset struct {
	Url           string `json:"url"`
	DownloadCount int    `json:"downloadCount"`
	Name          string `json:"name"`
	Size          int    `json:"size"`
}

type Release struct {
	RepoName    string    `json:"repoName"`
	TagName     string    `json:"tagName"`
	Name        string    `json:"name"`
	PublishedAt time.Time `json:"publishedAt"`
	Url         string    `json:"url"`
	Assets      []*Asset  `json:"assets"`
}

func (a *Asset) Contains(keys []string) bool {
	for _, k := range keys {
		if !strings.Contains(a.Name, k) {
			return false
		}
	}
	return true
}

func (r *Release) FindAssets(key []string) *Asset {
	for _, a := range r.Assets {
		found := true
		for _, k := range key {
			if !strings.Contains(a.Name, k) {
				found = false
				break
			}
		}
		if found {
			return a
		}
	}
	return nil
}

type Project struct {
	Owner              string   `json:"owner"`
	Name               string   `json:"name"`
	RepoName           string   `json:"-"`
	Description        string   `json:"description"`
	Url                string   `json:"url"`
	License            string   `json:"license"`
	Release            *Release `json:"-"`
	IgnoreFetchRelease bool     `json:"ignore-fetch-release"`
}

func (p *Project) IsMatchRepo(repoName string) bool {
	if p.RepoName == "" {
		p.RepoName = p.Owner + "/" + p.Name
	}
	return p.RepoName == repoName
}

func ParseProjects(fileName string) ([]*Project, error) {
	in, err := os.Open(fileName)
	if err != nil {
		return nil, err
	}
	defer in.Close()
	var results []*Project
	decoder := json.NewDecoder(in)
	err = decoder.Decode(&results)
	return results, err
}

func GetLatest(repoName string) (*Release, error) {
	cmd := exec.Command("gh", "release", "view", "-R", repoName, "--json", "assets,publishedAt,tagName,url,name")
	buffer := bytes.NewBuffer([]byte{})
	cmd.Stdout = buffer
	err := cmd.Start()
	if err != nil {
		return nil, err
	}
	err = cmd.Wait()
	if err != nil {
		return nil, err
	}
	return parse(buffer.Bytes(), repoName)
}

func parse(jsonData []byte, repoName string) (*Release, error) {
	result := Release{}
	err := json.Unmarshal(jsonData, &result)
	result.RepoName = repoName
	return &result, err
}

func ReadReleases(fileName string) ([]*Release, error) {
	in, err := os.Open(fileName)
	if err != nil {
		return nil, err
	}
	defer in.Close()
	results := []*Release{}
	decoder := json.NewDecoder(in)
	err = decoder.Decode(&results)
	return results, err
}

func UpdateRelease(releases []*Release, release *Release) []*Release {
	for i, r := range releases {
		if r.RepoName == release.RepoName {
			releases[i] = release
			return releases
		}
	}
	return append(releases, release)
}
