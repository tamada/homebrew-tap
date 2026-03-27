---
title: "Formula updater script"
date: 2026-03-27
---

## :speaking_head: Overview

> [!CAUTION]
> This document is for this repository owner.

The repository contains `formula_updater` written in the Rust language.
The `formula_updater` performs the following procedures in this order.

- downloads the assets of the specified product,
- calculates SHA256 of them, and then
- updates the homebrew recipe of the product.

## :fork_and_knife: Usage

### :runner: CLI

```sh
Usage: formula_updater [OPTIONS] <NAME>

Arguments:
  [NAME]  Name of the project to update.

Options:
  -l, --level <LEVEL>  Set the logging level. [default: warn]
                       [possible values: trace, debug, info, warn, error]
  -h, --help           Print help
  -V, --version        Print version
```

