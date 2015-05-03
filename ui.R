
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
source("global.R")
shinyUI(fluidPage(
  fluidRow(
    
    column(3, wellPanel(
      uiOutput("ui"),
      textOutput("fileUpload")
      
    )),
    mainPanel(
      htmlOutput("getHeaderOutput")
    )
  )
))