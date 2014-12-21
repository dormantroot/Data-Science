corr = function(directory, threshold=0)
{
  # global numeric vector
  result = vector(mode="numeric", length=0)
  
  # find all files in the specified directory
  path = paste(directory,"/", sep = "", collapse=NULL) 
  files = list.files(path=path, pattern="*.csv", full.names=T, recursive=FALSE)
  
  # find correlations between sulfate and nitrate for those files
  # whose total # of full observations is greater than the threshhold
  for(i in files)
  {
    fileData = read.csv(i)
    completeCase = na.omit(fileData)    
    
    if(dim(completeCase)[1] > threshold)
    {
      result = append(result,cor(completeCase$sulfate,completeCase$nitrate))      
    }   
  }
  

  return(result)  
}

cr = corr("specdata")
