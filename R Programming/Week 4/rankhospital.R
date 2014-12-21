# Task 3
#dir = paste(getwd(),"/Week 4", sep="")
#setwd(dir)
#getwd()


rankhospital = function(state, outcome, num)
{
  ## Read outcome data
  outcomes = read.csv("outcome-of-care-measures.csv", colClasses="character")

  
  ## Distinct state values
  states = unique(outcomes$State)
  
  ## Give shorter names for column 11, 17 & 23
  names(outcomes)[11] = "low30HT"   # col - Hospital 30-Day Death (Mortality) Rates from Heart Attack: Lists the risk adjusted rate (percentage) for each hospital
  names(outcomes)[17] = "low30HF"   # col - Hospital 30-Day Death (Mortality) Rates from Heart Failure: Lists the risk adjusted rate (percentage) for each hospital
  names(outcomes)[23] = "low30PN"   # col - Hospital 30-Day Death (Mortality) Rates from Pneumonia: Lists the risk adjusted rate (percentage) for each hospital
  
  
  ## 3 outcomes
  outcomeValues = c("heart attack", "heart failure", "pneumonia")
  
  
  ## Check that state and outcome are valid
  if (missing(state))
    stop("Need to specify a state.")
  
  if (missing(outcome))
    stop("Need to specify an outcome")
  
  if(!is.element(state, states))
    stop("invalid state")  
  
  if(!is.element(outcome, outcomeValues))
    stop("invalid outcome")
  
  
  # Find those hospitals with ranking - 'num' for the 30-day mortality for 'heart attack'
  if(outcome == outcomeValues[1])
  {
    result = outcomes[which(outcomes$low30HT != "Not Available" & outcomes$State == state), c(2,7,11)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30HT), ]
    
    if(num == "best")
    {
      nLowestValue = result[1,3]   
    }
    else
    {
      if(num == "worst")
      {
        nLowestValue = result[dim(result)[1],3]   
      }
      else
      {
        if(!is.numeric(num))
        {
          stop("NA")
        }
        else
        {
          if(as.numeric(num) > dim(result)[1])
          {
            return("NA")
          }
          else
          {
            nLowestValue = result[num,3] 
          }
        }
      }
    }
   
    if(dim(result[which(result$low30HT == nLowestValue),])[1] > 1)
    {
      result = result[which(result$low30HT == nLowestValue),]
      return(result[with(result, order(result$Hospital.Name, decreasing=TRUE)),][1,1])
    }
    else
    {
      return (result[which(result$low30HT == nLowestValue),1])
    }   
       
  }
  
  
  
  # Find those hospitals with ranking - 'num' for the 30-day mortality for 'heart failure'
  if(outcome == outcomeValues[2])
  {
    result = outcomes[which(outcomes$low30HF != "Not Available" & outcomes$State == state), c(2,7,17)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30HF), ]
    
    if(num == "best")
    {
      nLowestValue = result[1,3]   
    }
    else
    {
      if(num == "worst")
      {
        nLowestValue = result[dim(result)[1],3]   
      }
      else
      {
        if(!is.numeric(num))
        {
          stop("NA")
        }
        else
        {
          if(as.numeric(num) > dim(result)[1])
          {
            return("NA")
          }
          else
          {
            nLowestValue = result[num,3] 
          }
        }
      }
    }    
     
    if(dim(result[which(result$low30HF == nLowestValue),])[1] > 1)
    {
      result = result[which(result$low30HF == nLowestValue),]      
      return(result[with(result, order(result$Hospital.Name, decreasing=TRUE)),][1,1])
    }
    else
    {
      return (result[which(result$low30HF == nLowestValue),1])
    }   
   
  }
  
  
  
  
  
  #  Find those hospitals with ranking - 'num' for 30-day mortality for 'Pneumonia'
  if(outcome == outcomeValues[3])
  {
    result = outcomes[which(outcomes$low30PN != "Not Available" & outcomes$State == state), c(2,7,23)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30PN), ]
    
    if(num == "best")
    {
      nLowestValue = result[1,3]   
    }
    else
    {
      if(num == "worst")
      {
        nLowestValue = result[dim(result)[1],3]   
      }
      else
      {
        if(!is.numeric(num))
        {
          stop("NA")
        }
        else
        {
          if(as.numeric(num) > dim(result)[1])
          {
            return("NA")
          }
          else
          {
            nLowestValue = result[num,3] 
          }
        }
      }
    } 
    
    
    if(dim(result[which(result$low30PN == nLowestValue),])[1] > 1)
    {
      result = result[which(result$low30PN == lnLowestValue),]
      return(result[with(result, order(result$Hospital.Name, decreasing=TRUE)),][1,1])
    }
    else
    {
      return (result[which(result$low30HF == nLowestValue),1])
    }   
  }
  
}

# 
# outcomes = read.csv("outcome-of-care-measures.csv", colClasses="character")
# k = outcomes[which(outcomes$State=="TX"),c(2,7,17)]
# names(k)[3] = "y"
# k[,3] = as.numeric(k[,3])
# k[order(k$y),]
# 
# result = result[order(result$low30HF), ]

# names(outcomes)[17] = "low30HF"
# names(outcomes)
# result = outcomes[which(outcomes$low30HF != "Not Available" & outcomes$State == "MD"), c(2,7,19)]
# result[,3] = as.numeric(result[,3])
# result = result[order(result$low30HF), ]

rankhospital("MN", "heart attack", 5000)
