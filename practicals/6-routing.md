Routing
================
Malcolm Morgan
University of Leeds, 2019-03-15<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

Setting Up (10 minutes)
-----------------------

We will be using several R packages and will also need to get an API key for [cyclestreets](https://www.cyclestreets.net/api/apply/)

Unfortunately, some of the most interesting packages for routing are not yet available on CRAN. In this practical we will introduce three CRAN packages [cyclestreets](https://cran.r-project.org/web/packages/cyclestreets/index.html), [dodgr](https://cran.r-project.org/web/packages/dodgr/index.html), and [igraph](https://cran.r-project.org/web/packages/igraph/index.html) and one GitHub package [transportAPI](https://github.com/ITSLeeds/transportAPI).

There are also some bonus exercises using the [Open Trip Planner](https://github.com/ITSLeeds/opentripplanner)

To install packages from GitHub you will need the `devtools` package. **Note:** GitHub packages have not been reviewed so install at your own risk.

``` r
# Install packages from CRAN (as required)
list.of.packages <- c("sf", "stplanr","cyclestreets","devtools","dodgr","igraph","usethis","tmap")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
rm(list.of.packages, new.packages)

# Install packages from GitHub
devtools::install_github("mem48/transportAPI")
devtools::install_github("ITSleeds/opentripplanner") # For the bonus exercises

# Load packages
library(sf)
library(stplanr)
library(tmap)
library(cyclestreets)
library(transportAPI)
library(dodgr)
```

Now you will need to add your CycleStreets API key to your R Environment

``` r
usethis::edit_r_environ()
# Add CYCLESTREETS=your_key_here as a new line in your .Renviron file
```

You may need to restart R for the changes to come into effect.

We will also need some sample data, for this practical we will be using data about the Isle of Wight.

-   Commuter flow data from the [PCT](https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/isle-of-wight/od_attributes.csv)
-   MSOA centroids from the [PCT](https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/isle-of-wight/c.geojson)
-   The Open Street Map for the Isle of Wight from [Geofabrik](http://download.geofabrik.de/europe/great-britain/england/isle-of-wight.html)

``` r
flow <- read.csv("https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/isle-of-wight/od_attributes.csv",
                 stringsAsFactors = FALSE)
flow <- flow[flow$geo_code1 != flow$geo_code2,]
flow <- flow[flow$all > 600,] # Subset out the largest flows

centroids <- st_read("https://github.com/npct/pct-outputs-regional-notR/raw/master/commute/msoa/isle-of-wight/c.geojson")
centroids <- centroids[,"geo_code"]

roads <- st_read("http://download.geofabrik.de/europe/great-britain/england/isle-of-wight-latest.osm.pbf", layer = "lines")
roads <- roads[!is.na(roads$highway),] # Subset to just the roads
```

\*\* Exercises \*\*

Install and load the folloing packages:

-   `sf`
-   `stplanr`
-   `cyclestreets`
-   `tmap`
-   `transportAPI`
-   `opentripplanner` - optional

Add the CycleStreets API Key to your R Environment

Add the TransportAPI API key to your R Environment (Optional)

Download and load the example data

Basic Routing
-------------

Let's start with finding a simple route from A to B. We will use two different routing services

``` r
from <- c(-1.155884, 50.72186)
to <- c(-1.173878, 50.72301)
r_cs <- cyclestreets::journey(from, to)
r_tapi <- transportAPI::tapi_journey(from, to, apitype = "public", base_url = "http://fcc.transportapi.com/")
tmap_mode("view")
qtm(r_cs) +
  qtm(r_tapi)
```

Notice that `cyclestreets` has returned 8 rows, one for each road on the journey. While TransportAPI has returned 4 rows one row representing a direct walk, the other three a walk, bus, walk route. Notice the `route_option` and `route_stage` columns.

Let's suppose you want a single line for each route.

``` r
r_cs$routeID <- 1
r_cs <- r_cs %>%
  dplyr::group_by(routeID) %>%
  dplyr::summarise(distances = sum(distances),
            time = sum(time),
            busynance = sum(time))
```

We now have a single row but instead of a `LINESTRING` wen now have a `MULTILINESTRING`, we can convert to a linestring by using `st_line_merge()`. Note how the different columns where summarised.

``` r
st_geometry_type(r_cs)
r_cs <- st_line_merge(r_cs)
st_geometry_type(r_cs)
```

\*\* Exercise \*\* Experiment with routing can you find out how to:

-   Route for driving and cycling using transportAPI
-   Change the date and time of travel with transportAPI
-   Find fast and quiet routes from cyclestreets

Hint: Try using `?tapi_journey` to view the help files

Batch Routing
-------------

One route is useful, may many routes is better! We will find the routes for the 8 most commuter desire lines on the Isle of Wight. First, we must turn the flow data into a set of start and end points. We will use the `stplanr` package. The `od2odf` function returns the start and end coordinates by combing the `flow` and `centroids` datasets by the shared `geo_code`.

``` r
flow2 <- stplanr::od2odf(flow[,c("geo_code1","geo_code2")], as(centroids,"Spatial")) 
# Note this function does not currently work with SF, so as("Spatial") required
head(flow2)
```

The `cyclestreets` package doe not have an inbuilt batch routing option so we must build a simple loop

``` r
routes_cs <- list()
for(i in 1:nrow(flow2)){
  r_cs_sub <- cyclestreets::journey(as.numeric(flow2[i,3:4]), as.numeric(flow2[i,5:6]))
  r_cs_sub$routeID <- paste0(flow2$code_o[i]," ",flow2$code_d[i])
  routes_cs[[i]] <- r_cs_sub
}
```

This leaves us with a list of data.frames. Which we can combine using `do.call(rbind)`. **Note** for large lists this is slow. consider using `dplyr::bind_rows()` and rebuilding the geometry column. We can also group them into a single line for each route.

``` r
routes_cs <- do.call(rbind,routes_cs)
routes_cs <- routes_cs %>%
  dplyr::group_by(routeID) %>%
  dplyr::summarise(distances = sum(distances),
            time = sum(time),
            busynance = sum(time))
qtm(routes_cs)
```

The `transportAPI` package has a builtin batch routing function, and will also accept an SF point input.

``` r
from <- dplyr::left_join(flow, centroids, by = c("geo_code1" = "geo_code"))
to   <- dplyr::left_join(flow, centroids, by = c("geo_code2" = "geo_code"))
routes_tapi <- transportAPI::tapi_journey_batch(from$geometry, to$geometry, 
                                                from$geo_code1, to$geo_code2,
                                                base_url = "http://fcc.transportapi.com/")
```

**Exercises**

Examine the different results produced by cyclestreets and transportAPI.

-   how would you compare travel times by bike an public transport?

Network Analysis
----------------

We will now look to analyse the road network using `dodgr`.

``` r
streetnet <- dodgr::weight_streetnet(roads)
distances <- dodgr::dodgr_dists(streetnet, as.matrix(flow2[,3:4]), as.matrix(flow2[,5:6]))
colnames(distances) <- flow2$code_d
rownames(distances) <- flow2$code_o
distances
```
