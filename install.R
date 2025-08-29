## Use Posit Public Package Manager (RSPM) to prefer prebuilt binary CRAN packages
## This speeds up installs (no source compilation) in CI, Binder, Gitpod, Pixi etc.
## See: https://packagemanager.posit.co/ and https://packagemanager.rstudio.com/
rspm_url <- "https://packagemanager.rstudio.com/all/latest"
options(repos = c(CRAN = rspm_url))
# Prefer binaries on Windows/macOS, but on Linux R does not support type='binary'
sysname <- tolower(Sys.info()["sysname"] %||% "")
if (sysname %in% c("windows", "darwin")) {
  options(pkgType = "binary")
} else {
  # Linux: install from RSPM; R will use source packages where binaries are not
  # supported by the local R installation. RSPM still speeds up installs by
  # providing prebuilt packages appropriate for many Linux targets.
  options(pkgType = "source")
}

if (file.exists("DESCRIPTION")) {
  remotes::install_local(dependencies = TRUE, ask = FALSE)
} else {
  remotes::install_github('itsleeds/tds', dependencies = TRUE, ask = FALSE)
}

