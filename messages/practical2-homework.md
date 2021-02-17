
<!-- message to students, 2021-01-28 -->

Hi all,

Following the practical session yesterday I have some homework and links
and for you.

## 1) Think of topics/datasets that you would like to work on/with for the coursework report that you will submit in May.

Below are some options:

### Topics

-   Data collection and analysis

    -   Analysis of a large transport dataset,
        e.g. <https://www.nature.com/articles/sdata201889>

-   Infrastructure and travel behaviour

    -   What are the relationships between specific types of
        infrastructure and travel, e.g. between fast roads and walking?
    -   How do official sources of infrastructure data (e.g. the
        [CID](https://github.com/PublicHealthDataGeek/CycleInfraLnd/))
        compare with crowd-sourced datasets such as OpenStreetMap (which
        can be accessed with the new [`osmextract` R
        package](https://github.com/ropensci/osmextract))
    -   Machine learning and image recognition to understand transport
        infrastructure - see <https://telraam.net/> for example

-   Changing transport systems

    -   Modelling change in transport systems, e.g. by comparing
        before/after data for different countries/cities, which
        countries had the hardest lockdowns and where have changes been
        longer term? - see here for open data:
        <https://github.com/ActiveConclusion/COVID19_mobility>
    -   How have movement patterns changed during the Coronavirus
        pandemic and what impact is that likely to have long term (see
        [here](https://saferactive.github.io/trafficalmr/articles/report3.html)
        for some graphics on this)

-   Software development

    -   Creating a package to make a particular data source more
        accessible, see <https://github.com/ropensci/stats19> for an
        example
    -   Integration between R and A/B Street - see
        <https://github.com/a-b-street/abstr>

-   Road safety - how can we makes roads and transport systems in
    general safer?

-   Other

    -   Other topics are welcome

### Datasets

These do not need to be used in isolation but choosing a main dataset
shoule help

-   STATS19 road crash data (other countries have other datasets)
-   ‘PCT’ data from UK travel behaviour
-   OpenStreetMap data (global, you will need to think of a subset by
    area/type)
-   Open data from a single city, e.g. Seattle:
    <https://data-seattlecitygis.opendata.arcgis.com/>
-   See here:
    <https://github.com/awesomedata/awesome-public-datasets#transportation>
-   And here: <https://github.com/CUTR-at-USF/awesome-transit>

### Start work on 1 page document outlining your ideas

I have set a deadline of Friday 26th February for you to submit a 1-2
page pdf document and .Rmd file. This does not need to be the final
dissertation topic but will give you a chance to get feedback. The
document should contain:

-   Topics considered
-   Datasets available
-   Missing elements/skills/risks
-   Questions that will help decide the direction of the final
    coursework
    -   E.g. do you know of a package that can help with this?
    -   Is using this dataset a good idea?

<!-- Peer-to-peer feedback will help you develop your ideas. -->

## 2) Working with RMarkdown

Take a look at the info + video on RMarkdown here (they describe the
benefits of the format better than me!):
<https://rmarkdown.rstudio.com/lesson-1.html>

Try to reproduce the .Rmd file I have provided - download this and try
to knit it and reproduce the example data analysis:
<https://github.com/ITSLeeds/TDS/raw/master/coursework-template.Rmd>

## 3) Reading-up on R + Git

If you would like to learn more about geographic data in R, I suggest
taking a look at the first 5 chapters of Geocomputation with R:
<https://geocompr.robinlovelace.net/>

If you feel you need practice on R basics, revisit this workbook and
start at the beginning - it should answer many questions:
<https://itsleeds.github.io/rrsrr/>

If you like learning from Videos, I recommend checking out the links +
video by Tom Mock here: <https://education.rstudio.com/learn/beginner/>

If you’re interested in what’s coming next week, check this video:
<https://github.com/a-b-street/abstreet#ab-street>

And for everyone wanting more info on using Git/GitHub I highly
recommend watching this video:
<https://rstudio.com/resources/rstudioconf-2017/happy-git-and-gihub-for-the-user-tutorial/>

See here for a good introduction: <https://happygitwithr.com/>

## 4) Install key packages, download data and watch the ‘Routing’ video by Malcolm

Following feedback from students it seems it would be useful to get a
list of all packages used in the TDS module. I have separated these
between ‘core’ and ‘extra’ packages - you will need the core packages
for sure and should already have them installed.

### Core packages

Run the following commands to check you have them:

``` r
install.packages("remotes")
```

``` r
install.packages("remotes")
pkgs = c(
  "pct",         # package for getting travel data in the UK
  "sf",          # spatial data package
  "stats19",     # downloads and formats open stats19 crash data
  "stplanr",     # for working with origin-destination and route data
  "tidyverse",   # a package for user friendly data science
  "tmap",        # for making maps
  "opentriplanner" # routing
  "mapview"      # mapping
)
remotes::install_cran(pkgs)
```

### Extra packages

These may be useful

``` r
# dev versions
remotes::install_github("ITSLeeds/pct")
remotes::install_github("ITSLeeds/od")
remotes::install_github("a-b-street/abstr")
```

### Download data

Follow instructions here to download the A/B Street data:

<https://a-b-street.github.io/docs/howto/index.html>
