# UI.R

library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  titlePanel("Predict Iris Species Type"),
  helpText("This application will help determine the Iris species based on the Sepal and Petal measurements your provide. The server utilizes a trained Random Forest model to predict the Iris species type."),
  
  
  sidebarLayout(
    sidebarPanel(
      helpText("The Random Forest model will be created the very first time the application loads. This is controlled through a reactive function on the server. However, If you wish recreate the model, click the button below"),
      actionButton("learn", "Recreate Random Forest Model"),
      br(),
      br(),
      
      helpText("Fill in the Iris Sepal (length and width) and
               Petal (length and width) measurement to find out the Iris species type. Once filled out, click the button below."),
    
      textInput("sLength", "Sepal Length", "6.2"),
      textInput("sWidth", "Sepal Width", "3.4"),
      br(),
      br(),      
      textInput("pLength", "Petal Length", "5.4"),
      textInput("pWidth", "Petal Width", "2.3"),      
      br(),   
      actionButton("predict", "Find Iris Species"),      
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      br(),
      h4("Here are some sample Iris measurements to try out"),
      HTML("<table><tr><th>Sepal Length</th><th>Sepal Width</th><th>Petal Length</th><th>Petal Width</th><th>Species</th></tr><tr><td>5.0</td><td>3.6</td><td>1.4</td><td>0.2</td><td>setosa</td></tr><tr><td>4.5</td><td>2.3</td><td>1.3</td><td>0.3</td><td>setosa</td></tr><tr><td>5.1</td><td>3.3</td><td>1.7</td><td>0.5</td><td>setosa</td></tr><tr><td>6.7</td><td>3.1</td><td>4.4</td><td>1.4</td><td>versicolor</td></tr><tr><td>4.9</td><td>2.4</td><td>3.3</td><td>1.0</td><td>versicolor</td></tr><tr><td>5.7</td><td>2.6</td><td>3.5</td><td>1.0</td><td>versicolor</td></tr><tr><td>7.2</td><td>3.2</td><td>6.0</td><td>1.8</td><td>virginica</td></tr><tr><td>5.8</td><td>2.7</td><td>5.1</td><td>2.3</td><td>virginica</td></tr><tr><td>6.0</td><td>2.2</td><td>5.0</td><td>1.5</td><td>virginica</td></tr></table>")
    ),
    
    mainPanel(
      
         progressInit(),
         h3("Model Output"),
         br(),
         br(),
         verbatimTextOutput("result"),
         br(),
         br(),
         br(),
         plotOutput("sepalPlot"),       
         br(),
         br(),
         br(),
         plotOutput("petalPlot")
        )
  )
))                            