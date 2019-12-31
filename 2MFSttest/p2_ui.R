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
    
  p(tags$b("1. Give names to your groups (Required)")),

  tags$textarea(id = "cn2", rows = 2, "Age.positive\nAge.negative"), p(br()),

    p(tags$b("2. Input data")),

    tabsetPanel(
      ##-------input data-------##
      tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the AGE of 27 lymph node positive patients with Estrogen receptor (ER) positive (Group.1-Age.positive); and 117 patients with ER negative (Group.2-Age.negative)")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),

        p(tags$b("Group 1")),
        tags$textarea(id = "x1",rows = 10,
"47\n45\n31\n38\n44\n49\n48\n44\n47\n45\n37\n43\n49\n32\n41\n38\n37\n44\n45\n46\n26\n49\n48\n45\n46\n52\n51\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA"        
),
        p(tags$b("Group 2")),
        tags$textarea(id = "x2",rows = 10,
"50\n42\n50\n43\n47\n38\n41\n48\n47\n36\n42\n42\n45\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n36\n43\n40\n41\n48\n41\n45\n47\n43\n43\n49\n45\n41\n50\n49\n38\n42\n44\n48\n50\n44\n49\n43\n42\n50\n39\n42\n49\n43\n50\n49\n37\n48\n48\n48\n49\n45\n44\n35\n49\n39\n46\n49\n37\n50\n35\n47\n43\n41\n43\n42\n39\n40\n37\n44\n39\n45\n42\n49\n41\n36\n29\n43\n45\n47\n49\n41\n41\n36\n38\n49\n49\n42\n46\n42\n51\n51\n52\n52\n52\n52\n52\n53\n52\n51\n51\n51\n51\n51\n47\n39\n51"
        ),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),

      ##-------csv file-------##
    tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        p(tags$b("This only reads 2 columns form your data file")),
        fileInput('file2', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header2", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names?")),
        checkboxInput("col2", "Yes", TRUE),

             # Input: Select separator ----
        radioButtons("sep2", 
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

  h4(tags$b("Choose Hypothesis")),

  h4(tags$b("Step 2. Equivalence of Variance")),
  p("Before doing T test, we need to check the equivalence of variance and then decide which T test to use"),
  p(tags$b("Null hypothesis")),
  HTML("<p> v1 = v2: Group 1 and Group 2 have equal population variances </p>"),
    
    radioButtons("alt.t22", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("v1 &#8800 v2: the population variances of Group 1 and Group 2 are not equal"),
        HTML("v1 < v2: the population　variances of Group 1 is less than Group 2"),
        HTML("v1 > v2: the population　variances of Group 1 is greater than Group 2")
        ),
      choiceValues = list("two.sided", "less", "greater")),
    hr(),

  h4(tags$b("Step 3. T Test")),

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

      p(tags$i("In this default settings, we wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative"))


    ),

  mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::dataTableOutput("table2", width = "500px")),

    tabPanel("Basic Descriptives", p(br()),
          
          tableOutput("bas2"),

         p(br()), 
        downloadButton("download3", "Download Results")
      ),

      tabPanel("Box-Plot",p(br()),     
        
      plotOutput("bp2",width = "500px",height = "400px",click = "plot_click2"),
           
        verbatimTextOutput("info2"), 
        hr(),
        
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

        plotOutput("meanp2", width = "500px", height = "400px")),

    tabPanel("Distribution Plots", p(br()),

        plotOutput("makeplot2", width = "800px", height = "800px"),
        sliderInput("bin2","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
         HTML(
          "<b> Explanations </b>
          <ul> 
            <li> Normal Q–Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )
         )

      ),

    hr(),
    h4(tags$b("Output 2. Test Result 1")),

    tags$b("Check the equivalence of 2 variances"),

    tableOutput("var.test"),

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P value < 0.05, then refer to the <b>Welch Two-Sample t-test</b>
    <li> P Value >= 0.05, then refer to <b>Two-Sample t-test</b>
    </ul>"
  ),


    p(tags$i("In this example, P value of F test was about 0.11 (>0.05), we should refer to the results from 'Two-Sample t-test'")),

    hr(),
    h4(tags$b("Output 3. Test Result 2")),

    tags$b("Decide the T Test"),

    tableOutput("t.test2"),
    p(br()), 

      HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population means of the Group 1 IS significantly different from Group 2. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences between Group 1 and Group 2. (Accept null hypothesis) 
    </ul>"
  ),

    p(tags$i("In this example, we concluded that the age of lymph node positive population with ER positive was not significantly different from ER negative (P=0.24, from 'Two-Sample t-test')")),


    downloadButton("download2", "Download Results of Variance Test"),
    downloadButton("download4", "Download Results of T Test")
    
    )
  )