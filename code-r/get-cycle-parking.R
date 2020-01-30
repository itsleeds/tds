# aim: get cycle parking data

library(geofabrik)
library(dplyr)
osm_points = get_geofabrik(name = "West Yorkshire", layer = "points")
cycle_parking = osm_points %>% filter(amenity == "bicycle_parking")
cycle_parking
mapview::mapview(cycle_parking)
