##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 1
##
## Language: EN
##
## DT: 2019-04-07
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  tabsetPanel(

    tabPanel("Manual input", p(br()),

      HTML("Please follow the example to input your data in the box"),

      helpText("Missing value is input as NA"),

      tags$textarea(
        id = "x", #p
        rows = 10,
        "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
        ),

      p(br()),

      p("You can change the name of your data (No space)"),

      tags$textarea(id = "cn", rows = 1, "Name") ), #tabPanel(


    tabPanel("Upload CSV file", p(br()),

        ##-------csv file-------##
        fileInput('file', "Choose CSV file",
                  accept = c("text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),

             # Input: Select separator ----
        radioButtons("sep", "Separator",
                     choices = c(Comma = ',',
                                 Semicolon = ';',
                                 Tab = '\t'),
                     selected = ','),

        a("Find some example data here",
          href = "https://github.com/mephas/datasets")

      )
    ),

hr(),

  h4(tags$b("Step 2. Choose Parameters")),
  numericInput('mu', HTML("Specify the mean (&#956&#8320) that you want to compare with your data"), 7), #p

  h4("Hypotheses"),

  tags$b("Null hypothesis"),
  HTML("&#956 = &#956&#8320: the population mean of your data is &#956&#8320"),

  radioButtons(
    "alt",
    label = "Alternative hypothesis",
    choiceNames = list(
      HTML("&#956 &#8800 &#956&#8320: the population mean of your data is not &#956&#8320"),
      HTML("&#956 < &#956&#8320: the population mean of your data is less than &#956&#8320"),
      HTML("&#956 > &#956&#8320: the population mean of your data is greater than &#956&#8320")
      ),
    choiceValues = list("two.sided", "less", "greater"))

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
        tableOutput("nor")
        ), 

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
        downloadButton("download0", "Download Results")),

    tabPanel("Box-Plot", p(br()),
      
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click1"),
     
        verbatimTextOutput("info1"), 
          HTML(
          "Notes:
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            
          )
        
      ),

    tabPanel("Mean and SD Plot", p(br()),

      plotOutput("meanp", width = "400px", height = "400px")),

    tabPanel("Check the Normality", p(br()),

      plotOutput("makeplot", width = "900px", height = "300px"),
      sliderInput("bin","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),

          HTML(
          "Notes:
          <ul> 
            <li> Normal Q–Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )

      )
  ),

  hr(),
  h4(tags$b("Output 2. Test Results")),
  p(br()),
  tableOutput("t.test"),


  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population of the data IS significantly different from the specified mean
    <li> P Value >= 0.05, then the population of the data IS NOT significantly different from the specified mean
    </ul>"
  ),
  p(br()),
  downloadButton("download1", "Download Results")



 )

)
