Local Install of dodgr
================
Malcolm Morgan
University of Leeds,
2020-02-11<br/><img class="img-footer" alt="" src="http://www.stephanehess.me.uk/images/picture3.png">

Only if you cannot run the dodgr examples.

This will locally compile the latest version of dodgr on you computer.

1.  Close RStudio
2.  Go to <https://github.com/ATFutures/dodgr/> and click Clone or
    download
3.  Choose download zip
4.  Unzip the folder
5.  In the unziped folder find and open dodgr.Rproj a new Rstudio
    session will open.
6.  Run the follwoing code

<!-- end list -->

``` r
install.packages("devtools")
devtools::load_all (".", export_all = TRUE)
```
