# intro code from chapter 2 of 
# https://itsleeds.github.io/rrsrr/basics.html

# x = 3r # this creates an error
test_object = 1:3
test_object2 = c(1, 2, 3)
casualty_type = c("pedestrian", "cyclist", "cat")
casualty_age = seq(from = 20, to = 60, by = 20)
class(casualty_type)
class(casualty_age)
crashes = data.frame(casualty_type, casualty_age)
library(tidyverse)
ggplot(crashes) + geom_point(aes(casualty_type, casualty_age))
casualty_type[2]
crashes[2, ]
crashes[crashes$casualty_age > 25, ]
crashes %>%
  filter(casualty_age > 25)

accidents_2020 = stats19::get_stats19(year = 2020, type = "casualties")
View(accidents_2020)
unique(accidents_2020$road_type)
accidents_2020_one_way = accidents_2020 %>% 
  filter(road_type == "One way street")
table(accidents_2020_one_way)

crashes_sf = stats19::format_sf(x = accidents_2020_one_way)

library(tmap)
tmap_mode("view")
qtm(crashes_sf)
