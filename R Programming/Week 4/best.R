# Task 2
best = function(state, outcome)
{
  ## Read outcome data
  outcomes = read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  ## Distinct state values
  states = unique(outcomes$State)
  
  ## Give shorter names for column 13, 19 & 25
  names(outcomes)[13] = "low30HT"
  names(outcomes)[19] = "low30HF"
  names(outcomes)[25] = "low30PN"    
  
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
  
  # Find lowest 30-day mortality for 'heart attack'
  if(outcome == outcomeValues[1])
  {
    result = outcomes[which(outcomes$low30HT != "Not Available" & outcomes$State == state), c(2,7,13)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30HT), ]
    
    lowestValue = result[1,3]
    if(dim(result[which(result$low30HT == lowestValue),])[1] > 1)
    {
      result = result[which(result$low30HT == lowestValue),]
      return(result[with(result, order(result$Hospital.Name, decreasing=FALSE)),][1,1])
    }
    else
    {
      return (result[1,1])
    }   
  }
  
  
  # Find lowest 30-day mortality for 'heart failure'
  if(outcome == outcomeValues[2])
  {
    result = outcomes[which(outcomes$low30HF != "Not Available" & outcomes$State == state), c(2,7,19)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30HF), ]
    
    lowestValue = result[1,3]
    if(dim(result[which(result$low30HF == lowestValue),])[1] > 1)
    {
      result = result[which(result$low30HF == lowestValue),]
      return(result[with(result, order(result$Hospital.Name, decreasing=FALSE)),][1,1])
    }
    else
    {
      return (result[1,1])
    }   
  }
  
  
  # Find lowest 30-day mortality for 'Pneumonia'
  if(outcome == outcomeValues[3])
  {
    result = outcomes[which(outcomes$low30PN != "Not Available" & outcomes$State == state), c(2,7,25)]
    result[,3] = as.numeric(result[,3])
    result = result[order(result$low30PN), ]
    
    lowestValue = result[1,3]
    if(dim(result[which(result$low30PN == lowestValue),])[1] > 1)
    {
      result = result[which(result$low30PN == lowestValue),]
      return(result[with(result, order(result$Hospital.Name, decreasing=FALSE)),][1,1])
    }
    else
    {
      return (result[1,1])
    }   
  }
}


best("NY","neumonia")