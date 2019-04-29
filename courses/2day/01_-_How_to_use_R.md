How to use R/RStudio effectively
================

Learning Outcomes
-----------------

-   RStudio UI and main features
-   R Objects and Functions
-   Subsetting
-   Plotting
-   Help
-   Installing Packages

Welcome to RStudio
------------------

This course assumes that you have already got some basic knowledge of working with R. If you don't see the [prerequisites](https://github.com/ITSLeeds/TDS/blob/master/courses/2day.md).

<img src="images/rstudio-ui.png" width="992" />

### Projects

Projects are a way to organise related work togther. Each project has its own folder and Rproj file.

Start a new project with:

> File &gt; New Project

You can choose to create a new directory (folder) or associate a project with an existing directory. Make a new project called TDS and save it in a sencible place on your computer. Notice that TDS now appears in the top right of RStudio.

**Always do your work within a project**

### R Scripts

We could simple type all our code into the consol, but that would require us to retype all our code every time we wish to run it. So we usually save code in a script file (with the .R extension).

Make a new script:

> Flie &gt; New File &gt; Rscript

Or use the new script button on the toolbar.

Save the script and give it a sensible name like `TDS-lesson-1.R` with:

> File &gt; Save

Or the save button on the toolbar.

### Writing Code

Lets start with some basic R operations

``` r
x <- 1:5
y <- c(0,1,3,9,18)
plot(x, y)
```

This code creates two objects, both vectors of lenght == 5, and then plots them.

### Running Code

We have several ways to run code within a script.

1.  Place the cursor on a line of code and press `CTRL + Enter` to run that line of code.
2.  Highlight a block of code or part of a line of code and press `CTRL + Enter` to run the highligted code.
3.  Press `CTRL + Shift + Enter` to run all the code in a script.
4.  Press the Run button on the toolbar to run all the code in a script.
5.  Use the function `source()` to run all the code in a script e.g. `source("TDS-lesson-1.R")`

### Vewing Objects

Lets create some different types of object:

``` r
cat <- data.frame(name = c("Tiddles", "Chester", "Shadow"),
                  type = c("Tabby", "Persian", "Siamese"),
                   age = c(1, 3, 5),
                  likes_milk = c(TRUE, FALSE,TRUE))
even_numbers <- seq(from = 2, to = 4000, by = 2)
random_letters <- sample(letters, size = 100, replace = TRUE)
small_matrix <- matrix(1:24, nrow = 12)
```

We can view the objects in a range of ways:

1.  Type the name of object into the console e.g. `cat`, what happens if we try to view all 2000 even\_numbers?
2.  Use the `head()` function to view the first few values e.g. `head(even_numbers)`
3.  Use the view table button next to matrix or data.frame objects in the envrionment tab.

We can also get an overview of an object using a range of functions.

1.  `summary()`
2.  `class()`
3.  `class()`
4.  `dim()`
5.  `length()`

**Exercise** try these fucntions, what resutls do they give?

### Using Autocomplete

RStudio can help you write code by autocompleting. RStudio will look for similar objects and functions after typing the first three letters of a name.

<img src="images/autocomplete.jpg" width="158" />

When there is more than one option you can slect from the list using the mouse or arrow keys.

Within a fucntion you can get a list of arguments by pressing Tab.

<img src="images/fucntionhelp.jpg" width="553" />

Notce the help popup.

### Getting help

Every function in R has a help page. You can view the help using `?` for example `?sum`. Many packages also contain vignettes, these are long form help documents containg examples and guides. `vignette()` will show a list of all the vignettes aviaible, or you can show a specific vignette for example `vignette(topic = "sf1", package = "sf")`.

### Commenting Code

It is good practice to use comments in your code to expalin what your code does. You can comment code using `#`

For example:

``` r
# A whole line comment
x <- 1:5 # An inline comment
y <- x * 2
```

You can comment a whole block of text by slecting it an using CTRL + Shift + C

You can add a comment section using CTRL + Shift + R

### Cleaning your envrionment and removing objects

The Envrionment tab shows all the objects in your environment, this includes Data, Values, and Functions. By defaul new objects apprea in the Global Environment but you can see other envrionments with the drop down menu. For example each package has its own envrionment.

Sometime you wish to remove things from your environment, perhaps becuase you no longer need them or things are getting cluttered.

You can remove a specif object with the `rm()` function e.g. `rm(x)` or `rm(x,y)` or you can clear your whole envrionment with the broom button on the Enrionment Tab.

### Debugging Code

This code example will run, but we can see some of RStudio's debuggin features by changing it. See that when the barcket is removed the red X and the underlineing highlight the broken code. You may need to save the code you see the debuggin prompt.

<img src="images/debug.jpg" width="212" />

**Always address debuggin promts before running your code**

### Saving your work

We have already seen that you can save an R script. You can also save R objects in the RDS format.

``` r
saveRDS(cat,"cat.Rds")
```

We can also read back in our data.

``` r
cat2 <- readRDS("cat.Rds")
identical(cat, cat2)
```

R also supports many other formats. For example CSV files.

``` r
write.csv(cat, "cat.csv")
cat3 <- read.csv("cat.csv")
identical(cat3, cat1)
```

Notice that `cat3` and `cat` are not identical, what has changed? Hint: use `?write.csv`.

Now your ready to use R
-----------------------

``` r
eyes <- c(2.3,4,3.7,4)
eyes <- matrix(eyes, ncol = 2, byrow = T)
mouth <- c(2,2,2.5,1.3,3,1,3.5,1.3,4,2)
mouth <- matrix(mouth, ncol = 2, byrow = T)
plot(eyes, 
     type = "p", 
     main = "Smile you're using R",
     col = "blue",
     xlim = c(0,5),
     ylim = c(0,5))
lines(mouth,
     type = "l",
     col = "red")
```

![](01_-_How_to_use_R_files/figure-markdown_github/smile-1.png)
