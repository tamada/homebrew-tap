# :beer: Homebrew Recipes

Homebrew recipes for my products.

## Available products

| Products | Url | Formula | Description | Version | Release date |
|----------|-----|---------|-------------|---------|--------------|
{{- range $p := . }}
| {{ $p.Name }} | [:octocat:]({{ printf "https://github.com/%s" $p.RepoName }})
  {{- if ne $p.Url "" -}}
     [:spider_web:]({{ $p.Url }})
  {{- end -}}
| `{{ $p.Owner }}/tap/{{ $p.Name }}` | {{ $p.Description }} | 
  {{- if $p.Release -}}
    {{ $p.Release.TagName }} | {{ formatDate $p.Release.PublishedAt }} |
  {{- else -}}
    | |
  {{- end -}}
{{- end }}

## Archived products

| Products | Url | Formula | Description | Version | Release date |
|----------|-----|---------|-------------|---------|--------------|
| uniq2    | [:octocat:]() [:spider_web:](https://tamada.github.io/uniq2/) | `tamada/tap/uniq2` | Eliminating duplicate lines from file. | v1.0.0 | 2019-11-06 |

## How to install the above tools

At first, execute `brew tap tamada/tap`, then ready to install the above tools.
Then, type `brew install <formula>`.

Or, execute `brew install tamada/tap/<formula>` command for installing the tool in your environment.
