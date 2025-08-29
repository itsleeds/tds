if (file.exists("DESCRIPTION")) {
  remotes::install_local(ask = FALSE)
} else {
  remotes::install_github('itsleeds/tds', ask = FALSE)
}

