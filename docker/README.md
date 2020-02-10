## Docker

If you want to run the software in a container (which can make package installation easier), you can use docker, which allows you to run a virtual operating system inside your main operating system.

After you have [installed docker](https://docs.docker.com/install/), you should be able to run the software by executing the following commands in a terminal such as Windows PowerShell or the default terminal on Linx and MAC operating systems.

For an R installation:

```bash
docker run -d -p 8787:8787 -v $(pwd):/home/rstudio/data -e USERID=$UID -e PASSWORD=pickASafePassWord --name rstudio robinlovelace/geocompr
```

For a R/Python docker image (bigger, less well maintained):

```bash
docker run -d -p 8787:8787 -v $(pwd):/home/rstudio/data -e USERID=$UID -e PASSWORD=pickASafePassWord --name rstudio robinlovelace/tds  
```

This will:

- Pull the docker image from https://hub.docker.com/r/robinlovelace/tds/ or the geocompr repo if it's not already on your computer
- Launch a locally hosted instance of RStudio Server which can be accessed at http://localhost:8787/
- Mount your current working dirctory to the data folder in the home directly of the docker image

After navigating to http://localhost:8787/ in a browser you should see a login screen. Username and password are rstudio. See https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image for details.

Once in the container you can use all the R packages.
To access the pre-installed Python packages you will need to enter the following commands:

```bash
conda activate
python
```

to go into the Python shell. Form more on running Python in RStudio see [community.rstudio.com](https://community.rstudio.com/t/r-python-in-ide/279).
A demonstration showing the `tds` docker image in action is illustrated below.

![](https://user-images.githubusercontent.com/1825120/43570979-a41791c2-9633-11e8-9edd-f3e11bc884c1.gif)