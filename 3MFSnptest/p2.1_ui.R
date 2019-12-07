##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 2
##
## Language: EN
## 
## DT: 2019-01-10
##
##----------#----------#----------#----------
sidebarLayout(  

##########----------##########----------##########

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("Give a name to your data (No space)")), 

  tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),

    p(tags$b("Please follow the example to input your data in the box")),

    p(tags$i("Example here is the Depression Rating Scale factor measurements of 19 patients from a two group of patients.")),

    p(tags$b("Group 1")),
    tags$textarea(id="x1", 
    rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"    
    ),  

    p(tags$b("Group 2")),## disable on chrome
    tags$textarea(id="x2", 
      rows=10, 
      "0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
      ),
    
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error"),

    p(tags$i("In this default settings, we want to know if Depression Rating Scale from two group of patients are different."))
    ),


  ##-------csv file-------##   
tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        fileInput('file2', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header2", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep2", 
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

      dataTableOutput("table2")),

    tabPanel("Basic Descriptives", p(br()), 

        tableOutput("bas2"), 

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
        downloadButton("download2b", "Download Results") ),

    tabPanel("Box-Plot", p(br()), 
        plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),

        verbatimTextOutput("info2"), 
        hr(),
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

      plotOutput("makeplot2", width = "800px", height = "400px"),
      sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>")
      )
    )) 
)