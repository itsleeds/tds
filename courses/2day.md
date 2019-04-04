2 day course: R for Spatial Transport Data
================

See <https://github.com/ITSLeeds/TDS>

Assumed prior knowledge:

  - Working knowledge of R, e.g. have completed:
      - Introduction to R free DataCamp course:
        <https://www.datacamp.com/courses/free-introduction-to-r>
      - Recommended reading: Section 4.2 of *Efficient R Programming*
        (Gillespie and Lovelace 2016):
        <https://csgillespie.github.io/efficientR/efficient-workflow.html#package-selection>
  - Some knowledge of tidyverse is highly recommended, e.g. already know
    the contents of or have read-up on **and tried examples from** the
    following ‘cheatsheets’:
      - Tidyverse for Beginners DataCamp Cheat Sheet (see
        [here](https://s3.amazonaws.com/assets.datacamp.com/blog_assets/Tidyverse+Cheat+Sheet.pdf)).
        **At a minimum you will have completed up to Chapter 5 on this
        online course** (this may take ~2 hours)
      - Data wrangling with dplyr and tidyr RStudio cheet cheet (see
        [here](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf))

<!-- **It's in the Analysis directorate** -->

## Computing Requirements

  - DfT will provide desktops with recent versions of R and RStudio
    installed, including:
      - R 3.5.3 recommended (although any R 3.5 release should work):
        <https://cran.r-project.org/>
      - RStudio 1.1.436 - see
        <https://www.rstudio.com/products/rstudio/download/>
      - Will require up-to-date versions of **tidyverse** and **sf**
        packages, at a minimum
      - Other packages we’ll use:
          - stats19
          - stplanr
          - tmap
          - devtools
          - The GitHub package spDataLarge, which can be installed as
            follows:

<!-- end list -->

``` r
devtools::install_github("Nowosad/spDataLarge")
```

  - Own laptops allowed, provided necessary data is installed

  - Data: all data will be either provided by packages or downloaded on
    the day (assuming good internet)
    
      - A test to check if data downloads work is accessing stats19 data
        (check this
works):

<!-- end list -->

``` r
crashes = stats19::get_stats19(year = 2017, type = "accidents", ask = FALSE)
```

  - A script to test set-up will be provided to test it all works

## Venue and course times

Venue: near DfT HQ at Horseferry road, TBC

Course times each day:

  - 09:30 - 10:00 (set-up)

  - 10:00 - 11:00

  - break

  - 11:30 - 12:30

  - 12:30 - 13:30: lunch

  - 13:30 - 15:00

  - break

  - 15:00 - 16:00

  - 16:00 - 16:30 (Q\&A)

Day 1:

Introduction to R/RStudio

  - How to use R/RStudio effectively
  - Using packages: example with sf/ggplot2 (tbc)
  - Spatial data analysis
  - Visualising spatial datasets

Day 2:

  - stats19 data analysis - with spatial/temporal analysis
  - OD data with stplanr
  - Data and methods for assessing cycling potential
  - Local route network analysis
      - Download data from open roads: put on test scripts

## Optional extra reading

  - Optional extra reading: for context, you may want to read-up on:
      - Overview of GIS in R, e.g. in Chapter 1 of *Geocomputation with
        R* or this blog post:
        <https://www.jessesadler.com/post/gis-with-r-intro/>
      - stplanr: A package for transport planning (Lovelace and Ellison
        2018)
      - R for data science (Grolemund and Wickham 2016)
      - For an overview of spatial transport data types, see Chapter 12
        of *Geocomputation with R*
        (<span class="citeproc-not-found" data-reference-id="lovelace_geocomputation_2019">**???**</span>):
        <http://geocompr.robinlovelace.net/transport.html>

## References

<div id="refs" class="references">

<div id="ref-gillespie_efficient_2016">

Gillespie, Colin, and Robin Lovelace. 2016. *Efficient R Programming: A
Practical Guide to Smarter Programming*. O’Reilly Media.
<https://csgillespie.github.io/efficientR/>.

</div>

<div id="ref-grolemund_r_2016">

Grolemund, Garrett, and Hadley Wickham. 2016. *R for Data Science*. 1
edition. O’Reilly Media.

</div>

<div id="ref-lovelace_stplanr:_2018">

Lovelace, Robin, and Richard Ellison. 2018. “Stplanr: A Package for
Transport Planning.” *The R Journal* 10 (2): 7–23.
<https://doi.org/10.32614/RJ-2018-053>.

</div>

</div>
