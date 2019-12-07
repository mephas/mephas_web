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


  p(tags$b("Give a name to your data (No space)")), 

  tags$textarea(id="cn", rows= 1, "Scale"),p(br()),

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
        tableOutput("bas"), 
        
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

    tabPanel("Box-Plot", p(br()), 

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
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )
      )
    )
  )
)