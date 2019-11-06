An introduction to road safety analysis with R: setup notes
================

These are prerequisites for the upcoming course on 4th December, 9AM.

The course is located in the EC Stone Cluster 6.68, which is a 5 minute
walk from ITS - see here for directions:
<https://it.leeds.ac.uk/it?id=kb_article&sysparm_article=KB0011752>

**Note that it takes time to startup your laptop or login to the cluster
computers so please arrive by 09:00 prompt.**

## Installing RStudio

**Your computer should also have the necessary software installed before
the session.**

You are expected to have **RStudio properly installed on your computer**
or **to have tested RStudio on a cluster computer** before the R
workshop on 4th December. I encourage you to install R and RStudio, and
bring your own laptop for the course because the cluster computers are
slow, and you will have more control over your R setup that way. To
learn how to install R and RStudio, see
[here](https://courses.edx.org/courses/UTAustinX/UT.7.01x/3T2014/56c5437b88fa43cf828bff5371c6a924/).

**Test that your RStudio installation works before the course** by
opening the RStudio, pasting the following line of code into the console
on the bottom left of RStudio and pressing Enter:

``` r
source("https://git.io/JeaZH")
```

If you see a figure appear on the right of the screen, congratulations,
your RStudio installation is ready to go. If not, copy and paste the
following code into the console:

``` r
install.packages("remotes")
pkgs = c(
  "pct",         # package for getting travel data in the UK
  "sf",          # spatial data package
  "stats19",     # downloads and formats open stats19 crash data
  "stplanr",     # for working with origin-destination and route data
  "tidyverse",   # a package for user friendly data science
  "tmap"         # for making maps
)
remotes::install_cran(pkgs)
# remotes::install_github("ITSLeeds/pct")
```

## Prior reading

### Esential

To read up on R, we recommend reading Chapter 1 Getting Started with
Data in R of the online book Statistical Inference via Data Science,
which can be found here:
<https://moderndive.netlify.com/1-getting-started.html>

Reading sections 1.1 to 1.3 of that book and trying a few of the
examples are considered **essential prerequisites**, unless you are
already experienced with R.

### Optional

Optionally, if you want a more interactive learning environment, you can
try getting started with the free
[DataCamp](https://www.datacamp.com/courses/free-introduction-to-r)
course. Other good resources can be found at
[education.rstudio.com/learn](https://education.rstudio.com/learn/beginner/).

And for more information on how R can be used for transport research,
the Transportation chapter of Geocomputation with R (Lovelace, Nowosad,
and Meunchow 2019) is a good place to start:
<https://geocompr.robinlovelace.net/transport.html>

A more detailed resource on R for transport planning is Lovelace and
Ellison (2018).

For an introduction to data science with R, see Grolemund and Wickham
(2016).

## Another test of R and RStudio

As another test, try running the following commands from RStudio (which
should result in a
map):

<!-- method for helping people set up their computers. Type this single line into the console and follow the instructions.  -->

``` r
library(stats19)
library(tidyverse)
library(tmap) # installed alongside mapview
crashes = get_stats19(year = 2017, type = "ac")
crashes_iow = crashes %>% 
  filter(local_authority_district == "Isle of Wight") %>% 
  format_sf()
  
# basic plot
plot(crashes_iow)
```

You should see results like those shown in the map here:
<https://github.com/ropensci/stats19/issues/105>

If you cannot create that map by running the code above before the
course, get in touch with us, e.g. by writing a comment under that
github issue page (Note: You will need a github account).

For an online version of these instructions see here:
<https://github.com/ITSLeeds/TDS/blob/master/courses/training-setup-message.md>

## References

<div id="refs" class="references">

<div id="ref-grolemund_r_2016:1">

Grolemund, Garrett, and Hadley Wickham. 2016. *R for Data Science*.
O’Reilly Media.

</div>

<div id="ref-lovelace_stplanr:_2018">

Lovelace, Robin, and Richard Ellison. 2018. “Stplanr: A Package for
Transport Planning.” *The R Journal* 10 (2): 7–23.
<https://doi.org/10.32614/RJ-2018-053>.

</div>

<div id="ref-lovelace_geocomputation_2019">

Lovelace, Robin, Jakub Nowosad, and Jannes Meunchow. 2019.
*Geocomputation with R*. CRC Press. <http://robinlovelace.net/geocompr>.

</div>

</div>
