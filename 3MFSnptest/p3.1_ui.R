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
sidebarLayout(  

##########----------##########----------##########

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual Input", p(br()),
    p(tags$b("Please follow the example to input your data in the box")),

    p(tags$i("Example here is the Depression Rating Scale factor measurements of 9 patients Before and After treatment. ")),

    p(tags$b("Before")),
    tags$textarea(id="y1", 
      rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"    
    ),

    p(tags$b("After")),
    tags$textarea(id="y2", 
      rows=10, 
      "0.878\n0.647\n0.598\n2.050\n1.060\n1.290\n1.060\n3.140\n1.290"
      ),

    p("Missing value is input as NA"),

    p(tags$b("You can change the name of your data (No space)")),

    tags$textarea(id="cn3", rows=2, "Before\nAfter\nAfter-Before")),

  ##-------csv file-------##   
  tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        fileInput('file3', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header3", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep3", 
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
    )
  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),  

      dataTableOutput("table3")),

    tabPanel("Basic Descriptives", p(br()), 

      tags$b("Basic Descriptives of the Difference"),



        tableOutput("bas3"), 
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
  downloadButton("download3b", "Download Results")  ),

    tabPanel("Box-Plot of the Difference", p(br()),   

        plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),

        verbatimTextOutput("info3"), hr(),

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

      plotOutput("makeplot3", width = "800px", height = "400px"),
      sliderInput("bin3", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
            HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )
      )
    ))  

)
