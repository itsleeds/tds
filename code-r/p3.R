# Practical 3 homework

devtools::install_github("Nowosad/spDataLarge")
library(spDataLarge)
library(dplyr)
library(sf)

names(bristol_zones)
plot(bristol_zones)

zones_attr = bristol_od %>% 
  group_by(o) %>% 
  summarize_if(is.numeric, sum) %>% 
  dplyr::rename(geo_code = o)
zones_joined = left_join(bristol_zones, zones_attr, by = "geo_code")
sum(zones_joined$all)
#> [1] 238805
names(zones_joined)
