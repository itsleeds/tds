Routing
================
Malcolm Morgan
University of Leeds,
2020-02-11<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

## Setting Up (10 minutes)

We will use [ITS Go](https://itsleeds.github.io/go/) to do an easy setup
of your computer.

``` r
source("https://git.io/JvGjF")
```

If that does not work the packages we will be using are:

  - sf
  - tidyverse
  - tmap
  - pct
  - stplanr
  - dodgr
  - opentripplanner
  - igraph
  - ITSleeds/geofabrik

## Using OpenTripPlanner to get routes

We have setup the Multi-modal routing service OpenTripPlanner for West
Yorkshire. Try typing the URL shown during the session into your
broswer. You should see somthign like
this:

<img src="otp_screenshot.png" title="\label{fig:otpgui}OTP Web GUI" alt="\label{fig:otpgui}OTP Web GUI" style="display: block; margin: auto;" />

**Exercise**: Play with the web interface, finding different types of
routes. What strengths/limitations can you find?

### Connecting to OpenTripPlanner

To allow R to connect to the OpenTripPlanner server, we will use the
`opentripplanner` package and the function `otp_connect`. In this
example I have saved the hostname of the server as a variable called
“robinIP” in my Renviron file by using `usethis::edit_r_environ()`

However, you can also just set it manually.

``` r
library(sf)
library(tidyverse)
library(stplanr)
library(opentripplanner)
library(tmap)
tmap_mode("plot")
otpcon <- otp_connect(hostname = Sys.getenv("robinIP"), port = 8080)
```

If you have connected successfully, then you should get a message
“Router exists.”

To get some routes, we will start by importing some data we have used
previously.

``` r
u = "https://github.com/ITSLeeds/TDS/releases/download/0.1/desire_lines.geojson"
download.file(u, "desire_lines.geojson")
desire_lines = read_sf("desire_lines.geojson")
```

**Exercise** Subset the `desire_lines` data frame so that it only has
the folloing columns: “geo\_code1”, “geo\_code2”, “all”, “bicycle”,
“foot”, “car\_driver”, “car\_passenger”, “train”, “taxi”, “motorbike”,
and “geometry”

This dataset has desire lines, but most routing packages need start and
endpoints, so we will extract the points from the lines using the
`line2df` function. An then select the top 3 desire lines.

**Exercises**

1.  Produce a data frame called `desire` which contains the coordinate
    of the start and endpoints of the lines in `desire_lines` but not
    the geometries.
2.  Subset out the top three desire lines by the total number of
    commuters and create a new data frame called `desire_top`
3.  Find the driving routes for `desire_top` and call them `routes_top`
    using `otp_plan`

<!-- end list -->

``` r
desire = bind_cols(desire_lines, line2df(desire_lines))
desire = st_drop_geometry(desire)
desire_top = top_n(desire, 3, all)
```

To find the routes for these desire lines.

``` r
routes_top = otp_plan(otpcon,
                      fromPlace = as.matrix(desire_top[,c("fx","fy")]),
                      toPlace = as.matrix(desire_top[,c("tx","ty")]),
                      mode = "CAR")
```

We can plot those routes using the `tmap` package.

We can also get Isochonres from OTP.

``` r
isochrone = otp_isochrone(otpcon, fromPlace = c(-1.558655, 53.807870), 
                          mode = c("BICYCLE","TRANSIT"),
                          maxWalkDistance = 3000)
isochrone$time = isochrone$time / 60
isochrone <- st_buffer(isochrone, 0)
```

    ## Warning in st_buffer.sfc(st_geometry(x), dist, nQuadSegs, endCapStyle =
    ## endCapStyle, : st_buffer does not correctly buffer longitude/latitude data

``` r
qtm(isochrone, fill = "time")
```

![](6-routing_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

To save overloading the server, I have pre-generated some extra
routes.

``` r
routes_drive = read_sf("https://github.com/ITSLeeds/TDS/releases/download/0.20.1/driving_routes.gpkg")
routes_transit = read_sf("https://github.com/ITSLeeds/TDS/releases/download/0.20.1/transit_routes.gpkg")
```

**Exercise** Examine these two new datasets `routes_drive` and
`routes_transit` plot them on a map, what useful information do they
contain what is missing?

Finally, let’s join the routes to the original desire dataset.

Note that some of the desire lines do not have a route. This is usually
because the start or endpoint is too far from the road.

**Exercise** How many routes are missing for each mode? How could you
improve this method, so there were no missing routes?

## Line Merging

Notice that `routes_transit` has returned separate rows for each mode
(WALK, RAIL). Notice the `route_option` column shows that some routes
have multiple options.

Let’s suppose you want a single line for each route.

**Exercise**: Filter the `routes_transit` to contain only one route
option per origin-destination pair. **Bonus Exercise**: Do the above,
but make sure you always select the fastest option.

Now We will group the separate parts of the routes together.

``` r
routes_transit_group <- routes_transit %>%
  dplyr::group_by(fromPlace, toPlace) %>%
  dplyr::summarise(duration = sum(duration),
                   startTime = min(startTime),
                   endTime = max(endTime),
                   distance = sum(distance))
```

We now have a single row, but instead of a `LINESTRING`, we now have a
mix of `MULTILINESTRING` and `LINESTRING`, we can convert to a
linestring by using `st_line_merge()`. Note how the different columns
where summarised.

First, we must separate out the `MULTILINESTRING` and
`LINESTRING`

``` r
routes_transit_group_ml <- routes_transit_group[st_geometry_type(routes_transit_group) == "MULTILINESTRING", ]
routes_transit_group <- routes_transit_group[st_geometry_type(routes_transit_group) != "MULTILINESTRING", ]
routes_transit_group_ml <- st_line_merge(routes_transit_group_ml)
routes_transit_group <- rbind(routes_transit_group, routes_transit_group_ml)
```

## Network Analysis (dodgr) (20 minutes)

**Note** Some people have have problems running dodgr on Windows, if you
do follow these
[instructions](https://github.com/ITSLeeds/TDS/blob/master/practicals/dodgr-install.md).

We will now look to analyse the road network using `dodgr`. First let’s
find the distances between all our centroids for a cyclist.
`dodgr_dists` returns a matrix of distances in km, note the speed of
using dodgr to find 64 distances compared to using a routing service.
`dodgr` works well for these type of calculation, but cannot do public
transport timetables.

``` r
library(geofabrik)
library(dodgr)
library(igraph)
roads = get_geofabrik("isle-of-wight")
roads = roads[!is.na(roads$highway),]
roads = roads[,c( "osm_id","name","highway","maxspeed","oneway","lanes","bridge","foot","bicycle","lit","footway")]
roads = roads[!roads$highway %in% c("proposed","construction"),]
graph = weight_streetnet(roads)
```

**Exercise**: Reproduce the Isle of Wight flow data `d_iow_origins` that
you used in the Data Cleaning Practical

Now we need to add coordinates to these flows. Let’s use the
population-weighted centroids in the `pct` package.

``` r
centroids = pct::get_pct_centroids("isle-of-wight", geography = "msoa")
centroids = centroids[,"geo_code"]
```

We can extract the coordinates out of a geometry column using
`st_coordinates`.

``` r
centroids = bind_cols(centroids, as.data.frame(st_coordinates(centroids)))
centroids = st_drop_geometry(centroids)
```

`dodgr` can also aggregate flows across a network; this allows you to
find the total number of cyclists on a particular road.

``` r
iow_od = od_to_odmatrix(d_iow_origins)
centroids = centroids[match(centroids$geo_code, rownames(iow_od)),]
summary(rownames(iow_od) == centroids$geo_code)
```

    ##    Mode    TRUE 
    ## logical      18

``` r
verts = match_points_to_graph(verts = dodgr_vertices(graph), as.matrix(centroids[,c("X","Y")]))

net = dodgr_flows_aggregate(graph, from = verts, to = verts, flows = iow_od)
summary(net$flow)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    0.00    0.00    0.00   41.04    0.00 6424.00

``` r
net = merge_directed_flows(net)
# net = merge_directed_graph(net) #function renamed on dev version
# dodgr_flowmap(net) built in plotting
net_sf = dodgr::dodgr_to_sf(net)
qtm(net_sf, lines.col = "flow", lines.lwd = 3)
```

![](6-routing_files/figure-gfm/unnamed-chunk-21-1.png)<!-- -->

## Network Analysis (igraph) (20 minutes)

`igraph` is a package for analysing all types of networks; we will use
`igraph` to identify any bottlenecks in the road network. We will do
this by calculating the betweenness centrality of the major road
network. The will provide a measure of the most “important” roads in the
network. As this calculation takes a long time, we will only do it for
the major roads.

``` r
# subset to main roads
graph2 = weight_streetnet(roads[roads$highway %in% c("primary","secondary","tertiary"),])
graph2 = dodgr_contract_graph(graph2) # Simplify the street network
# convert to igraph and calualte betweeness
graph2_ig = dodgr_to_igraph(graph2)
betweenness = igraph::edge_betweenness(graph2_ig, directed = FALSE) # This will take a while

# Transfer Value from contracted graph to main graph
graph2$between <- betweenness
graph2_sf = dodgr_to_sf(graph2)
qtm(graph2_sf, lines.col = "between", lines.lwd = 3)
```

![](6-routing_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

**Bonus Exercises**

1.  Work out how to to make the above plot using the uncontracted road
    network. Discuss in groups how this is possible.

![](6-routing_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

2.  Work though the OpenTripPlanner vignettes [Getting
    Started](https://docs.ropensci.org/opentripplanner/articles/opentripplanner.html)
    and [Advanced
    Features](https://docs.ropensci.org/opentripplanner/articles/advanced_features.html)
    to run your own local trip planner.

3.  Calculate betweenness centrality using the dodgr package directly.
    Hint: `?dodgr_centrality` is in the development version of dodgr.
