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

# Install dodgr from GitHub dev version.
# CRAN version 0.4.3 fails to compile with R >= 4.6 / Rcpp due to
# ambiguous operator== on Rcpp::CharacterVector::const_Proxy and
# Rcpp::Vector '[]' operator returning proxy objects.
# See: https://github.com/UrbanAnalyst/dodgr/pull/330
# The dev version's dodgr-to-sf.cpp still has these issues at the
# HEAD commit, so we patch it inline after checkout.
if (!requireNamespace("dodgr", quietly = TRUE) ||
    packageVersion("dodgr") <= "0.4.3.18") {
  # Download source, patch, install
  tmpdir <- tempfile()
  dir.create(tmpdir)
  on.exit(unlink(tmpdir, recursive = TRUE))

  utils::download.file(
    "https://cran.r-project.org/src/contrib/dodgr_0.4.3.tar.gz",
    file.path(tmpdir, "dodgr.tar.gz")
  )
  utils::untar(file.path(tmpdir, "dodgr.tar.gz"), exdir = tmpdir)

  # Patch dodgr-to-sf.cpp: replace Rcpp CharacterVector operator[] with ()
  # to avoid ambiguous proxy comparison in Rcpp >= 1.1.x / R >= 4.6
  src_file <- file.path(tmpdir, "dodgr", "src", "dodgr-to-sf.cpp")
  src <- readLines(src_file)
  # Fix old_edges[0] -> old_edges(0) (CharacterVector access)
  src <- gsub("old_edges \\[0\\]", "old_edges (0)", src)
  # Fix new_edges[0] -> new_edges(0) (CharacterVector access)
  src <- gsub("new_edges \\[0\\]", "new_edges (0)", src)
  # Fix proxy-to-proxy == comparison
  src <- gsub(
    "if \\(new_edges \\(i\\) == new_edges \\(i - 1\\)\\)",
    "if (std::string(new_edges(i)) == std::string(new_edges(i - 1)))",
    src
  )
  src <- gsub(
    "if \\(new_edges \\(i\\) != new_edges \\(i - 1\\)\\)",
    "if (std::string(new_edges(i)) != std::string(new_edges(i - 1)))",
    src
  )
  writeLines(src, src_file)

  # Install patched dodgr from source
  install.packages(file.path(tmpdir, "dodgr"), repos = NULL, type = "source")
}

# Use pak to install the package and dependencies. pak prefers binaries from
# RSPM on supported platforms and will significantly reduce compile time.
if (file.exists("DESCRIPTION")) {
  pak::local_install(ask = FALSE)
} else {
  pak::pak("itsleeds/tds", ask = FALSE)
}
