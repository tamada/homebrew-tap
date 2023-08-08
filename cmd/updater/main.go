package main

import (
	"crypto/sha256"
	"errors"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"text/template"
	"time"

	"github.com/gookit/color"
	"github.com/tamada/homebrew-tap/updater"
)

func helpMessage(prog string) string {
	return fmt.Sprintf(`%s <formula>`, prog)
}

func findResult(results []*updater.Project, name string) *updater.Project {
	for _, result := range results {
		if result.IsMatchRepo(name) {
			return result
		}
	}
	return nil
}

func funcMaps() map[string]interface{} {
	return map[string]interface{}{
		"sha256":     calculateSha256,
		"formatDate": formatDate,
		"isAsset":    isAsset,
		"findAsset":  findAsset,
	}
}

func findAsset(release *updater.Release, keywords ...string) *updater.Asset {
	for _, asset := range release.Assets {
		if isAsset(asset, keywords...) {
			return asset
		}
	}
	return nil
}

func isAsset(asset *updater.Asset, keywords ...string) bool {
	for _, keyword := range keywords {
		if !strings.Contains(asset.Url, keyword) {
			return false
		}
	}
	return true
}

func formatDate(date time.Time) string {
	return date.Format("2006-01-02")
}

func getContent(url string) ([]byte, error) {
	resp, err := http.Get(url)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode/100 == 3 { // Redirect
		return getContent(resp.Header.Get("Location"))
	}
	return io.ReadAll(resp.Body)
}

func calculateSha256(url string) string {
	content, err := getContent(url)
	if err != nil {
		return ""
	}
	return fmt.Sprintf("%x", sha256.Sum256(content))
}

func updateFormula(r *updater.Project, name string) error {
	if r == nil {
		return fmt.Errorf("%s formula not found", name)
	}
	names := strings.Split(name, "/")
	base := names[1] + "_template.rb"
	from := filepath.Join(".template/", base)
	to := filepath.Join("Formula", names[1]+".rb")
	tmpl, err := template.New(base).Funcs(funcMaps()).ParseFiles(from)
	if err != nil {
		return err
	}
	dest, err := os.Create(to)
	if err != nil {
		return err
	}
	return tmpl.Execute(dest, r)
}

func printReadme(results []*updater.Project) error {
	tmpl, err := template.New("README_template.md").
		Funcs(funcMaps()).
		ParseFiles(".template/README_template.md")
	if err != nil {
		return err
	}
	dest, err := os.Create("README.md")
	if err != nil {
		return err
	}
	return tmpl.Execute(dest, results)
}

func printResult(results []*updater.Project, args []string) error {
	var baseError error
	for _, arg := range args {
		err := updateFormula(findResult(results, arg), arg)
		if err != nil {
			baseError = errors.Join(baseError, err)
		}
	}
	err := printReadme(results)
	if err != nil {
		baseError = errors.Join(baseError, err)
	}
	return baseError
}

func getReleases(releases []*updater.Release, args []string) []*updater.Release {
	for _, arg := range args {
		r, err := updater.GetLatest(arg)
		if err == nil {
			releases = updater.UpdateRelease(releases, r)
		} else {
			fmt.Println(color.Red.Sprintf("%s", err.Error()))
		}
	}
	return releases
}

func sortReleases(projects []*updater.Project) []*updater.Project {
	sort.SliceStable(projects, func(i, j int) bool {
		if projects[i].Release == nil {
			return false
		} else if projects[j].Release == nil {
			return true
		}
		return projects[i].Release.PublishedAt.After(projects[j].Release.PublishedAt)
	})
	return projects
}

func readProjects(args []string) ([]*updater.Project, error) {
	releases, err := updater.ReadReleases("data/releases.json")
	if err != nil {
		return nil, err
	}
	releases = getReleases(releases, args)
	projects, err := updater.ParseProjects("data/projects.json")
	if err != nil {
		return nil, err
	}
	for _, r := range releases {
		for _, p := range projects {
			if p.IsMatchRepo(r.RepoName) {
				p.Release = r
				break
			}
		}
	}
	return projects, nil
}

func goMain(args []string) int {
	projects, err := readProjects(args)
	if err != nil {
		fmt.Println(color.Red.Sprintf("Error: %s", err.Error()))
		return 2
	}
	err = printResult(sortReleases(projects), args)
	if err != nil {
		fmt.Println(color.Red.Sprintf("Error: %s", err.Error()))
		return 1
	}
	return 0
}

func main() {
	status := goMain(os.Args[1:])
	os.Exit(status)
}
