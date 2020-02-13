if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("reshape")) {install.packages("reshape")}; library("reshape")
if (!requireNamespace("exactRankTests",quietly = TRUE)) {install.packages("exactRankTests")}; require("exactRankTests",quietly = TRUE)  
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Non-parametric Test for Medians", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "Non-parametric Test for Medians",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("One Sample",

headerPanel("Wilcoxon Signed-Rank Test for One Sample"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
    "
<p>This method is an alternative to a one-sample t-test when the data cannot be assumed to be normally distributed.
This method is based on the ranks of observations rather than on their actual values</p>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the median/location of the population from which your data is drawn statistically significantly different from the specified median</li>
<li> To know the basic descriptive statistics about your data</li>
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 1 group of values (or 1 numeric vector)</li>
<li> Your data are meaningful to measure the distance from the specified median</li>
<li> The values are independent observations</li>
<li> No assumption on the distributional shape of your data, which means your data may be not normally distributed</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a particular group of patients. DRS Scale > 1 indicated Depression.
We wanted to know if the DRS of patients was significantly greater than 1.
</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>


    "
)
),

hr(),
source("ui_1.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann–Whitney U test) for Two Independent Samples"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(

    "
<p>This method is an alternative to two-sample t-test when the data cannot be assumed to be normally distributed</p>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the medians of two population from which your 2 groups data drawn are statistically significantly different from each other</li>
<li> To determine if the distributions of 2 groups of data differ in locations</li>
<li> To know the basic descriptive statistics about your data</li>
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 2 groups of values (or 2 numeric vectors)</li>
<li> Your data are meaningful to measure the distance between 2 groups values</li>
<li> The values are independent observations</li>
<li> No assumption on the distributional shape of your data</li>
<li> Your data may be not normally distributed</li>
</ul>

<h4><i>Case Example</i></h4>
<i>Suppose we collected the Depression Rating Scale (DRS) measurements of 19 patients from a particular group of patients. Among 19 people, 9 were women, and 10 were men.
We wanted to know if the DRS of patients was significantly different among different genders; or, whether age was related to DRS scores.
</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>


    "
 )
),

hr(),
source("ui_2.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tabPanel("Paired Samples",

headerPanel("Wilcoxon Signed-Rank Test for Two Paired Samples"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
    "
<b>In the paired case, we compare the differences between 2 groups to zero. Thus, it becomes a one-sample test problem.</b>
<p>This method is an alternative to paired-sample t-test when the data cannot be assumed to be normally distributed.</p>

<h4><b> 1. Functionalities  </b></h4>
<ul>
<li> To determine if the difference of paired data is statistically significantly different from 0</li>
<li> To know the basic descriptive statistics about your data</li>
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data</li>
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 groups of values (or 2 numeric vectors)</li>
<li> Your data are meaningful to measure the distance from the specified median</li>
<li> The values are paired or matched observations</li>
<li> No assumption on the distributional shape of your data</li>
<li> Your data may be not normally distributed</li>
</ul>

<h4><b> 3. Examples for Matched or Paired Data </b></h4>
<ul>
<li>  One person's pre-test and post-test scores</li>
<li>  When two samples have been matched or paired</li>
</ul>


<h4><i>Case Example</i></h4>
<i>We wanted to know if the DRS of patients before and after were significant; or, whether the differences were significantly different from 0, which could indicate if the treatment was effective.
</i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
)
),

hr(),
source("ui_p.R", local=TRUE)$value,
hr()

),
##########----------##########----------##########

tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

))

