install.packages("remotes")
pkgs = c(
  "nycflights13",# data package
  "pct",         # package for getting travel data in the UK
  "sf",          # spatial data package
  "stats19",     # downloads and formats open stats19 crash data
  "stplanr",     # for working with origin-destination and route data
  "tidyverse",   # a package for user friendly data science
  "tmap"         # for making maps
)
remotes::install_cran(pkgs)
remotes::install_github("nowosad/spDataLarge")

install.packages("terra", type = "binary")
?install_cran
od_data = od_data_sample

names(od_data)
# Ctl + Shift + M
od_data_walk = od_data %>% 
  rename(walk = foot) %>% 
  filter(walk > 0) %>% 
  select(geo_code1, geo_code2, all, car_driver, walk, bicycle) %>% 
  mutate(
    proportion_walk = walk / all,
    proportion_drive = car_driver / all
  )
class(od_data)

# calculate the % of OD have at least 1 person walking?
nrow(od_data_walk) / nrow(od_data) * 100
od_data_walk_cycle = od_data_walk %>% 
  mutate(pcycle = bicycle / all)

# Exercise 3
cor(od_data_walk_cycle$proportion_walk, od_data_walk_cycle$pcycle)
plot(od_data_walk_cycle$proportion_walk, od_data_walk_cycle$pcycle)
od_data_walk_cycle %>% 
  ggplot() +
  geom_point(aes(proportion_walk, pcycle)) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(labels = scales::percent) 

?od_data_sample
zones_sf
summary(zones_sf$geo_code %in% od_data$geo_code1)

od_data_sf = od::od_to_sf(x = od_data, z = zones_sf)
library(tmap)
tmap_mode("view")
tm_shape(zones_sf, alpha = 0.2) +
  tm_polygons() +
  tm_shape(od_data_sf) +
  tm_lines() 
?tm_basemap


