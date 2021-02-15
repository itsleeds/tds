Routing homework
================
Malcolm Morgan and Robin Lovelace
University of Leeds
<br/><img class="img-footer" alt="" src="https://comms.leeds.ac.uk/wp-content/themes/toolkit-wordpress-theme/img/logo.png">

## Prior set-up and reading (before practical)

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

Make sure that you have installed these.

Read the OpenTripPlanner package paper for information on routing
(Morgan et al. 2019).

<!-- ## The practical (during and after practical) -->

<!-- Ensure that you have completed the exercises in the practical session (see the [`practicals.2f6-routing.pdf`](https://github.com/ITSLeeds/TDS/releases/download/0.20.1/practicals.2f6-routing.pdf) file in https://github.com/ITSLeeds/TDS/releases ) -->

<!-- ## An RMarkdown template -->

<!-- - Read Chapter 2 of the definitive guide to the .Rmd file format [@xie_r_2018]: https://bookdown.org/yihui/rmarkdown/basics.html -->

<!-- - Create a new project called `tdsproject` (or similar) and create a new RMarkdown file by running the following command (you must have installed `usethis` with `install.packages("usethis")`): -->

<!-- ```{r, eval=FALSE} -->

<!-- usethis::use_readme_rmd() -->

<!-- ``` -->

<!-- On line 32 of the resulting file, replace this line -->

<!-- ``` -->

<!-- plot(pressure) -->

<!-- ``` -->

<!-- with this: -->

<!-- ```{r, eval=FALSE} -->

<!-- m1 = lm(pressure ~ temperature, data = pressure) -->

<!-- plot(pressure) -->

<!-- lines(pressure$temperature, m1$fitted.values, col = "red") -->

<!-- ``` -->

<!-- Knit the file. You should see something that looks like this. -->

<!-- What is wrong with the prediction? -->

<!-- Challenge: generate a model prediction that more accurately models the relationship between pressure and temperature (hint: the code ` + I(temperature^2)` may help, the result should look something like that shown below). -->

<!-- ```{r, echo=FALSE} -->

<!-- m1 = lm(pressure ~ temperature, data = pressure) -->

<!-- m2 = lm(pressure ~ temperature + I(temperature^2), data = pressure) -->

<!-- m3 = lm(log(pressure) ~ temperature + I(temperature^2), data = pressure) -->

<!-- plot(pressure) -->

<!-- lines(pressure$temperature, m1$fitted.values, col = "red") -->

<!-- lines(pressure$temperature, m2$fitted.values, col = "blue") -->

<!-- lines(pressure$temperature, exp(m3$fitted.values), col = "yellow") -->

<!-- ``` -->

<!-- Try to reproduce the output of this file: https://github.com/ITSLeeds/TDS/blob/master/coursework-template.Rmd -->

<!-- The results should look something like this: https://github.com/ITSLeeds/TDS/blob/master/coursework-template.md -->

<!-- Challenge: knit the document to create a file called coursework-template.pdf. -->

<!-- **Hint**: to reproduce the figure above, see this file: https://github.com/ITSLeeds/TDS/blob/master/practicals/6-routing-homework.Rmd -->

## References

<div id="refs" class="references">

<div id="ref-morgan_opentripplanner_2019">

Morgan, Malcolm, Marcus Young, Robin Lovelace, and Layik Hama. 2019.
“OpenTripPlanner for R.” *Journal of Open Source Software* 4 (44):
1926. <https://doi.org/10.21105/joss.01926>.

</div>

</div>
