##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------

##Panel 1

  sidebarLayout(

    sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Please input your data")),

    p(tags$i("Example here is that 10 women were found infertile among 40 women who are homozygous for the SNP. Thus, the number of event is 10 and sample size is 40.
      Suppose that in the general population, the infertility rate is 20%.")),
    
      numericInput("x", "How many success / events, x", value = 10, min = 0, max = 100000, step = 1),
      numericInput("n", "How many trials / samples, n", value = 40, min = 1, max = 100000, step = 1),
      numericInput('p', HTML("The specified rate / proportion / probability (0 < p<sub>0</sub> < 1) that you want to compare"), value = 0.2, min = 0, max = 1, step = 0.1),

      hr(),

       h4(tags$b("Step 2. Choose Hypotheses")),

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

    h4(tags$b("Output 1. Pie Plot of Proportions")), p(br()), 

    plotOutput("makeplot", width = "400px", height = "400px"),

    p(tags$b("You can change legend names (no space)")),
    tags$textarea(id = "ln", rows = 2, "Infertility\nNon-infertility "),

    hr(),

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
