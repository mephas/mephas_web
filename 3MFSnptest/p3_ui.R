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

signtest.p<- sidebarLayout(

##########----------##########----------##########

sidebarPanel(

  h4("Hypotheses"),
  tags$b("Null hypothesis"),
 # p("m = 0: the difference of medians between X and Y is zero; X and Y are equally effective"),

  radioButtons("alt.ps", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; X and Y are not equally effective"),
      HTML("m < 0: the population median of X is greater; X is more effective"),
      HTML("m > 0: the population median of Y is greater; Y is more effective")),
      choiceValues = list("two.sided", "less", "greater")) 
  ),

mainPanel(
  h4('Results of Sign Test'), p(br()),
  tableOutput("psign.test"), p(br()),
  helpText("Notes: 'Estimated.d' denotes the estimated differences of medians"),p(br()),
  downloadButton("download3.1", "Download Results")
          )

##########----------##########----------##########

)

##---------- 3.2 ----------

wstest.p <- sidebarLayout(

##########----------##########----------##########

  sidebarPanel(

  #h4("Wilcoxon Signed-Rank Test"),
  #helpText("An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution."),

  h4("Hypotheses"),
  tags$b("Null hypothesis"),
  p("m = 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is symmetric around zero."),

  radioButtons("alt.pwsr", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is not symmetric around zero"),
      HTML("m < 0: the population median of Y is greater"),
      HTML("m > 0: the population median of X is greater")),
    choiceValues = list("two.sided", "less", "greater")),

  h4("Correction"),
  radioButtons("nap", label = "Normal Approximation", 
    choices = list("Sample size is not large" = FALSE,
                   "Sample size is moderate large" = TRUE,
                   "Small sample size" = TRUE), selected = FALSE),
  helpText("Normal approximation is applicable when n > 10.")),

  mainPanel(h4('Results of Wilcoxon Signed-Rank Test'), tableOutput("psr.test"), 
    helpText("When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction'"),p(br()),
  downloadButton("download3.2", "Download Results")
    ) 

##########----------##########----------##########

  )

##---------- data ----------
psample <- sidebarLayout(  

##########----------##########----------##########

sidebarPanel(

h4("Data Preparation"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manually input", p(br()),
    helpText("Missing value is input as NA"),
    tags$textarea(id="y1", 
      rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"    
    ),
    tags$textarea(id="y2", 
      rows=10, 
      "0.878\n0.647\n0.598\n2.050\n1.060\n1.290\n1.060\n3.140\n1.290"
      ),
    helpText("Change the names of two samples (optional)"), 
    tags$textarea(id="cn3", rows=2, "Before\nAfter\nAfter-Before")),

  ##-------csv file-------##   
  tabPanel("Upload CSV file", p(br()),
    fileInput('file3', 'Choose CSV file', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', 'Header', TRUE), #p
    radioButtons('sep3', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')
    ) 
  )
),

mainPanel(

  h4("Descriptive Statistics"),

  tabsetPanel(

    tabPanel("Data Display", p(br()),  

      dataTableOutput("table3")),

    tabPanel("Basic descriptives", p(br()), 

      splitLayout(
        tableOutput("bas3"), 
        tableOutput("des3"), 
        tableOutput("nor3")), p(br()),
  downloadButton("download3b", "Download Results")  ),

    tabPanel("Boxplot", p(br()), 

      splitLayout(
        plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),

      wellPanel(
        verbatimTextOutput("info3"), hr(),

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

      plotOutput("makeplot3", width = "800px", height = "400px"),
      sliderInput("bin3", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)
      )
    ))  

##########----------##########----------##########

)
