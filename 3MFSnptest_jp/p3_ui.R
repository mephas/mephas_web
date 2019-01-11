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
  h4('Results of Sign Test'), 
  tableOutput("psign.test"), 
  helpText("Notes: 'Estimated.d' denotes the estimated differences of medians")
          )
)

##---------- 3.2 ----------

wstest.p <- sidebarLayout(
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
    helpText("When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction'")
    ) )

##---------- data ----------
psample <- sidebarLayout(  

sidebarPanel(

h4("Data Preparation"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manually input", p(br()),
    helpText("Missing value is input as NA"),
    tags$textarea(id="y1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="y2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("Change the names of two samples (optional)"), 
    tags$textarea(id="cn3", rows=2, "X\nY\n(X-Y)")),

  ##-------csv file-------##   
  tabPanel("Upload .csv", p(br()),
    fileInput('file3', 'Choose .csv', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', 'Header', TRUE), #p
    radioButtons('sep3', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')
    ) 
  )
),

mainPanel(

  h4("Data Description"),

  tabsetPanel(

    tabPanel("Data display", p(br()),  

      dataTableOutput("table3")),

    tabPanel("Basic descriptives", p(br()), 

      splitLayout(
        tableOutput("bas3"), 
        tableOutput("des3"), 
        tableOutput("nor3"))  ),

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
    ))  )
