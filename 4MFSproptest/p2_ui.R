##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: EN
## 
## DT: 2019-04-07
##
##----------#----------#----------#----------


##----------  Panel 2 ----------

sidebarLayout(

  sidebarPanel(
    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to the sample Groups")),
    tags$textarea(id = "cn.2", rows = 2,
        "Birth>30\nBirth<30"
      ),
    p(tags$b("Give names to the success / events")),
    tags$textarea(id = "rn.2", rows = 2,
        "Cancer (Case)\nNo-Cancer (Control)"
      ),
    p(br()),

    p(tags$b("Please follow the example to input your data")),

    p(tags$b("Group 1 (Case)")),
      numericInput("x1", "How many success / events (in case), x1", value =683, min = 0, max = 10000000, step = 1),
      numericInput("n1", "How many trials / samples, n1 > x1", value = 3220, min = 1, max = 10000000, step = 1),
    p(tags$i("Example in Group 1 were 3220 breast cancer women. Among them, 683 had at least one birth after 30 years old. ")),
    
    p(tags$b("Group 2 (Control)")),  
      numericInput("x2", "How many success / events (in control), x2", value = 1498, min = 0, max = 10000000, step = 1),
      numericInput("n2", "How many trials / samples (Total), n2 > x2", value = 10245, min = 1, max = 10000000, step = 1),
    p(tags$i("Example in Group 2 were 10245 no breast cancer women. Among them, 1498 had at least one birth after 30 years old. ")),

      hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

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
    p(tags$i("In this example, we wanted to know if the underlying probability of having first birth over 30 years old was different in 2 groups.")),
    hr(),
     
    h4(tags$b("Step 3. Whether to do Yates-correction")),
    radioButtons("cr", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: sample is large enough: n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("Not do: n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        )

      ),

  mainPanel(

    h4(tags$b("Output 1. Data Preview")), p(br()), 

    p(tags$b("Data Table")),
    tableOutput("n.t2"),

    p(tags$b("Percentage Plot")),

    plotOutput("makeplot2", width = "800px", height = "400px"),

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
    