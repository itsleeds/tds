## Use Posit Public Package Manager (RSPM) to prefer prebuilt binary CRAN packages
## This speeds up installs (no source compilation) in CI, Binder, Gitpod, Pixi etc.
## See: https://packagemanager.posit.co/ and https://packagemanager.rstudio.com/
rspm_url <- "https://packagemanager.rstudio.com/all/latest"
options(repos = c(CRAN = rspm_url))
# Prefer binaries on Windows/macOS, but on Linux R does not support type='binary'
sysname <- tolower(Sys.info()["sysname"] %||% "")
## Use pak with Posit Public Package Manager (RSPM) so installs prefer
## RSPM-provided binaries where available. pak will fall back to source
## only when binaries are not available for the platform/version.
rspm_url <- "https://packagemanager.rstudio.com/all/latest"
options(repos = c(CRAN = rspm_url))

# Ensure pak is available (install from RSPM)
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak", repos = rspm_url)
}

# Use pak to install the package and dependencies. pak prefers binaries from
# RSPM on supported platforms and will significantly reduce compile time.
if (file.exists("DESCRIPTION")) {
  pak::local_install(ask = FALSE)
} else {
  pak::pak("itsleeds/tds", ask = FALSE)
}

