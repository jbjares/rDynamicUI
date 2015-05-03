library(shiny)
main <- function(){
  require(shiny)
  runApp(appDir = getwd(), port = 9876, 
         launch.browser = TRUE, 
         host = getOption("127.0.0.1"), 
         workerId = "", 
         quiet = FALSE, 
         display.mode = "normal")
  
}