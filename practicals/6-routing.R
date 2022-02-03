packageVersion("stplanr")
remotes::install_cran("stplanr") # install the stplanr package if not up-to-date

library(sf)         # Spatial data functions
library(tidyverse)  # General data manipulation
library(stplanr)    # General transport data functions
library(dodgr)      # Local routing and network analysis
library(opentripplanner) # Connect to and use OpenTripPlanner
library(tmap)       # Make maps
library(osmextract) # Download and import OpenStreetMap data
tmap_mode("plot")


## ----otpgui, echo = FALSE, fig.align='center', fig.cap="OTP Web GUI"---------------------------------
# knitr::include_graphics("otp_screenshot.png")
knitr::include_graphics("https://github.com/ITSLeeds/TDS/blob/master/practicals/otp_screenshot.png?raw=true")


## ---- echo=FALSE, eval=FALSE-------------------------------------------------------------------------
## piggyback::pb_upload("otp_TDS.zip")
## piggyback::pb_download_url("otp_TDS.zip")
## # https://github.com/ITSLeeds/TDS/releases/download/0.20.1/otp_TDS.zip


## # java –Xmx10000M -d64 -jar "D:/OneDrive - University of Leeds/Data/opentripplanner/otp-1.5.0-shaded.jar" --router west-yorkshire --graphs "D:/OneDrive - University of Leeds/Data/opentripplanner/graphs" --server --port 8080 --securePort 8081

## sudo update-alternatives --config java

## # java --version

## java -version

## java -Xmx10000M -d64 -jar "/home/robin/programs/otp1.5/otp_TDS/otp-1.5.0-shaded.jar" --router west-yorkshire --graphs "/home/robin/programs/otp1.5/otp_TDS/graphs" --server --port 8080 --securePort 8081

## # ip = "xx.x.218.83"


## ---- eval=TRUE, message=FALSE, warning=FALSE--------------------------------------------------------
# ip = "localhost" # to run it on your computer (see final bonus exercise)
ip = "otp.saferactive.org" # an actual server
otpcon = otp_connect(hostname = ip, 
                     port = 80,
                     router = "west-yorkshire")


## ---- message=FALSE----------------------------------------------------------------------------------
u = "https://github.com/ITSLeeds/TDS/releases/download/22/NTEM_flow.geojson"
desire_lines = read_sf(u)
head(desire_lines)


## ---- message=FALSE----------------------------------------------------------------------------------
u = "https://github.com/ITSLeeds/TDS/releases/download/22/NTEM_cents.geojson"
centroids = read_sf(u)
head(centroids)


## ---- message=FALSE, echo=TRUE-----------------------------------------------------------------------
tmap_mode("plot") #Change to view for interactive map
tm_shape(desire_lines) +
  tm_lines(lwd = "all", col = "all", scale = 4, palette = "viridis")


## ---- message=FALSE, echo=FALSE----------------------------------------------------------------------
tmap_mode("plot") #Change to view for interactive map
tm_shape(desire_lines) +
  tm_lines(lwd = "rail", col = "rail", scale = 4, palette = "viridis", style = "jenks")


## ---- eval=TRUE, echo=FALSE--------------------------------------------------------------------------
desire_top = desire_lines %>% 
  top_n(n = 3, wt = all)


## ---- message=FALSE----------------------------------------------------------------------------------
routes_drive_top = route(l = desire_top, route_fun = otp_plan, otpcon = otpcon, mode = "CAR")


## ---- eval=FALSE, echo=FALSE-------------------------------------------------------------------------
## # Old way of doing it using zone centroids:
## fromPlace = centroids[match(desire_top$from, centroids$Zone_Code),]
## toPlace = centroids[match(desire_top$to, centroids$Zone_Code),]
## routes_drive_top = otp_plan(otpcon = otpcon,
##                             fromPlace = fromPlace,
##                             toPlace = toPlace,
##                             fromID = fromPlace$Zone_Code,
##                             toID = toPlace$Zone_Code,
##                             mode = "CAR")
## waldo::compare(routes_drive_top, routes_drive_top_new)


## ----------------------------------------------------------------------------------------------------
tmap_mode("plot")
tm_shape(routes_drive_top) + tm_lines()


## ---- message=FALSE, eval=TRUE-----------------------------------------------------------------------
isochrone = otp_isochrone(otpcon, fromPlace = c(-1.558655, 53.807870), 
                          mode = c("BICYCLE","TRANSIT"),
                          maxWalkDistance = 3000)
isochrone$time = isochrone$time / 60
tm_shape(isochrone) +
  tm_fill("time", alpha = 0.6)


