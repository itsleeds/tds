crashes = stats19::get_stats19(year = 2018, type = "accidents")
casualties = stats19::get_stats19(year = 2018, type = "casualties")
head(crashes)
names(crashes)
summary(crashes$speed_limit)
summary(crashes$datetime)
plot(crashes$datetime)
head(crashes$datetime)
head(crashes$police_force)
plot(factor(crashes$police_force))

library(ggplot2)

ggplot(crashes, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill")


library(stplanr)
library(sf)
library(tmap)

flowlines_sf
tm_shape(flowlines_sf) +
  tm_lines() +
  tm_shape(flowlines_sf) +
  tm_lines(lwd = 5, col = "red", alpha = 0.2) +
  tm_shape(routes_fast_sf) +
  tm_lines(col = "green")


# get travel data for UK regions
pct::pct_regions$region_name
mapview::mapview(pct::pct_regions)

region_name = "cheshire"
zones_region = pct::get_pct_zones(region = region_name)
library(tmap)
tm_shape(zones_region) + tm_polygons("bicycle")

desire_lines = pct::get_pct_lines(region = region_name)
tm_shape(zones_region) + tm_polygons("bicycle") +
  tm_shape(desire_lines) + tm_lines("bicycle", palette = "viridis")

# get crash data
crashes = stats19::get_stats19(year = 2018, type = "ac")
crashes_sf = stats19::format_sf(crashes, lonlat = TRUE)
crashes_region = crashes_sf[zones_region, ]

desire_lines = pct::get_pct_lines(region = region_name)
tm_shape(zones_region) + tm_polygons("bicycle") +
  tm_shape(desire_lines) + tm_lines("bicycle", palette = "viridis") +
  tm_shape(crashes_region) + tm_dots()

plot(desire_lines$foot, desire_lines$bus)
m = lm(foot ~ bus + e_dist_km, data = desire_lines)
m
summary(m)

library(osmdata)
tube_network = opq("london") %>% 
  add_osm_feature(key = "railway", value = "subway") %>% 
  osmdata_sf()

mapview::mapview(tube_network$osm_lines)
