source("mongo.R")

df <- NULL

read <- function(){
  df <<- read.csv("C:\\Users\\JOAOBO~1\\AppData\\Local\\Temp\\RtmpCOTxs7/db9c4b7b08e115909378ad88/0",header=TRUE)
}



installRequiredPackages <- function(){
  if(!("rmongodb" %in% rownames(installed.packages()))){
    install.packages("rmongodb")  
  }
  if(!("rthreejs" %in% rownames(installed.packages()))){
    install.packages("rthreejs")  
  }
  if(!("shinyBS" %in% rownames(installed.packages()))){
    install.packages("shinyBS")  
  }
  if(!("jsonlite" %in% rownames(installed.packages()))){
    install.packages("jsonlite")  
  }
  if(!("curl" %in% rownames(installed.packages()))){
    install.packages("curl")  
  }
  if(!("plyr" %in% rownames(installed.packages()))){
    install.packages("plyr")  
  }
  if(!("RJSONIO" %in% rownames(installed.packages()))){
    install.packages("RJSONIO")  
  }
  
}

installRequiredPackages()
