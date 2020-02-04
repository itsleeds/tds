x = 1:9
x_squared = x^2
x_squared
y = 10:2
x_plus_y = x+y
class(x_plus_y)

x2 = x + 0.2
class(x2)
typeof(x2)
x_character = "hello"
class(x_character)

x_character_numeric = c(x_character, x)
class(x_character_numeric)
x2 * x
length(x2)
x2 * as.numeric(x_character_numeric[2:10])

d = data.frame(x_character, x, stringsAsFactors = F)
sapply(d, class)

1:9 # Ctl+Enter

# real world dataset
zones = pct::get_pct_zones(region = "isle-of-wight") # tab autocomplete
zones
class(zones)
plot(zones)
mapview::mapview(zones)
class(zones$geo_name)
class(zones$all)
x_all = zones$all
class(x_all)
x_all
class(zones$geometry)
