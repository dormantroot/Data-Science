library(shiny)
library(UsingR)
data(galton)



# Define server logic required to draw a histogram
shinyServer(function(input, output) {  
  
  output$myHist <- renderPlot({
    
    hist(galton$child, xlab='child height', col='lightblue',main='Histogram')
    
    mu <- input$mu
    lines(c(mu, mu), c(0, 200),col="red",lwd=5)
    mse <- mean((galton$child - mu)^2)
    text(63, 150, paste("mu = ", mu))
    text(63, 140, paste("MSE = ", round(mse, 2)))
  })
  
})