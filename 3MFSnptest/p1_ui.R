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

##########----------##########----------##########
sidebarPanel(

p(tags$b("Hypotheses")),
p(tags$b("Null hypothesis")),

HTML("<p> m = m&#8320: the population median (m) is equal to the specified median ( m&#8320)</p>"),

radioButtons("alt.st", label = "Alternative hypothesis", 
  choiceNames = list(
  HTML("m > m&#8320: the population median of X is greater than the specified median"),
  HTML("m < m&#8320: the population median of X is less than the specified median"),
  HTML("m &#8800 m&#8320: the population median of X is significantly different from the specified median")
  
  ),
choiceValues = list("greater", "less", "two.sided")),
),

  mainPanel(
    h4(tags$b("Output 2.1. Test Results")),p(br()), 
    h4('Results of Sign Test'), p(br()), 
    tableOutput("sign.test"),p(br()), 
    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population median IS significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population median IS NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we can conclude that the scales is significantly greater than 1 (P=0.02), which indicates the patients are suffering from depression.")),

    downloadButton("download1.1", "Download Results")
    )  
##########----------##########----------##########
  )

##---------- Wilcoxon Signed-Rank Test ----------

wstest<-sidebarLayout(

##########----------##########----------##########
sidebarPanel(

p(tags$b("1. Hypotheses")),
p(tags$b("Null hypothesis")),

HTML("<p> m = m&#8320: the population median is equal to the specified median( m&#8320); </p>
  <p>Or, the distribution of the data set is symmetric about the specified median</p>"),

radioButtons("alt.wsr", 
  label = "Alternative hypothesis", 
  choiceNames = list(  
  HTML("m > m&#8320: the population median of is greater than the specified median"),
  HTML("m < m&#8320: the population median of is less than the specified median"),
  HTML("m &#8800 m&#8320: the population median of is significantly different from the specified median")
  ),
choiceValues = list("greater", "less", "two.sided")),

p(tags$b("2. Whether to do Normal Approximation")),
radioButtons("nap.wsr", 
  label = "How large is your sample size", 
  choiceNames = list(
    HTML("Sample size is not large (<10), I want exact P Value. No need to do Normal Approximation"),
    HTML("Sample size is moderate large (>10), then do Normal Approximation")), 
  choiceValues = list(FALSE, TRUE)),
p("Note: Normal Approximation is to apply continuity correction for the p-value and confidence interval.")
),

  mainPanel(
    h4(tags$b("Output 2.2. Test Results")),p(br()), 
    h4('Results of Wilcoxon Signed-Rank Test'), p(br()), 
    tableOutput("ws.test"), p(br()), 

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population median IS significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population median IS NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we can conclude that the scales is significantly greater than 1 (P=0.006), which indicates the patients are suffering from depression.")),


    downloadButton("download1.2", "Download Results")
  )
##########----------##########----------##########
)

##---------- data ----------
onesample<- sidebarLayout(  

##########----------##########----------##########
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual Input", p(br()),
    
    p(tags$b("Please follow the example to input your data in the box")),

    p(tags$i("Example here is the Depression Rating Scale factor measurements of 9 patients from a certain group of patients. Scale > 1 indicates Depression.")),


    tags$textarea(id="a", 
      rows=10, 
      "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
      ),
    
    p("Missing value is input as NA"),

    p(tags$b("You can change the name of your data (No space)")),

    tags$textarea(id="cn", rows= 1, "X")
    ),

    tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        fileInput('file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep", 
          "Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a("Find some example data here",
          href = "https://github.com/mephas/datasets")

      )
    ),

  hr(),
  h4(tags$b("Step 2. Choose Parameter")),
  numericInput("med", HTML("Specify the median (m&#8320) that you want to compare with your data"), 1),
  p(tags$i("In this default settings, we want to know if the group of patients are suffering from depression (m > 1)."))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),  

      dataTableOutput("table")),

    tabPanel("Basic Descriptives", p(br()), 

      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor")),
        HTML(
          "Notes:
          <ul>
            <li> If Skew.2SE > 1, then skewness is significantly different than zero
            <li> If Kurt.2SE > 1, then kurtosis is significantly different than zero
            <li> Normtest.W: the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p: p value the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p < 0.05, then data significantly different from normality
          </ul>"
          ),
        p(br()), 
      downloadButton("download1b", "Download Results")),

    tabPanel("Boxplot", p(br()), 

        plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),

        verbatimTextOutput("info"), hr(),

          HTML(
          "Notes:
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            
          )
      ),

    tabPanel("Histogram", p(br()), 

      plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)
      )
    )
  )
##########----------##########----------##########
)



