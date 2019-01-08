##----------#----------#----------#----------
##
## 2MFSttest UI
##
##    >Panel 1
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

sidebarLayout(
  sidebarPanel(
    ##----Configuration----
    h4(tags$b("Configuration")),
    numericInput('mu', HTML("Specify the mean, &#956&#8320"), 7), #p

    h4(tags$b("Hypotheses")),
    tags$b("Null hypothesis"),
    HTML("<p> &#956 = &#956&#8320: the population mean of X is &#956&#8320 </p>"),
    
    radioButtons(
      "alt", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("&#956 &#8800 &#956&#8320: the population mean of X is not &#956&#8320"),
        HTML("&#956 < &#956&#8320: the population mean of X is less than &#956&#8320"),
        HTML("&#956 > &#956&#8320: the population mean of X is greater than &#956&#8320")
        ),
      choiceValues = list("two.sided", "less", "greater")
      ),
    hr(),
   
    h4(tags$b("Data Preparation")),

    tabsetPanel(
    
      tabPanel(
        "Manual input",
        p(br()),
        helpText("Missing value is input as NA"),
        tags$textarea(
          id = "x", #p
          rows = 10,
          "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
          ),
    helpText("Change the name of sample (optinal)"),
    tags$textarea(id = "cn", rows = 1, "X") #p
        ), #tabPanel(

      ##-------csv file-------##
      tabPanel(
        "Upload .csv",
        p(br()),
        fileInput(
          'file', 'Choose .csv File', #p
          accept = c(
            'text/csv',
            'text/comma-separated-values,text/plain',
            '.csv'
            )
          ),
        checkboxInput('header', 'Header', TRUE), #p
        radioButtons('sep', 'Separator', #p
          c(
            Comma = ',',
            Semicolon = ';',
            Tab = '\t'
            ),
          ','
          )
        ) 
      )
    ),

mainPanel(

  h4(tags$b("Test Results")),
  tableOutput("t.test"), 

  hr(),
  h4(tags$b("Data Description")),

  tabsetPanel(

    tabPanel("Data display", p(br()),  dataTableOutput("table")),

    tabPanel("Basic descriptives", p(br()), 
      splitLayout(
        tableOutput("bas"), 
        tableOutput("des"), 
        tableOutput("nor")
      )),

    tabPanel("Boxplot", p(br()), 
      splitLayout(
        plotOutput("bp", width = "400px", height = "400px", click = "plot_click1"),
      wellPanel(
        verbatimTextOutput("info1"), 
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

    tabPanel("Mean and SD plot", p(br()), plotOutput("meanp", width = "400px", height = "400px")),

    tabPanel("Plots of normality", p(br()), plotOutput("makeplot", width = "900px", height = "300px"), 
      sliderInput("bin","The width of bins in histogram",min = 0.01,max = 5,value = 0.2))
  )
 )
)