# Aim: set-up and use local routing service

devtools::install_github("ropensci/opentripplanner", build_vignettes = TRUE)
devtools::install_github("itsleeds/geofabrik")

library(geofabrik)
library(opentripplanner)

otp_data = geofabrik::gf_filename("West Yorkshire")
# vignette("opentripplanner")

path_data <- "/home/robin/hd/data/otp"
dir.create(path_data) 

dir.create(file.path(path_data, "graphs"))
dir.create(file.path(path_data, "graphs", "default"))

file.copy(otp_data, file.path(path_data, "graphs", "default"))
path_otp <- otp_dl_jar(path_data)

# install java with sudo apt install openjdk-8-jdk on Ubuntu

system("which javac")
system("java -version")
system("update-java-alternatives --list")
# system("sudo update-java-alternatives --set /usr/lib/jvm/java-1.8.0-openjdk-amd64")

log1 <- otp_build_graph(otp = path_otp, dir = path_data)

# 2020-01-29 11:14:54 Basic checks completed, building graph, this may take a few minutes
# The graph will be saved to /home/robin/hd/data/otp
# 2020-01-29 11:15:19 Graph built

log2 <- otp_setup(otp = path_otp, dir = path_data)
log2 <- otp_setup(otp = path_otp, dir = path_data, port = 8801, securePort = 8802)
otpcon <- otp_connect()
route <- otp_plan(otpcon, 
                  fromPlace = c(-1.54804, 53.79335), 
                  toPlace = c(-1.52264, 53.82964), mode = "WALK")
