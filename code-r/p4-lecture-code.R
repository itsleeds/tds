d_read.csv = read.csv("wu03ew_v2.csv")
nrow(d)
# [1] 2402201
nrow(d_read.csv)
# [1] 2402201
class(d)
# [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame" 
class(d_read.csv)
read_csv
object.size(d) / 1e6
# 270 bytes
names(d)
names_old = names(d)
names_new = snakecase::to_snake_case(names_old)
names_new
# [1] "area_of_residence"  
# [2] "area_of_workplace"  
# [3] "all_categories_method_of_travel_to_work"
# [4] "work_mainly_at_or_from_home"  
# [5] "underground_metro_light_rail_tram"      
# [6] "train"    
# [7] "bus_minibus_or_coach"         
# [8] "taxi"     
# [9] "motorcycle_scooter_or_moped"  
# [10] "driving_a_car_or_van"         
# [11] "passenger_in_a_car_or_van"    
# [12] "bicycle"  
# [13] "on_foot"  
# [14] "other_method_of_travel_to_work"         
names_old[13] = "onFoot"
names_old
# [1] "Area of residence"   
# [2] "Area of workplace"   
# [3] "All categories: Method of travel to work"
# [4] "Work mainly at or from home"   
# [5] "Underground, metro, light rail, tram"    
# [6] "Train"     
# [7] "Bus, minibus or coach"         
# [8] "Taxi"      
# [9] "Motorcycle, scooter or moped"  
# [10] "Driving a car or van"
# [11] "Passenger in a car or van"     
# [12] "Bicycle"   
# [13] "onFoot"    
# [14] "Other method of travel to work"
names_new
# [1] "area_of_residence"  
# [2] "area_of_workplace"  
# [3] "all_categories_method_of_travel_to_work"
# [4] "work_mainly_at_or_from_home"  
# [5] "underground_metro_light_rail_tram"      
# [6] "train"    
# [7] "bus_minibus_or_coach"         
# [8] "taxi"     
# [9] "motorcycle_scooter_or_moped"  
# [10] "driving_a_car_or_van"         
# [11] "passenger_in_a_car_or_van"    
# [12] "bicycle"  
# [13] "on_foot"  
# [14] "other_method_of_travel_to_work"         

  
  names(d)
# [1] "Area of residence"   
# [2] "Area of workplace"   
# [3] "All categories: Method of travel to work"
# [4] "Work mainly at or from home"   
# [5] "Underground, metro, light rail, tram"    
# [6] "Train"     
# [7] "Bus, minibus or coach"         
# [8] "Taxi"      
# [9] "Motorcycle, scooter or moped"  
# [10] "Driving a car or van"
# [11] "Passenger in a car or van"     
# [12] "Bicycle"   
# [13] "On foot"   
# [14] "Other method of travel to work"
names(d) = names_new
names_new[3] = "all"
names(d) = names_new
names(d)
# [1] "area_of_residence"       "area_of_workplace"      
# [3] "all" "work_mainly_at_or_from_home"      
# [5] "underground_metro_light_rail_tram" "train"        
# [7] "bus_minibus_or_coach"    "taxi"         
# [9] "motorcycle_scooter_or_moped"       "driving_a_car_or_van"   
# [11] "passenger_in_a_car_or_van"         "bicycle"      
# [13] "on_foot"       "other_method_of_travel_to_work"   

  
  names(d)[5]
# [1] "underground_metro_light_rail_tram"
names(d)[5] = "metro"
# d_small = d %>% select(c(1, 2, 3, 12))
object.size(d_small) / 1e6
# 77.8 bytes
saveRDS(d_small, "d_small.Rds")

  
  names(d_small)
# [1] "area_of_residence" "area_of_workplace" "all"    
# [4] "bicycle"
d2 = mutate(d_small, bicycle / all)
names(d2)
# [1] "area_of_residence" "area_of_workplace" "all"    
# [4] "bicycle" "bicycle/all"      
d2 = mutate(d_small, pcycle = bicycle / all)
d2
# # A tibble: 2,402,201 x 5
# area_of_residence area_of_workplace   all bicycle pcycle
# <chr  <chr  <dbl  <dbl <dbl>
#   1 E02000001         E020000011506      33 0.0219
# 2 E02000001         E02000014   2       0 0     
# 3 E02000001         E02000016   3       0 0     
# 4 E02000001         E02000025   1       0 0     
# 5 E02000001         E02000028   1       0 0     
# 6 E02000001         E02000051   1       0 0     
# 7 E02000001         E02000053   2       0 0     
# 8 E02000001         E02000057   1       0 0     
# 9 E02000001         E02000058   1       0 0     
# 10 E02000001         E02000059   1       0 0     
# # … with 2,402,191 more rows
names(d)[5] = "metro"

  
  
  library(ukboundaries)
# Loading required package: sf
# Linking to GEOS 3.7.0, GDAL 2.3.2, PROJ 5.2.0
# Using default data cache directory ~/.ukboundaries/cache 
# Use cache_dir() to change it.
# Contains National Statistics data © Crown copyright and database right2019
# Contains OS data © Crown copyright and database right, 2019
# See https://www.ons.gov.uk/methodology/geography/licences
lsoa2011_
lsoa2011_lds     lsoa2011_simple  
lsoa2011_lds


  