## ---- message=FALSE, eval=FALSE, echo=FALSE----------------------------------------------------------
## routes_drive = route(l = desire_lines, route_fun = otp_plan, otpcon = otpcon, mode = "CAR")
## # fromPlace = centroids[match(desire_lines$from, centroids$Zone_Code),]
## # toPlace = centroids[match(desire_lines$to, centroids$Zone_Code),]
## # routes_drive = otp_plan(otpcon = otpcon,
## #                             fromPlace = fromPlace,
## #                             toPlace = toPlace,
## #                             fromID = fromPlace$Zone_Code,
## #                             toID = toPlace$Zone_Code,
## #                             mode = "CAR",
## #                             ncores = 20)
## 
## sf::write_sf(routes_drive, "routes_drive.geojson", delete_dsn = TRUE)
## piggyback::pb_upload("routes_drive.geojson")
## 
## date_time = lubridate::ymd_hms("2022-01-25 09:00:00")
## routes_transit = route(
##   l = desire_lines, route_fun = otp_plan, otpcon = otpcon,
##   mode = c("WALK","TRANSIT"), date_time = date_time, maxWalkDist = 2000
##   )
## 
## # routes_transit = otp_plan(otpcon = otpcon,
## #                             fromPlace = fromPlace,
## #                             toPlace = toPlace,
## #                             fromID = fromPlace$Zone_Code,
## #                             toID = toPlace$Zone_Code,
## #                             mode = c("WALK","TRANSIT"),
## #                             date_time = date_time,
## #                             ncores = 20,
## #                             maxWalkDistance = 2000)
## summary(st_is_valid(routes_transit))
## routes_transit = st_make_valid(routes_transit)
## sf::write_sf(routes_transit, "routes_transit.geojson", delete_dsn = TRUE)
## piggyback::pb_upload("routes_transit.geojson")


## ---- message=FALSE, eval=TRUE, echo=TRUE------------------------------------------------------------
u = "https://github.com/ITSLeeds/TDS/releases/download/22/routes_drive.geojson"
routes_drive = read_sf(u)
u = "https://github.com/ITSLeeds/TDS/releases/download/22/routes_transit.geojson"
routes_transit = read_sf(u)


## ---- message=FALSE, eval=TRUE, echo=FALSE-----------------------------------------------------------
n_driver = desire_lines %>%
  st_drop_geometry() %>%
  select(from, to, drive)


## ---- message=FALSE, eval=TRUE, echo=FALSE-----------------------------------------------------------
routes_drive = left_join(routes_drive, n_driver, by = c("fromPlace" = "from","toPlace" = "to"))


## ---- message=FALSE, eval=TRUE, echo=TRUE------------------------------------------------------------
rnet_drive = overline(routes_drive, "drive")


## ---- message=FALSE, eval=TRUE, echo=FALSE-----------------------------------------------------------
tm_shape(rnet_drive) +
  tm_lines(lwd = 2, col = "drive", style = "jenks", palette = "-viridis")


## ---- eval=TRUE, message=FALSE, echo=FALSE-----------------------------------------------------------
routes_transit = routes_transit %>%
  filter(route_option == 1) %>%
  select(fromPlace, toPlace, distance)


## ---- eval=TRUE, message=FALSE-----------------------------------------------------------------------
routes_transit_group = routes_transit %>%
  dplyr::group_by(fromPlace, toPlace) %>%
  dplyr::summarise(distance = sum(distance))


## ---- eval=FALSE-------------------------------------------------------------------------------------
## routes_transit_group_ml = routes_transit_group[st_geometry_type(routes_transit_group) == "MULTILINESTRING", ]
## routes_transit_group = routes_transit_group[st_geometry_type(routes_transit_group) != "MULTILINESTRING", ]
## routes_transit_group_ml = st_line_merge(routes_transit_group_ml)
## routes_transit_group = rbind(routes_transit_group, routes_transit_group_ml)


## ---- message=FALSE, eval=TRUE, echo=FALSE-----------------------------------------------------------
tm_shape(routes_transit_group) +
  tm_lines(lwd = 2, col = "black", palette = "-viridis")


## ---- eval=TRUE, warning=FALSE, message=FALSE, results='hide'----------------------------------------
roads = oe_get("Isle of Wight", extra_tags = c("maxspeed","oneway"))
roads = roads[!is.na(roads$highway),]
road_types = c("primary","primary_link",
               "secondary","secondary_link",
               "tertiary", "tertiary_link",
               "residential","unclassified")
roads = roads[roads$highway %in% road_types, ]
graph = weight_streetnet(roads)


## ---- message=TRUE, echo=TRUE------------------------------------------------------------------------
estimate_centrality_time(graph)
centrality = dodgr_centrality(graph)


## ---- message=TRUE, echo=TRUE, results='hide'--------------------------------------------------------
clear_dodgr_cache()
centrality_sf = dodgr_to_sf(centrality)


## ---- message=TRUE, echo=FALSE-----------------------------------------------------------------------
tm_shape(centrality_sf) +
  tm_lines("centrality",
           lwd = 3,
           n = 8,
           style = "fisher",
           palette = "-viridis")


