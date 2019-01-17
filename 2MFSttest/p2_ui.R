##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 2
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(
  
    h4("Data Preparation"),

    tabsetPanel(
      ##-------input data-------##
      tabPanel(
        "Manual input",
        p(br()),
        helpText("Missing value is input as NA"),
        tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
        ## disable on chrome
        tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

    helpText("Change the names of samples (optinal)"),
    tags$textarea(id = "cn2", rows = 2, "X\nY")
        ),

      ##-------csv file-------##
      tabPanel(
        "Upload CSV file",
        p(br()),
        
        fileInput('file2','Choose CSV file', #p
          accept = c(
            'text/csv',
            'text/comma-separated-values,text/plain',
            '.csv'
            )
          ),
        checkboxInput('header2', 'Header', TRUE), #p
        radioButtons("sep2", "Separator",
                     choices = c(Comma = ',',
                                 Semicolon = ';',
                                 Tab = '\t'),
                     selected = ',')
        )
      ),

    hr(),

    h4("Hypotheses"),

    tags$b("Null hypothesis"),
    HTML("<p> &#956&#8321 = &#956&#8322: X and Y have equal population mean </p>"),
    
    radioButtons("alt.t2", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: the population means of X and Y are not equal"),
        HTML("&#956&#8321 < &#956&#8322: the population means of X is less than Y"),
        HTML("&#956&#8321 > &#956&#8322: the population means of X is greater than Y")
        ),
      choiceValues = list("two.sided", "less", "greater")
      )
    ),

  mainPanel(

    h4("Descriptive Statistics"),

    tabsetPanel(

      tabPanel("Data Display",p(br()), 

        dataTableOutput("table2")),

      tabPanel("Basic Statistics",p(br()), 
        
        splitLayout(
          tableOutput("bas2"),
          tableOutput("des2"),
          tableOutput("nor2")
          )),

      tabPanel("Boxplot",p(br()),     
        splitLayout(
          plotOutput("bp2",width = "400px",height = "400px",click = "plot_click2"),
           
           wellPanel(
              verbatimTextOutput("info2"), 
              hr(),
              
              helpText(
                HTML(
                  "Notes:
                  <ul>
                  <li> Points are simulated and located randomly in the same horizontal line. </li>
                  <li> Outliers will be highlighted in red, if existing. </li>
                  <li> The red outlier may not cover the simulated point. </li>
                  <li> The red outlier only indicates the value in horizontal line.</li>
                  </ul>"
                  )
                )
              )              
           )),

      tabPanel("Mean and SD Plot", p(br()), 

        plotOutput("meanp2", width = "400px", height = "400px")),

      tabPanel("Plots of Normality", p(br()), 

        plotOutput("makeplot2", width = "600px", height = "600px"),
        sliderInput("bin2","The width of bins in histogram",min = 0.01,max = 5,value = 0.2))

      ),

    hr(),
    h4(("Test Results")),
    tableOutput("var.test"),
    helpText("When P value<0.05, please go to the 'Welch Two Sample t-test'"),
    tableOutput("t.test2")
    
    )
  )