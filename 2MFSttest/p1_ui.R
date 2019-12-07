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

  p(tags$b("Give a name to your data (No space)")), 

  tags$textarea(id = "cn", rows = 1, "Age"),p(br()),

  tabsetPanel(

    tabPanel("Manual Input", p(br()),

      p(tags$b("Please follow the example to input your data in the box")),

      p(tags$i("Example here is the AGE of 144 independent lymph node positive patients")),

      tags$textarea(
        id = "x", #p
        rows = 10,
        "50\n42\n50\n43\n47\n47\n38\n45\n31\n41\n48\n47\n38\n44\n36\n42\n42\n45\n49\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n48\n36\n43\n44\n47\n40\n41\n48\n41\n45\n45\n47\n37\n43\n43\n49\n45\n41\n50\n49\n43\n38\n42\n49\n44\n48\n50\n44\n49\n32\n43\n42\n50\n39\n42\n41\n49\n38\n43\n50\n49\n37\n37\n48\n48\n48\n49\n45\n44\n35\n49\n39\n46\n49\n37\n50\n35\n47\n43\n44\n41\n43\n45\n42\n39\n40\n37\n44\n39\n45\n46\n42\n49\n41\n26\n49\n36\n48\n29\n43\n45\n45\n47\n49\n41\n46\n41\n36\n38\n49\n49\n42\n46\n42\n51\n51\n52\n52\n52\n52\n52\n52\n53\n52\n51\n51\n51\n51\n51\n51\n47\n39\n51"
        ),

      p("Missing value is input as NA")
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

  h4(tags$b("Step 2. Choose Hypotheses and Parameters")),

  p(tags$b("Null hypothesis")),
  HTML("&#956 = &#956&#8320: the population mean (&#956) of your data is &#956&#8320"),

  radioButtons(
    "alt",
    label = "Alternative hypothesis",
    choiceNames = list(
      HTML("&#956 &#8800 &#956&#8320: the population mean of your data is not &#956&#8320"),
      HTML("&#956 < &#956&#8320: the population mean of your data is less than &#956&#8320"),
      HTML("&#956 > &#956&#8320: the population mean of your data is greater than &#956&#8320")
      ),
    choiceValues = list("two.sided", "less", "greater")),

 p(tags$b("2. Specified Mean")),
  numericInput('mu', HTML("Specify the mean (&#956&#8320) that you want to compare with your data"), 50), #p

  p(tags$i("In this default settings, we want to know if the age of lymph node positive population is 50 years old."))


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

    tabPanel("Distribution Plots", p(br()),

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
  h4(tags$b("Output 2. Test Results")),p(br()),
  tableOutput("t.test"),


  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population of the data IS significantly different from the specified mean. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population of the data IS NOT significantly different from the specified mean. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we can conclude that the age of lymph node positive population is not significantly different from 50 years old")),

  p(br()),
  downloadButton("download1", "Download Results")



 )

)
