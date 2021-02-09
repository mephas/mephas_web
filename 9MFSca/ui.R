library(shiny)
if(!require("stringr")) install.packages("stringr")
library("stringr")
if(!require("Rtsne")) install.packages("Rtsne")
library("Rtsne")
if(!require("ggplot2")) install.packages("ggplot2")
library("ggplot2")
if(!require("factoextra")) install.packages("factoextra")
library("factoextra")
#if(!require("ggfortify")) install.packages("ggfortify")
#library(ggfortify)
if(!require("cluster")) install.packages("cluster")
library("cluster")
if(!require("umap")) install.packages("umap")
library("umap")

if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("mephas.tools",quietly = TRUE)) {remotes::install_github("mephas/mephas.tools", upgrade="never")}; require("mephas.tools",quietly = TRUE)


source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")


#shinyUI(
  tagList(
  
  includeCSS("../www/style.css"),
  stylink(),
  tabOF(),
  
  navbarPage(
    theme = shinythemes::shinytheme("cerulean"),
    #title = a("Cluster analysis", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
    
    title ="Cluster analysis",
    collapsible = TRUE,
    #id="navbar",
    position="fixed-top",
    
    
#panel 0 num
    tabPanel("the optimal value of K ",
             titlePanel("the Optimal Number of Clusters"),
             
             conditionalPanel(
               condition = "input.explain_on_off",
             HTML(
               "    
<h4><b>Functionalities</b></h4>
<p><b>Determine the best 'k' for k-means clustering algorithm by the gap statistic</b></p>
<ul> 
<li>Use the sample data or upload your data from CSV files.
<li> Draw the plot of the gap statistic.The intersection of the blue dotted line and horizontal axis (X-axis) indicates the best 'k'.
<li> Display the input data and calculate the gap statistic.
</ul>


<i><h4>Case Example</h4>
We selected the first four columns of the iris data as an example of cluster analysis.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    

    "
             )
             ),
             
             hr(),
             
             source("0num_ui.R", local=TRUE,encoding = "utf-8")$value),
#panel 1 Kmeans
tabPanel("Kmeans Clustering",
         titlePanel("Kmeans"),
         conditionalPanel(
           condition = "input.explain_on_off",
         HTML(
           "    
<h4><b>Functionalities</b></h4>
<p><b>Partition your data into k classes with k-means clustering.</b></p>
<ul> 
<li> Use the sample data or upload your data from CSV files.
<li> Choose a visualization method to draw the plot of the K-means clustering. Dots of the same color indicate that they belong to the same class.
<li> Display the input data and visualize the results.
</ul>


<i><h4>Case Example</h4>
We selected the first four columns of the iris data as an example of cluster analysis.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    

    "
         )
         ),
         
         hr(),
         
         source("1Kmeans_ui.R", local=TRUE,encoding = "utf-8")$value),

#panel 2 Kmeans
tabPanel("Hierarchical Clustering",
         titlePanel("Hierarchical Clustering"),
         conditionalPanel(
           condition = "input.explain_on_off",
         HTML(
           "    

<h4><b>Functionalities</b></h4>
<p><b>Partition your data with hierarchical clustering.</b></p>
<ul> 
<li> Use the sample data or upload your data from CSV files.
<li> Choose a visualization method to draw the plot of the K-means clustering.The sample in the dotted boxes belong to the same cluster.
<li> Display the input data and visualize the results.
</ul>

<i><h4>Case Example</h4>
We selected the first four columns of the iris data as an example of cluster analysis.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    

    "
         )
           ),
         
         hr(),
         
         source("2HC_ui.R", local=TRUE,encoding = "utf-8")$value),

hr(),

tabstop(),
tablink()

  ))


#navbarMenu("",icon=icon("link"))





