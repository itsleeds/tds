# Aim: set-up and use local routing service

# Settings: Things to change to work on your PC
path_data = file.path(tempdir(), "otp")


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
library(tmap)
tmap_mode("view")


# test with a remote server -----------------------------------------------

# note: this will only work if the remote instance is working (not reliable)
otpcon = otp_connect(hostname = "86.6.99.6", port = 8080) # To connect to robin's instance

route_walk = otp_plan(otpcon, 
                      fromPlace = c(-1.63078, 53.84675), 
                      toPlace = c(-1.59499, 53.81743), mode = "WALK")
plot(route_walk)


# set-up a local otp server instance --------------------------------------

# Make file structure, download files
dir.create(path_data) 
dir.create(file.path(path_data, "graphs"))
dir.create(file.path(path_data, "graphs", "default"))
path_otp = otp_dl_jar(path_data)
wy = geofabrik::gf_find("West Yorkshire")
download.file(wy$pbf_url, file.path(path_data,"graphs","default","wy.pbf"))
gtfs_url = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/wy_rail8.zip"
dem_url = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/dem.tif"

add_data = function(url, path_data, router = "default", filename = "gtfs.zip") {
  download.file(url, file.path(path_data, "graphs", router, filename))
}

add_data(gtfs_url, path_data, filename = "gtfs.zip")
add_data(dem_url, path_data, filename = "dem.tif")
#otp_dl_demo(path_data)

log1 = otp_build_graph(otp = path_otp, dir = path_data)
log2 = otp_setup(otp = path_otp, dir = path_data) 

otpcon = otp_connect() # if OpenTripPlanner is running locally

route_walk = otp_plan(otpcon, 
                  fromPlace = c(-1.63078, 53.84675), 
                  toPlace = c(-1.59499, 53.81743), mode = "WALK")

route_walk = otp_plan(otpcon, 
                      fromPlace = c(-1.63078, 53.84675), 
                      toPlace = c(-1.59499, 53.81743), mode = "WALK")

route_transit = otp_plan(otpcon, 
                  fromPlace = c(-1.63078, 53.84675), 
                  toPlace = c(-1.59499, 53.81743), mode = c("WALK","TRANSIT"))


qtm(sf::st_zm(route_transit), lines.col = "mode", lines.lwd = 3)

otp_stop()
