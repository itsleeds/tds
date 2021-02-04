x = 1:9
x = c(x, 1.1)
y = sqrt(x = x)

class(x)
class(y)

z = paste0(1:10, "z")
class(z)
d = data.frame(x = x, y = y, z)
View(d)
class(d)

d[3, c(2, 3)]

library(tidyverse)
d %>%
  filter(x == 3)
# identical to:
filter(d, x == 3)
?filter

plot(d)
plot(d$x, d$y)

od_data = stplanr::od_data_sample

od_data_walk = od_data %>%
  rename(walk = foot) %>%
  filter(walk > 0) %>%
  select(geo_code1, geo_code2, walk, car_driver, all) %>%
  mutate(
    proportion_walk = walk / all,
    proportion_drive = car_driver / all
    )

plot(od_data_walk$car_driver, od_data_walk$walk)

m1 = lm(proportion_walk ~ proportion_drive + all, data = od_data_walk )
m1
summary(m1)
plot(od_data_walk$car_driver, od_data_walk$proportion_walk)
line(od_data$car_driver, m1$fitted.values)

