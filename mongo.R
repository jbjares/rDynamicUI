dataSourceNS <- "multivision_jbjares.DatasourceTO"
hostDesenv <- "ds061371.mongolab.com:61371"
usernameDesenv <-"jbjares"
passwordDesenv <- "multivision"
dbDesenv = "multivision_jbjares"



mongoHelper <- list(
  
  library(rmongodb), 
  library(RJSONIO),
  connect = function(){
    mongo <- mongo.create(host = hostDesenv, username = usernameDesenv, password = passwordDesenv, db = dbDesenv, timeout = 0L)
    return(mongo)
  },
  
  storeUploadedFile = function(){
    if(is.null(df) || length(df)==0){
      return
    }
    collumnNamesCharArray <- colnames(df)
    if(is.null(collumnNamesCharArray)){
      print("collumnNamesCharArray cant be null.")
      return()
    }

    for(i in seq_along(collumnNamesCharArray)){
      name <- collumnNamesCharArray[i]
      values <- c(eval(parse(text = paste0("df$",name))))
      values <- as.numeric(unlist(values))
      jsonBuf <- paste0("{",shQuote("varName"),":",shQuote(name),",",shQuote("values"),":", "[")
      valuesBuf <- ""
      for(j in seq_along(values)){
         value <- values[j]
         if(is.na(value)){
           value <- 0
         }
         if(j!=length(values)){
           valuesBuf <- paste0(valuesBuf,value,",")
         }else{
           valuesBuf <- paste0(valuesBuf,value)  
         }
      }
      jsonBuf <- paste0(jsonBuf,valuesBuf,"]}")
      bson <- mongo.bson.from.JSON(jsonBuf)
      mongo.insert(mongo, dataSourceNS, bson)
    }

    #works, but not as expected
#     buffer <- mongo.bson.from.df(df)
#     mongo.insert(mongo, dataSourceNS, buffer)
    
  }
  
  
)


mongo <- mongoHelper$connect()