##----------#----------#----------#----------
##
## 4MFSproptest UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
#shinythemes::themeSelector(),
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,
navbarPage(
 
  title = "Test for Binomial Proportions",

##---------- 1. Panel 1 ----------
  tabPanel("One Single Proportion",

    titlePanel("Exact Binomial Test"),

#tags$b("Introduction"),

#p("To test the probability of events (success) in a series of Bernoulli experiments. "),
HTML("

      <b> Notations </b>

      <ul>
      <li> x is the number of events</li>
      <li> n is the number of trials</li>
      <li> p is the underlying probability of event</li>
      <li> p&#8320 is the specific probability </li>
      </ul>

    <b>Assumptions </b>

      <ul>
      <li> The observations come from binomial distribution </li>
      <li> The normal approximation to the binomial distribution is valid</li>
      </ul>
      " ),

    p(br()),

  sidebarLayout(

    sidebarPanel(

    h4("Hypotheses"),
    tags$b("Null hypothesis"), 
    HTML("<p>p = p&#8320: the probability of events is p&#8320 </p>"),
    
    radioButtons("alt", 
      label = "Alternative hypothesis", 
      choiceNames = list(
        HTML("p &#8800 p&#8320: the probability of events is not p&#8320"),
        HTML("p < p&#8320: the probability of events is less than p&#8320"),
        HTML("p > p&#8320: the probability of events is greater than p&#8320")),
      choiceValues = list("two.sided", "less", "greater")),

    hr(),

    h4("Data Preparation"),  
      numericInput("x", "How many events, x", value = 5, min = 0, max = 10000, step = 1),
      numericInput("n", "How many trials, n", value = 10, min = 1, max = 50000, step = 1),
      numericInput('p', HTML("The specific probability, p&#8320"), value = 0.5, min = 0, max = 1, step = 0.1)
    ),

  mainPanel(
    h4("Results"), 
    p(br()), 
    tableOutput("b.test"),
  #tags$b("Interpretation"), wellPanel(p("When p-value is less than 0.05, it indicates that the underlying probability is far away from the specified value.")),
    hr(),
    h4('Pie Plot of Proportions'), 
    plotOutput("makeplot", width = "400px", height = "400px")
    )
  )
),

##----------  Panel 2 ----------
tabPanel("Two Proportions for Independent Groups",

    titlePanel("Chi-square Test, Fisher's Exact Test"),

HTML("

<b> Assumptions </b>
<ul>
  <li> The expected value in each cell is greater than 5
  <li> When the expected value in each cell < 5, one should do correction or Fisher's exact test 
</ul>

  "),


    sidebarLayout(

      sidebarPanel(
        h4("Data Preparation"),
        helpText("2 x 2 Table"),
        tags$b("Input groups' names"),
        splitLayout(
          verticalLayout(
            tags$b("Group names"),
            tags$textarea(id="cn", label = "Group names", rows=4, cols = 20, "Group1\nGroup2")
            ),
          
          verticalLayout(
            tags$b("Status"), 
            tags$textarea(id="rn", label = "Status", rows=4, cols = 20, "Case\nControl")
            )
          ),
        p(br()),

        tags$b("Input data"), 

          splitLayout(
            verticalLayout(
              tags$b("The first column"), 
              tags$textarea(id="x1", rows=4, "10\n20")
              ),
            verticalLayout(
              tags$b("The second column"),
              tags$textarea(id="x2", rows=4, "30\n35")
              )
            ),
          helpText("Note: ")
        
        ),

  mainPanel(

    h4("Data description"),

      tabsetPanel(
        tabPanel("Display of Table", p(br()),
          tableOutput("t")
          ),

        tabPanel("Expected values", p(br()),
          tableOutput("e.t")
          ),

        tabPanel("Percentages for columns", p(br()),
          tableOutput("p.t")
          ),
        tabPanel("Pie Plot of Proportions", p(br()),
          plotOutput("makeplot2", width = "800px", height = "400px") 
          ) )
        )
      ),


  h4("Chi-square Test"),

    sidebarLayout(
      sidebarPanel(
        
      h4("Hypotheses"),
      tags$b("Null hypothesis"), 
      HTML("<p> p&#8321 = p&#8322: the probabilities of cases are equal in both group. </p>"),
      
      radioButtons("alt1", label = "Alternative hypothesis", 
        choiceNames = list(
          HTML("p&#8321 &#8800 p&#8322: the probabilities of cases are not equal"),
          HTML("p&#8321 < p&#8322: the probability of case in the first group is less than the second group"),
          HTML("p&#8321 > p&#8322: the probability of case in the first group is greater than the second group")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),

      radioButtons("cr", label = "Yates-correction", 
        choiceNames = list(
          HTML("No: no cell has an expected value less than 5"),
          HTML("Yes: at least one cell has an expected value less than 5")
          ),
        choiceValues = list(FALSE, TRUE)
        )
      ),

      mainPanel(
        h4("Results"), tableOutput("p.test")
        #tags$b("Interpretation"), p("Chi-square.test")
        )
      ),


      h4("Fisher's Exact Test"),
    sidebarLayout(

      sidebarPanel(


      tags$b("Assumptions"),
      HTML("
        <ul>
        <li> The normal approximation to the binomial distribution is not valid</li>
        <li> The expected value in each cell is less than 5</li>
        </ul>" )
      ),

      mainPanel(
        h4("Results"), 
        tableOutput("f.test")
      #tags$b("Interpretation"), p("Fisher's exact test")
        )
    )
    ),

##---------- 3. Chi-square test for 2 paired-independent sample ----------
    tabPanel("Two Proportions for Matched-Pair Data",

    titlePanel("McNemar's Test"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    p(br()),

    sidebarLayout(
      sidebarPanel(

      h4("Hypotheses"),
      tags$b("Null hypothesis"), 
      HTML("<p> The probabilities of being classified into cells [i,j] and [j,i] are the same</p>"),
      tags$b("Alternative hypothesis"), 
      HTML("<p> The probabilities of being classified into cells [i,j] and [j,i] are not same</p>"),
      hr(),

      h4("Data Preparation"),
      helpText("2 x 2 Table"),

      tags$b("Input groups' names"),
      splitLayout(
        verticalLayout(
          tags$b("Results of Treatment A"),
          tags$textarea(id="ra", rows=4, cols = 20, "Result1.A\nResult2.A")
          ),
        
        verticalLayout(
          tags$b("Results of Treatment B"), 
          tags$textarea(id="cb", rows=4, cols = 20, "Result1.B\nResult2.B")
          )
        ),
      p(br()),
      tags$b("Input Data"),
      
        splitLayout(
          verticalLayout(
            tags$b("Column 1"), 
            tags$textarea(id="xn1", rows=4, "510\n15")
            ),
          verticalLayout(
            tags$b("Column 2"),
            tags$textarea(id="xn2", rows=4, "16\n90")
            )
          )
        
      ),

      mainPanel(
        h4("Display of Table"), 
        tableOutput("n.t"),
        helpText(
          HTML(
            "<p> When the number of discordant pairs < 20, one should refer to results with correction </p>
            <ul>
            <li> Discordant pair is a matched pair in which the outcome differ for the members of the pair. </li>
            </ul>"
            )
          ),
        h4("Results"), 
        tableOutput("n.test")
  #tags$b("Interpretation"), p("bbb")
        )
      )
    )
    ,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help4.R",local=TRUE, encoding="UTF-8")$value


  
  )))


