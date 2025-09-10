# :beer: Homebrew Recipes

Homebrew recipes for my products.

## How to install the following tools

At first, execute `brew tap tamada/tap`, then ready to install the above tools.
Then, type `brew install <formula>`.

Or, execute `brew install tamada/tap/<formula>` command for installing the tool in your environment.

## Available products
{# spacing #}
{%- for p in projects %}
- [{{ p.name }}](https://github.com/{{ p.owner }}/{{ p.name }}) 
  {%- if p.url != "" -%}
  {#- spacing -#} ([:spider_web:]({{ p.url }}))
  {%- endif %}
  - **Formula:** `{{ p.owner }}/tap/{{ p.name }}`
  - **Description:** {{ p.description }}
  - **Releases:** {# spacing -#}
  {%- if releases[loop.index0] -%}
    {{ releases[loop.index0].tagName }} ({{ releases[loop.index0].publishedAt | format_date }})
  {%- endif %}
{%- endfor %}

## Archived products

- [gibo-wrapper](https://github.com/tamada/gibo-wrapper)([:spider_web:](https://tamada.github.io/gibo-wrapper/))
  - **Formula:** `tamada/tap/gibo-wrapper`
  - **Description:** gibo-wrapper acts like gibo and improves gibo by adding some features.
  - **Releases:** v0.7.10 (2025-07-18), the final release.
  - **Archived At**: 2025-07-18
    - Transfer into the [tamada/gixor](https://github.com/tamada/gixor)
- [uniq2](https://github.com/tamada/uniq2) ([:spider_web:](https://tamada.github.io/uniq2/))
  - **Formula:** `tamada/tap/uniq2`
  - **Description:** Eliminating duplicate lines from a file.
  - **Releases:**
    v1.0.0 (2019-11-06)
  - **Archived At**: 2023-09-17
    - Transfer into the part of [tamada/peripherals](https://github.com/tamada/peripherals) repository.
