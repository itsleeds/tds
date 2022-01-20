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

u = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/west-yorkshire/z.geojson"
zones = sf::read_sf(u)
mapview::mapview(zones)

u_zip = "https://www.nomisweb.co.uk/output/census/2011/wu02ew_msoa.zip"
u_zip = "https://www.nomisweb.co.uk/output/census/2011/wu01ew_msoa.zip"
f_zip = basename(u_zip)
f_zip
download.file(url = u_zip, destfile = f_zip)
od_uk = read_csv(f_zip)
nrow(od_uk)
summary(od_uk)
od_uk_100_plus = od_uk %>% 
  rename(all = `All categories: Sex`) %>% 
  filter(all > 100)

summary(od_uk_100_plus$`Area of residence` %in% zones$geo_code)

od_uk_100_plus_yorkshire = od_uk_100_plus %>% 
  filter(`Area of residence` %in% zones$geo_code) %>% 
  filter(`Area of workplace` %in% zones$geo_code)

desire_lines = od2line(flow = od_uk_100_plus_yorkshire, zones)
mapview::mapview(desire_lines)

od_female = od_uk_100_plus_yorkshire %>% 
  filter(Female < Male)

