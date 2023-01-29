packageVersion("stplanr")
pkgs = c("dodgr", "dplyr", "knitr", "opentripplanner", "osmextract", 
         "remotes", "sf", "stplanr", "tidyverse", "tmap")
remotes::install_cran(pkgs) # install the stplanr package if not up-to-date

library(sf)         # Spatial data functions
library(tidyverse)  # General data manipulation
library(stplanr)    # General transport data functions
library(dodgr)      # Local routing and network analysis
library(opentripplanner) # Connect to and use OpenTripPlanner
library(tmap)       # Make maps
library(osmextract) # Download and import OpenStreetMap data
tmap_mode("plot")

## ---- eval=TRUE, message=FALSE, warning=FALSE--------------------------------------------------------
# ip = "localhost" # to run it on your computer (see final bonus exercise)
ip = "otp.saferactive.org" # an actual server
otpcon = otp_connect(hostname = ip, 
                     port = 80,
                     router = "west-yorkshire")

u = "https://github.com/ITSLeeds/TDS/releases/download/22/NTEM_flow.geojson"
desire_lines = read_sf(u)
head(desire_lines)

u = "https://github.com/ITSLeeds/TDS/releases/download/22/NTEM_cents.geojson"
centroids = read_sf(u)
head(centroids)


tm_shape(desire_lines) +
  tm_lines(lwd = "all", col = "all", scale = 4, palette = "viridis")


tm_shape(desire_lines) +
  tm_lines(lwd = "rail", col = "rail", scale = 4, palette = "viridis", style = "jenks")

