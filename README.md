
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TDS (Transport Data Science)

This is a GitHub Repository (repo for short) that supports teaching of
the Transport Data Science module at the University of Leeds. The module
can be taken by students on the [Data Science and
Analytics](https://courses.leeds.ac.uk/i071/data-science-and-analytics-msc)
and (from 2022 onwards) [Transport Planning and the
Environment](https://courses.leeds.ac.uk/a386/transport-planning-and-the-environment-msc)
MSc courses.

The module catalogue can be found at
[`catalogue.md`](https://github.com/ITSLeeds/TDS/blob/master/catalogue.md).
The computer code accompanying the course can be found in the `code`
folders. To run this code you will need R and Python installed plus
various packages and libraries.
<!-- This software has been packaged-up into a docker container to ease teaching. -->

The timetable can be found:

-   On the University’s system (official):
    [http://timetable.leeds.ac.uk/](http://timetable.leeds.ac.uk/teaching/202021/reporting/Individual?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21)
-   In ical format (for import into Google/Outlook/other Calendar
    systems):
    <https://github.com/ITSLeeds/TDS/raw/master/timetable-2020.ics>
-   As a .csv file (for easy reading as data):
    <https://github.com/ITSLeeds/TDS/blob/master/timetable-2020.csv>

See below for the sessions

The module timetable is shown in the table below.

| Summary                    | Description                                                         | Dtstart             | Location       | Duration |
|:---------------------------|:--------------------------------------------------------------------|:--------------------|:---------------|:---------|
| TDS deadline 1             | Computer set-up                                                     | 2021-01-29 13:00:00 | Online - Teams | 240 mins |
| TDS Lecture 1: intro       | Introduction to transport data science in Online - Teams            | 2021-02-01 09:00:00 | Online - Teams | 60 mins  |
| TDS Practical 1: structure | The structure of transport data in Online - Teams                   | 2021-02-04 14:00:00 | Online - Teams | 150 mins |
| TDS Lecture 2: structure   | The structure of transport data and data cleaning in Online - Teams | 2021-02-08 09:00:00 | Online - Teams | 60 mins  |
| TDS Practical 2: getting   | Getting transport data in Online - Teams                            | 2021-02-11 14:00:00 | Online - Teams | 150 mins |
| TDS Lecture 3: routing     | Routing in Online - Teams                                           | 2021-02-15 09:00:00 | Online - Teams | 60 mins  |
| TDS seminar 1              | Mapping large datasets                                              | 2021-02-18 14:00:00 | Online - Teams | 150 mins |
| TDS deadline 2             | Practical: visualising transport data                               | 2021-02-19 13:00:00 | Online - Teams | 150 mins |
| TDS Practical 3: routing   | Routing in Online - Teams                                           | 2021-02-25 14:00:00 | Online - Teams | 150 mins |
| TDS seminar 2              | Data science in transport planning                                  | 2021-03-04 14:00:00 | Online - Teams | 150 mins |
| TDS Lecture 4: viz         | Visualisation in Online - Teams                                     | 2021-03-15 09:00:00 | Online - Teams | 60 mins  |
| TDS Practical 4: modelling | Modelling in Online - Teams                                         | 2021-03-18 14:00:00 | Online - Teams | 150 mins |
| TDS Lecture 5: project     | Project work in Online - Teams                                      | 2021-03-22 09:00:00 | Online - Teams | 60 mins  |
| TDS deadline 3             | Draft portfolio                                                     | 2021-03-26 13:00:00 | Online - Teams | 60 mins  |
| TDS Practical 5: project   | Project work in Online - Teams                                      | 2021-04-29 14:00:00 | Online - Teams | 150 mins |
| TDS deadline 4             | Deadline: coursework, 2pm                                           | 2021-05-14 13:00:00 | Online - Teams | 60 mins  |

<!-- # References -->
<!-- To access references collected for this course (and contribute more if you want), you can join the 'tds' Zotero group: https://www.zotero.org/groups/956304/tds -->

# Software

For this module you need to have up-to-date versions of R and RStudio.
Install:

-   R from [cran.r-project.org](https://cran.r-project.org/)
-   RStudio from
    [rstudio.com](https://rstudio.com/products/rstudio/download/#download)
-   R packages, by opening RStudio and typing
    `install.packages("stats19")` in the R console.

We recommend using at least the latest stable release of R (4.0.0 or
above). We recommend running R on a decent computer, with at least 4 GB
RAM and ideally 8 GB or more RAM. See [Section 1.5 of the online guide
Reproducible Road Safety Research with
R](https://itsleeds.github.io/rrsrr/introduction.html#installing-r-and-rstudio)
for instructions on how to install key packages we will use in the
module.[1]

<!-- ## Course locations -->
<!-- See the image below for the course locations and the following links: -->
<!-- The lectures will be in the Business School Maurice Keyworth SR (1.15): http://students.leeds.ac.uk/room/1-01-087-2730-01-115 -->
<!-- The practicals will be in the West Teaching Lab Cluster (B.16): http://it.leeds.ac.uk/site/custom_scripts/clusters.php -->

# Slides and lectures

Slides can be found online:

-   See <https://itsleeds.github.io/TDS/slides/1-intro.html#1> for the
    introductory slides, for example
-   Videos of the lectures can be found on the University of Leeds’
    Blackboard system (you must must
    [register](https://www.leeds.ac.uk/info/101040/applying/86/how_to_apply_for_masters_courses)
    to courses such as [Data Science and
    Analytics](https://courses.leeds.ac.uk/i071/data-science-and-analytics-msc)
    or [Transport Planning and the
    Environment](https://courses.leeds.ac.uk/a386/transport-planning-and-the-environment-msc)
    to take the course)

# Assessment (for those doing this as credit-bearing)

-   You will build-up a portfolio of work
-   100% coursework assessed, you will submit by **Friday 14th May**:
    -   **a pdf document up to 10 pages long with figures, tables,
        references explaining how you used data science to research a
        transport problem**
    -   **reproducible code contained in an RMarkdown (.Rmd) document
        that produced the report**
-   Written in RMarkdown - will be graded for reproducibility
-   Code chunks and figures are encouraged
-   You will submit a non-assessed 2 page pdf + Rmd report by **Friday
    26th March**

# Issues and contributing

Any feedback or contributions to this repo are welcome. If you have a
question please open an issue here (you’ll need a GitHub account):
<https://github.com/ITSLeeds/TDS/issues>

<!-- # Data -->
<!-- Data for course can be accessed from the repos [Releases](https://github.com/ITSLeeds/TDS/releases) page. -->
<!-- You can, for example, download and unzip the data folder in a local version of the repo (accessed by downloading and unzipp https://github.com/ITSLeeds/TDS/archive/master.zip ) with the following R commands: -->
<!-- If you want to be clever you can use the piggyback package: -->
<!-- # Other projects -->
<!-- - A book on R for Geocomputation: https://github.com/Robinlovelace/geocompr -->
<!-- - A Python package for OSM data analysis: https://github.com/gboeing/osmnx -->
<!-- # Building the website -->
<!-- To publish the slides and other content online, the following commands were used: -->

[1]  For further guidance on setting-up your computer to run R and
RStudio for spatial data, see these links, we recommend Chapter 2 of
Geocomputation with R (the Prerequisites section contains links for
installing spatial software on Mac, Linux and Windows):
<https://geocompr.robinlovelace.net/spatial-class.html> and Chapter 2 of
the online book *Efficient R Programming*, particularly sections 2.3 and
2.5, for details on R installation and
[set-up](https://csgillespie.github.io/efficientR/set-up.html) and the
[project management
section](https://csgillespie.github.io/efficientR/set-up.html#project-management).
