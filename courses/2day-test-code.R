# The following code should work on every computer

# test ability to install packages
install.packages("remotes")

# install packages we'll use (remotes is more efficient at installing them)
pkgs = c(
  "pct",
  "stats19",
  "stplanr",
  "tidyverse",
  "sf",
  "tmap",
  "dodgr",
  "osmdata",
  "pbapply"
)
remotes::install_cran(pkgs)

# load the pkgs
lapply(pkgs, library, character.only = TRUE)

# Test link with osmdata works:
osm_data = opq(bbox = "westminster") %>% 
  add_osm_feature(key = "name", value = "Horseferry Road") %>% 
  osmdata_sf()
horseferry_road = osm_data$osm_lines
tmap_mode("view")
qtm(horseferry_road)
region_bb = horseferry_road %>% 
  st_transform(27700) %>% 
  st_buffer(200) %>% 
  st_transform(4326)

# Test stats19 data downloads
a = get_stats19(year = 2017, type = "acc", ask = FALSE)
asf = 