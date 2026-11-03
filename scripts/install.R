## Use Posit Public Package Manager (P3M) to prefer prebuilt binary CRAN packages
## This speeds up installs (no source compilation) in CI, Binder, Codespaces, Docker, etc.
options(pkg.sysreqs = FALSE, repos = c(geocompx = "https://geocompx.r-universe.dev", getOption("repos")))
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
      repos = c(geocompx = "https://geocompx.r-universe.dev", CRAN = rspm_url),
      pkg.sysreqs = FALSE,
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

# Ensure vscode-R bundled 'sess' package is pre-installed so VS Code sessionWatcher attaches without prompting
if (!requireNamespace("sess", quietly = TRUE) && requireNamespace("jsonlite", quietly = TRUE)) {
  try({
    js <- jsonlite::fromJSON("https://api.github.com/repos/REditorSupport/vscode-R/releases/latest")
    u <- js[["assets"]][["browser_download_url"]][grepl("\\.vsix$", js[["assets"]][["browser_download_url"]])][1]
    tf <- tempfile(fileext = ".vsix")
    td <- tempfile()
    download.file(u, tf, mode = "wb", quiet = TRUE)
    f <- unzip(tf, list = TRUE)[["Name"]]
    unzip(tf, files = f[startsWith(f, "extension/dist/resources/sess/")], exdir = td)
    install.packages(file.path(td, "extension/dist/resources/sess"), repos = NULL, type = "source", quiet = TRUE)
    unlink(c(tf, td), recursive = TRUE)
  }, silent = TRUE)
}
