options(shiny.maxRequestSize=95*1024^2)

library(shiny)
library(shinyIncubator)
library(rJava)
library(RWeka)
library(R.utils)
library(stringi)
library(stringr)
library(shiny)
library(textcat)
library(tm)
library(markovchain)
source("./predictNextWord.R")

# Read all the necessary files before starting
shinyServer(function(input, output, session) {
  
  
  # Read data
  readData = reactive({  
    
    # Read data
    blackList = read.csv("./Terms-to-Block.csv", skip=4)
    blackList = blackList[,2]
    blackList = gsub(",","",blackList) 
    
    # read transition matrix that was created during modeling
    load(file="./transitionMatrix.RData")
    
    # create markovs predictor   
    textPredictor = new("markovchain", transitionMatrix=transitionMatrix)
    rm(transitionMatrix) 
  
    # return
    return (list("blacklist" = blackList, "markovPredict" = textPredictor))     
  });
  
  
  
  
  ####################################################################################################
  ####################################### Prediction #################################################
  ####################################################################################################
  predictWord = function(updateProgress = NULL){tryCatch({
   
    # Initialize 
    updateProgress(detail = "Working hard..... Predicting is not easy! :) ")      
    data = readData()
    
    
    #Predicting
    currentPhrase = preprocessTextInput(input$sPhrase, data$blackList)
    if (length(currentPhrase) > 0) {    
      textPrediction = predictNextWord(currentPhrase, 1,  data$markovPredict)        
      predictedNextWord = t(as.matrix(textPrediction$conditionalProbability))        
      rownames(predictedNextWord) = "P(term)"     
      nextWord = (colnames(predictedNextWord)[1])
    }        
    
    # Return the next predicted word
    return (paste("Based on the phrase/sentence/word you entered, the next highly probable word is: ", toupper(toString(nextWord))))    
  }, error = function(err){    
    return (paste("Couldn't predict the Iris species; encountered this error: ", err))
  }, finally = {} 
  )}
  
  
  ## Render results
  output$result = renderText({    
    
    # Respond to 'predict' button click only
    input$predict
    
    # User isolate to avoid dependency on other inputs
    isolate({       
     
      # Create a Progress object
      progress <- shiny::Progress$new()
      progress$set(message = "", value = 0)
      
      # Close the progress when this reactive exits (even if there's an error)
      on.exit(progress$close())
      
      # Create a closure to update progress.
      # Each time this is called:
      # - If `value` is NULL, it will move the progress bar 1/5 of the remaining
      #   distance. If non-NULL, it will set the progress to that value.
      # - It also accepts optional detail text.
      updateProgress <- function(value = NULL, detail = NULL) {
        if (is.null(value)) {
          value <- progress$getValue()
          value <- value + (progress$getMax() - value) / 5
        }
        progress$set(value = value, detail = detail)
      }
      
      # Find the next word
      predictWord(updateProgress)     
    }) 
    
    
  })
})