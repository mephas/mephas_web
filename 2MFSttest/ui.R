
##--------------------------------------------------
##
## MFSttest ui
##
## 2018-11-28
##
##---------------------------------------------------

shinyUI(

tagList(
#shinythemes::themeSelector(),
navbarPage(
  #theme = shinytheme("cosmo"),
  title = "Tests of Means",

  ## 1. One sample -----------------------------------------------------------------
  tabPanel(
    "One Sample",
    headerPanel("One Sample t-Test"),

    tags$b("Notations"),
    HTML(
      "
      <ul>
      <li> X is the dependent observations </li>
      <li> &#956 is the population mean of X </li>
      <li> &#956&#8320 is the specific mean </li>
      </ul>
      "
      ),

    tags$b("Assumptions"),
    HTML(
      "
      <ul>
      <li> X is numeric and continuous and based on the normal distribution </li>
      <li> Each observation of X (sample) is independent and approximately normally distributed </li>
      <li> The data collection process was random without replacement </li>
      "
      ),

    sidebarLayout(
      sidebarPanel(
        ##----Configuration----
        helpText("Configuration"),
        numericInput('mu', HTML("Specify the mean, &#956&#8320"), 7), #p

        helpText("Hypotheses"),
        tags$b("Null hypothesis"),
        HTML("<p> &#956 = &#956&#8320: the population mean of X is &#956&#8320 </p>"),
        radioButtons(
          "alt.pt", #p
          label = "Alternative hypothesis",
          choiceNames = list(
            HTML("&#956 &#8800 &#956&#8320: the population mean of X is not &#956&#8320"),
            HTML("&#956 < &#956&#8320: the population mean of X is less than &#956&#8320"),
            HTML("&#956 > &#956&#8320: the population mean of X is greater than &#956&#8320")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),
        hr(),

        ##----Import data----##
        helpText("Data import"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "Manually input",
            p(br()),
            helpText("Missing value is input as NA"),
            tags$textarea(
              id = "x", #p
              rows = 10,
              "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
              ),
        helpText("Change the names of sample (optinal)"),
        tags$textarea(id = "cn", rows = 1, "X") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "Upload .csv file",
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
            ) #tabPanel(
          ),

        hr(),
        h4("Data Display"),
        
        dataTableOutput("table"),
        hr(),
        h4("Figure Configuration"),
        sliderInput("bin", "The width of bins in histogram",min = 0.01,max = 5,value = 0.2) #p
        ),

      mainPanel(
        h3(tags$b("Test Results")),
        tableOutput("t.test"), 
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('Descriptive statistics')),
        splitLayout(
          tableOutput("bas"), 
          tableOutput("des"), 
          tableOutput("nor")
          ),
        hr(),
        h3(tags$b("Mean and SD Plot")),
        plotOutput("meanp", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("Boxplot")),
        splitLayout(
          plotOutput(
            "bp",
            width = "400px",
            height = "400px",
            click = "plot_click"
            ),
          wellPanel(
            verbatimTextOutput("info"), 
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
          ),
        hr(),
        h3(tags$b('Plots of normality')),
        plotOutput("makeplot", width = "900px", height = "300px")
        )
      )
    ),
  ##

  ## 2. Two independent samples ---------------------------------------------------------------------------------
  tabPanel(
    "Two Independent Samples",

    headerPanel("Two-Sample t-Test"),

    tags$b("Assumptions"),
    tags$ul(
      tags$li("Each of the two populations being compared should follow the normal distribution"),
      tags$li("X and Y should be sampled independently from the two populations being compared"),
      tags$li("The two populations being compared should have the same variance")
      ),

    tags$b("Notations"),
    HTML(
      "
      <ul>
      <li> The independent observations are designated X and Y</li>
      <li> &#956&#8321 = the population mean of X; &#956&#8322 = the population mean of Y </li>
      </ul>"
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("Hypotheses"),
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
          ),

        hr(),
        # for seperate
        helpText("Two ways to import your data sets"),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "Manually input values",
            p(br()),
            helpText("Missing value is input NA"),
            tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
            ## disable on chrome
            tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

            helpText("Change the names of two samples (optinal)"),
        tags$textarea(id = "cn2", rows = 2, "X\nY")
            ),

          ##-------csv file-------##
          tabPanel(
            "Upload .csv file",
            p(br()),
            fileInput('file2','Choose .csv File', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header2', 'Header', TRUE), #p
            radioButtons('sep2','Separator', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
                ','
              )
            )
          ),
        hr(),
        h4("Data Display"),

        dataTableOutput("table2"),
        hr(),
        h4("Figure Configuration"),
        sliderInput("bin2","The width of bins in histogram",min = 0.01,max = 5,value = 0.2)
        ),

      mainPanel(
        h3(tags$b("Test Results")),
        tableOutput("var.test"),
        helpText("When P value<0.05, please go to the 'Welch Two Sample t-test'"),
        tableOutput("t.test2"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('Descriptive statistics')),
        splitLayout(
          tableOutput("bas2"),
          tableOutput("des2"),
          tableOutput("nor2")
          ),

        hr(),
        h3(tags$b("Mean and SD Plot")),
        plotOutput("meanp2", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("Boxplot")),
        splitLayout(
          plotOutput("bp2",width = "400px",height = "400px",click = "plot_click"),
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
          ),
        hr(),
        h3(tags$b('Plots of normality')),
        plotOutput("makeplot2", width = "600px", height = "600px")
        )
      )
    ),
  ##

  ## 3. Two paried samples ---------------------------------------------------------------------------------
  tabPanel(
    "Two Paired Samples",

    headerPanel("Paired t-Test"),

    helpText("A typical example of the pared sample is that the repeated measurements, where subjects are tested prior to a treatment, say for high blood pressure, and the same subjects are tested again after treatment with a blood-pressure lowering medication"),

    tags$b("Assumption"),
    tags$ul(
      tags$li("The differences of paired samples are approximately normally distributed."),
      tags$li("The differences of paired samples are numeric and continuous and based on the normal distribution"),
      tags$li("The data collection process was random without replacement.")
      ),

    tags$b("Notations"),
    HTML(
      "
      <ul>
      <li> The dependent observations are designated X and Y </li>
      <li> &#916 is the underlying mean differences between X and Y</li>
      </ul>"
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("Hypotheses"),
        tags$b("Null hypothesis"),
        HTML("<p> &#916 = 0: X and Y have equal effect </p>"),
        radioButtons("alt.pt",
          label = "Alternative hypothesis",
          choiceNames = list(
            HTML("&#916 &#8800 0: the population mean of X and Y are not equal"),
            HTML("&#916 < 0: the population mean of X is less than Y"),
            HTML("&#916 > 0: the population mean of X is greater than Y")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),

        hr(),
        helpText("Two ways to import your data sets"),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "Manually input values",
            p(br()),
            

            helpText("Missing value is input NA"),
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
          tabPanel("Upload .csv file",
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
            radioButtons('sep.p','Separator',
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            )
          ),

        hr(),
        h4("Data Display"),
        dataTableOutput("table.p"),
        hr(),
        h4("Figure Configuration"),
        sliderInput("bin.p","The width of bins in histogram",min = 0.01,max = 5,value = 0.2)
        ),

      mainPanel(
        h3(tags$b("Test Results")),
        tableOutput("t.test.p"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('Descriptive statistics')),
        splitLayout(
          tableOutput("bas.p"),
          tableOutput("des.p"),
          tableOutput("nor.p")
          ),

        hr(),
        h3(tags$b("Mean and SD Plot")),
        plotOutput("meanp.p", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("Boxplot of the difference")),
        splitLayout(
          plotOutput("bp.p",width = "400px",height = "400px",click = "plot_click"),
          wellPanel(
            verbatimTextOutput("info.p"), hr(),
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
          ),
        hr(),
        h3(tags$b('Plots of normality of the difference')),
        plotOutput("makeplot.p", width = "900px", height = "300px")
        )
      )
    )
    ##
,
  tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "Close window")
),
tabPanel(
     tags$button(
     id = 'close',
     type = "button",
     class = "btn action-button",

  )
)
)

