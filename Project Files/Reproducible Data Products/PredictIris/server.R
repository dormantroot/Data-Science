library(shiny)
library(quantmod)
library(randomForest)
library(datasets)
library(shinyIncubator)
library(ggplot2)


shinyServer(function(input, output, session) {
  trainModel = reactive({
    withProgress(session,{
      
      # Provides a progress output as the model is being trained
      setProgress(detail = "Training the Random Forest Model, this may take a few moments...")
      
      # Utilized for invoking the reactive feature
      input$learn
      
      # Train the random forest model using the provided Iris dataset
      ml =randomForest(Species ~ ., data=iris)
      
      # Return the computed model
      return (ml) 
    })     
  });
  
  predictIris = reactive({tryCatch({
    withProgress(session, {
      # Call to train the Random forest model
      model = trainModel() 
      
      # Prepare the test dataset from the provided user measurements. If the input is not validate, the program will
      # terminate gracefully with errors
      df = data.frame(as.numeric(input$sLength),as.numeric(input$sWidth), as.numeric(input$pLength), as.numeric(input$pWidth))      
      names(df) = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")
            
      # Provide UI feedback while the Iris species type is predicted
      setProgress(message = "Predicting", detail = "This may take a few moments...")      
      prModel = predict(model, df)                  
      df = cbind(df, data.frame(toString(prModel)))
      names(df) = c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species") 
      
      # Return the predicted model and the user provided Sepal measurements
      return (list("predictedModel"=prModel, "userDF"=df))
    })   
    
  }, error = function(err){
    
    return (paste("Couldn't predict the Iris species; encountered this error: ", err))
  }, finally = {
    
  } 
  )})
  
  output$result = renderText({
    # Take a dependency on input$predict
    input$predict
    input$learn
    
    # User isolate to avoid dependency on other inputs
    isolate({      
      pr = predictIris()      
      paste("Based on the measurements you entered, the Iris species is ", toupper(toString(pr$predictedModel)))
    })   
  })
  
  output$petalPlot <- renderPlot({ 
    # Take a dependency on input$predict
    input$predict
    input$learn
    
    # User isolate to avoid dependency on other inputs
    isolate({      
      pr = predictIris()      
      p = qplot(Petal.Width, Petal.Length, col=Species,data=iris)
      p + scale_alpha(guide = 'none')
      p + geom_point(color="black",size=10,shape=4,x=pr$userDF$Petal.Width,y=pr$userDF$Petal.Length)   
    })    
  })
  
  output$sepalPlot <- renderPlot({    
    # Take a dependency on input$predict
    input$predict
    input$learn
    
    # User isolate to avoid dependency on other inputs
    isolate({      
      pr = predictIris()
      p = qplot(Sepal.Width, Sepal.Length, col=Species,data=iris)
      p + scale_alpha(guide = 'none')
      p + geom_point(color="black",size=10,shape=4,x=pr$userDF$Sepal.Width,y=pr$userDF$Sepal.Length)
    })  
  })
  
})