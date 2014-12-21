pollutantmean = function(directory, pollutant, id=1:332)
{
  # global data frame to hold values
  result = vector()
  
  
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
    
    # find pollutants 
    result = append(result, as.vector(t(na.omit(data[pollutant]))))        
  } 

  return(mean(result))
  
}

pollutantmean("specdata","sulfate",1:10)




