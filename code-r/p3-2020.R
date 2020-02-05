# aim: demo around practical 1
library(tidyverse)

d_by_bus = d %>% filter(like_bus_travel)
mean(d_by_bus$n_coffee)

b_not_by_bus = d %>% filter(!like_bus_travel)
mean(b_not_by_bus$n_coffee)

d %>% 
  group_by(like_bus_travel) %>% 
  summarise(mean_coffee = mean(n_coffee))

# tapply...

zones = pct::get_pct_zones(region = "west-yorkshire")
sf::st_crs(zones) = 4326
index_max_bicycle = which.max(zones$bicycle)
max(zones$bicycle)
zones$bicycle[index_max_bicycle]

zone_max_bicycle = zones %>% filter(bicycle == max(bicycle))
zone_max_bicycle_10 = zones %>% top_n(n = 20, wt = bicycle)
mapview::mapview(zone_max_bicycle_10)
zone_max_bicycle = zones[which.max(zones$bicycle), ]
plot(zone_max_bicycle)
sf::st_crs(zone_max_bicycle) = 4326
mapview::mapview(zone_max_bicycle)
