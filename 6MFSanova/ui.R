##----------#----------#----------#----------
##
## 6MFSanova UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------
shinyUI(

tagList(
# shinythemes::themeSelector(),
navbarPage(
  #theme = shinytheme("cosmo"),
  title = "Analysis of variance",

  ## 2. One way anova ---------------------------------------------------------------------------------
  tabPanel(
    "One-way",

    headerPanel("One-way ANOVA"),

    tags$b("Assumption"),
    tags$ul(
      tags$li("The differences of samples are numeric and continuous and based on the normal distribution"),
      tags$li("The data collection process was random without replacement."),
      tags$li("The samples are from the populations with same vairances.")
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("Hypotheses"),
        tags$b("Null hypothesis"),
        HTML("<p>All group means are equal</p>"),
        tags$b("Alternative hypothesis"),
        HTML("<p>At least two of the group means are not the same</p>"),
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
              id = "x1", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            
            helpText("The factor"),
            tags$textarea(
              id = "f11", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),

        helpText("Change the names of sample (optinal)"),
        tags$textarea(id = "cn1", rows = 2, "X\nA")),

                    ##-------csv file-------##
          tabPanel(
            "Upload .csv file",
            p(br()),
            fileInput(
              'file1', 'Choose .csv File', #p
                accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header1', 'Header', TRUE), #p
            radioButtons('sep1', 'Separator', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ))
          ),

        hr(),
        h4("Data Display"),
        dataTableOutput("table1")),

      mainPanel(
        h3(tags$b("Test Results")),
        tableOutput("anova1"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('Descriptive statistics')),
        verbatimTextOutput("bas1"),

        hr(),
        h3(tags$b("Marginal means plot")),
        plotOutput("mmean1", width = "500px", height = "300px")


        )

      )
    ),

 ## 2. two way anova ---------------------------------------------------------------------------------
  tabPanel(
    "Two-way",

    headerPanel("Two-way ANOVA"),

    tags$b("Assumption"),
    tags$ul(
      tags$li("The populations from which the samples were obtained are normally or approximately normally distributed."),
      tags$li("The samples are independent."),
      tags$li("The variances of the populations are equal."),
      tags$li("The groups have the same sample size.")

      ),

    sidebarLayout(
      sidebarPanel(
        helpText("Hypotheses"),
        tags$b("Null hypothesis 1"),
        HTML("<p>The population means of the first factor are equal. </p>"),
        tags$b("Null hypothesis 2"),
        HTML("<p>The population means of the second factor are equal.</p>"),
        tags$b("Null hypothesis 3"),
        HTML("<p>There is no interaction between the two factors.</p>"),
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
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            splitLayout(
            helpText("The first factor"),
            tags$textarea(
              id = "f1", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),
            helpText("The second factor"),
            tags$textarea(
              id = "f2", #p
              rows = 10,
              "T1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT1\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2\nT2"
              )),
            
        helpText("Change the names of sample (optinal)"),
        tags$textarea(id = "cn", rows = 3, "X\nA\nB") #p
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
            )),

        hr(),
        h4("Data Display"),
        dataTableOutput("table")),


      mainPanel(
        h3(tags$b("Test Results")),
        checkboxInput('inter', 'Interaction', TRUE), #p
        tableOutput("anova"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('Descriptive statistics')),
          numericInput("grp", 'Choose the factor in the Data Display column', 2, 2, 3, 1),
          verbatimTextOutput("bas"),

        hr(),
        h3(tags$b("Means plot")),
        checkboxInput('tick', 'Untick to change the group and x-axis', TRUE), #p
        plotOutput("meanp.a", width = "500px", height = "300px"),

        hr(),
        h3(tags$b("Marginal means plot")),
        checkboxInput('tick2', 'Untick to change the x-axis', TRUE), #p
        plotOutput("mmean.a", width = "500px", height = "300px")
        )
      )
    ), ##

  ## 3. multiple comparision ---------------------------------------------------------------------------------
  tabPanel(
    "Multiple comparison",
    headerPanel("Multiple Comparison"),

    tags$b("Assumption"),
    tags$ul(
      tags$li("Significant effects have been found when there are three or more levels of a factor"),
      tags$li("After an ANOVA, the means of your response variable may differ significantly across the factor, but it is unkown which pairs of the factor levels are significantly different from each other")
      ),

    sidebarLayout(

        sidebarPanel(
        helpText("Hypotheses"),
        tags$b("Null hypothesis"),
        HTML("<p>The population means of the factor are equal. </p>"),
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
              id = "xm", #p
              rows = 10,
              "0.55\n3.22\n1.08\n1.99\n0.93\n2.98\n2.93\n2.41\n1.98\n1.94\n2.27\n2.69\n2.23\n3.87\n1.43\n3.6\n1.51\n1.7\n2.79\n2.96\n4.67\n5.37\n1.77\n3.52\n5.62\n4.22\n3.33\n3.91\n4.85\n3.4"
              ),
            p(br()),
            helpText("The factor"),
            tags$textarea(
              id = "fm", #p
              rows = 10,
              "A1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3\nA1\nA2\nA3"
              ),

        helpText("Change the names of sample (optinal)"),
        tags$textarea(id = "cnm", rows = 2, "X\nA") #p
            ),
        
         ##-------csv file-------##
          tabPanel(
            "Upload .csv file",
            p(br()),
            fileInput(
              'filem', 'Choose .csv File', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('headerm', 'Header', TRUE), #p
            radioButtons('sepm', 'Separator', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              ) 
          )),

        hr(),
        h4("Data Display"),
        
        dataTableOutput("tablem")),

       mainPanel(
        h3(tags$b("Test Results")),
        h3("Pairwise t-test"),

        radioButtons("method", "Method", 
          c(Bonferroni = 'bonferroni',
            Holm = 'holm',
            Hochberg = 'hochberg',
            Hommel = 'hommel',
            FDR_Benjamini_Hochberg = 'BH',
            Benjamini_Yekutieli = 'BY'
            ), 
          "bonferroni"),
        verbatimTextOutput("multiple"),

        hr(),
        h3("Tukey Honest Significant Differences"),
        verbatimTextOutput("hsd")
        )
      ) 
  ),

 
##----------

tabPanel((a("Home",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/")))),

tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "Stop App"))




)))

