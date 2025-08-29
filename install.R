if (file.exists("DESCRIPTION")) {
  remotes::install_local(repos = c('https://geocompx.r-universe.dev', 'https://cloud.r-project.org'), ask = FALSE)
} else {
  remotes::install_github('itsleeds/tds', repos = c('https://geocompx.r-universe.dev', 'https://cloud.r-project.org'), ask = FALSE)
}

