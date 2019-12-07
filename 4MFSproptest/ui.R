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

titlePanel("Normal Theory Method or Exact Method"),

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

  sidebarLayout(

    sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Please input your data")),

    p(tags$i("Example here is that 10 women were found infertile among 40 women who are homozygous for the SNP. Thus, the number of event is 10 and sample size is 40.
      Suppose that in the general population, the infertility rate is 20%.")),
    
      numericInput("x", "How many success / events, x", value = 10, min = 0, max = 100000, step = 1),
      numericInput("n", "How many trials / samples, n", value = 40, min = 1, max = 100000, step = 1),
      numericInput('p', HTML("The specified rate / proportion / probability (0 < p<sub>0</sub> < 1) that you want to compare"), value = 0.2, min = 0, max = 1, step = 0.1)
      ),

  mainPanel(

    h4(tags$b("Output 1. Pie Plot of Proportions")), p(br()), 

    plotOutput("makeplot", width = "400px", height = "400px"),

    p(tags$b("You can change legend names (no space)")),
    tags$textarea(id = "ln", rows = 2, "Infertility\nNon-infertility ")

    )
  ),

  hr(),

  sidebarLayout(

    sidebarPanel(

    h4(tags$b("Step 2. Choose Hypotheses")),

    h4(tags$b("Hypotheses")),
    p(tags$b("Null hypothesis")), 
    HTML("<p>p = p<sub>0</sub>: the probability/proportion is p<sub>0</sub></p>"),
    
    radioButtons("alt", 
      label = "Alternative hypothesis", 
      choiceNames = list(
        HTML("p &#8800 p<sub>0</sub>: the probability/proportion is not p<sub>0</sub>"),
        HTML("p < p<sub>0</sub>: the probability/proportion is less than p<sub>0</sub>"),
        HTML("p > p<sub>0</sub>: the probability/proportion is greater than p<sub>0</sub>")),
      choiceValues = list("two.sided", "less", "greater")
      ),

   p(tags$i("In this setting, we want to test if there is a significant difference in the rate of infertility among homozygous women compared to 20% the general infertile rate."))


    ),

    mainPanel(

    h4(tags$b("Output 2. Test Results")), p(br()), 

    h4(tags$b("Choice 1. Normal Theory Method with Yates' Continuity Correction")), p(br()), 

    tableOutput("b.test1"),

    h4(tags$b("Choice 2. Exact Binomial Method")),  p(br()), 

    tableOutput("b.test"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate IS significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate IS NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  HTML("<i> From the default settings, we conclude that there is no significant difference in the rate of infertility among homozygous women compared to the general interfile rate (P = 0.55). In this case, np<sub>0</sub>(1-p<sub>0</sub>)=40*0.2*0.8 > 5, so <b>Normal Theory Method</b> is preferable. </i>")

      )
    )
),

##----------  Panel 2 ----------
tabPanel("Two Samples",

titlePanel("Normal Theory Method"),

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

sidebarLayout(

  sidebarPanel(
    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Group 1")),
      numericInput("x1", "How many success / events, x1", value =683, min = 0, max = 100000, step = 1),
      numericInput("n1", "How many trials / samples, n1", value = 3220, min = 1, max = 100000, step = 1),
    p(tags$i("Example in Group 1 are 3220 breast cancer women. Among them, 683 have at least one birth after 30 years old. ")),
    
    p(tags$b("Group 2")),  
      numericInput("x2", "How many success / events, x2", value = 1498, min = 0, max = 100000, step = 1),
      numericInput("n2", "How many trials / samples, n2", value = 10245, min = 1, max = 100000, step = 1),
    p(tags$i("Example in Group 2 are 10245 no breast cancer women. Among them, 1498 have at least one birth after 30 years old. ")),

      hr(),

    h4(tags$b("Step 2. Choose Hypotheses and Parameters")),

     h4(tags$b("1. Hypotheses")),
     tags$b("Null hypothesis"), 

      HTML("<p> p<sub>1</sub> = p<sub>2</sub>: the probability/proportion of cases are equal in Group 1 and Group 2. </p>"),
      
      radioButtons("alt1", label = "Alternative hypothesis", 
        choiceNames = list(
          HTML("p<sub>1</sub> &#8800 p<sub>2</sub>: the probability/proportion of cases are not equal"),
          HTML("p<sub>1</sub> < p<sub>2</sub>: the probability/proportion of case in Group 1 is less than Group 2"),
          HTML("p<sub>1</sub> > p<sub>2</sub>: the probability/proportion of case in Group 1 is greater than Group 2")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),
    p(tags$i("In this setting, we want to know if the underlying probability of having first birth over 30 years old is different in 2 groups.")),
     
    h4(tags$b("2. Decide your Sample Size")),
    radioButtons("cr", label = "Yates-correction", 
        choiceNames = list(
          HTML("Do: sample is large enough: n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("Not do: n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        )

      ),

  mainPanel(

    h4(tags$b("Output 1. Pie Plot of Proportions")), p(br()), 

    plotOutput("makeplot2", width = "800px", height = "400px"),

    p(tags$b("You can change legend names (no space)")),

    tags$textarea(id = "ln2", rows = 2, "Birth\nNo-Birth"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("p.test"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different in two groups. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different in two groups. (Accept null hypothesis)
    </ul>"
  ),

  HTML("<i> From the default settings, we conclude that women with breast cancer are significantly more likely to have their first child after 30 years old compared to women without breast cancer. (P<0.001) </i>")
          ) 

    )
    ),

##---------- 3. Chi-square test for 2 paired-independent sample ----------
    tabPanel(">2 Samples",

    titlePanel("Normal Theory Method without Yates-correction"),

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

    sidebarLayout(
      sidebarPanel(

        p(tags$b("How many success / events in every Group, x")),
        tags$textarea(id = "xx",
          rows = 5,
        "320\n1206\n1011\n463\n220"        
        ),

        p(tags$b("How many trials / samples in every Group, n")),     
        tags$textarea(id = "nn",
          rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

         p(tags$b("You can change success / events names (no space)")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Cancer\nNo-Cancer"
      ),

        p(tags$b("You can change Groups names (no space)")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p("Note: No Missing Value and n > x"),

    p(tags$i("In this example, we have 5 age groups of people as shown in n, and we record the number of people who have cancer in x.")),

        hr(),

    h4(tags$b("Step 2. Choose Hypotheses and Parameters")),

     h4(tags$b("1. Hypotheses")),
     p(tags$b("Null hypothesis")), 

      p("The probability/proportion are equal over the Groups"),
      
      p(tags$b("Alternative hypothesis")), 
       p("The probability/proportions are not equal"),          

    p(tags$i("In this setting,  We want to know if the probability to have cancer are different among different age groups ."))
   

    ),

      mainPanel(

      h4(tags$b("Output 1. Data Preview")), p(br()), 

      p(tags$b("Data Table")),

      tableOutput("n.t"),

      p(tags$b("Percentage Plot")),

      plotOutput("makeplot3", width = "600px", height = "300px"),

      hr(),

      h4(tags$b("Output 2. Test Results")), p(br()), 

      tableOutput("n.test"),


     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that the probability to have cancer are significantly different in different age groups. (P < 0.001)"))

        )
      )
    )

##########----------##########----------##########
    ,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help4.R",local=TRUE, encoding="UTF-8")$value


  
  )))


