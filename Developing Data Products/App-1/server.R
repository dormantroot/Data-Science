library(shiny)

diabetesRisk <- function(glucose) glucose / 200


# Define server logic required to draw a histogram
shinyServer(function(input, output) {  
  output$inputValue <- renderPrint({input$glucose})
  output$prediction <- renderPrint({diabetesRisk(input$glucose)})
  
})