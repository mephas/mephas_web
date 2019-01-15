##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 2
##
## Language: CN
## 
## DT: 2019-01-10
##
##----------#----------#----------#----------
##---------- Wilcoxon Rank-Sum Test ----------
wrtest<- sidebarLayout(

sidebarPanel(
##-------explanation-------##

h4("Hypotheses"),
tags$b("Null hypothesis"),

HTML("<p> m&#8321 = m&#8322: the medians of each group are equal; the distribution of values for each group are equal </p>"),

radioButtons("alt.mwt", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal; there is systematic difference in the distribution of values for the groups"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater")),

h4("Correction"),
radioButtons("nap.mwt", label = "Normal Approximation", 
  choices = list("Sample size is not large" = FALSE,
                 "Sample size is moderate large" = TRUE, 
                 "Small sample size" = TRUE), selected = FALSE)),

mainPanel(
  h4("Results of Wilcoxon Rank-Sum Test"), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff' denotes the estimated differences of medians
      <li> When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction' </li>  
      </ul>" ))
  )

)

##---------- 2.2 ----------

mmtest<- sidebarLayout(
sidebarPanel(

h4("Hypotheses"),
tags$b("Null hypothesis"),
HTML("m&#8321 = m&#8322, the medians of values for each group are equal"),

radioButtons("alt.md", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(
  h4("Results of Mood's Median Test"), tableOutput("mood.test") 
  ) 
)

##---------- data ----------
twosample<- sidebarLayout(  
sidebarPanel(

h4("Data Preparation"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manually input", p(br()),
    helpText("Missing value is input as NA"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("Change the names of two samples (optional)"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("Upload CSV file", p(br()),
    fileInput('file2', 'Choose CSV file', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', 'Header', TRUE), #p
    radioButtons('sep2', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) )
),

mainPanel(

  h4("Descriptive Statistics"),

  tabsetPanel(

    tabPanel("Data Display", p(br()),  

      dataTableOutput("table2")),

    tabPanel("Basic descriptives", p(br()), 

      splitLayout(
        tableOutput("bas2"), 
        tableOutput("des2"), 
        tableOutput("nor2"))  ),

    tabPanel("Boxplot", p(br()), 

      splitLayout(
        plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),

      wellPanel(
        verbatimTextOutput("info2"), hr(),

        helpText(
          HTML(
            "Notes:
            <ul>
            <li> Points are simulated and located randomly in the same horizontal line 
            <li> Outliers will be highlighted in red, if existing
            <li> The red outlier may not cover the simulated point
            <li> The red outlier only indicates the value in horizontal line
            </ul>"
            )
          )
        )
        ) ),

    tabPanel("Histogram", p(br()), 

      plotOutput("makeplot2", width = "800px", height = "400px"),
      sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)
      )
    ))  )