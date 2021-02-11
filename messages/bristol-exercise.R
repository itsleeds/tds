# Aim: read-in and analyse medium sized dataset

remotes::install_github("nowosad/spDataLarge")
library(tidyverse)
library(sf)
library(tmap)

od = spDataLarge::bristol_od
head(od)
View(od)
class(od)

zones = spDataLarge::bristol_zones
names(zones)

zones = zones %>% 
  mutate(local_authority = word(string = name, start = 1))
zones %>% 
  slice(1:5) %>% 
  pull(name)

plot(zones %>% select(local_authority), key.pos = 1)
zones %>% slice(1:3)

tmap_mode(mode = "view")
tm_shape(zones) +
  # tm_polygons(col = "name") # not working
  tm_polygons(col = "local_authority")

bristol_sf = tmaptools::geocode_OSM("bristol", as.sf = TRUE, return.first.only = T, geometry = "point")
mapview::mapview(bristol_sf)

bristol_buffer = stplanr::geo_buffer(bristol_sf, dist = 10000)
mapview::mapview(bristol_buffer)
zones_central = zones[bristol_buffer, , op = sf::st_within]
mapview::mapview(zones_central)

od_central = od %>%
  filter(o %in% zones_central$geo_code) %>% 
  filter(d %in% zones_central$geo_code) 
nrow(od_central) / nrow(od)

library(stplanr)
desire_lines = od2line(od_central, zones_central)

## Creating centroids representing desire line start and end points.

desire_lines$distance_direct_m = as.numeric(st_length(desire_lines))
desire_lines = desire_lines %>% 
  mutate(proportion_active = (bicycle + foot) / all)

# visualise
ggplot(desire_lines) +
  geom_point(aes(distance_direct_m, proportion_active))
ggplot(desire_lines) +
  geom_point(aes(distance_direct_m, proportion_active, size = all), alpha = 0.3)

# model/visualise
m1 = lm(proportion_active ~ 
          distance_direct_m + I(distance_direct_m^2),
        data = desire_lines)
desire_lines = desire_lines %>% 
  mutate(
    new_active_travel = m1$fitted.values * car_driver,
    new_total_active = new_active_travel + bicycle + foot,
    new_proportion_active = new_total_active / all
  ) %>% 
  arrange(proportion_active)
ggplot(desire_lines) +
  geom_point(aes(distance_direct_m, proportion_active, size = all), alpha = 0.3) +
  geom_point(aes(distance_direct_m, new_proportion_active, size = all), alpha = 0.3, colour = "blue")


l = desire_lines %>% filter(all > 500) %>% 
  filter(o != d)
r = stplanr::route(l = l, route_fun = route_osrm)
mapview::mapview(r) +
  mapview::mapview(l)


# get data leeds ----------------------------------------------------------
