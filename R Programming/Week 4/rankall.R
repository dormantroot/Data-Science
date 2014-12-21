rankall = function(outcome, num="best")
{
  ## Load library
  library(plyr)
  
  ## Read outcome data
  outcomes = read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  ## Give shorter names for column 11, 17 & 23
  names(outcomes)[11] = "low30HT"   # col - Hospital 30-Day Death (Mortality) Rates from Heart Attack: Lists the risk adjusted rate (percentage) for each hospital
  names(outcomes)[17] = "low30HF"   # col - Hospital 30-Day Death (Mortality) Rates from Heart Failure: Lists the risk adjusted rate (percentage) for each hospital
  names(outcomes)[23] = "low30PN"   # col - Hospital 30-Day Death (Mortality) Rates from Pneumonia: Lists the risk adjusted rate (percentage) for each hospital
  
  ## Distinct state values
  states = sort(unique(outcomes$State))
 
  ## 3 outcomes
  outcomeValues = c("heart attack", "heart failure", "pneumonia")
  
  if (missing(outcome))
    stop("invalid outcome")
  
  
  
  # Find those hospitals with ranking - 'num' for the 30-day mortality for 'heart attack'
  if(outcome == outcomeValues[1])
  {
    result = outcomes[which(outcomes$low30HT != "Not Available"), c(2,7,11)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30HT), ]
    
    # data frame to hold values
    output = data.frame(hospital=character(0), state=character(0))
    
    # Group the data by states    
    result = ddply(result, c("State"))
    
    # Loop through each state and find the hospital that matches the
    # nLowestValue ranking
    for(n in 1:length(states))
    {             
          nLowestValue = inStateRank(result[which(result$State == states[n]),], num)
          #print(nLowestValue)
          #print(states[n])
          
          if(dim(result[which(result$low30HT == nLowestValue & result$State == states[n]),])[1] <= 0)
          {
            newRow = data.frame(hospital="NA", state=states[n])
            output = rbind(output, newRow) 
          }
          else
          {
            if(dim(result[which(result$low30HT == nLowestValue & result$State == states[n]),])[1] > 1)
            {
              data = result[which(result$low30HT == nLowestValue & result$State == states[n]),]
              newRow = data.frame(hospital=data[with(data, order(data$Hospital.Name, decreasing=FALSE)),][1,1], state=states[n]) 
              output = rbind(output, newRow) 
            }
            else
            {
              newRow = data.frame(hospital=result[which(result$low30HT == nLowestValue & result$State == states[n]),1], state=states[n])
              output = rbind(output, newRow) 
            }   
          }
          
    }
    
  }
  
  
  # Find those hospitals with ranking - 'num' for the 30-day mortality for 'heart failure'
  if(outcome == outcomeValues[2])
  {
    result = outcomes[which(outcomes$low30HF != "Not Available"), c(2,7,17)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30HF), ]
    
    # data frame to hold values
    output = data.frame(hospital=character(0), state=character(0))
    
    # Group the data by states    
    result = ddply(result, c("State"))
    
    # Loop through each state and find the hospital that matches the
    # nLowestValue ranking
    for(n in 1:length(states))
    {             
      nLowestValue = inStateRank(result[which(result$State == states[n]),], num)
      #print(nLowestValue)
      #print(states[n])
      
      if(dim(result[which(result$low30HF == nLowestValue & result$State == states[n]),])[1] <= 0)
      {
        newRow = data.frame(hospital="NA", state=states[n])
        output = rbind(output, newRow) 
      }
      else
      {
        if(dim(result[which(result$low30HF == nLowestValue & result$State == states[n]),])[1] > 1)
        {
          data = result[which(result$low30HF == nLowestValue & result$State == states[n]),]
          newRow = data.frame(hospital=data[with(data, order(data$Hospital.Name, decreasing=FALSE)),][1,1], state=states[n]) 
          output = rbind(output, newRow) 
        }
        else
        {
          newRow = data.frame(hospital=result[which(result$low30HF == nLowestValue & result$State == states[n]),1], state=states[n])
          output = rbind(output, newRow) 
        }   
      }
      
    }
  }
    
    
  # Find those hospitals with ranking - 'num' for the 30-day mortality for 'Pneumonia'
  if(outcome == outcomeValues[3])
  {
    result = outcomes[which(outcomes$low30PN != "Not Available"), c(2,7,23)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30PN), ]
    
    # data frame to hold values
    output = data.frame(hospital=character(0), state=character(0))
    
    # Group the data by states    
    result = ddply(result, c("State"))
    
    # Loop through each state and find the hospital that matches the
    # nLowestValue ranking
    for(n in 1:length(states))
    {             
      nLowestValue = inStateRank(result[which(result$State == states[n]),], num)
      #print(nLowestValue)
      #print(states[n])
      
      if(dim(result[which(result$low30PN == nLowestValue & result$State == states[n]),])[1] <= 0)
      {
        newRow = data.frame(hospital="NA", state=states[n])
        output = rbind(output, newRow) 
      }
      else
      {
        if(dim(result[which(result$low30PN == nLowestValue & result$State == states[n]),])[1] > 1)
        {
          data = result[which(result$low30PN == nLowestValue & result$State == states[n]),]
          newRow = data.frame(hospital=data[with(data, order(data$Hospital.Name, decreasing=FALSE)),][1,1], state=states[n]) 
          output = rbind(output, newRow) 
        }
        else
        {
          newRow = data.frame(hospital=result[which(result$low30PN == nLowestValue & result$State == states[n]),1], state=states[n])
          output = rbind(output, newRow) 
        }   
      }
      
    }
  }
   
      
      
      
  return(output)  
}

# Function that finds the rank that matches the given 'num' for the given state data
inStateRank = function(stateOutcome, num="best")
{
  if(num == "best")
  {
    return(stateOutcome[1,3])
  }
  else
  {
    if(num == "worst")
    {
      return(stateOutcome[dim(stateOutcome)[1],3])
    }
    else
    {
      if(!is.numeric(num))
      {
        stop("NA")
      }
      else
      {
        if(as.numeric(num) > dim(stateOutcome)[1])
        {
          return(-1)
        }
        else
        {
          # return ranking that matches the given value of num
          return(stateOutcome[num,3])
        }
      }
    }
  }
}


#tail(rankall("heart failure"), 3)
