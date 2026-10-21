# Configure reticulate to use the system Python and prevent uv autoconfiguration
if (Sys.getenv("RETICULATE_PYTHON") == "") {
  py_path <- Sys.which("python3")
  if (!nzchar(py_path)) py_path <- Sys.which("python")
  if (nzchar(py_path)) Sys.setenv(RETICULATE_PYTHON = py_path)
}
Sys.setenv(RETICULATE_AUTOCONFIGURE = "FALSE")
