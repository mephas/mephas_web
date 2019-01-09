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
        
        h4(tags$b("Data Preparation")),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "Manual input",
            p(br()),
            helpText("Missing value is input as NA"),
            tags$textarea(id = "x1.p",rows = 10,
              "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
              ),
            ## disable on chrome
            tags$textarea(id = "x2.p",rows = 10,
              "6.6\n6.9\n6.7\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"
              ),
            helpText("Change the names of two samples (optinal)"),
            tags$textarea(id = "cn.p", rows = 2, "X\nY\n(X-Y)")

            ),

          ##-------csv file-------##
          tabPanel("Upload .csv",
            p(br()),
            
            fileInput(
              'file.p',
              'Choose .csv File',
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
              )
            ),
            checkboxInput('header.p', 'Header', TRUE), #p
       
            radioButtons("sep.p", "Separator",
                         choices = c(Comma = ',',
                                     Semicolon = ';',
                                     Tab = '\t'),
                         selected = ',')
            )
          ),

        hr(),

        h4("Hypotheses"),

        tags$b("Null hypothesis"),
        HTML("<p> &#916 = 0: X and Y have equal effect </p>"),
        
        radioButtons(
          "alt.pt",
          label = "Alternative hypothesis",
          choiceNames = list(
            HTML("&#916 &#8800 0: the population mean of X and Y are not equal"),
            HTML("&#916 < 0: the population mean of X is less than Y"),
            HTML("&#916 > 0: the population mean of X is greater than Y")
            ),
          choiceValues = list("two.sided", "less", "greater")
          )

        ),

      mainPanel(

        h4('Data Description'),

        tabsetPanel(

          tabPanel("Data display", p(br()),  

            dataTableOutput("table.p")),

          tabPanel("Basic descriptives", p(br()), 
            
            splitLayout(
              tableOutput("bas.p"),
              tableOutput("des.p"),
              tableOutput("nor.p")
              )
            ),

          tabPanel("Boxplot of the difference", p(br()), 
            splitLayout(
              plotOutput("bp.p",width = "400px",height = "400px",click = "plot_click3"),
          
          wellPanel(
            verbatimTextOutput("info3"), hr(),
            
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
          )
          ),

          tabPanel("Mean and SD plot", p(br()), 

            plotOutput("meanp.p", width = "400px", height = "400px")),

          tabPanel("Plots of normality", p(br()), 

            plotOutput("makeplot.p", width = "900px", height = "300px"),
            sliderInput("bin.p","The width of bins in histogram",min = 0.01,max = 5,value = 0.2)
            )
          ),

          hr(),
          h4("Test Results"),
          tableOutput("t.test.p")
        )
      )