crashes = stats19::get_stats19(year = 2018, type = "accidents")
casualties = stats19::get_stats19(year = 2018, type = "casualties")
head(crashes)
names(crashes)
summary(crashes$speed_limit)
summary(crashes$datetime)
plot(crashes$datetime)
head(crashes$datetime)
head(crashes$police_force)
plot(factor(crashes$police_force))

library(ggplot2)

ggplot(crashes, aes(speed_limit)) +
  geom_bar(aes(fill = accident_severity), position = "fill")


library(stplanr)
library(sf)
library(tmap)

flowlines_sf
tm_shape(flowlines_sf) +
  tm_lines() +
  tm_shape(flowlines_sf) +
  tm_lines(lwd = 5, col = "red", alpha = 0.2) +
  tm_shape(routes_fast_sf) +
  tm_lines(col = "green")






#



