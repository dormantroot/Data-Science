library(shiny)
library(shinyIncubator)

# Define UI for application
shinyUI(fluidPage(

  # Application title
  titlePanel("Predict Word"),
  helpText("This application will predict the next highly probable word in a phrase. In other words, if a phrase/sentence/word is given, the application can predict the word with highest probability of occuring next."),

  # Sidebar 
  sidebarLayout(
    sidebarPanel(      
      helpText("Enter the phrase/sentence/word for which you want to predict the next word. Once filled out, click the button below."),
      
      textInput("sPhrase", "Phrase/Sentence/Word", "policies that are"),           
      br(),   
      actionButton("predict", "Predict Next Word"),      
      br()   
    )
    ,

    # Main panel
    mainPanel(
      progressInit(),
      h3("Model Output"),
      br(),
      br(),
      verbatimTextOutput("result")      
    )
  )
))