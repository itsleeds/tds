

[![pages-build-deployment](https://github.com/itsleeds/tds/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/itsleeds/tds/actions/workflows/pages/pages-build-deployment)
[![Open in GitHub
Codespaces](https://img.shields.io/badge/Open%20in-GitHub%20Codespaces-blue?logo=github.png)](https://github.com/codespaces/new/itsleeds/tds?quickstart=1)

This repo contains code for the Transport Data Science module at the
Institute for Transport Studies, University of Leeds. See the website at
https://itsleeds.github.io/tds/ and at
[leeds.ac.uk](https://webprod3.leeds.ac.uk/catalogue/dynmodules.asp?Y=202223&M=TRAN-5340M)

## Cloning and contributing

We welcome contributions! To fork and clone the repo, use the following
commands:

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

Note: we have branch protections in place so you should create a PR
before pushing to the main branch.

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
```

You can save presentations as PDF files with the following command:

See documentation on Quarto website for info on publishing.
