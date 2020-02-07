Data structures
================
Robin Lovelace
University of Leeds,
2020-02-07<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

## Review of homework exercise: demo then individual Q\&A

``` r
library(tidyverse)
library(sf)
```

## Data cleaning on a big dataset

Download the file `wu03ew_v2.zip` from the Wicid website:
[wicid.ukdataservice.ac.uk](http://wicid.ukdataservice.ac.uk/cider/wicid/downloads.php).
You should be able to read it in as follows:

``` r
unzip("~/Downloads/wu03ew_v2.zip")
d = read_csv("wu03ew_v2.csv")
```

Load data representing MSOA zones in Isle of Wight. You could download
zones from a number of places, including
<https://www.ukdataservice.ac.uk/get-data/geography.aspx>

An easy way to get zone data for West-Yorkshire is with the `pct`
package, which can be installed as follows:

The zones for Isle of Wight can be shown as follows.

``` r
zones = pct::get_pct_zones(region = "isle-of-wight", geography = "msoa")
```

    ## Loading required package: sp

``` r
plot(zones$geometry)
```

![](4-cleaning_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

## Processing/cleaning

  - Clean the names of the `d` object, e.g. using the following
    commands:

<!-- end list -->

``` r
names(d) = snakecase::to_snake_case(names(d))
names(d)[5] = "metro"
```

  - Create a new variable called `pcycle` representing the percentage
    cycling in each OD pair

  - Create a minimal version of the dataset `d` only containing a few
    key variables

  - What proportion of people in England and Wales are represented in
    the dataset `d`

  - Create a subset of the object `d` called `d_iow_origins` that only
    contains routes that originate in Isle of Wight

  - Create a subset that contains only od pairs with origins and
    destinations in Isle of Wight

**Bonus: Convert the origin-destination data you have of Isle of Wight
into desire lines**, e.g. with:

``` r
desire_lines = stplanr::od2line(flow = d_iow_origins, zones)
desire_top = desire_lines %>% top_n(100, bicycle)
plot(desire_top)
```

``` r
mapview::mapview(desire_top)
```

## Working on your own datset / project portfolio

  - Identify, download and clean a dataset to include in your coursework
    portfolio .Rmd document

## Homework

  - Consolidate your knowledge of data cleaning by adding reproducible
    data cleaning code to your in-progress project portfolio.
