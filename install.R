## Use Posit Public Package Manager (RSPM) to prefer prebuilt binary CRAN packages
## This speeds up installs (no source compilation) in CI, Binder, Gitpod, Pixi etc.
## See: https://packagemanager.posit.co/ and https://packagemanager.rstudio.com/
rspm_url <- "https://packagemanager.rstudio.com/all/latest"
options(repos = c(CRAN = rspm_url))
# Ask R to prefer binary packages when available
options(pkgType = "binary")

if (file.exists("DESCRIPTION")) {
  remotes::install_local(dependencies = TRUE, ask = FALSE)
} else {
  remotes::install_github('itsleeds/tds', dependencies = TRUE, ask = FALSE)
}

