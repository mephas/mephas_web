#****************************************************************************************************************************************************3.npp

sidebarLayout(  

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),
  p(tags$b("1. Give names to your data (Required)")), 

  tags$textarea(id="cn3", rows=3, "Before\nAfter\nAfter-Before"), p(br()),


  p(tags$b("2. Input data")),

  tabsetPanel(

  tabPanel("Manual Input", p(br()),
    p(tags$i("Example here was the Depression Rating Scale factor measurements of 9 patients Before and After treatment. ")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Before")),
    tags$textarea(id="y1", 
      rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"    
    ),

    p(tags$b("After")),
    tags$textarea(id="y2", 
      rows=10, 
      "0.88\n0.65\n0.59\n2.05\n1.06\n1.29\n1.06\n3.14\n1.29"
      ),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

),

  ##-------csv file-------##   
  tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads the 2 columns from your data file")),
        fileInput('file3', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
       p(tags$b("2. Show 1st row as header?")),        
        checkboxInput("header3", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col3", "Yes", TRUE),
             # Input: Select separator ----
        radioButtons("sep3", 
          "Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", "\t", ";", " ")
          ),

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")

      )
    ),

  hr(),

  h4(tags$b("Step 2. Choose Hypothesis")),

  p(tags$b("Null hypothesis")),
  HTML("<p>  m = 0: the difference of medians between X and Y is not zero </p> 
        <p>  Or, the distribution of the differences in paired values is symmetric around zero</p> "),

  radioButtons("alt.wsr3", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is not symmetric around zero"),
      HTML("m < 0: the population median of Y is greater"),
      HTML("m > 0: the population median of X is greater")),
    choiceValues = list("two.sided", "less", "greater")),
      p(tags$i("In this example, we wanted to know if there was significant difference on the scale after the treatment. ")),
hr(),

h4(tags$b("Step 3. Decide P Value method")),
radioButtons("alt.md3", 
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

      DT::DTOutput("table3")
      ),

    tabPanel("Basic Descriptives", p(br()), 

        DT::DTOutput("bas3") 
  ),

    tabPanel("Box-Plot of the Difference", p(br()),   

        plotly::plotlyOutput("bp3", width = "80%"),#click = "plot_click3"

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
            HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            ),
      p(tags$b("Histogram")),
      plotly::plotlyOutput("makeplot3", width = "80%"),
      sliderInput("bin3", "The number of bins in histogram",min = 0,max = 100,value = 0),
      p("When the number of bins is 0, plot will use the default number of bins"),
      p(tags$b("Density plot")),
      plotly::plotlyOutput("makeplot3.1", width = "80%")

      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")),p(br()), 
  tags$b('Results of Wilcoxon Signed-Rank Test'), 
    DT::DTOutput("psr.test.t"), 
      HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the Before and After are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the Before and After are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),
  p(tags$i("From the default settings, we concluded no significant difference is found after the treatment. (P=0.46)"))


)
)
