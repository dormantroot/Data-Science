complete = function(directory, id=1:332)
{
  # global data frame to hold values
  result = data.frame(id=character(0), nobs=integer(0))
  
  
  for(d in id)
  {
    modifiedID = as.numeric(d)
    
    if(modifiedID < 10)
    {
      modifiedID = paste("00",modifiedID,sep="",collapse=NULL)
    }
    else
    {
      if(modifiedID < 100)
      {
        modifiedID = paste("0",modifiedID,sep="",collapse=NULL)
      }
    }
    
    modifiedID = toString(modifiedID)
    
    # read file
    filename = paste(directory,"/",modifiedID,".csv", sep = "", collapse=NULL)   
    data = read.csv(filename)
    
    # find total number of non empty observations
    newRow = data.frame(id=d, nobs=dim(na.omit(data))[1])
    result = rbind(result, newRow)    
  } 
  
  return(result)
  
}

complete("specdata",3)
