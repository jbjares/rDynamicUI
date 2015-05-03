dataSourceNS <- "multivision_jbjares.DatasourceTO"
headerCacheNS <- "multivision_jbjares.HeaderCacheTO"
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
  cacheDataFrameHeader = function(colnames,hash){
    hashchar <- as.character(hash)
    buf <- mongo.bson.buffer.create()
    print(class(hash))
    print(class(hashchar))
    mongo.bson.buffer.append.string(buf, "hash",hashchar)
    coList <- as.list(colnames)
    mongo.bson.buffer.append.list(buf, "value",coList)
    b <- mongo.bson.from.buffer(buf)
    mongo.insert(mongo,headerCacheNS, b)
    return(T)
  },
  cacheDataFrame = function(dataframe,user="user1"){
    buffer <- mongo.bson.from.df(dataframe)
    mongo.insert(mongo, eval(parse(text=paste0(cacheNS,user))) , buffer)
    return(T)
  },
  loadCachedDataFrame = function(user="user1"){
    #mongo.insert(mongo, eval(parse(text=paste0(cacheNS,user))), buffer)
    cursor <- mongo.find.all(mongo, eval(parse(text=paste0(cacheNS,user))), query = mongo.bson.empty())
    res <- mongo.cursor.to.data.frame(cursor)
    return(res)
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

    
  }
  
  
)


mongo <- mongoHelper$connect()