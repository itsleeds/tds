
[![pages-build-deployment](https://github.com/itsleeds/tds/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/itsleeds/tds/actions/workflows/pages/pages-build-deployment)
[![Open in GitHub
Codespaces](https://img.shields.io/badge/Open%20in-GitHub%20Codespaces-blue?logo=github.png)](https://github.com/codespaces/new/itsleeds/tds?quickstart=1)
![GitHub Downloads (all assets, all
releases)](https://img.shields.io/github/downloads/itsleeds/tds/total.png)
[![Docker
Pulls](https://img.shields.io/badge/Docker:_ghcr.io-image_ghcr)](https://github.com/itsleeds/tds/pkgs/container/tds)
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/itsleeds/tds/HEAD)
<!-- [![Open in Gitpod](https://img.shields.io/badge/Open%20in-Gitpod-blue?logo=gitpod)](https://gitpod.io/#https://github.com/itsleeds/tds) -->

This repo contains code for the Transport Data Science module at the
Institute for Transport Studies, University of Leeds. See the website at
https://itsleeds.github.io/tds/ and a summary of the catelogue entry at
[leeds.ac.uk](https://catalogue.leeds.ac.uk/Module/TP/TRAN/5340M/202526)

## Quickstart


See the course website at
[itsleeds.github.io/tds](https://itsleeds.github.io/tds/)

The quickest way to get started with the code for many people will be to
use GitHub Codespaces. Click the [Open in GitHub
Codespaces](https://github.com/codespaces/new/itsleeds/tds?quickstart=1)
button above to get started.

Alternatively you can launch this repository on Binder (notebooks).

If you’re using VS Code and have Docker installed you can open the
project in a Devcontainer by pressing Ctrl+Shift+P, typing in
“Devcontainer”, and selecting “Remote-Containers: Reopen in Container”.

## Cloning and contributing

We welcome contributions!

To fork and clone the repo, use the following commands:

``` sh
# install the gh command line tool: https://cli.github.com/
gh repo fork itsleeds/tds
git clone tds
code tds # to open in VS Code, or open in your preferred editor
# make changes
git add .
git status # to check what you've changed
git commit -m "your message"
git push
gh pr create # to create a pull request
```

Please create an issue before contributing, so we can discuss the
changes you’d like to make.

<!-- Note: we have branch protections in place so you should create a PR before pushing to the main branch. -->

You can create and work on an issue with the following commands:

``` sh
gh repo clone itsleeds/tds
cd tds # or code tds to open with VS Code
gh issue create # to create an issue
gh issue develop 123 --checkout # to create a branch and start working on issue 123
# make changes
git add .
git commit -m "your message"
git push
gh pr create # to create a pull request
```

## Reproducing the website

### Using Pixi (Recommended for all platforms)

The most reliable way to reproduce the website locally is using [Pixi](https://pixi.sh/). It handles both R and Python dependencies in a single isolated environment.

1. **Install Pixi**: Follow the instructions at [pixi.sh](https://pixi.sh/).
2. **Initialize Environment**:
   ```bash
   pixi install
   ```
3. **Preview the website**:
   ```bash
   pixi run preview
   ```

### Using R (Alternative)

To reproduce the website using R, you can use the following command:

``` r
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak")
}
pak::pak("itsleeds/tds")
```

**Note for Python users:** If your local machine lacks Python or the required libraries (like `jupyter` and `geopandas`), Quarto may fail to render documents containing Python code. We recommend the Pixi approach above to ensure all dependencies are met.

### Windows Users

If you are on Windows, we strongly recommend using **Pixi** or **GitHub Codespaces**. If you prefer a manual setup, ensure you have:
1. [Quarto](https://quarto.org/docs/get-started/) installed.
2. [R](https://cran.r-project.org/) and [Python](https://www.python.org/) installed and added to your PATH.
3. Python dependencies installed via: `pip install jupyter jupyter-cache geopandas matplotlib shapely seaborn ipykernel osmnx`.


## Archive

See an archived version of the repo, before we switched to using Quarto,
at https://github.com/itsleeds/tdsarchive

## Setup

<details>

To set it up we used commands such as:

``` r
usethis::use_description()
usethis::use_package("stats19")
usethis::use_package("DT")
usethis::use_package("quarto")
usethis::use_package("zonebuilder")
```

You can save presentations as PDF files with the following command:

We use the Harvard citation style, added as follows:

``` bash
wget https://github.com/citation-style-language/styles/raw/refs/heads/master/elsevier-harvard.csl
```

See documentation on Quarto website for info on publishing.
