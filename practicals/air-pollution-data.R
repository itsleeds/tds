# get air pollution data
remotes::install_github("jimhester/archive")
download.file("https://github.com/ITSLeeds/TDS/releases/download/0.2/aq.7z", "aq.7z")
archive::archive("aq.7z")
archive::archive_extract("aq.7z")
file.edit("airquality.r")
