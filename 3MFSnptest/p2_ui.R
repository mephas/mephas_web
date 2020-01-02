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

  p(tags$b("1. Give names to your data (Required)")), 

  tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),
    p(tags$i("Example here was the Depression Rating Scale factor measurements of 19 patients from a two group of patients.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
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
          choiceValues = list(",", "\t", ";", " ")
          ),

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
        )
        ),

  hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

    p(tags$b("Null hypothesis")),

    HTML("<p> m&#8321 = m&#8322: the medians of two group are equal </p>
          <p> Or, the distribution of values for each group are equal </p>"),

radioButtons("alt.wsr2", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of Group 2 is greater"),
    HTML("m&#8321 > m&#8322: the population median of Group 1 is greater")),
  choiceValues = list("two.sided", "less", "greater")),
    p(tags$i("In this default settings, we wanted to know if Depression Rating Scale from two group of patients were different.")),
    hr(),


  h4(tags$b("Step 3. Decide P Value method")),
  radioButtons("alt.md2", 
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ), 
    choiceValues = list("a", "b", "c")),
      p(tags$i("The sample sizes in each group were 9 and 10, so we used exact p value."))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table2")
      ),

    tabPanel("Basic Descriptives", p(br()), 

        DT::DTOutput("bas2")#, 

      #p(br()), 
      #  downloadButton("download2b", "Download Results") 
      ),

    tabPanel("Box-Plot", p(br()), 
        plotOutput("bp2", width = "600px", height = "400px", click = "plot_click2"),

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
    ),
  hr(),

  h4(tags$b("Output 2. Test Results")),
  tags$b('Results of Wilcoxon Rank-Sum Test'), p(br()), 

  DT::DTOutput("mwu.test.t"), p(br()),

  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population medians of 2 groups are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, no significant differences between the medians of 2 groups. (Accept null hypothesis)
    </ul>"
  ),

    p(tags$i("From the default settings, we concluded that there was no significant differences in 2 groups Rating scale (P=0.44)."))#,


 # downloadButton("download2.1", "Download Results")

  ) 
)
