Predict Next Word
========================================================
 An Intuitive Shiny R Application

Predict Next Word
========================================================

<p style="font-size:60px;font-style:Italic"> Introducing an interactive Shiny R application that can predict the next word based on the phrase/sentence/word you enter. It's intuitive and easy to use</p>

How Does It Work?
========================================================
<p>If you have a phrase, sentence or word then this application can predict the succeeding word with the highest probability.</p>

Here are the steps:

1. The user enters the required phrase, sentence or word
2. The application utilizes its trained Decision Tree to figure out which word occurs next
3. The application outputs the results


The Internal of the Applications
========================================================
<p>At the core, the application uses Trigram Markov model for prediction.</p> You can read more about it here <a target="_blank" href="http://nlpwp.org/book/chap-ngrams.xhtml#chap-ngrams-markov-models">N-grams using Markov Models</a>. Also, you can read more about the application <a target="_blank" href="https://github.com/dormantroot/Data-Science/blob/master/Capstone%20Project/Word_Prediction.Rmd">here</a>

The accuracy of the application is not very impressive. I hope to increase it the next iteration/release.



How Do I Get my Hands on the Application?
========================================================
Now, try it out for yourself!

<a target="_blank" href="http://dormantroot.shinyapps.io/PredictWord/">PredictWord - An Intuitive Shiny Application</a>

<a target="_blank" href="https://github.com/dormantroot/Data-Science/tree/master/Capstone%20Project/PredictWord"> Here's the source code</a>
