## Use Posit Public Package Manager (P3M) to prefer prebuilt binary CRAN packages
## This speeds up installs (no source compilation) in CI, Binder, Codespaces, Docker, etc.
current_cran <- getOption("repos")["CRAN"]
if (is.na(current_cran) || current_cran == "@CRAN@" || !grepl("p3m\\.dev|packagemanager", current_cran)) {
  if (tolower(Sys.info()[["sysname"]]) == "linux" && file.exists("/etc/os-release")) {
    os_lines <- readLines("/etc/os-release", warn = FALSE)
    codename_line <- grep("^VERSION_CODENAME=", os_lines, value = TRUE)
    codename <- gsub('^VERSION_CODENAME="?([^"]+)"?$', "\\1", codename_line[1])
    if (length(codename) == 1 && nzchar(codename)) {
      rspm_url <- sprintf("https://p3m.dev/cran/__linux__/%s/latest", codename)
    } else {
      rspm_url <- "https://p3m.dev/cran/latest"
    }
    options(
      repos = c(CRAN = rspm_url),
      HTTPUserAgent = sprintf(
        "R/%s R (%s)",
        getRversion(),
        paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])
      )
    )
  } else {
    rspm_url <- "https://p3m.dev/cran/latest"
    options(repos = c(CRAN = rspm_url))
  }
}

# Ensure pak is available (install from configured binary repository)
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak")
}

# Use pak to install the package and dependencies. pak prefers binaries from
# P3M on supported platforms and significantly reduces compile time.
if (file.exists("DESCRIPTION")) {
  pak::local_install(ask = FALSE, upgrade = FALSE)
} else {
  pak::pak("itsleeds/tds", ask = FALSE, upgrade = FALSE)
}
