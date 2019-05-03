2 day course: R for Spatial Transport Data
================

See <https://github.com/ITSLeeds/TDS>

Assumed prior knowledge:

  - Working knowledge of R, e.g. have completed:
      - Introduction to R free DataCamp course:
        <https://www.datacamp.com/courses/free-introduction-to-r>
      - Recommended reading: Section 4.2 of *Efficient R Programming*
        (Gillespie and Lovelace 2016):
        <https://csgillespie.github.io/efficientR/efficient-workflow.html#package-selection>
  - Some knowledge of tidyverse is highly recommended, e.g. already know
    the contents of or have read-up on **and tried examples from** the
    following ‘cheatsheets’:
      - Tidyverse for Beginners DataCamp Cheat Sheet (see
        [here](https://s3.amazonaws.com/assets.datacamp.com/blog_assets/Tidyverse+Cheat+Sheet.pdf)).
        **At a minimum you will have completed up to Chapter 5 on this
        online course** (this may take ~2 hours)
      - Data wrangling with dplyr and tidyr RStudio cheet cheet (see
        [here](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf))

<!-- **It's in the Analysis directorate** -->

## Computing Requirements

  - DfT will provide desktops with recent versions of R and RStudio
    installed, including:
      - R 3.5.3 recommended (although any R 3.5 release should work):
        <https://cran.r-project.org/>
      - RStudio 1.1.436 - see
        <https://www.rstudio.com/products/rstudio/download/>
      - Will require up-to-date versions of **tidyverse** and **sf**
        packages, at a minimum
      - Other packages we’ll use:
          - stats19
          - stplanr
          - tmap
          - devtools
          - The GitHub package spDataLarge, which can be installed as
            follows:

<!-- end list -->

``` r
devtools::install_github("Nowosad/spDataLarge")
```

  - Own laptops allowed, provided necessary data is installed

  - Data: all data will be either provided by packages or downloaded on
    the day (assuming good internet)
    
      - A test to check if data downloads work is accessing stats19 data
        (check this
works):

<!-- end list -->

``` r
crashes = stats19::get_stats19(year = 2017, type = "accidents", ask = FALSE)
```

  - A script to test set-up will be provided to test it all works

## Venue and course times

### Day 1: Introduction to R/RStudio

Course times each day:

  - 09:30 - 10:00 (set-up)

  - 10:00 - 11:00 How to use R/RStudio effectively (MM)

  - break

  - 11:15 - 12:30 Using packages: example with sf/ggplot2 (RL)

  - 12:30 - 13:30: lunch

  - 13:30 - 14:45 Spatial data analysis (MM)

  - break

  - 15:00 - 16:00 Visualising spatial datasets (RL)

  - 16:00 - 16:30 (Q\&A)

### Day 2:

Course times each day:

  - 09:30 - 11:00 stats19 data analysis - with spatial/temporal analysis
    (RL)

  - break

  - 11:15 - 12:30 OD data with stplanr (RL)

  - 12:30 - 13:30: lunch

  - 13:30 - 14:45 Local route network analysis (MM)

  - break

  - 15:00 - 16:00 Data and methods for assessing cycling potential (RL)

  - 16:00 - 16:30 (Q\&A)
    
    <!-- - Download data from open roads: put on test scripts -->

## Optional extra reading

  - Optional extra reading: for context, you may want to read-up on:
      - Overview of GIS in R, e.g. in Chapter 1 of *Geocomputation with
        R* or this blog post:
        <https://www.jessesadler.com/post/gis-with-r-intro/>
      - stplanr: A package for transport planning (Lovelace and Ellison
        2018)
      - R for data science (Grolemund and Wickham 2016)
      - For an overview of spatial transport data types, see Chapter 12
        of *Geocomputation with R*
        (<span class="citeproc-not-found" data-reference-id="lovelace_geocomputation_2019">**???**</span>):
        <http://geocompr.robinlovelace.net/transport.html>

## Notes

The overview slides for the course can be found here:
<https://itsleeds.github.io/TDS/slides/2day-slides#1>

### stats19 exercises

1.  Download and plot all crashes reported in Great Britain in 2017
    (hint: see [the stats19
    vignette](https://cran.r-project.org/web/packages/stats19/vignettes/stats19.html))
2.  Find the function in the `stats19` package that converts a
    `data.frame` object into an `sf` data frame. Use this function to
    convert the road crashes into an `sf` object, called `crashes_sf`,
    for example.
3.  Filter crashes that happened in the Isle of Wight based on attribute
    data (hint: the relevant column contains the word `local`)
4.  Filter crashes happened in the Isle of Wight using geographic
    subsetting (hint: remember `st_crs()`?)
5.  Bonus: Which type of spatial subsetting yielded more results and
    why?
6.  Bonus: how many crashes happened in each zone?
7.  Create a new column called `month` in the crash data using the
    function `lubridate::month()` and the `date` column.
8.  Create an object called `a_iow_may` representing all the crashes
    that happened in the Isle of Wight in the month of May
9.  Bonus: Calculate the average (`mean`) speed limit associated with
    each crash that happened in May across the zones of the Isle of
    Wight (the result is shown in the map)

Short keys:

  - Alt-Shift-K: shows short keys
  - Tab: does autocompletions
  - Ctl-Shift-A: format code

Link to transportAPI: <https://developer.transportapi.com/signup>

Link to chapter: <https://geocompr.robinlovelace.net/transport.html>

## Example code

### From the morning of day 1

``` r
library(pct)

x = 1:5
y = c(0,1,3,9,18)
# Ctl+2

cat = data.frame(
  name = c("Tiddles", "Chester", "Shadow"),
  type = c("Tabby", "Persian", "Siamese"),
  age = c(1, 3, 5),
  likes_milk = c(TRUE, FALSE, TRUE),
  stringsAsFactors = FALSE
)
class(cat$name)
even_numbers = seq(from = 2, to = 4000, by = 2)
random_letters = sample(letters, size = 100, replace = TRUE)

iow = pct::get_pct_zones(region = "isle-of-wight")
class(iow)
dim(iow)
iow = iow[1:9]
iow_geo = iow$geometry
plot(iow_geo)
plot(iow)
number_who_walk = iow$foot
class(number_who_walk)
summary(number_who_walk)
number_who_walk[c(1, 3, 9)]
sel = number_who_walk > 500
number_who_walk[sel]
length(sel)
class(sel)
iow$many_walk = sel
iow_walk = iow[iow$many_walk, ]

l = get_pct_lines("isle-of-wight")
l$percent_drive =
  l$car_driver / l$all * 100 
dim(l)

summary(l$rf_dist_km)
# identify short routes
sel = l$rf_dist_km < 3 
l_short = l[sel, ]


plot(l$geometry)
plot(l_short$geometry, add = TRUE, col = "red")

l_order = l_short[order(l_short$percent_drive), ]
mapview::mapview(l_order[nrow(l_order), ])

library(dplyr)
l_short2 = l %>% 
  filter(rf_dist_km < 3) %>% 
  mutate(pdrive = car_driver / all) %>% 
  top_n(n = 3, wt = pdrive)
mapview::mapview(l_short2$geometry)
```

### Afternoon of day 1

``` r
library(sf)
library(pct)
library(spData)
#install.packages("spData")

iow = get_pct_zones("isle-of-wight")
iow = st_transform(iow, 27700)
iow2 = iow[1,]
cents = get_pct_centroids("isle-of-wight",
                          geography = "lsoa")
cents = st_transform(cents, 27700)
cent2 = cents[iow2,]
plot(cents$geometry)
plot(iow$geometry)
plot(cent2, col = "red", add = TRUE)
cent3 = cents[iow2,, op = st_disjoint]
plot(cent3, col = "blue", add = TRUE)


plot(nz$geom)
nz

nz_islands = nz %>% 
  group_by(Island) %>% 
  summarise(Population = sum(Population))
plot(nz_islands)

cents_buff = st_buffer(cents, 10000)
plot(cents_buff$geometry)
plot(cents$geometry, col = "red", add = T)


canterbury = nz[nz$Name == "Canterbury",]
cant_height = nz_height[canterbury,]

nz_height2 = st_join(nz_height, nz)

nz_height3 = nz_height2 %>% 
  group_by(Name) %>% 
  summarise(numb_mountain = n()) %>% 
  select(Name, numb_mountain) %>% 
  st_drop_geometry()

nz_joined = left_join(nz["Name"], nz_height3)
plot(nz_joined)

nz_agg = aggregate(nz_height[1], nz, FUN = length)
plot(nz_agg)



nrow(cant_height)
nz$geom = canterbury$geom
plot(nz)
nz = spData::nz
```

### Code to download and visualise geo data

``` r
u = "https://opendata.arcgis.com/datasets/66f41d4ccc8a4fce9137b3a1947bfcdb_0.kml?outSR=%7B%22wkid%22%3A27700%2C%22latestWkid%22%3A27700%7D"
download.file(url = u, destfile = "d.kml")
f = list.files(pattern = "kml")
s = read_sf(f)
plot(s$geometry)
nrow(s)
mapview::mapview(s)
s_simple = rmapshaper::ms_simplify(input = s, 0.1)
object.size(s)
object.size(s_simple)
mapview::mapview(s_simple)
?rmapshaper::ms_simplify

library(spData)
library(tmap)

tmap_mode("plot")
tm_shape(nz) +
  tm_fill(
    "Population",
    palette = "RdYlBu",
    alpha = 0.2) +
  tm_shape(nz_height) +
  tm_dots()
class(m)
tmap_save(m, "m.html")

mapview::mapview(nz)

library(ggplot2)
nz$geometry = nz$geom
ggplot(nz) +
  geom_sf()
```

## References

<div id="refs" class="references">

<div id="ref-gillespie_efficient_2016">

Gillespie, Colin, and Robin Lovelace. 2016. *Efficient R Programming: A
Practical Guide to Smarter Programming*. O’Reilly Media.
<https://csgillespie.github.io/efficientR/>.

</div>

<div id="ref-grolemund_r_2016">

Grolemund, Garrett, and Hadley Wickham. 2016. *R for Data Science*. 1
edition. O’Reilly Media.

</div>

<div id="ref-lovelace_stplanr:_2018">

Lovelace, Robin, and Richard Ellison. 2018. “Stplanr: A Package for
Transport Planning.” *The R Journal* 10 (2): 7–23.
<https://doi.org/10.32614/RJ-2018-053>.

</div>

</div>
