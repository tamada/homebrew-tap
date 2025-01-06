package main

import (
	"crypto/sha256"
	"encoding/json"
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
	updater "github.com/tamada/homebrew-tap/formula_updater"
)

func helpMessage(prog string) string {
	return `Usage: formula_updater [OPTIONS] <formula>
Description:
    This command updates the latest release version of the specified tool.
	Update the homebrew recipes located in Formula folder for downloading the latest releases and calculating SHA256 of them.
	This command also update README.md file.

Options:
    -h, --help  Show this help message

Example:
    formula_updater tamada/sibling
	This commands update the latest release version of sibling and update Formula/sibling.rb`
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
		"toVersion":  toVersion,
	}
}

func toVersion(tagName string) string {
	return strings.TrimPrefix(tagName, "v")
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

func getReleases(releases []*updater.Release, args []string) ([]*updater.Release, error) {
	errs := make([]error, 0)
	for _, arg := range args {
		r, err := updater.GetLatest(arg)
		if err == nil {
			releases = updater.UpdateRelease(releases, r)
		} else {
			errs = append(errs, err)
		}
	}
	return releases, errors.Join(errs...)
}

func updateReleasesIfNeeded(projects []*updater.Project, args []string) error {
	errs := make([]error, 0)
	for _, arg := range args {
		r, err := updater.GetLatest(arg)
		if err != nil {
			errs = append(errs, err)
			continue
		}
		for _, p := range projects {
			if p.IsMatchRepo(arg) {
				p.Release = r
				break
			}
		}
	}
	return errors.Join(errs...)
}

func findLatestReleasesOnNoReleaseProjects(projects []*updater.Project, args []string) error {
	errs := make([]error, 0)
	for _, p := range projects {
		if p.Release == nil && !p.IgnoreFetchRelease {
			r, err := updater.GetLatest(p.RepoName)
			if err != nil {
				errs = append(errs, err)
				continue
			}
			p.Release = r
		}
	}
	return errors.Join(errs...)
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
	projects, err := updater.ParseProjects("data/projects.json")
	if err != nil {
		return nil, err
	}
	releases, err := updater.ReadReleases("data/releases.json")
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
	if err := findLatestReleasesOnNoReleaseProjects(projects, args); err != nil {
		return projects, err
	}
	if err := updateReleasesIfNeeded(projects, args); err != nil {
		return projects, err
	}

	return projects, nil
}

func teardown(projects []*updater.Project) error {
	releases := []*updater.Release{}
	for _, p := range projects {
		if p.Release != nil {
			releases = append(releases, p.Release)
		}
	}
	return writeReleaseJson(releases)
}

func writeReleaseJson(releases []*updater.Release) error {
	f, err := os.Create("data/releases.json")
	if err != nil {
		return err
	}
	defer f.Close()
	data, err := json.MarshalIndent(releases, "", "  ")
	if err != nil {
		return err
	}
	_, err = f.Write(data)
	return err
}

func parseArgs(args []string) ([]string, bool) {
	helpFlag := false
	result := []string{}
	for _, arg := range args {
		if arg == "-h" || arg == "--help" {
			helpFlag = true
		} else {
			result = append(result, arg)
		}
	}
	return result, helpFlag
}

func goMain(args []string) int {
	args, helpFlag := parseArgs(args)
	if helpFlag {
		fmt.Println(helpMessage(os.Args[0]))
		return 0
	}
	projects, err := readProjects(args)
	if err != nil {
		fmt.Println(color.Red.Sprintf("Error: %s", err.Error()))
		return 2
	}
	if err = printResult(sortReleases(projects), args); err != nil {
		fmt.Println(color.Red.Sprintf("Error: %s", err.Error()))
		return 3
	}
	if err = teardown(projects); err != nil {
		fmt.Println(color.Red.Sprintf("Error: %s", err.Error()))
		return 5
	}
	return 0
}

func main() {
	status := goMain(os.Args[1:])
	os.Exit(status)
}
