#****************************************************************************************************************************************************3.tp

sidebarLayout(

sidebarPanel(
        
  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your groups (Required)")),
    
    tags$textarea(id = "cn.p", rows = 3, "Before\nAfter\nAfter-Before"), p(br()),

    p(tags$b("2. Input data")),

  tabsetPanel(
          ##-------input data-------##
    tabPanel("Manual Input", p(br()),
        p(tags$i("Example here was the HOUR of sleep effected by a certain drug. Sleeping hours before and after taking the drug were recorded")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
          p(tags$b("Before")),
            tags$textarea(id = "x1.p",rows = 10,
              "0.6\n3\n4.7\n5.5\n6.2\n3.2\n2.5\n2.8\n1.1\n2.9"
              ),
           p(tags$b("After")),
            tags$textarea(id = "x2.p",rows = 10,
              "1.3\n1.4\n4.5\n4.3\n6.1\n6.6\n6.2\n3.6\n1.1\n4.9"
              ),
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

),

          ##-------csv file-------##
    tabPanel("Upload Data", p(br()),
    p(tags$b("This only reads the 2 columns from your data file")),
    fileInput('file.p', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header.p", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col.p", "Yes", TRUE),
             # Input: Select separator ----
        radioButtons("sep.p", 
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

        tags$b("Null hypothesis"),
        HTML("<p> &#916 = 0: Group 1 (Before) and Group 2 (After) have equal effect </p>"),
        
        radioButtons(
          "alt.pt",
          label = "Alternative hypothesis",
          choiceNames = list(
            HTML("&#916 &#8800 0: Group 1 (Before) and Group 2 (After) have unequal effect"),
            HTML("&#916 < 0: Group 2 (After) is worse than Group 1 (Before)"),
            HTML("&#916 > 0: Group 2 (After) is better than Group 1 (Before)")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),
       p(tags$i("In this default settings, we wanted to know if the drug has effect. 
        Or, if sleep HOUR changed after they take the drug. "))

        ),

      mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

        tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table.p")),

    tabPanel("Basic Descriptives", p(br()),

      tags$b("Basic Descriptives of the Difference"),
            
              DT::DTOutput("bas.p")
            ),

      tabPanel("Boxplot of the difference", p(br()), 
        
       plotly::plotlyOutput("bp.p",width = "80%"),#,click = "plot_click3"
          
       #verbatimTextOutput("info3"), hr(),
            
          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            )        
         ),

          tabPanel("Mean and SD Plot", p(br()), 

            plotly::plotlyOutput("meanp.p", width = "80%")),

    tabPanel("Distribution Plots", p(br()),

            HTML(
          "<b> Explanations </b>
          <ul> 
            <li> Normal Q–Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the difference
          </ul>"
            ),
            p(tags$b("Normal Q-Q plot")),
            plotly::plotlyOutput("makeplot.p", width = "80%"),
            p(tags$b("Histogram")),
            plotly::plotlyOutput("makeplot.p2", width = "80%"),
            sliderInput("bin.p","The number of bins in histogram",min = 0,max = 100,value = 0),
            p("When the number of bins is 0, plot will use the default number of bins"),
            p(tags$b("Density plot")),
            plotly::plotlyOutput("makeplot.p3", width = "80%")
            
            )
          ),

          hr(),
    h4(tags$b("Output 2. Test Results")),p(br()), 
          DT::DTOutput("t.test.p"),p(br()), 

            HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Group 1 (Before) and Group 2 (After) have significantly unequal effect. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant difference between 2 groups. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we concluded that the drug has no significant effect on the sleep hour. (P=0.2)"))
        )
      )