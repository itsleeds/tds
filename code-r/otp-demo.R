# Aim: set-up and use local routing service

# Settings: Things to change to work on your PC
path_data = file.path(tempdir(),"otp")


# Check Java: Linux Only
# install java with sudo apt install openjdk-8-jdk on Ubuntu
# system("which javac")
# system("java -version")
# system("update-java-alternatives --list")
# system("sudo update-java-alternatives --set /usr/lib/jvm/java-1.8.0-openjdk-amd64")

# Setup:
devtools::install_github("ropensci/opentripplanner", build_vignettes = TRUE)
devtools::install_github("itsleeds/geofabrik")

library(geofabrik)
library(opentripplanner)

# Make file structure, download files
dir.create(path_data) 
dir.create(file.path(path_data, "graphs"))
dir.create(file.path(path_data, "graphs", "default"))
path_otp = otp_dl_jar(path_data)
wy <- geofabrik::gf_find("West Yorkshire")
download.file(wy$pbf_url, file.path(path_data,"graphs","default","wy.pbf"))
gtfs_url = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/wy_rail.zip"

add_gtfs_data = function(gtfs_url, path_data, router = "default", gtfs_filename = "gtfs.zip") {
  download.file(gtfs_url, file.path(path_data, "graphs", router, gtfs_filename))
}

add_gtfs_data(gtfs_url = gtfs_url, path_data = path_data)

log1 = otp_build_graph(otp = path_otp, dir = path_data)
log2 = otp_setup(otp = path_otp, dir = path_data) 

otpcon = otp_connect()
route_walk = otp_plan(otpcon, 
                  fromPlace = c(-1.54804, 53.79335), 
                  toPlace = c(-1.52264, 53.82964), mode = "WALK")

route_car = otp_plan(otpcon, 
                  fromPlace = c(-1.54804, 53.79335), 
                  toPlace = c(-1.52264, 53.82964), mode = "CAR")

mapview::mapview(route_walk)

