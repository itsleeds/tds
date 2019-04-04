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
tmap_mode("plot") # use "view" for interactive maps

# Test link with osmdata works:
osm_data = opq(bbox = "westminster") %>% 
  add_osm_feature(key = "name", value = "Horseferry Road") %>% 
  osmdata_sf()
horseferry_road = osm_data$osm_lines

qtm(horseferry_road)
horseferry_region = horseferry_road %>% 
  st_transform(27700) %>% 
  st_buffer(500) %>% 
  st_union() %>% 
  st_transform(4326)

# Test stats19 data downloads
a = get_stats19(year = 2017, type = "acc", ask = FALSE)
asf = format_sf(a, lonlat = TRUE)
horseferry_crashes = asf[horseferry_region, ]
plot(horseferry_crashes)

# Test pct data downloads
rnet = get_pct_rnet(region = "london")
horseferry_routenet = rnet[horseferry_region, ]

# Final combined plot
tm_shape(horseferry_region) +
  tm_borders() +
  tm_shape(horseferry_road) +
  tm_lines("red", scale = 9) +
  tm_shape(horseferry_routenet) +
  tm_lines(lwd = "bicycle", scale = 9, col = "blue") +
  tm_shape(horseferry_crashes) +
  tm_dots("accident_severity", size = 0.5, alpha = 0.5, palette = "magma")
