# Visualisation: basic code from practical 4

library(tidyverse)

crashes_gb = stats19::get_stats19(year = 2019)

names(crashes_gb)
ggplot(crashes_gb) +
  geom_bar(aes(accident_severity))

class(crashes_gb$speed_limit)
crashes_gb$speed_limit = as.character(crashes_gb$speed_limit)
class(crashes_gb$speed_limit)
ggplot(crashes_gb, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill")

# example of global settings
ggplot(crashes_gb, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill", alpha = 0.3)

# manual colour palette
ggplot(crashes_gb, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill") +
  scale_fill_manual(values = c("red", "yellow", "blue"))

ggplot(crashes_gb, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill") +
  scale_fill_brewer(palette = "Reds") +
  facet_grid(~ speed_limit)


ggplot(crashes_gb, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill") 


ggplot(crashes_gb, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill") +
  scale_y_continuous(labels = scales::percent, name = "Percent") 


# show layers
crashes_gb_fatal = crashes_gb %>% 
  filter(accident_severity == "Fatal")
nrow(crashes_gb_fatal) / nrow(crashes_gb)

ggplot(crashes_gb) +
  geom_point(aes(x = date, y = time), alpha = 0.1) +
  geom_point(aes(x = date, y = time),
             alpha = 0.1, data = crashes_gb_fatal, colour = "red")

b = c("07:00", "09:00", "12:00", "17:00", "19:00")
ggplot(crashes_gb) +
  geom_point(aes(datetime, time), alpha = 0.01) +
  geom_point(aes(datetime, time), alpha = 0.1, data = crashes_gb_fatal, colour = "red") +
  scale_y_discrete(breaks = b)

# Demonstrate geographic data visualisation techniques

# get some data
# searching internet...
u = "https://npttile.vs.mythic-beasts.com/npct-data/pct-outputs-regional-notR/commute/msoa/isle-of-wight/z.geojson"
zones = sf::read_sf(u)

# basic visualisation
plot(zones)

library(tmap)
tm_shape(zones) +
  tm_polygons()

# driving
names(zones)[1:15]
tm_shape(zones) +
  tm_polygons(col = "car_driver")

View(zones)
summary(zones$all)

# Saving a plot
map1 = tm_shape(zones) +
  tm_polygons(col = "car_driver")
tmap_save(tm = map1, filename = "isle-of-wight-drive.png")

# boundaries
bounding_box = sf::st_bbox(zones)
bounding_box

# multiple layers
pct::pct_regions$region_name
routes = pct::get_pct_routes_fast(region = "isle-of-wight")

tm_shape(zones) +
  tm_polygons(col = "car_driver") +
  tm_shape(routes) +
  tm_lines(lwd = "all")

tmap_mode("view")

tm_shape(zones) +
  tm_polygons(col = "car_driver") +
  tm_shape(routes) +
  tm_lines(lwd = "all")

