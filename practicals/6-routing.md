Routing
================
Malcolm Morgan
University of Leeds
<br/><img class="img-footer" alt="" src="https://comms.leeds.ac.uk/wp-content/themes/toolkit-wordpress-theme/img/logo.png">

## Setting Up

If you have not installed the package before hand. You can use [ITS
Go](https://itsleeds.github.io/go/) to do an easy setup of your computer

``` r
source("https://git.io/JvGjF")
```

The packages we will be using are:

``` r
library(sf) # Spatial data functions
library(tidyverse) # General data manipulation
library(stplanr) # General transport data functions
library(dodgr) # Local routing and network analysis
library(opentripplanner) # Connect to and use OpenTripPlanner
library(tmap) # Make maps
library(osmextract) # Download and import OpenStreetMap data
tmap_mode("plot")
```

## Using OpenTripPlanner to get routes

We have setup the Multi-modal routing service OpenTripPlanner for West
Yorkshire. Try typing this URL — otp. saferactive. org (no spaces) —
during the session into your browser. You should see something like
this:

<img src="otp_screenshot.png" title="OTP Web GUI" alt="OTP Web GUI" style="display: block; margin: auto;" />

**Exercise**

1.  Play with the web interface, finding different types of routes. What
    strengths/limitations can you find?

### Connecting to OpenTripPlanner

To allow R to connect to the OpenTripPlanner server, we will use the
`opentripplanner` package and the function `otp_connect`.

``` r
# ip = "localhost" # to run it on your computer (see final bonus exercise)
ip = "otp.saferactive.org" # an actual server
otpcon = otp_connect(hostname = ip, 
                     port = 80,
                     router = "west-yorkshire")
```

If you have connected successfully, then you should get a message
“Router exists.”

To get some routes, we will start by importing some data we have used
previously. Note that the data frame has 78 columns (only a few of which
are useful) and 1k rows:

``` r
u = "https://github.com/ITSLeeds/TDS/releases/download/22/desire_lines_100.geojson"
desire_lines = read_sf(u)
dim(desire_lines)
```

    ## [1] 101  78

**Exercise**

2.  Subset the and overwrite the `desire_lines` data frame with the `=`
    assignment operator so that it only has the following columns:
    geo_code1, geo_code2, all, bicycle, foot, car_driver, and geometry.
    You can test the that the operation worked by executing the object
    name, the result should look like that shown below.

3.  Use the `tmap` package to plot the `desire_lines`. Choose different
    ways to visualise the data so you can understand local commuter
    travel patterns. See example plot below.

![](6-routing_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

This dataset has desire lines, but most routing packages need start and
endpoints, so we will extract the points from the lines using the
`stplanr::line2df` function. An then select the top 3 desire lines.

**Exercise**

4.  Produce a data frame called `desire` which contains the coordinates
    of the start and endpoints of the lines in `desire_lines` but not
    the geometries. Hint `?stplanr::line2df` and `?dplyr::bind_cols`

5.  Subset out the top three desire lines by the total number of
    commuters and create a new data frame called `desire_top`. Hint
    `?dplyr::slice_max`

``` r
desire_top = desire_lines %>% 
  top_n(n = 3, wt = car_driver)
```

6.  Find the driving routes for `desire_top` and call them `routes_top`
    using `opentripplanner::otp_plan`

To find the routes for the first three desire lines use the following
command:

``` r
routes_drive_top = route(
  l = desire_top,
  route_fun = otp_plan,
  mode = "CAR",
  otpcon = otpcon
  )
```

7.  Plot `routes_drive_top` using the `tmap` package in interactive
    mode. You should see something like the image below.

``` r
tmap_mode("view")
```

    ## tmap mode set to interactive viewing

``` r
tm_shape(routes_drive_top) + tm_lines()
```

![](6-routing_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

``` r
tmap_mode("plot")
```

    ## tmap mode set to plotting

We can also get Isochrones from OTP.

``` r
sf::sf_use_s2(FALSE)
isochrone = otp_isochrone(otpcon, fromPlace = c(-1.558655, 53.807870), 
                          mode = c("BICYCLE","TRANSIT"),
                          maxWalkDistance = 3000)
isochrone$time = isochrone$time / 60
tm_shape(isochrone) +
  tm_fill("time", alpha = 0.6)
```

![](6-routing_files/figure-gfm/unnamed-chunk-15-1.png)<!-- -->

To save overloading the server, we have pre-generated some extra routes.
Download these routes and load them into R.

``` r
u = "https://github.com/ITSLeeds/TDS/releases/download/22/routes_drive.geojson"
routes_drive = read_sf(u)
u = "https://github.com/ITSLeeds/TDS/releases/download/22/routes_transit.geojson"
routes_transit = read_sf("transit_routes.gpkg")
```

## Route Networks

Route networks (also called flow maps) show transport demand on
different parts of the road network.

Now we have the number of commuters and their routes, we can produce a
route network map using `stplanr::overline`.

``` r
rnet_drive <- overline(routes_drive, "car_driver")
```

**Exercise** 15. Make a route network for driving and plot it using the
`tmap` package. How is is different from just plotting the routes?

![](6-routing_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

## Line Merging

Notice that `routes_transit` has returned separate rows for each mode
(WALK, RAIL). Notice the `route_option` column shows that some routes
have multiple options.

Let’s suppose you want a single line for each route.

**Exercise**

16. Filter the `routes_transit` to contain only one route option per
    origin-destination pair.

Now We will group the separate parts of the routes together.

``` r
routes_transit_group = routes_transit %>%
  dplyr::group_by(fromPlace, toPlace) %>%
  dplyr::summarise(distance = sum(distance))
```

We now have a single row, but instead of a `LINESTRING`, we now have a
mix of `MULTILINESTRING` and `LINESTRING`, we can convert to a
`LINESTRING` by using `st_line_merge()`. Note how the different columns
where summarised.

First, we must separate out the `MULTILINESTRING` and `LINESTRING`

``` r
routes_transit_group_ml = routes_transit_group[st_geometry_type(routes_transit_group) == "MULTILINESTRING", ]
routes_transit_group = routes_transit_group[st_geometry_type(routes_transit_group) != "MULTILINESTRING", ]
routes_transit_group_ml = st_line_merge(routes_transit_group_ml)
routes_transit_group = rbind(routes_transit_group, routes_transit_group_ml)
```

**Exercise**

17. Plot the transit routes, what do you notice about them?

![](6-routing_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

**Bonus Exercise**:

18. Redo exercise 16 but make sure you always select the fastest option.

## Network Analysis (dodgr)

**Note** Some people have have problems running dodgr on Windows, if you
do follow these
[instructions](https://github.com/ITSLeeds/TDS/blob/master/practicals/dodgr-install.md).

We will now analyse the road network using `dodgr`. Network analysis can
take a very long time on large areas. So we will use the example of the
[Isle of Wight](https://en.wikipedia.org/wiki/Isle_of_Wight), which is
ideal for transport studies as it is small, but has a full transport
system including a railway and the last commercial hovercraft service in
the world.

First we need to download the roads network from the OpenStreetMap using
`osmextract::oe_get`. We will removed most of the paths and other
features and just focus on the main roads. Then use
`dodgr::weight_streetnet` to produce a graph of the road network.

``` r
roads = oe_get("Isle of Wight", extra_tags = c("maxspeed","oneway"))
roads = roads[!is.na(roads$highway),]
road_types = c("residential","secondary","tertiary",
                        "unclassified","primary","primary_link",
                        "secondary_link","tertiary_link")
roads = roads[roads$highway %in% road_types, ]
graph = weight_streetnet(roads)
```

We will find the betweenness centrality of the Isle of Wight road
network. This can take a long time, so first lets check how long it will
take.

``` r
estimate_centrality_time(graph)
```

    ## Estimated time to calculate centrality for full graph is 00:00:04

``` r
centrality = dodgr_centrality(graph)
```

We can convert a `dodgr` graph back into a sf data frame for plotting
using `dodgr::dodgr_to_sf`

``` r
clear_dodgr_cache()
centrality_sf = dodgr_to_sf(centrality)
```

    ## old-style crs object detected; please recreate object with a recent sf::st_crs()

**Exercise**

19. Plot the centrality of the Isle of Wight road network. What can
    centrality tell you about a road network?

![](6-routing_files/figure-gfm/unnamed-chunk-28-1.png)<!-- -->

20. Use `dodgr::dodgr_contract_graph` before calculating centrality, how
    does this affect the computation time and the results?

**Bonus Exercises**

21. Work though the OpenTripPlanner vignettes [Getting
    Started](https://docs.ropensci.org/opentripplanner/articles/opentripplanner.html)
    and [Advanced
    Features](https://docs.ropensci.org/opentripplanner/articles/advanced_features.html)
    to run your own local trip planner for the Isle of Wight.

**Note** To use OpenTripPlanner on your own computer requires Java 8.
See the
[Prerequisites](https://docs.ropensci.org/opentripplanner/articles/prerequisites.html)
for more details. If you can’t install Java 8 try some of the examples
in the vignettes but modify them for West Yorkshire.

22. Read the `dodgr`
    [vignettes](https://atfutures.github.io/dodgr/articles/index.html)
