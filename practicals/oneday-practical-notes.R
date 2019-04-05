# get pct 

l = pct::get_pct_lines(region = "west-yorkshire")
plot(l["all"])

# https://itsleeds.github.io/TDS/slides/5-web.html#18
# Ctl Shift M - creates %>% 
osm = opq(bbox = "leeds") %>%
  add_osm_feature(key = "highway",value = "cycleway") %>% 
  osmdata_sf()
summary(osm)  
cyclway = osm$osm_lines
plot(cyclway)

cy = sf::read_sf("export.geojson")
plot(cy)


od = pct::get_od(area = "avon", n = 100)
od = pct::get_od(area = "leeds")
# pct::get_pct_lines()

# http://86.2.213.202:8787/



