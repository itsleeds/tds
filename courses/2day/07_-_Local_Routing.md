Local route network analysis
================

Routing from A to B
-------------------

Routing is the process of finding the "shortest" path from A to B. In this context shortest does not just mean in distance, it may be in time (quickest), or some other characteristic e.g. safest, quietest.

There are many packages that enable you to do routing in R. When choosing a package you should consider seveal characteritics:

### Local or Remote

Some packages can do local routing on your own computer. While other allow you to connect to a service.

**Local Routing**

-   Usually requires more effort to set up
-   No cost (except for time and hardware)
-   Control over data, custom scenarios possible futures etc

\*\* Remote Routing \*\*

-   Easy setup
-   May charge or limit the number of routes
-   May support more complex options e.g. traffic, public transport
-   Usually limited to routing in the present e.g. current road network current transpor timetables.

### Routing Features

Not all routing services can do all types of routing, or do them equally well. Most do driving directions but consider if they do:

-   Walking / Cycling (if so does it include specalist road types, exclude dangerour roads)
-   Take account of hilliness
-   Public Transport (if so does it include fares, which types?)
-   Are public transport routes based on timetables or realtime service status?
-   Take account of steps and disabled access
-   Support specialist vehicles (e.g. lorrys and low bridges)
-   Does it support realtime or historic traffic data?

Routing packages for R
----------------------

A non-comprehesive list of routing packages for R

Packages on CRAN
----------------

-   [googleway](https://cran.r-project.org/web/packages/googleway/) support for Google Maps and Directions
-   [mapsapi](https://cran.rstudio.com/web/packages/mapsapi/) alternative for google maps
-   [osrmr](https://cran.r-project.org/web/packages/osrmr/) Open Source Routing Machine, can connect to remote \* [CycleStreets](https://cran.r-project.org/web/packages/cyclestreets) Specalist cycling routing, used by
-   [dodgr](https://cran.r-project.org/web/packages/dodgr) Routing done in R
-   [igraph](https://cran.r-project.org/web/packages/igraph) General network analysis, not transport specific
-   [stplanr](https://cran.r-project.org/web/packages/stplanr) Limited routing functions based on dodgr and igraph, and some other services.
-   [gtfsrouter](https://cran.r-project.org/web/packages/gtfsrouter/index.html) For integrating GTFS public transport timetables

Packages on GitHub
------------------

-   [Open Route Service](https://giscience.github.io/openrouteservice-r/) Connect to ORS website
-   [TransportAPI](https://github.com/mem48/transportAPI) An ITS Leeds Package, in development
-   [OpenTripPlanner](https://github.com/ITSLeeds/opentripplanner) An ITS Leeds Package, local or remote OTP routing
-   [graphhopper](https://github.com/graphhopper/directions-api-clients/tree/master/r)

Including Code
--------------

You can include R code in the document as follows:

``` r
summary(cars)
```

    ##      speed           dist       
    ##  Min.   : 4.0   Min.   :  2.00  
    ##  1st Qu.:12.0   1st Qu.: 26.00  
    ##  Median :15.0   Median : 36.00  
    ##  Mean   :15.4   Mean   : 42.98  
    ##  3rd Qu.:19.0   3rd Qu.: 56.00  
    ##  Max.   :25.0   Max.   :120.00

Including Plots
---------------

You can also embed plots, for example:

![](07_-_Local_Routing_files/figure-markdown_github/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
