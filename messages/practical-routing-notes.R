library(sf)
library(tidyverse)
library(stplanr)
library(dodgr) # Local routing and network analysis
library(opentripplanner) # Connect to and use OpenTripPlanner
library(tmap) # Make maps
library(osmextract) # Download and import OpenStreetMap data
tmap_mode("plot")

ip = "otp.saferactive.org" # an actual server
otpcon = otp_connect(hostname = ip, 
                     port = 80,
                     router = "west-yorkshire")

u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
desire_lines = read_sf(u)
dim(desire_lines)

desire_lines = desire_lines %>%
  select(geo_code1, geo_code2, all, bicycle, foot, car_driver)
names(desire_lines)

tmaptools::palette_explorer()

tm_shape(desire_lines) +
  tm_lines(lwd = "all", col = "car_driver",
           palette = "-viridis")


desire = bind_cols(desire_lines, line2df(desire_lines))
desire = st_drop_geometry(desire)

desire_top = slice_max(desire, order_by = all, n = 3)


desire_top_origin = as.matrix(desire_top[,c("fx","fy")])
desire_top_destination = as.matrix(desire_top[,c("tx","ty")])
routes_top = otp_plan(otpcon,
                      fromPlace = desire_top_origin,
                      toPlace = desire_top_destination,
                      mode = "CAR")

u = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/transit_routes.gpkg"
download.file(url = u, destfile = "transit_routes.gpkg", mode = "wb")
u = "https://github.com/ITSLeeds/TDS/releases/download/0.20.1/driving_routes.gpkg"
download.file(url = u, destfile = "driving_routes.gpkg", mode = "wb")

routes_drive = read_sf("driving_routes.gpkg")
routes_transit = read_sf("transit_routes.gpkg")

routes_drive = routes_drive %>%
  select(fromPlace, toPlace, mode, route_option, distance)
routes_transit = routes_transit %>%
  select(fromPlace, toPlace, mode, route_option, distance)

desire_drive = left_join(desire, routes_drive,
                         by = c("geo_code1" = "fromPlace",
                                "geo_code2" = "toPlace"))

desire_drive = st_as_sf(desire_drive)
plot(desire_drive[1, ])


desire_transit = left_join(desire, routes_transit,
                         by = c("geo_code1" = "fromPlace",
                                "geo_code2" = "toPlace"))

desire_transit = st_as_sf(desire_transit)

desire_drive = desire_drive[!is.na(desire_drive$mode),]
desire_transit = desire_transit[!is.na(desire_transit$mode),]


rnet_drive <- overline(desire_drive, "car_driver")


roads = oe_get("Isle of Wight", extra_tags = c("maxspeed","oneway"))
roads = roads[!is.na(roads$highway),]
road_types = c("residential","secondary","tertiary",
               "unclassified","primary","primary_link",
               "secondary_link","tertiary_link")


roads = roads[roads$highway %in% road_types, ]
graph = weight_streetnet(roads)

estimate_centrality_time(graph)
graph = dodgr_contract_graph(graph)
centrality = dodgr_centrality(graph)

clear_dodgr_cache()
centrality_sf = dodgr_to_sf(centrality)

tmap_mode("view")
tm_shape(centrality_sf) +
  tm_lines("centrality",
          lwd = 3,
          n = 8,
          style = "fisher",
          palette = "-viridis")
