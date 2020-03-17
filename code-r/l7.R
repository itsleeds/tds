library(spData)
nz2 = nz
plot(nz)
nz

plot(st_geometry(nz))
plot(nz_height, add = TRUE)

library(tmap)
tmap_mode("plot")
names(nz)
tm_shape(nz) +
  tm_fill("Population", palette = "viridis") +
  tm_borders(col = "black")

tmap_mode("view")
tmap_mode("plot")
m = tm_shape(nz) +
  tm_fill("Population") +
  tm_borders(col = "grey")

tmap_save(m, "m.png")

class(m)
tmap_save(m, "m.html")

vignette("ggplot2-specs")

mapview::mapview(nz)

library(stplanr)
l = flowlines_sf
plot(l)
