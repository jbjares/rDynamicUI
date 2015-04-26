
library(shiny)
source("global.R")

shinyServer(function(input, output, session) {
  
    getQueryArgumentValues <- reactive({
      query <- parseQueryString(session$clientData$url_search)
      return(query)
    })
    
    output$ui <- renderUI({
      switch(getQueryArgumentValues()[1]$cmd,
             "slider" = sliderInput("dynamic", "Dynamic",
                                    min = 1, max = 20, value = 10),
             "text" = textInput("dynamic", "Dynamic",
                                value = "starting value"),
             "numeric" =  numericInput("dynamic", "Dynamic",
                                       value = 12),
             "checkbox" = checkboxInput("dynamic", "Dynamic",
                                        value = TRUE),
             "checkboxGroup" = checkboxGroupInput("dynamic", "Dynamic",
                                                  choices = c("Option 1" = "option1",
                                                              "Option 2" = "option2"),
                                                  selected = "option2"
             ),
             "radioButtons" = radioButtons("dynamic", "Dynamic",
                                           choices = c("Option 1" = "option1",
                                                       "Option 2" = "option2"),
                                           selected = "option2"
             ),
             "selectInput" = selectInput("dynamic", "Dynamic",
                                         choices = c("Option 1" = "option1",
                                                     "Option 2" = "option2"),
                                         selected = "option2"
             ),
             "selectInput (multi)" = selectInput("dynamic", "Dynamic",
                                                 choices = c("Option 1" = "option1",
                                                             "Option 2" = "option2"),
                                                 selected = c("option1", "option2"),
                                                 multiple = TRUE
             ),
             "date" = dateInput("dynamic", "Dynamic"),
             "daterange" = dateRangeInput("dynamic", "Dynamic"),

              "fileUpload" =  fluidRow(
                column(6, 
                fileInput('fileUploadCSV', 'Choose CSV File',
                          accept=c("txt/csv", "text/comma-separated-values,text/plain", ".csv"))),
                column(6,actionButton("upload_data", "Upload Data"))
              )

      )
    })
    
    
    # builds a reactive expression that only invalidates 
    # when the value of input$goButton becomes out of date 
    # (i.e., when the button is pressed)
    ntext <- eventReactive(input$upload_data, {
      inFile <- input$fileUploadCSV
      if (is.null(inFile)){
        return(NULL)
      }
      tryCatch({
        df <<- read.csv((input$fileUploadCSV)$datapath,sep=",",header = TRUE)
        unlink((input$fileUploadCSV)$datapath)
      }, interrupt = function(ex) {
        cat("An interrupt was detected.\n");
        print(ex);
      }, error = function(ex) {
        cat("An error was detected.\n");
        print(ex);
      }, finally = {
        cat("done\n");
      }) 
    })
    
    output$fileUpload <- renderText({
      invisible(ntext())
      if(length(df)>0){
        print("File uploaded successfully.")
      }else{
        print("unexpected exception during upload try again.")
      }
    })
    
  })
  

