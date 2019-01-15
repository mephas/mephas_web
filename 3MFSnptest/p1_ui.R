##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 1
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
##---------- Sign Test ----------
signtest<-sidebarLayout(


sidebarPanel(

h4("Hypotheses"),

tags$b("Null hypothesis"),
HTML("<p> m = m&#8320: the population median is equal to the specified value </p>"),

radioButtons("alt.st", label = "Alternative hypothesis", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: the population median of X is not equal to the specified value"),
  HTML("m < m&#8320: the population median of X is less than the specified value"),
  HTML("m > m&#8320: the population median of X is greater than the specified value")),
choiceValues = list("two.sided", "less", "greater"))),

  mainPanel(
    h4('Results of Sign Test'), 
    tableOutput("sign.test")
    )  
  )

##---------- Wilcoxon Signed-Rank Test ----------

wstest<-sidebarLayout(

sidebarPanel(

h4("Hypotheses"),

tags$b("Null hypothesis"),
HTML("<p> m = m&#8320: the population median is equal to the specified value; the distribution of the data set is symmetric about the default value </p>"),

radioButtons("alt.wsr", label = "Alternative hypothesis", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: the population median of X is not equal to the specified value; or, the distribution of the data set is not symmetric about the default value"),
  HTML("m < m&#8320: the population median of X is less than the specified value"),
  HTML("m > m&#8320: the population median of X is greater than the specified value")),
choiceValues = list("two.sided", "less", "greater")),

helpText("Correction"),
radioButtons("nap.wsr", label = "Normal Approximation", 
  choices = list("Sample size is not large" = FALSE,
                 "Sample size is moderate large" = TRUE, 
                 "Small sample size" = TRUE), selected = FALSE),
helpText("Normal approximation is applicable when sample size > 10.")),

  mainPanel(
    h4('Results of Wilcoxon Signed-Rank Test'), 
    tableOutput("ws.test"), 
    helpText("When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction'")
  )
)

##---------- data ----------
onesample<- sidebarLayout(  

sidebarPanel(

h4("Data Preparation"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),
    helpText("Missing value is input as NA"),

    tags$textarea(id="a", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),
    helpText("Change the names of the samples (optional)"), 
    tags$textarea(id="cn", rows=2, "X")
    ),

  ##-------csv file-------##   
  tabPanel("Upload CSV file", p(br()),
    fileInput('file', 'Choose CSV file', 
      accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE), #p
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) 
  ),

  hr(),
  h4("Configuration"),
  numericInput("med", HTML("The specific value, m&#8320"), 4)#p),
  ),

mainPanel(

  h4("Descriptive Statistics"),

  tabsetPanel(

    tabPanel("Data Display", p(br()),  

      dataTableOutput("table")),

    tabPanel("Basic descriptives", p(br()), 

      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor"))  ),

    tabPanel("Boxplot", p(br()), 

      splitLayout(
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),

      wellPanel(
        verbatimTextOutput("info"), hr(),

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

      plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)
      )
    )
  )
)



