##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 3
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(
        
  h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("You can change the name of your data (No space)")),
    
    tags$textarea(id = "cn.p", rows = 3, "Before\nAfter\nAfter-Before"), p(br()),

  tabsetPanel(
          ##-------input data-------##
    tabPanel("Manual Input", p(br()),
        p(tags$i("Example here was the HOUR of sleep effected by a certain drug. Sleeping hours before and after taking the drug were recorded")),

    p(tags$b("Please follow the example to input your data")),

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
            
    fileInput('file.p', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header.p", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep.p", 
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

            dataTableOutput("table.p")),

    tabPanel("Basic Descriptives", p(br()),

      tags$b("Basic Descriptives of the Difference"),
            
              tableOutput("bas.p"),

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
      downloadButton("download5", "Download Results")
            ),

      tabPanel("Boxplot of the difference", p(br()), 
        
       plotOutput("bp.p",width = "400px",height = "400px",click = "plot_click3"),
          
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


          tabPanel("Mean and SD Plot", p(br()), 

            plotOutput("meanp.p", width = "400px", height = "400px")),

    tabPanel("Distribution Plots", p(br()),

            plotOutput("makeplot.p", width = "900px", height = "300px"),
            sliderInput("bin.p","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
            HTML(
          "Notes:
          <ul> 
            <li> Normal Q–Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the difference
          </ul>"
            )
            )
          ),

          hr(),
    h4(tags$b("Output 2. Test Results")),p(br()), 
          tableOutput("t.test.p"),p(br()), 

            HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Group 1 (Before) and Group 2 (After) have significantly unequal effect. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant difference between 2 groups. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we concluded that the drug has no significant effect on the sleep hour. (P=0.2)")),

  downloadButton("download6", "Download Results")
        )
      )