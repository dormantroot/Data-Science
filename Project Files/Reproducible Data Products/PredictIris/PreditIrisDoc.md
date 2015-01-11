Predict Iris Species
========================================================
 An Intuitive Shiny R Application

Predict Iris Species
========================================================

<p style="font-size:60px;font-style:Italic"> Introducing an interactive Shiny R application that can predict Iris species type. It's intuitive and easy to use</p>


How Does It Work?
========================================================
<p>If you have Sepal measurements then this application can predict which Iris species you are dealing with.</p>

Here are the steps:

1. The user enters the required sepal measurements
2. The application utilizes its trained Random Forest model to figure out which Iris species it is.
3. The application outputs the results


Random Forest Model
========================================================
<p>Here's the output (with impressive accuracy) from a trained Random Forest model.</p>

```
            
pred         setosa versicolor virginica
  setosa         15          0         0
  versicolor      0         15         3
  virginica       0          0        12
```

![plot of chunk unnamed-chunk-2](PreditIrisDoc-figure/unnamed-chunk-2-1.png) 

How Do I Get my Hands on the Application?
========================================================
Now, try it out for yourself!

1. <a target="_blank" href="http://goo.gl/Lu9TTc">Github source code</a>
2. <a target="_blank" href="https://dormantroot.shinyapps.io/PredictIris/">R Shiny Application</a>


