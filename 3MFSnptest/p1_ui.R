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

##---------- data ----------
sidebarLayout(  
##########----------##########----------##########
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give a name to your data (Required)")),

  tags$textarea(id="cn", rows= 1, "Scale"), p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual Input", p(br()),

    p(tags$i("Data here was the Depression Rating Scale factor measurements of 9 patients from a certain group of patients. ")),
    
    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),
    tags$textarea(id="a", 
      rows=5, 
      "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
      ),
    
    p("Missing value is input as NA")

    ),

    tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        p(tags$b("This only reads the one column from your data file")),
        fileInput('file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        p(tags$b("2. Show 1st row as column names?")),
        checkboxInput("header", "Yes", TRUE),
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col", "Yes", FALSE),

             # Input: Select separator ----
        radioButtons("sep", 
          "4. Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")

      )
    ),

  hr(),
  h4(tags$b("Step 2. Specify Parameter")),
  numericInput("med", HTML("Specify the median (m&#8320) that you want to compare with your data"), 1),
  p(tags$i("In this default settings, we wanted to know if the group of patients were suffering from depression (Scale > 1).")),
  hr(),

  h4(tags$b("Step 3. Choose Hypothesis")),
  p(tags$b("Null hypothesis")),

  HTML("<p> m = m&#8320: the population median is equal to the specified median( m&#8320) </p>
        <p>Or, the distribution of the data set is symmetric about the specified median</p>"),

  radioButtons("alt.wsr", 
    label = "Alternative hypothesis", selected = "greater",
    choiceNames = list(  
    HTML("m &#8800 m&#8320: the population median of is significantly different from the specified median"),
    HTML("m > m&#8320: the population median of is greater than the specified median"),
    HTML("m < m&#8320: the population median of is less than the specified median")
    ),
  choiceValues = list("two.sided", "greater", "less")),
  hr(),
    p(tags$i("In this default settings, we wanted to know if the group of patients were suffering from depression (Scale > 1).")),

  h4(tags$b("Step 4. Decide P Value method")),
  radioButtons("alt.md", 
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ), 
    choiceValues = list("a", "b", "c")),
    p(tags$i("In this example, we had only 9 people. So we chose exact P value"))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()), 
      DT::DTOutput("table", width = "500px")
      ),

    tabPanel("Basic Descriptives", p(br()), 

        tableOutput("bas"), 
        
        p(br()), 
      downloadButton("download1b", "Download Results")
      ),

    tabPanel("Box-Plot", p(br()), 

        plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),

        verbatimTextOutput("info"), hr(),

          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            
          )
      ),

    tabPanel("Histogram", p(br()), 

      plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      HTML(
          "<b> Explanations </b>
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )
      )
    ),
hr(),
h4(tags$b("Output 2. Test Results")),
    p(tags$b('Results of Wilcoxon Signed-Rank Test')), p(br()), 
    tableOutput("ws.test.t"),

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population median is significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population median is NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we concluded that the scales was significantly greater than 1 (P=0.006), which indicated the patients were suffering from depression.")),


    downloadButton("download1", "Download Results")



  )
)
