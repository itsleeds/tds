Accessing data from web sources and data cleaning
================
Robin Lovelace
University of Leeds,
2020-02-18<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

## Review of homework exercise: demo with RMarkdown then individual Q\&A

We will be using these packages in this practical:

``` r
library(sf)
library(stats19)
library(tidyverse)
```

## Accessing crowd-sourced data from OSM

  - Navigate to <https://overpass-turbo.eu/> and play with the interface
    to see what data is available from OpenStreetMap. Download data on
    highway=cycleway for Leeds from <https://overpass-turbo.eu/>

  - Load the data in R and plot it with your favourite plotting package
    (e.g. `sf`, `mapview` or `tmap`)

  - Bonus: now try to get the same data using the **osmdata** package

## Get official data with stats19

  - Take a read of the stats19 README page and at least one of the
    articles on it here: <https://docs.ropensci.org/stats19/>
  - Install and load the stats19 package as with one of the following
    commands:

<!-- end list -->

``` r
install.packages("stats19") # the stable version
remotes::install_github("ropensci/stats19") # the most recent 'development' version
```

  - Show crashes involving pedestrians in Manchester by reproducing the
    following lines of code:

<!-- end list -->

``` r
library(sf)
library(stats19)
library(tidyverse)
crashes_2018 = get_stats19(year = 2018)
crashes_2018_sf = format_sf(crashes_2018)
crashes_manchester = crashes_2018_sf %>% filter(local_authority_district == "Manchester")
plot(crashes_manchester["accident_severity"])
```

![](5-web_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
casualties_2018 = get_stats19(year = 2018, type = "cas")
crashes_manchester = inner_join(crashes_manchester, casualties_2018)
pedestrian_casualties = crashes_manchester %>% filter(casualty_type == "Pedestrian")
plot(pedestrian_casualties["accident_severity"])
```

![](5-web_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

  - Use the tmap package to create an interactive map of pedestrian
    casualties in Manchester, starting with the following commands
    (hint, use `tmaptools::palette_explorer()` and the argument `palette
    = "Reds"` in the function `tm_dots()`, for example, to change the
    default colour palette):

<!-- end list -->

``` r
library(tmap)
tmap_mode("view")
```

![](5-web_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

  - Based on the documentation at <https://docs.ropensci.org/stats19/>:
    
      - Download data on road crashes in Great Britain in 2018
      - Filter crashes that happened in Leeds

  - Bonus: make a map of pedestrian casualties in Leeds that shows the
    speed limit where pedestrians were hit. Explore the results in an
    interactive map. Where do you think the speed limit should be
    reduced based on this data?

The result should look something like
this:

``` r
crashes_leeds = crashes_2018_sf %>% filter(local_authority_district == "Leeds")
crashes_leeds = inner_join(crashes_leeds, casualties_2018)
pedestrian_casualties = crashes_leeds %>% filter(casualty_type == "Pedestrian")
tm_shape(pedestrian_casualties) +
  tm_dots("speed_limit")
```

![](5-web_files/figure-gfm/unnamed-chunk-7-1.png)<!-- -->

  - Bonus: what is the relationship between crash severity and the speed
    limit?

  - Bonus: download and visualise the Leeds Bradford Cycle Superhighway
    data with these commands:

<!-- end list -->

``` r
library(osmdata)
data_osm = opq("leeds uk") %>% 
  add_osm_feature(key = "name", value = "Cycle Superhighway 1") %>% 
  osmdata_sf()
```

``` r
# if the previous command fails, try:
data_osm = readRDS(url("https://github.com/ITSLeeds/TDS/releases/download/0.20.1/data_osm_cycle_superhighway.Rds"))
cycleway_100m_buffer = stplanr::geo_buffer(data_osm$osm_lines, dist = 100)
crashes_leeds_lon_lat = crashes_leeds %>% st_transform(4326)
crashes_near_cycle_superhighway = crashes_leeds_lon_lat[cycleway_100m_buffer, ]
tm_shape(data_osm$osm_lines) + tm_lines() +
  tm_shape(crashes_near_cycle_superhighway) + tm_dots("casualty_type")
```

![](5-web_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

  - Filter crashes that happened within a 500 m buffer of the cycle
    infrastructure
  - Do cyclists seem safer on the cycle superhighway?
  - Bonus: pull down origin-destination data with the `pct` package
    hosted at: <https://github.com/ITSLeeds/pct>

## Getting data from the web

Read through Section
[7.2](https://geocompr.robinlovelace.net/read-write.html#retrieving-data)
and 7.3 of Geocomputation with R.

Complete Excersises 4, 5, 6 and 7 of the chapter

## Bonus 1: Geofabrik

Take a read of the documentation on the website
<https://itsleeds.github.io/geofabrik/>

Reproduce the examples

Get all supermarkets in OSM for West Yorkshire

Identify all cycleways in West Yorkshire and, using the stats19 data you
have already downloaded, identify all crashes that happened near them.

## Bonus 2: Getting data from statistics.gov.uk

Identify a region and zonal units of interest from
<http://geoportal.statistics.gov.uk/>

  - Read them into R as an `sf` object

  - Join-on data from a non-geographic object

  - Add a data access section to your in progress portfolio
