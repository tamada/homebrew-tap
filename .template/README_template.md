# :beer: Homebrew Recipes

Homebrew recipes for my products.

## Available products

| Formula | GitHub | Description | Version | Release date |
|---------|--------|-------------|---------|--------------|
{{- range $p := . }}
|
  {{- if $p.Url -}}
    [{{ $p.RepoName }}]({{ $p.Url }})
  {{- else -}}
    {{ $p.RepoName }}
  {{- end -}}
| [:octocat:]({{ printf "https://github.com/%s" $p.RepoName }}) | {{ $p.Description }} | 
  {{- if $p.Release -}}
    {{ $p.Release.TagName }} | {{ formatDate $p.Release.PublishedAt }} |
  {{- else -}}
    | |
  {{- end -}}
{{- end }}


## How to install above tools

At first, execute `brew tap tamada/tap`, then ready to install above tools.
Then, type `brew install <formula>`.

Or, execute `brew install tamada/tap/<formula>` command for installing tool in your environment.
