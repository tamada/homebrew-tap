# :beer: Homebrew Recipes

Homebrew recipes for my products.

## How to install the following tools

At first, execute `brew tap tamada/tap`, then ready to install the above tools.
Then, type `brew install <formula>`.

Or, execute `brew install tamada/tap/<formula>` command for installing the tool in your environment.

## Available products
{{ range $p := . }}
- [{{ $p.Name }}]({{ printf "https://github.com/%s" $p.RepoName }}) 
  {{- if ne $p.Url "" -}}
    {{/* spacing */}} ([:spider_web:]({{ $p.Url }}))
  {{- end }}
  - **Formula:** `{{ $p.Owner }}/tap/{{ $p.Name }}`
  - **Description:** {{ $p.Description }}
  - **Releases:** {{/* for spacing */}}
  {{- if $p.Release -}}
    {{ $p.Release.TagName }} ({{ formatDate $p.Release.PublishedAt }})
  {{- else -}}
    <!-- for spacing -->
  {{- end -}}
{{ end }}

## Archived products

- [uniq2](https://github.com/tamada/uniq2) ([:spider_web:](https://tamada.github.io/uniq2/))
  - **Formula:** `tamada/tap/uniq2`
  - **Description:** Eliminating duplicate lines from a file.
  - **Releases:**
    v1.0.0 (2019-11-06)
  - **Archived At**: 2023-09-17
    - Transfer into the part of [tamada/peripherals](https://github.com/tamada/peripherals) repository.
