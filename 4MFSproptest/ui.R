##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------

shinyUI(

tagList(
#shinythemes::themeSelector(),
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(
 
title = "Test for Binomial Proportions",

##---------- 1. Panel 1 ----------
tabPanel("One Sample",

titlePanel("Normal Theory Method or Exact Method for One Proportion"),

#tags$b("Introduction"),

#p("To test the probability of events (success) in a series of Bernoulli experiments. "),
HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population rate/proportion behind your data is significantly different from the specified rate/proportion
      <li> To determine how compatible the sample rate/proportion with a population rate/proportion
      <li> To determine the probability of success in a Bernoulli experiment
    </ul>

    <h4><b> 2. About your data </b></h4>

      <ul>
      <li> Your data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group)
      <li> You have a specified proportion (p<sub>0</sub>)
      </ul>

    <h4><b> 3. Two choices of tests </b></h4>

    <ul>
      <li> <b>Normal Theory Method with Yates' Continuity Correction: </b> suggested when np<sub>0</sub>(1-p<sub>0</sub>) >= 5; n is the whole sample size, p<sub>0</sub> is the specified rate/proportion
      <li> <b>Exact Binomial Method:</b> an exact test about the probability of success in a Bernoulli experiment
    </ul> 


    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      " ),

hr(),

source("p1_ui.R", local=TRUE)$value,
hr()

),

##----------  Panel 2 ----------
tabPanel("Two Samples",

titlePanel("Normal Theory Method for Two Independent Proportions"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population rate/proportion behind your 2 Groups data are significantly different </ul>

    <h4><b> 2. About your data </b></h4>

      <ul>
      <li> Your 2 Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from 2 Groups
      <li> The 2 Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("p2_ui.R", local=TRUE)$value,
hr()


    ),

##---------- 3. Chi-square test for 2 paired-independent sample ----------
    tabPanel(">2 Samples",

    titlePanel("Normal Theory Method without Yates-correction for More than Two Independent Proportions"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population rate/proportion behind your multiple Groups data are significantly different </ul>

    <h4><b> 2. About your data </b></h4>

      <ul>
      <li> Your Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
      <li> The multiple Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("p3_ui.R", local=TRUE)$value,
hr()
    ),

##---------- 4. trend test ----------
tabPanel("Trend in >2 Samples ",

titlePanel("Chi-square Test for Trend in Multiple Independent Samples"),

HTML("
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the population rate/proportion behind your multiple Groups data vary with score </ul>

    <h4><b> 2. About your data </b></h4>

      <ul>
      <li> Your Groups data come from binomial distribution (the proportion of success)
      <li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
      <li> The multiple Groups are independent observations
      </ul>

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
  
      "),
hr(),

source("p4_ui.R", local=TRUE)$value,
hr()

),


##########----------##########----------##########

##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help4.R",local=TRUE, encoding="UTF-8")$value


  
  )))


