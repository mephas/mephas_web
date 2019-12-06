##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
#source("p1_ui.R", local=TRUE,encoding = "UTF-8")
#source("p2_ui.R", local=TRUE,encoding = "UTF-8")
#source("p3_ui.R", local=TRUE,encoding = "UTF-8")

shinyUI(

tagList( 
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(

title = "Non-Parametric Test for Median",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Sign Test or Wilcoxon Signed-Rank Test"),

HTML(
    "
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the median of the population from which your data is drawn statistically significantly different from the specified median
      <li> To determine the distribution of you data is symmetric about the specified median
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain only 1 group of values (or a vector)
      <li> Your data are meaningful to measure the distance from the specified median
      <li> The values are independent observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
    </ul> 

    <h4><b> 3. Two choices of tests </b></h4>

    <ul>
      <li> <b>Sign Test:</b> lack some the statistical power 
      <li> <b>Wilcoxon Signed-Rank Test:</b> alternative to one-sample t-test, when the data cannot be assumed to be normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

hr(),
##---------- 1.1 ----------

source("p1.1_ui.R", local=TRUE),

hr(),

h4(tags$b("Step 3. Choose Methods and Hypotheses")),

##---------- 1.2 ----------
##---------- Sign Test ----------
h4(tags$b("Choice 1. Sign Test")),

source("p1.2_ui.R", local=TRUE),

hr(),
##---------- 1.3 ----------
h4(tags$b("Choice 2. Wilcoxon Signed-Rank Test")),

source("p1.3_ui.R", local=TRUE),

),

##---------- Panel 2 ----------

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test or Mood's Median Test"),

HTML(
    "
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the medians of two population from which your 2 groups data drawn are statistically significantly different from each other
      <li> To determine if the distributions of 2 groups of data differ in locations
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain only 2 group of values (or 2 vector) 
      <li> Your data are meaningful to measure the distance between 2 groups values
      <li> The values are independent observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
    </ul> 

    <h4><b> 3. Two choices of tests </b></h4>

    <ul>
      <li> <b>Wilcoxon Rank-Sum Test / Mann-Whitney U Test / Mann-Whitney-Wilcoxon Test / Wilcoxon-Mann-Whitney Test:</b> alternative to two-sample t-test, when the data cannot be assumed to be normally distributed
      <li> <b>Mood's Median Test:</b> a special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. 
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

hr(),

##---------- 2.1 ----------

source("p2.1_ui.R", local=TRUE),

hr(),

h4(tags$b("Step 2. Choose Methods and Hypotheses")),
##---------- 2.2 ----------
h4(tags$b("Choice 1. Wilcoxon Rank-Sum Test, Mann-Whitney U Test, Mann-Whitney-Wilcoxon Test, Wilcoxon-Mann-Whitney Test")),

source("p2.2_ui.R", local=TRUE),

hr(),
##---------- 2.3 ----------
h4(tags$b("Choice 2. Mood's Median Test")),

source("p2.3_ui.R", local=TRUE),

),

##---------- Panel 3 ----------

tabPanel("Paired Samples",    

headerPanel("Sign Test or Wilcoxon Signed-Rank Test"),

HTML(
    "
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the difference of paired data is statistically significantly different from 0
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain 2 group of values (or a vector)
      <li> Your data are meaningful to measure the distance from the specified median
      <li> The values are paired or matched observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
    </ul> 

    <h4><b> 3. Examples for Matched or Paired Data </b></h4>
      <ul>
       <li>  One person's pre-test and post-test scores 
       <li>  When there are two samples that have been matched or paired
      </ul>  

     <b>In paired case, we compare the differences of 2 groups to zero. Thus, it becomes a one-sample test problem.</b>

    <h4><b> 4. Two choices of tests </b></h4>

    <ul>
      <li> <b>Sign Test:</b> lack some the statistical power 
      <li> <b>Wilcoxon Signed-Rank Test:</b> alternative to one-sample t-test, when the data cannot be assumed to be normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

source("p3.1_ui.R", local=TRUE),

hr(),
##---------- 3.1 ----------

h4("Sign Test"),

source("p3.2_ui.R", local=TRUE),

hr(),
##---------- 3.2 ----------

h4("Wilcoxon Signed-Rank Test"),

source("p3.3_ui.R", local=TRUE),

),
##########----------##########----------##########
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/help3.R",local=TRUE, encoding="UTF-8")$value

  
))
)

