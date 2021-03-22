# Aim: demonstrate how to get data from UK gov sources

library(tidyverse)

# First stage: search - I searched on Google for:
# https://www.google.com/search?q=recycling+points+leeds+geojson

# That took me here:
# https://datamillnorth.org/publisher/leedscitycouncil?format=geojsonhttps://datamillnorth.org/publisher/leedscitycouncil?format=geojson


# That linked me to:
# https://datamillnorth.org/dataset/bring-sites

u = "https://datamillnorth.org/download/bring-sites/97bd60ae-ced3-4ddc-996e-f1ebe5d21136/tonnage%20to%20Sept%2020.csv"
waste_sites = read_csv(u)
waste_sites
dim(waste_sites)
skimr::skim(waste_sites)
waste_sites_unique = waste_sites %>%
  # remove missing values: data cleaning
  filter(! is.na(Longitude)) %>% 
  group_by(`Site Name`, Longitude, Latitude) %>% 
  summarise(tonnes_glass = sum(`Apr 20 Glass Tonnage Kg`, `May 20 Glass Tonnage Kg`))

waste_sites_sf = sf::st_as_sf(waste_sites_unique, coords = c("Longitude", "Latitude"), crs = 4326)

mapview::mapview(waste_sites_sf)

# remove sites that are miles away
pct_regions = pct::pct_regions
waste_sites_clean = waste_sites_sf[pct_regions, ]

library(tmap)  
tm_shape(waste_sites_clean) +
  tm_dots(size = "tonnes_glass")


# Tests

# u = "https://mapservices.leeds.gov.uk/arcgis/rest/services/Public/Waste/MapServer/2?f=pjson"
# d_json = jsonlite::read_json(u)
# d_json$name
# d_json$fields
# d = jsonlite::flatten(d_json)
