setup_R <- function(rversion = 3.4,
                    pkgs = c("remotes",
                             "sf",
                             "tidyverse",
                             "cyclestreets",
                             "tmap",
                             "pct",
                             "stats19",
                             "stplanr")
                    
                    ){
  
  message("This code will install packages and run tests to prepare your computer for an ITS Leeds R course")
  message("If this process is successful you will see the message 'You computer is ready for the ITS Leeds Course'")
  readline(prompt = "Press [enter] to continue, [escape] to abort")
  
  message("Step 1 of N: Check the basics")
  Rv <- as.numeric(R.version$major) + as.numeric(R.version$minor) / 10 
  if(Rv >= rversion){
    message("PASS: R Version Check")
  }else{
    browseURL("https://cran.r-project.org/")
    stop("Your version of R is not up to date, go to https://cran.r-project.org/ and download the latest version of R")
    
  }
  
  message("Step 2 of N: Install Packages")
  
  new.packages <- pkgs[!(pkgs %in% installed.packages()[,"Package"])]
  if(length(new.packages) > 0){
    message("Installing packages")
    install.packages(new.packages)
  } 

  if(all(pkgs %in% installed.packages()[,"Package"])){
    message("PASS: All packages installed")
  }else{
    warning(paste0("Missing packages: ",paste(pkgs[!pkgs %in% installed.packages()[,"Package"]]), collapse = ", "))
    stop("Some packages did not install sucessfully")
  }
  
  message("Step 3 of N: Test geocomputation")
  zones_all <- try(pct::get_pct_zones("isle-of-wight"), silent = TRUE)
  lines_all <- try(pct::get_pct_lines("isle-of-wight"), silent = TRUE)
  
  if(!"sf" %in% class(zones_all) | !"sf" %in% class(lines_all)){
    stop("Faield to get data from the pct package")
  }else{
    message("PASS: Got data from the pct package")
  }
  
  message(" ")
  message(" ")
  message("##############################################")
  message("You computer is ready for the ITS Leeds Course")  
  message("##############################################")
  
}

setup_R(); rm(setup_R)
