
remotes::install_github("a-b-street/abstr")



library(abstr)
library(tidyverse)
library(tmap)
tmap_mode("view")

leeds_desire_lines
class(leeds_desire_lines)

tm_shape(leeds_desire_lines) +
  tm_lines() +
  qtm(leeds_houses) +
  qtm(leeds_buildings) +
  qtm(leeds_zones)

ablines_dutch = ab_scenario(
  houses = leeds_houses,
  buildings = leeds_buildings,
  desire_lines = leeds_desire_lines,
  zones = leeds_zones,
  output_format = "sf"
)

qtm(ablines_dutch) +
  qtm(leeds_buildings)
ablines_dutch_drive = ablines_dutch %>% 
  filter(mode_base == "Drive")
tm_shape(leeds_buildings, bbox = sf::st_bbox(ablines_dutch_drive)) + tm_polygons() +
  tm_shape(leeds_houses) + tm_polygons(col = "blue") +
  tm_shape(ablines_dutch_drive) + tm_lines(col = "red") 


ablines_dutch_drive_routes = stplanr::route(
  l = ablines_dutch_drive,
  route_fun = stplanr::route_osrm,
  osrm.profile = "car"
)
ablines_dutch_drive_routes$n = 1
ablines_rnet = stplanr::overline(ablines_dutch_drive_routes, "n")
tm_shape(ablines_rnet) + tm_lines(lwd = "n", scale = 9)

mean(ablines_dutch_drive_routes$distance)
sd(ablines_dutch_drive_routes$distance)


# Bonus (warning: very difficult): Generate an A/B Street scenario of your choice for the local authority of Hereford (or any other local authority in England and Wales) starting with this code. Note: this requires fast internet connection and decent computer:
  
local_authority_name = "Leeds"
pct_region_name = pct::pct_regions_lookup %>% 
  filter(lad16nm == local_authority_name) %>% 
  pull(region_name)
zones_region = pct::get_pct_zones(region = pct_region_name, geography = "msoa")
table(zones_region$lad_name)
nrow(zones_region)
zones = zones_region %>% 
  filter(str_detect(string = lad_name, pattern = local_authority_name))
nrow(zones)
plot(zones %>% select(bicycle:car_passenger))
od_national = pct::get_od()
desire_lines = od::od_to_sf(od_national, z = zones)
qtm(zones, alpha = 0.3) + 
  tm_shape(desire_lines) +
  tm_lines(lwd = "all", scale = 5)

times = list(commute = list(hr = 8.5, sd = 0.3), town = list(hr = 11, sd = 2))
central_hereford = tmaptools::geocode_OSM("tupsley, hereford", as.sf = TRUE)
central_hereford = tmaptools::geocode_OSM("leeds centre", as.sf = TRUE)
site_area = stplanr::geo_buffer(central_hereford, dist = 500)
study_area = sf::st_union(zones)
# buildings = osmextract::oe_get(study_area, layer = "multipolygons")
osm_polygons = osmextract::oe_get(sf::st_centroid(study_area), layer = "multipolygons")

# # # sanity check scenario data
# class(desire_lines)
# sum(desire_lines$trimode_base)
# sum(desire_lines$walk_base, desire_lines$cycle_base, desire_lines$drive_base)
# sum(desire_lines$walk_godutch, desire_lines$cycle_godutch, desire_lines$drive_godutch)

building_types = c(
  "office",
  "industrial",
  "commercial",
  "retail",
  "warehouse",
  "civic",
  "public"
)
osm_buildings = osm_polygons
# osm_buildings = osm_polygons %>%
#   filter(building %in% building_types)
# pct_zone = pct::pct_regions[site_area %>% sf::st_centroid(), ]
# zones = pct::get_pct_zones(pct_zone$region_name, geography = "msoa")
# zones_of_interest = zones[zones$geo_code %in% c(desire_lines$geo_code1, desire_lines$geo_code2), ]
zones_of_interest = zones

buildings_in_zones = osm_buildings[zones_of_interest, , op = sf::st_within]

