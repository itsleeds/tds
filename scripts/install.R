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

# Install dodgr from CRAN source with a patch for R >= 4.6 / Rcpp compatibility.
# CRAN version 0.4.3 fails to compile with R >= 4.6.0 because Rcpp's
# const_string_proxy operator== / operator!= become ambiguous between multiple
# built-in and Rcpp-defined candidates. The dodgr-to-sf.cpp compares Rcpp
# CharacterVector proxy objects directly (new_edges[i] == new_edges[i-1])
# which hits this ambiguity.
if (!requireNamespace("dodgr", quietly = TRUE) ||
    packageVersion("dodgr") <= "0.4.3") {
  tmpdir <- tempfile()
  dir.create(tmpdir)
  on.exit(unlink(tmpdir, recursive = TRUE))

  utils::download.file(
    "https://cran.r-project.org/src/contrib/dodgr_0.4.3.tar.gz",
    file.path(tmpdir, "dodgr.tar.gz")
  )
  utils::untar(file.path(tmpdir, "dodgr.tar.gz"), exdir = tmpdir)

  # Patch dodgr-to-sf.cpp:
  # Wrap all Rcpp CharacterVector element comparisons in static_cast<std::string>
  # to avoid ambiguous proxy operator== / operator!= in Rcpp >= 1.1.x with R >= 4.6.
  src_file <- file.path(tmpdir, "dodgr", "src", "dodgr-to-sf.cpp")
  src <- readLines(src_file)

  # Debug: count matches before
  before_eq <- sum(grepl("new_edges \\[i\\] == new_edges \\[i - 1\\]", src))
  before_neq <- sum(grepl("new_edges \\[i\\] != new_edges \\[i - 1\\]", src))
  cat("dodgr patch: found", before_eq, "== and", before_neq, "!= comparisons\n")

  # Fix new_edges[i] == new_edges[i-1]
  src <- gsub(
    "if \\(new_edges \\[i\\] == new_edges \\[i - 1\\]\\)",
    "if (std::string(new_edges[i]) == std::string(new_edges[i - 1]))",
    src
  )
  # Fix new_edges[i] != new_edges[i-1]
  src <- gsub(
    "if \\(new_edges \\[i\\] != new_edges \\[i - 1\\]\\)",
    "if (std::string(new_edges[i]) != std::string(new_edges[i - 1]))",
    src
  )

  # Debug: count matches after
  after_eq <- sum(grepl("new_edges \\[i\\] == new_edges \\[i - 1\\]", src))
  after_neq <- sum(grepl("new_edges \\[i\\] != new_edges \\[i - 1\\]", src))
  cat("dodgr patch: remaining", after_eq, "== and", after_neq, "!= comparisons\n")
  cat("dodgr patch: std::string == count:", sum(grepl("std::string\\(new_edges\\[i\\]\\) == std::string\\(new_edges\\[i - 1\\]\\)", src)), "\n")
  cat("dodgr patch: std::string != count:", sum(grepl("std::string\\(new_edges\\[i\\]\\) != std::string\\(new_edges\\[i - 1\\]\\)", src)), "\n")

  writeLines(src, src_file)

  # Install patched dodgr from source using pak (which handles dependencies)
  pak::pkg_install(paste0("local::", file.path(tmpdir, "dodgr")), ask = FALSE)
}


# Use pak to install the package and dependencies. pak prefers binaries from
# RSPM on supported platforms and will significantly reduce compile time.
if (file.exists("DESCRIPTION")) {
  pak::local_install(ask = FALSE)
} else {
  pak::pak("itsleeds/tds", ask = FALSE)
}
