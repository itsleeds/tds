setup_R <- function(rversion = 3.4,
                    pkgs = c("remotes",
                             "sf",
                             "tidyverse",
                             "cyclestreets",
                             "tmap",
                             "pct",
                             "stats19",
                             "stplanr"),
                    pkgs_gh = c(),
                    ram_warn = 4000
                    
                    ){
  
  message("This code will install packages and run tests to prepare your computer for an ITS Leeds R course")
  message("If this process is successful you will see the message 'You computer is ready for the ITS Leeds Course'")
  
  readline(prompt = "Press [enter] to continue, [escape] to abort")
  
  log <- " "
  
  message("Step 1 of 3: Check the basics")
  Rv <- as.numeric(R.version$major) + as.numeric(R.version$minor) / 10 
  if(Rv >= rversion){
    message("PASS: R Version Check")
  }else{
    browseURL("https://cran.r-project.org/")
    stop("Your version of R is not up to date, go to https://cran.r-project.org/ and download the latest version of R")
    
  }
  
  # We need devtools to do some checks
  if(!"devtools" %in% utils::installed.packages()[,"Package"]){
    utils::install.packages("devtools")
  }
  
  if("devtools" %in% utils::installed.packages()[,"Package"]){
    message("PASS: Devtools is installed")
  }else{
    stop("Unable to install devtools try running install.packages('devtools')")
  }
  
  # Check for Rtools
  if (.Platform$OS.type == "windows") { 
    if(pkgbuild::find_rtools()){
      message("PASS: RTools is installed")
    }else{
      if(length(pkgs_gh) > 0){
        browseURL("https://cran.r-project.org/bin/windows/Rtools/")
        stop("You need to install RTools https://cran.r-project.org/bin/windows/Rtools/ and download the latest stable version")
      }else{
        log <- c(log, "WARN: You don't have RTools installed, but have not requested any packages that require it")
        message("PASS: RTools is not required")
      }
    }
  }else{
    message("PASS: RTools is not required on your OS")
  }
  
  # Check for RStudio
  if(rstudioapi::isAvailable()){
   message("PASS: You are using RStudio") 
  }else{
    browseURL("https://www.rstudio.com/products/rstudio/download/")
    stop("You are not using RStudio, ITS Courses require R Studio, please download and install from https://www.rstudio.com/products/rstudio/download/")
  }
  
  # Check RAM
  if (.Platform$OS.type == "windows") { 
    memfree <- utils::memory.limit()
  }else{
    memfree <- as.numeric(system("awk '/MemFree/ {print $2}' /proc/meminfo", intern=TRUE)) / 1024
  }
  
  if(memfree < 1000){
    stop("You have less than 1 GB of RAM your computer is not suitable for the course")
  }else if(memfree < ram_warn){
    log <- c(log, "Your computer is low on RAM, consider bringing a better laptop to the course")
    message("PASS: Your computer has just enough RAM to run the course")
  }else{
    message("PASS: Plenty of RAM")
  }
  
  
  message("Step 2 of 3: Install Packages")
  
  # Install Packages CRAN
  if(length(pkgs) > 0){
    new.packages <- pkgs[!(pkgs %in% utils::installed.packages()[,"Package"])]
    if(length(new.packages) > 0){
      message("Installing packages")
      utils::install.packages(new.packages, verbose = FALSE)
    } 
    
    if(all(pkgs %in% utils::installed.packages()[,"Package"])){
      message("PASS: All CRAN packages installed")
    }else{
      warning(paste0("Missing packages: ",paste(pkgs[!pkgs %in% utils::installed.packages()[,"Package"]]), collapse = ", "))
      stop("Some CRAN packages did not install sucessfully")
    }
  }else{
    message("PASS: No CRAN packages were requested")
  }
  message("Updating any out of date packages")
  update.packages(oldPkgs = pkgs, ask = FALSE)
  
  # Install Packages Github
  if(length(pkgs_gh) > 0){
    for(i in seq(1, length(pkgs_gh))){
      remotes::install_github(pkgs_gh[i], quiet = TRUE)
    }
    
    if(all(pkgs_gh %in% utils::installed.packages()[,"Package"])){
      message("PASS: All GitHub packages installed")
    }else{
      warning(paste0("Missing packages: ",paste(pkgs_gh[!pkgs_gh %in% utils::installed.packages()[,"Package"]]), collapse = ", "))
      stop("Some GitHub packages did not install sucessfully")
    }
  }else{
    message("PASS: No GitHub packages were requested")
  }
  
  # Check Geocomputation
  message("Step 3 of 3: Test geocomputation")
  
  # pct package
  if(all(c("sf","pct") %in% utils::installed.packages()[,"Package"] )){
    zones_all <- try(pct::get_pct_zones("isle-of-wight"), silent = TRUE)
    lines_all <- try(pct::get_pct_lines("isle-of-wight"), silent = TRUE)
    
    if(!"sf" %in% class(zones_all) | !"sf" %in% class(lines_all)){
      stop("Faield to get data from the pct package")
    }else{
      message("PASS: Got data from the pct package")
    }
    
    plot(zones_all$geometry, main = "Test plot of desire lines on the Isle of Wight")
    plot(lines_all$geometry[lines_all$all > 300], col = "red", add = TRUE)
    
    message("PASS: Basic Plotting")
  }else{
    message("SKIP: pct package not tested")
  }
  
  # Cyclestreet package
  if(all(c("cyclestreets") %in% utils::installed.packages()[,"Package"] )){
    if(nchar(Sys.getenv("CYCLESTREETS")) > 0){
      message("PASS: Cyclestreets key found")
    }else{
      log <- c(log,"WARN: The cyclestreets package requires an API key, please sign up for one at https://www.cyclestreets.net/api/ then add it to your R environ file")
      message("WARN: No cyclestreets API key found.")
    }
  }else{
    message("SKIP: cyclestreets package not tested")
  }
  
  
  # Report Results
  message(" ")
  message(" ")
  message("##############################################")
  message("You computer is ready for the ITS Leeds Course")  
  message("##############################################")
  
  for(i in seq(1, length(log))){
    message(log[i])
    message("______________")
  }
}

setup_R(); rm(setup_R)