# mapview::mapview(zones_of_interest) +
#   mapview::mapview(buildings_in_zones)
buildings_in_zones = buildings_in_zones %>%
  select(osm_way_id, building)

n_buildings_per_zone = aggregate(buildings_in_zones, zones_of_interest, FUN = "length")
summary(n_buildings_per_zone$osm_way_id)
mbz = 10
zones_lacking_buildings = n_buildings_per_zone$osm_way_id < mbz
zones_lacking_buildings[is.na(zones_lacking_buildings)] = TRUE
# if(any(zones_lacking_buildings)) {
#   sz = rep(5, length(zones_lacking_buildings) ) # n buildings per zone - arbitrary
#   new_buildings = sf::st_sample(zones_of_interest[zones_lacking_buildings, ], size = sz)
#   new_buildings = sf::st_sf(
#     data.frame(osm_way_id = rep(NA, length(new_buildings)), building = NA),
#     geometry = stplanr::geo_buffer(new_buildings, dist = 20, nQuadSegs = 1)
#   )
#   buildings_in_zones = rbind(buildings_in_zones, new_buildings)
# }

zones_of_interest = zones %>% 
  filter(!zones_lacking_buildings)

osm_polygons_cents = osm_polygons %>% sf::st_centroid()
osm_polygons_cents_in_site = osm_polygons_cents[site_area, , op = sf::st_within]
osm_polygons_in_site = osm_polygons %>% 
  filter(osm_id %in% osm_polygons_cents_in_site$osm_way_id)
houses = osm_polygons_in_site %>%
  filter(building == "residential") %>% # todo: all non-destination buildings?
  select(osm_way_id, building)
n_houses = nrow(houses)

names(desire_lines)

names(desire_lines)
# names(desire_lines)[3:13]
# names(desire_lines)[3:13] = paste0("base_", names(desire_lines)[3:13])
desire_lines_scenario = desire_lines %>% 
  transmute(geo_code1, geo_code2, walk_base = foot, cycle_base = bicycle, drive_base = car_driver) %>% 
  mutate(all_base = walk_base + cycle_base + drive_base)

# visualise inputs
mapview::mapview(houses) +
  mapview::mapview(zones_of_interest) +
  mapview::mapview(buildings_in_zones) +
  mapview::mapview(desire_lines_scenario) 


abc = abstr::ab_scenario(
  houses,
  buildings = buildings_in_zones,
  desire_lines = desire_lines_scenario %>% sample_n(5),
  zones = zones_of_interest,
  scenario = "base",
  output_format = "sf"
)

abc$departure = abstr::ab_time_normal(hr = times$commute$hr, sd = times$commute$sd, n = nrow(abc))
abt = abstr::ab_scenario(
  houses,
  buildings = buildings_in_zones,
  desire_lines = desire_lines %>% filter(purpose == "town"),
  zones = zones_of_interest,
  scenario = "base",
  output_format = "sf"
)
abt$departure = abstr::ab_time_normal(hr = times$town$hr, sd = times$town$sd, n = nrow(abt))
abb = rbind(abc, abt)
abbl = abstr::ab_sf_to_json(abb)

abcd = abstr::ab_scenario(
  houses,
  buildings = buildings_in_zones,
  desire_lines = desire_lines %>% filter(purpose == "commute"),
  zones = zones_of_interest,
  scenario = "dutch",
  output_format = "sf"
)
abcd$departure = abstr::ab_time_normal(hr = times$commute$hr, sd = times$commute$sd, n = nrow(abc))
abtd = abstr::ab_scenario(
  houses,
  buildings = buildings_in_zones,
  desire_lines = desire_lines %>% filter(purpose == "town"),
  zones = zones_of_interest,
  scenario = "dutch",
  output_format = "sf"
)
abtd$departure = abstr::ab_time_normal(hr = times$town$hr, sd = times$town$sd, n = nrow(abtd))
abbd = rbind(abcd, abtd)
hist(abbd$departure, breaks = seq(0, 60*60*24, 60 * 15))
abbld = abstr::ab_sf_to_json(abbd, mode_column = "mode_dutch")

