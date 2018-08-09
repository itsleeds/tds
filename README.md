
<!-- README.md is generated from README.Rmd. Please edit that file -->
TDS (Transport Data Science)
============================

This repo support teaching of the Transport Data Science module, part of the Mathematical Modelling for Transport ([MMT](http://www.its.leeds.ac.uk/courses/masters/msc-mathematical-modelling-transport/)) MSc course at the Institute for Transport Studies.

The module catalogue can be found at [`catalogue.md`](https://github.com/ITSLeeds/TDS/blob/master/catalogue.md). The code accompanying the course can be found in the `code` folders. To run this code you will need R and Python installed plus various packages and libraries. This software has been packaged-up into a docker container to ease teaching.

Software
========

After you have [installed docker](https://docs.docker.com/install/), you should be able to run the software by executing the following commands in a terminal such as Windows PowerShell or the default terminal on Linx and MAC operating systems:

``` bash
docker run -d -p 8787:8787 -v $(pwd):/home/rstudio/data robinlovelace/tds  
```

This will:

-   Pull the docker image from <https://hub.docker.com/r/robinlovelace/tds/> if it's not already on your computer
-   Launch a locally hosted instance of RStudio Server which can be accessed at <http://localhost:8787/>
-   Mount your current working dirctory to the data folder in the home directly of the docker image

After navigating to <http://localhost:8787/> in a browser you should see a login screen. Username and password are rstudio. See <https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image> for details.

Once in the container you can use all the R packages. To access the pre-installed Python packages you will need to enter the following commands:

``` bash
conda activate
python
```

to go into the Python shell. Form more on running Python in RStudio see [community.rstudio.com](https://community.rstudio.com/t/r-python-in-ide/279). A demonstration showing the `tds` docker image in action is illustrated below.

![](https://user-images.githubusercontent.com/1825120/43570979-a41791c2-9633-11e8-9edd-f3e11bc884c1.gif)

Issues and contributing
=======================

Any feedback or contributions to this repo are welcome. If you have a question please open an issue here (you'll need a GitHub account): <https://github.com/ITSLeeds/TDS/issues>

Data
====

Data for course can be accessed from the repos [Releases](https://github.com/ITSLeeds/TDS/releases) page. You can, for example, download and unzip the data folder in a local version of the repo (accessed by downloading and unzipp <https://github.com/ITSLeeds/TDS/archive/master.zip> ) with the following R commands:

``` r
download.file("https://github.com/ITSLeeds/TDS/releases/download/0.1/data.zip", destfile = "data.zip")
unzip("data.zip")
```

If you want to be clever you can use the piggyback package:

``` r
# install.packages("devtools")
devtools::install_github("cboettig/piggyback")
piggyback::pb_download("data.zip")

# (This package was used to upload the data with:)
# piggyback::pb_upload(file = "data.zip")
# piggyback::pb_upload(file = "codeExamples.zip")
```

Other projects
==============

-   A book on R for Geocomputation: <https://github.com/Robinlovelace/geocompr>
-   A Python package for OSM data analysis: <https://github.com/gboeing/osmnx>
