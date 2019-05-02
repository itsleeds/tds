2 day course: R for Spatial Transport Data
================

See <https://github.com/ITSLeeds/TDS>

Assumed prior knowledge:

-   Working knowledge of R, e.g. have completed:
-   Introduction to R free DataCamp course: <https://www.datacamp.com/courses/free-introduction-to-r>
-   Recommended reading: Section 4.2 of *Efficient R Programming* (Gillespie and Lovelace 2016): <https://csgillespie.github.io/efficientR/efficient-workflow.html#package-selection>

-   Some knowledge of tidyverse is highly recommended, e.g. already know the contents of or have read-up on **and tried examples from** the following 'cheatsheets':
-   Tidyverse for Beginners DataCamp Cheat Sheet (see [here](https://s3.amazonaws.com/assets.datacamp.com/blog_assets/Tidyverse+Cheat+Sheet.pdf)). **At a minimum you will have completed up to Chapter 5 on this online course** (this may take ~2 hours)
-   Data wrangling with dplyr and tidyr RStudio cheet cheet (see [here](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf))

<!-- **It's in the Analysis directorate** -->
Computing Requirements
----------------------

-   DfT will provide desktops with recent versions of R and RStudio installed, including:
-   R 3.5.3 recommended (although any R 3.5 release should work): <https://cran.r-project.org/>
-   RStudio 1.1.436 - see <https://www.rstudio.com/products/rstudio/download/>
-   Will require up-to-date versions of **tidyverse** and **sf** packages, at a minimum
-   Other packages we'll use:
    -   stats19
    -   stplanr
    -   tmap
    -   devtools
    -   The GitHub package spDataLarge, which can be installed as follows:

``` r
devtools::install_github("Nowosad/spDataLarge")
```

-   Own laptops allowed, provided necessary data is installed

-   Data: all data will be either provided by packages or downloaded on the day (assuming good internet)
-   A test to check if data downloads work is accessing stats19 data (check this works):

``` r
crashes = stats19::get_stats19(year = 2017, type = "accidents", ask = FALSE)
```

-   A script to test set-up will be provided to test it all works

Venue and course times
----------------------

### Day 1: Introduction to R/RStudio

Course times each day:

-   09:30 - 10:00 (set-up)

-   10:00 - 11:00 How to use R/RStudio effectively (MM)

-   break

-   11:15 - 12:30 Using packages: example with sf/ggplot2 (RL)

-   12:30 - 13:30: lunch

-   13:30 - 14:45 Spatial data analysis (MM)

-   break

-   15:00 - 16:00 Visualising spatial datasets (RL)

-   16:00 - 16:30 (Q&A)

### Day 2:

Course times each day:

-   09:30 - 11:00 stats19 data analysis - with spatial/temporal analysis (RL)

-   break

-   11:15 - 12:30 OD data with stplanr (RL)

-   12:30 - 13:30: lunch

-   13:30 - 14:45 Local route network analysis (MM)

-   break

-   15:00 - 16:00 Data and methods for assessing cycling potential (RL)

-   16:00 - 16:30 (Q&A)

<!-- - Download data from open roads: put on test scripts -->

Optional extra reading
----------------------

-   Optional extra reading: for context, you may want to read-up on:
-   Overview of GIS in R, e.g. in Chapter 1 of *Geocomputation with R* or this blog post: <https://www.jessesadler.com/post/gis-with-r-intro/>
-   stplanr: A package for transport planning (Lovelace and Ellison 2018)
-   R for data science (Grolemund and Wickham 2016)
-   For an overview of spatial transport data types, see Chapter 12 of *Geocomputation with R* (<span class="citeproc-not-found" data-reference-id="lovelace_geocomputation_2019">**???**</span>): <http://geocompr.robinlovelace.net/transport.html>

Notes
-----

The overview slides for the course can be found here: <https://itsleeds.github.io/TDS/slides/2day-slides#1>

Short keys:

-   Alt-Shift-K: shows short keys
-   Tab: does autocompletions
-   Ctl-Shift-A: format code

Example code
------------

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

References
----------

Gillespie, Colin, and Robin Lovelace. 2016. *Efficient R Programming: A Practical Guide to Smarter Programming*. O’Reilly Media. <https://csgillespie.github.io/efficientR/>.

Grolemund, Garrett, and Hadley Wickham. 2016. *R for Data Science*. 1 edition. O’Reilly Media.

Lovelace, Robin, and Richard Ellison. 2018. “Stplanr: A Package for Transport Planning.” *The R Journal* 10 (2): 7–23. doi:[10.32614/RJ-2018-053](https://doi.org/10.32614/RJ-2018-053).
