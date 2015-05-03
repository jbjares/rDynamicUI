
library(shiny)
source("global.R")


shinyServer(function(input, output, session) {
  
  
    getQueryArgumentValues <- reactive({
      if(!is.null(session) && length(session)>0 && !is.null(session$clientData) 
         && length(session$clientData)>0 && !is.null(session$clientData$url_search) &&
           length(session$clientData$url_search)>0){
            query <- parseQueryString(session$clientData$url_search)
            return(query)
              
      }else{
        return(NULL)
      }
    })
    
    output$ui <- renderUI({
      if(is.null(getQueryArgumentValues())){
        return
      }
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
        hash <- getQueryArgumentValues()[2]
        colnamesJason <- toJSON(colnames(df)) 
        mongoHelper$cacheDataFrameHeader(colnames(df),hash)
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
      ntext()
      if(length(df)>0){
        print("File uploaded successfully.")
      }else{
        print("unexpected exception during upload try again.")
      }
    })
    
    output$getHeaderOutput <- renderUI({
      
      if(is.null(getQueryArgumentValues())){
        return
      }
      if(getQueryArgumentValues()[1]$cmd=="getHeaderValues"){
        #toJSON(df) 
        exceptionText <- paste0("{",shQuote("exception"),":",shQuote("File not uploaded yet."), "}")

          if(is.null(df) || length(df)==0){
            HTML(cat(exceptionText))
            
          }else{
            HTML(toJSON(colnames(df)))
          }
        }else{
        print("")
      }

    })
    
  })
  

