##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 2
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
      ##-------input data-------##
      tabPanel("Manual Input", p(br()),

        p(tags$b("Please follow the example to input 2 sets of data in the box")),

        p(tags$i("Example here is the AGE of 27 lymph node positive patients with Estrogen receptor (ER) positive (Group.1-Age.positive); and 117 patients with ER negative (Group.2-Age.negative)")),


        tags$textarea(id = "x1",rows = 10,
"47\n45\n31\n38\n44\n49\n48\n44\n47\n45\n37\n43\n49\n32\n41\n38\n37\n44\n45\n46\n26\n49\n48\n45\n46\n52\n51\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA"        
),
        ## disable on chrome
        tags$textarea(id = "x2",rows = 10,
"50\n42\n50\n43\n47\n38\n41\n48\n47\n36\n42\n42\n45\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n36\n43\n40\n41\n48\n41\n45\n47\n43\n43\n49\n45\n41\n50\n49\n38\n42\n44\n48\n50\n44\n49\n43\n42\n50\n39\n42\n49\n43\n50\n49\n37\n48\n48\n48\n49\n45\n44\n35\n49\n39\n46\n49\n37\n50\n35\n47\n43\n41\n43\n42\n39\n40\n37\n44\n39\n45\n42\n49\n41\n36\n29\n43\n45\n47\n49\n41\n41\n36\n38\n49\n49\n42\n46\n42\n51\n51\n52\n52\n52\n52\n52\n53\n52\n51\n51\n51\n51\n51\n47\n39\n51"
        ),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error"),

    p(br()),
    

    p(tags$b("You can change the name of your data (No space)")),

    tags$textarea(id = "cn2", rows = 2, "Age.positive\nAge.negative")
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
        ),

    hr(),

  h4(tags$b("Step 2. Choose Hypotheses")),

  p(tags$b("1. Hypotheses")),
  p(tags$b("Null hypothesis")),
  HTML("<p> &#956&#8321 = &#956&#8322: Group 1 and Group 2 have equal population mean </p>"),
    
    radioButtons("alt.t2", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: the population means of Group 1 and Group 2 are not equal"),
        HTML("&#956&#8321 < &#956&#8322: the population means of Group 1 is less than Group 2"),
        HTML("&#956&#8321 > &#956&#8322: the population means of Group 1 is greater than Group 2")
        ),
      choiceValues = list("two.sided", "less", "greater")),

      p(tags$i("In this default settings, we want to know if the ages of patients with ER positive is significantly different from patients with ER negative"))


    ),

  mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),

        dataTableOutput("table2")),

    tabPanel("Basic Descriptives", p(br()),
        
        splitLayout(
          tableOutput("bas2"),
          tableOutput("des2"),
          tableOutput("nor2")
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
        downloadButton("download3", "Download Results")
      ),

      tabPanel("Box-Plot",p(br()),     
        
      plotOutput("bp2",width = "400px",height = "400px",click = "plot_click2"),
           
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

      tabPanel("Mean and SD Plot", p(br()), 

        plotOutput("meanp2", width = "400px", height = "400px")),

    tabPanel("Distribution Plots", p(br()),

        plotOutput("makeplot2", width = "600px", height = "600px"),
        sliderInput("bin2","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
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

    tags$b("1. Check the equivalence of 2 variances"),

    tableOutput("var.test"),

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P value < 0.05, then refer to the 'Welch Two-Sample t-test'
    <li> P Value >= 0.05, then refer to 'Two-Sample t-test'
    </ul>"
  ),


    p(tags$i("From the default settings, P value of F test is about 0.11 (>0.05), we should refer to the results from 'Two-Sample t-test'")),

    tags$b("2. Decide the test"),


    tableOutput("t.test2"),
    p(br()), 

      HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population means of the Group 1 IS significantly different from Group 2. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences between Group 1 and Group 2. (Accept null hypothesis) 
    </ul>"
  ),

    p(tags$i("From the default settings, we can conclude that the age of lymph node positive population with ER positive is not significantly different from ER negative (P=0.24, from 'Two-Sample t-test')")),


    downloadButton("download2", "Download Results of Variance Test"),
    downloadButton("download4", "Download Results of T Test")
    
    )
  )