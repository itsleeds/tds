x = 1:9
y = sqrt(x)
m = cbind(x, y)
plot(m)

# roads in Leeds
library(osmdata)
# roads_leeds = opq("leeds") %>% 
#   add_osm_feature("highway") %>% 
#   osmdata_sf()
cycleway_leeds = opq("leeds") %>%
  add_osm_feature("highway", "cycleway") %>%
  osmdata_sf()
library(sf)
cw = cycleway_leeds$osm_lines
plot(cw)

u = "https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/west-yorkshire/l.geojson"
library(dplyr)
library(sf)
desire_lines_all = read_sf(u)
plot(desire_lines_all$geometry)
plot(cw, add = T, col = "green")
