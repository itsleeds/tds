
<!-- README.md is generated from README.Rmd. Please edit that file -->

# TDS (Transport Data Science)

This is a GitHub Repository (repo for short) that supports teaching of
the Transport Data Science module at the University of Leeds. The module
can be taken by students on the [Data Science and
Analytics](https://courses.leeds.ac.uk/i071/data-science-and-analytics-msc)
and (from 2022 onwards) [Transport Planning and the
Environment](https://courses.leeds.ac.uk/a386/transport-planning-and-the-environment-msc)
MSc courses.

<!-- The module catalogue can be found at [`catalogue.md`](https://github.com/ITSLeeds/TDS/blob/master/catalogue.md). -->
<!-- The computer code accompanying the course can be found in the `code` folders. -->
<!-- To run this code you will need R and Python installed plus various packages and libraries. -->
<!-- The timetable can be found: -->

-   On the University’s system (official):
    [http://timetable.leeds.ac.uk/](http://timetable.leeds.ac.uk/teaching/202122/reporting/Individual?objectclass=module&idtype=name&identifier=TRAN5340M01&&template=SWSCUST+module+Individual&days=1-7&weeks=1-52&periods=1-21)
-   In ical format (for import into Google/Outlook/other Calendar
    systems):
    <https://github.com/ITSLeeds/TDS/raw/master/timetable-2022.ics>
-   As a .csv file (for easy reading as data):
    <https://github.com/ITSLeeds/TDS/blob/master/timetable.csv> (see
    table below)

<!-- See below for the sessions -->

The module timetable can be downloaded as an [ical (.ics) file and added
to your calendar
here](https://teams.microsoft.com/l/team/19%3aRoB5IN0Rdk4rip9Y0bwQ5TyyO0FEeB76ei27wK8XIqM1%40thread.tacv2/conversations?groupId=0ee6f3e6-292e-4139-af39-4399feb06434&tenantId=bdeaeda8-c81d-45ce-863e-5232a535b7cb).
It is also shown in the table below.

| Summary                                           | Date       | Start_time | Duration (Hours) |
|:--------------------------------------------------|:-----------|:-----------|-----------------:|
| TDS Lecture 1                                     | 2022-01-24 | 09:00:00   |                1 |
| TDS Lecture 2: The structure of transport data    | 2022-01-31 | 09:00:00   |                1 |
| TDS Practical 1                                   | 2022-02-03 | 09:00:00   |                3 |
| Lecture 3: Routing                                | 2022-02-07 | 09:00:00   |                1 |
| TDS Practical 2: Routing                          | 2022-02-10 | 09:00:00   |                3 |
| TDS Practical 3: Data from Web Sources            | 2022-02-17 | 09:00:00   |                3 |
| TDS Practical 4: OD and route data analysis       | 2022-02-24 | 09:00:00   |                3 |
| TDS seminar: From OD Data to Dynamic Simulations  | 2022-03-09 | 13:00:00   |                3 |
| TDS Lecture 4: Visualising Transport Data         | 2022-03-14 | 09:00:00   |                1 |
| TDS Deadline 1: 2 page outline of project         | 2022-03-18 | 13:00:00   |                1 |
| TDS Lecture 5: Transport Data Science in Practice | 2022-03-21 | 09:00:00   |                1 |
| TDS Practical 5: Visualisation and project work   | 2022-04-28 | 09:00:00   |                3 |
| TDS Deadline 2: 10 page project report            | 2022-05-13 | 13:00:00   |                1 |

<!-- # References -->
<!-- To access references collected for this course (and contribute more if you want), you can join the 'tds' Zotero group: https://www.zotero.org/groups/956304/tds -->

# Prerequisites

## Software

For this module you need to have up-to-date versions of R and RStudio
installed on a computer you have access to:

-   R from [cran.r-project.org](https://cran.r-project.org/)
-   RStudio from
    [rstudio.com](https://rstudio.com/products/rstudio/download/#download)
-   R packages, which can be installed by opening RStudio and typing
    `install.packages("stats19")` in the R console, for example.

You should have the latest stable release of R (4.0.0 or above) running
R on a decent computer, with at least 4 GB RAM and ideally 8 GB or more
RAM. See [Section 1.5 of the online guide Reproducible Road Safety
Research with
R](https://itsleeds.github.io/rrsrr/introduction.html#installing-r-and-rstudio)
for instructions on how to install key packages we will use in the
module.[^1]

It is also recommended that you have installed and have experience with
GitHub Desktop (or command line git on Linux and Mac), Docker, Python,
QGIS and transport modelling tools such as SUMO and A/B Street. These
software packages will help with the course but are not essential.

## Data science experience

Attending the Introduction to R one-off 3 hour workshop (semester 1
Computer Skills workshop) and experience of using R (e.g. having used it
for work, in previous degrees or having completed an online course) is
essential. Students can demonstrate this by showing evidence that they
have worked with R before, have completed an online course such as the
first 4 sessions in the RStudio Primers series
<https://rstudio.cloud/learn/primers> or DataCamp’s Free Introduction to
R course: <https://www.datacamp.com/courses/free-introduction-to-r>.
This is an advanced and research-led module. Evidence of substantial
programming and data science experience in previous professional or
academic work, in languages such as R or Python, also constitutes
sufficient pre-requisite knowledge for the course.

## Course reading

See the [handbook](handbook-tds.md).

<!-- # Slides and lectures -->
<!-- Slides can be found online: -->
<!-- - See https://itsleeds.github.io/TDS/slides/1-intro.html#1 for the introductory slides, for example -->
<!-- - Videos of the lectures can be found on the University of Leeds' Blackboard system (you must must [register](https://www.leeds.ac.uk/info/101040/applying/86/how_to_apply_for_masters_courses) to courses such as [Data Science and Analytics](https://courses.leeds.ac.uk/i071/data-science-and-analytics-msc) or [Transport Planning and the Environment](https://courses.leeds.ac.uk/a386/transport-planning-and-the-environment-msc) to take the course) -->

# Assessment (for those doing this as credit-bearing)

-   You will build-up a portfolio of work
-   100% coursework assessed, you will submit by **Friday 13th May**:
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
<!-- ```{r, eval=FALSE, engine='python', echo=FALSE} -->
<!-- import pandas as pd -->
<!-- e = pd.read_csv("/mnt/27bfad9a-3474-4e61-9a43-0156ebc67d67/home/robin/ITSLeeds/TDS/sample-data/everyone.csv") -->
<!-- pd.DataFrame.sort_values(e, "n_coffee") -->
<!-- ``` -->
<!-- # Other projects -->
<!-- - A book on R for Geocomputation: https://github.com/Robinlovelace/geocompr -->
<!-- - A Python package for OSM data analysis: https://github.com/gboeing/osmnx -->
<!-- # Building the website -->
<!-- To publish the slides and other content online, the following commands were used: -->

# References

[^1]:  For further guidance on setting-up your computer to run R and
    RStudio for spatial data, see these links, we recommend Chapter 2 of
    Geocomputation with R (the Prerequisites section contains links for
    installing spatial software on Mac, Linux and Windows):
    <https://geocompr.robinlovelace.net/spatial-class.html> and Chapter
    2 of the online book *Efficient R Programming*, particularly
    sections 2.3 and 2.5, for details on R installation and
    [set-up](https://csgillespie.github.io/efficientR/set-up.html) and
    the [project management
    section](https://csgillespie.github.io/efficientR/set-up.html#project-management).
