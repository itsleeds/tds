library(sf)
library(tmap)
library(dplyr)

region = "west-yorkshire"

u = paste0(
  "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/",
  region,
  "/l.geojson"
  )

desire_lines = read_sf(u)
desire_lines_1000 = desire_lines %>% 
  top_n(1000, all)
plot(desire_lines_1000$geometry)

car_dependent_routes = desire_lines_1000 %>% 
  mutate(percent_drive = car_driver / all * 100) %>% 
  filter(rf_dist_km < 3 & rf_dist_km > 1) 

b = c(0, 25, 50, 75)
tm_shape(car_dependent_routes) +
  tm_lines(col = "percent_drive", lwd = "all", scale = 5, breaks = b, palette = "-inferno")



# roads in Leeds
library(osmdata)
# roads_leeds = opq("leeds") %>% 
#   add_osm_feature("highway") %>% 
#   osmdata_sf()
# cycleway_leeds = opq("leeds") %>%
#   add_osm_feature("highway", "cycleway") %>%
#   osmdata_sf()
library(sf)
cw = cycleway_leeds$osm_lines
plot(cw)