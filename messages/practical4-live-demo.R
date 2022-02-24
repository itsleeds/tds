library(tidyverse)
library(tmap)
library(sf)

zones = pct::get_pct_zones(region = "west-yorkshire", geography = "msoa")
zones_lsoa = pct::get_pct_zones("west-yorkshire")
nrow(zones_lsoa)
nrow(zones)

u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
download.file(u, "desire_lines.geojson")
desire_lines = read_sf("desire_lines.geojson")

ncol(zones)

zones_clean = zones %>% 
  select(geo_code, foot)

ncol(zones_clean)

zones_active_modes = zones %>% 
  mutate(active = bicycle + foot)
# tmaptools::palette_explorer()
tm_shape(zones_active_modes) +
  tm_fill(c("car_driver", "active"), palette = "viridis")
ggplot(zones_active_modes) +
  geom_point(aes(car_driver, active))

zones_active_percent = zones_active_modes %>% 
  transmute(
    geo_code = geo_code,
    all = all,
    proportion_car_driver = car_driver / all,
    proportion_active = active / all
  )

ggplot(zones_active_percent) +
  geom_point(aes(proportion_car_driver, proportion_active, size = all), alpha = 0.5) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(labels = scales::percent) +
  ylab("Percent of trips by active modes") +
  xlab("Percent of trips by driving") 

# Get traffic data --------------------------------------------------------

u = "https://storage.googleapis.com/dft-statistics/road-traffic/downloads/data-gov-uk/region_traffic_by_vehicle_type.csv"
regional_traffic_data = readr::read_csv(u)
traffic_clean = regional_traffic_data %>%
  mutate(region_id = as.character(region_id)) %>% 
  group_by(year, region_id) %>% 
  summarise(
    cycling = sum(pedal_cycles),
    driving = sum(all_motor_vehicles)
    ) %>% 
  pivot_longer(cols = matches("ing"))

traffic_clean %>% 
  ggplot(aes(year, value, colour = region_id)) +
  geom_line() +
  facet_wrap(~ name, scales = "free")


