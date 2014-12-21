library(shiny)
library(shinyIncubator)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  readData = reactive({
    withProgress(session,{
      print("read file")
      # read bigram probability
      bigram_pr = read.csv("dtm_bi_train_prob_shrunk.csv", header = TRUE, sep = " ", stringsAsFactors=FALSE)
      valid_eng = read.csv("corncob_lowercase.csv", header = TRUE, sep = ",", stringsAsFactors=FALSE)
      words = as.vector(valid_eng$Word)
      return (list("prob" = bigram_pr, "words" = words))
    })     
  });
  
  
  
  
  ####################################################################################################
  ####################################### Prediction #################################################
  ####################################################################################################
  predictWord = reactive({tryCatch({
    withProgress(session, {
      
      # Provides a progress output
      setProgress(detail = "Preparing the model, this may take a moment...")      
      trim = function (x) gsub("^\\s+|\\s+$", "", x)     
      
      # Read data
      data = readData() 
      
      # probablity
      pro = data$prob
      
      # list of valid words
      words = data$words
       
      # Prediction function
      pred = function(sentence){  
        
        unigrams = rev(strsplit(tolower(sentence), " ")[[1]])
        for(unigram in unigrams){     
          unigramInd = which(words==unigram)
          b = pro[which(pro$V1==unigramInd),]     
          
          if(nrow(b) > 0){   
            bigramInd = head(b[order(-b$V3),],1)
            print(words[bigramInd$V2])
            return (words[bigramInd$V2])
          }
        }
        
        return (sample(words,1))
      }
      
      # Predict the next word
      nextWord = pred(tolower(trim(toString(input$sPhrase))))    
      
      # Return the next predicted word
      return (paste("Based on the phrase/sentence/word you entered, the next highly probable word is: ", toupper(toString(nextWord))))      
    })   
    
  }, error = function(err){
    
    return (paste("Couldn't predict the next word; encountered this error: ", err))
  }, finally = {
    
  } 
  )})
  
  output$result = renderText({    
        
    # Respond to 'predict' button click only
    input$predict
    
    # User isolate to avoid dependency on other inputs
    isolate({      
      predictWord() 
    }) 
   
    
  })
})