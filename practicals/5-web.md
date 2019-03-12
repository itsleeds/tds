Data structures
================
Robin Lovelace
University of Leeds,
2019-03-12<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

## Discussion of homework and worked example (30 minutes)

``` r
library(tidyverse)
```

    ## ── Attaching packages ───────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.1.0       ✔ purrr   0.3.1  
    ## ✔ tibble  2.0.1       ✔ dplyr   0.8.0.1
    ## ✔ tidyr   0.8.3       ✔ stringr 1.4.0  
    ## ✔ readr   1.3.1       ✔ forcats 0.4.0

    ## ── Conflicts ──────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(sf)
```

    ## Linking to GEOS 3.7.0, GDAL 2.3.2, PROJ 5.2.0

## Accessing crowd-sourced data from OSM

  - Download data on highway=cycleway for Leeds from
    <https://overpass-turbo.eu/>

  - Load the data in R and plot it with your favourite plotting package
    (e.g. `sf`, `mapview` or `tmap`)

  - Now try to get the same data using the **osmdata** package

## Get official data with stats19

  - Download data on road crashes in Great Britain in 2017
  - Filter crashes that happened in Leeds
  - Filter crashes that happened within a 10m buffer of the cycle
    infrastructure
  - Bonus: pull down origin-destination data with the `pct` package
    hosted at: <https://github.com/ITSLeeds/pct>

## Homework

  - Add a data access section to your in progress portfolio
