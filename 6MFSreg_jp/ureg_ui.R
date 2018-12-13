##----------------------------------------------------------------
##
## The univariate regression models: lm, logistic model, cox model
## 
## DT: 2018-4-5
##----------------------------------------------------------------
ui <- shinyUI(

tagList(
#shinythemes::themeSelector(),
    ##model
navbarPage(
  title = "Regression Model (NRow > NColumn)",

# 1. LM regression
  tabPanel("Linear Regression (Continuous Outcomes)",

    titlePanel("Linear Regression"),

    sidebarLayout(

      sidebarPanel(

      ## 1. input data
        h4(tags$b("Input Data")),

        ##>>----------csv file--------->> 
        # Input: Select a file ----
        fileInput("file", "Upload .csv data set",
                  multiple = TRUE,
                  accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
        helpText("If no data is uploaded, the example data (mtcars) is being shown."),
         # Input: Checkbox if file has header ----
        checkboxInput("header", "Header", TRUE),

        fluidRow(

          column(4, 
             # Input: Select separator ----
            radioButtons("sep", "Separator",
                         choices = c(Comma = ",",
                                     Semicolon = ";",
                                     Tab = "\t"),
                         selected = ",")),

          column(4,
            # Input: Select quotes ----
            radioButtons("quote", "Quote",
                         choices = c(None = "",
                                     "Double Quote" = '"',
                                     "Single Quote" = "'"),
                         selected = '"'))
          ),
        hr(),
  ##<<-----------------------------<<

  ##>>---------lm formula---------->>
        h4(tags$b("Choose variables to build the model")),      
        uiOutput('y'),    
        uiOutput('x'),
        uiOutput('fx'),
        radioButtons("intercept", "Intercept", ##> intercept or not
                     choices = c("Remove Intercept" = "-1",
                                 "Keep intercept" = ""),
                     selected = "-1"),
        h5("Additional terms (confounding or interaction)"), 
        helpText("Start with '+'. For interactive term, please type + as.factor(cyl):wt"), 
        tags$textarea(id='conf', cols=40, " " ), 
        p(br()),
        actionButton("F", "First: Create formula"),
        verbatimTextOutput("formula"),
        helpText("'-1' indicates to remove intercept"),
        hr(),

  ##-------Basic Plot -------## 

        h4(tags$b("Exploration of Variables")),  
        tags$b("1. Scatter plot between X and Y"),     
        fluidRow(
          column(6, uiOutput('ty')),
          column(6, uiOutput('tx'))),
        plotOutput("p1", width = "400px", height = "400px"),

        p(br()), 
        tags$b("2. Histogram"),
        uiOutput('hx'),
        plotOutput("p3", width = "400px", height = "400px"),
        sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 50, value = 0.7)
        ),

      mainPanel(
        h4(tags$b("Outputs")),
        tags$b("1. Data Display"), 
        dataTableOutput("table"), 
        tags$b("2. Basic Descriptives"), 
        helpText("Select the variables for descriptives"),

        tabsetPanel(
          tabPanel("Continuous variables",
            uiOutput('cv'),
            actionButton("Bc", "Submit"),
            tableOutput("sum")
            ),
          tabPanel("Discrete variables",
            uiOutput('dv'),
            actionButton("Bd", "Submit"),
            verbatimTextOutput("fsum")
            )
          ),

        hr(),
        h4(tags$b("Models")),

        tabsetPanel(
          tabPanel("Estimation", 
            p(br()),
            actionButton("B1", "Submit after the display of formula"),
            p(br()),
            tags$b("1. Regression Fitting"),
            htmlOutput("fit"), 
            p(br()),
            tags$b("2. ANOVA Table"), 
            tableOutput("anova")
            ),
          tabPanel("Diagnostics", 
            p(br()),
            tags$b("1. Diagnostic Plots"), 
            radioButtons("num", "Choose plot",
               choices = c("Residuals vs fitted plot" = 1,
                           "Normal Q-Q" = 2,
                           "Scale-Location" = 3,
                           "Cook's distance" = 4,
                           "Residuals vs Leverage" = 5),
               selected = 1),
            plotOutput("p2", width = "400px", height = "400px"),
            tags$b("2. Estimated Fitting Values"), 
            dataTableOutput("fitdt0")
            ),
        tabPanel("Prediction", 
          p(br()),
        #prediction part
          ##-------csv file for prediction -------##   
        # Input: Select a file ----
          fileInput("newfile", "Upload new .csv data set",
                    multiple = TRUE,
                    accept = c("text/csv",
                             "text/comma-separated-values,text/plain",
                             ".csv")),
          helpText("If no data is uploaded, the example testing data (mtcars) is being shown."),
           # Input: Checkbox if file has header ----
          checkboxInput("newheader", "Header", TRUE),

          fluidRow(
            column(3, 
               # Input: Select separator ----
              radioButtons("newsep", "Separator",
                 choices = c(Comma = ",",
                             Semicolon = ";",
                             Tab = "\t"),
                 selected = ",")),

            column(3,
              # Input: Select quotes ----
              radioButtons("newquote", "Quote",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"')),
            column(3,
             # prediction type
              radioButtons("interval", "Choose predictive interval (0.95-level)",
                 choices = c(
                             "Confidence Interval" = "confidence",
                             "Prediction Interval" = "prediction"),
                 selected = 'confidence'))
            ), ##fluidRow(

          actionButton("B2", "Submit after the estimation of model"), 
          p(br()),
          tags$b("1. Data display with prediction results"), 
          p(br()),
          dataTableOutput("pred"),
          p(br()),
          tags$b("2. Scatter plot of the predicted outcomes"), 
          helpText("Red dash lines are prediction interval; Grey area is confidence interval"), 
          plotOutput("p4", width = "400px", height = "400px"),
          uiOutput('px')
          ) ##tabPanel("Prediction",
        )
      ) ## mainPanel
    ) ## siderbarlayout,
  ), ## tabPanel

##-----------------------------------------------------------------------
## 2. logistic regression---------------------------------------------------------------------------------
  tabPanel("Logistic Regression (1-0 Outcomes)",

    titlePanel("Logistic Regression"),

    sidebarLayout(
      sidebarPanel(

        h4(tags$b("Input Data")),

##-------csv file-------##   
# Input: Select a file ----
        fileInput("file.l", "Upload .csv data set",
                  multiple = TRUE,
                  accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
        helpText("If no data is uploaded, the example data (mtcars) is being shown."),
         # Input: Checkbox if file has header ----
        checkboxInput("header.l", "Header", TRUE),

        fluidRow(

          column(4, 
             # Input: Select separator ----
            radioButtons("sep.l", "Separator",
                         choices = c(Comma = ",",
                                     Semicolon = ";",
                                     Tab = "\t"),
                         selected = ",")),

          column(4,
            # Input: Select quotes ----
            radioButtons("quote.l", "Quote",
                         choices = c(None = "",
                                     "Double Quote" = '"',
                                     "Single Quote" = "'"),
                         selected = '"'))
          ),
        hr(),

##-------lr formula-------## 
        h4(tags$b("Regression Formula")),       
        uiOutput('y.l'),    
        uiOutput('x.l'),
        uiOutput('fx.l'),
# select intercept
        radioButtons("intercept.l", "Intercept",
           choices = c("Remove Intercept" = "-1",
                       "Keep intercept" = ""),
           selected = "-1"),
        h5("Additional terms (confounding or interaction)"), 
        helpText("Start with '+'. For interception term, please type +as.factor(cyl)*wt"), 
        tags$textarea(id='conf.l', column=40, ""), 
        p(br()),
        actionButton("F.l", "First: formula display"),
        verbatimTextOutput("formula.l"),
        helpText("'-1' means no intercept"),
        hr(),

##-------Basic Plot -------## 
        h4(tags$b("Exploration of Variables")),  
        tags$b("1. Box Plot (by group)"),   
        fluidRow(
          column(6, uiOutput('ty.l')),
          column(6, uiOutput('tx.l'))
          ),

        h4(tags$b("")), 
        plotOutput("p1.l", width = "400px", height = "400px"),
        p(br()),

        h4(tags$b("2. Histogram")), 
        uiOutput('hx.l'),
        plotOutput("p3.l", width = "400px", height = "400px"),
        sliderInput("bin.l", "The width of bins in histogram", min = 0.01, max = 5, value = 0.7)

        ), ## sidebarPanel(

      mainPanel(

        h4(tags$b("Outputs")),
        tags$b("1. Data Display"), 
        dataTableOutput("table.l"), 
        tags$b("2. Basic Descriptives"), 
        helpText("Select the variables for descriptives"),

        tabsetPanel(
          tabPanel("Continuous variables",
            uiOutput('cv.l'),
            actionButton("Bc.l", "Submit"),
            tableOutput("sum.l")
            ),
          tabPanel("Discrete variables",
            uiOutput('dv.l'),
            actionButton("Bd.l", "Submit"),
            verbatimTextOutput("fsum.l")
            )
          ),

        hr(),
        h4(tags$b("Models")),
        tabsetPanel(
          
          tabPanel("Estimation", 
            p(br()),
            actionButton("B1.l", "Submit after the display of formula"), 
            p(br()),
            tags$b("1. Regression Fitting"), 
            htmlOutput("fit.l"),
            p(br()),
            tags$b("2. ANOVA Table"),
            tableOutput("anova.l")
            ),

          tabPanel("Diagnostic",
            p(br()),
            tags$b("1. ROC Plot"),

            fluidRow(
              column(6, plotOutput("p2.l", width = "400px", height = "400px")),
              column(6, verbatimTextOutput("auc"))
              ),
            p(br()),
            tags$b("2. Estimated Fitting Values"), 
            dataTableOutput("fitdt")
            ),

          tabPanel("Prediction", 
            p(br()),
            #prediction part
              ##-------csv file for prediction -------##   
            # Input: Select a file ----
            fileInput("newfile.l", "Upload new .csv data set",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),

             # Input: Checkbox if file has header ----
            checkboxInput("newheader.l", "Header", TRUE),

            fluidRow(
              column(3, 
                 # Input: Select separator ----
              radioButtons("newsep.l", "Separator",
                 choices = c(Comma = ",",
                             Semicolon = ";",
                             Tab = "\t"),
                 selected = ",")),

              column(3,
                # Input: Select quotes ----
              radioButtons("newquote.l", "Quote",
                 choices = c(None = "",
                             "Double Quote" = '"',
                             "Single Quote" = "'"),
                 selected = '"'))

              ),
            actionButton("B2.l", "Submit after the estimation of model"), 
            p(br()),
            tags$b("1. Data display with prediction results"), 
            p(br()),
            dataTableOutput("preddt.l"),
            p(br()),
            tags$b("2. ROC plot of the predicted outcomes"),
            uiOutput('px.l'),
            fluidRow(
              column(6, plotOutput("p4.l", width = "400px", height = "400px")),
              column(6, verbatimTextOutput("auc2")))
            ) ##  tabPanel("Prediction"
          ) ## tabsetPanel(
        ) ## mainPanel(
      ) ## sidebarLayout(
    ), ## tabPanel(

##----------------------------------------------------------------------
## 3. cox regression---------------------------------------------------------------------------------
    tabPanel("Cox Regression (Time-Event Outcomes)",

      titlePanel("Cox Regression"),

      sidebarLayout(

        sidebarPanel(

          h4(tags$b("Input Data")),

          ##-------csv file-------##   
          # Input: Select a file ----
          fileInput("file.c", "Upload .csv data set",
              multiple = TRUE,
              accept = c("text/csv",
                       "text/comma-separated-values,text/plain",
                       ".csv")),
          helpText("If no data is uploaded, the example data (mtcars) is being shown."),
           # Input: Checkbox if file has header ----
          checkboxInput("header.c", "Header", TRUE),

          fluidRow(

            column(4, 
               # Input: Select separator ----
            radioButtons("sep.c", "Separator",
               choices = c(Comma = ",",
                           Semicolon = ";",
                           Tab = "\t"),
               selected = ",")),

            column(4,
              # Input: Select quotes ----
            radioButtons("quote.c", "Quote",
               choices = c(None = "",
                           "Double Quote" = '"',
                           "Single Quote" = "'"),
               selected = '"'))
            ), 
            hr(),
          ##<<-----------------------------<<

          ##>>---------cox formula---------->>
            uiOutput('t1.c'),
            uiOutput('t2.c'),
            uiOutput('c.c'),    
            uiOutput('x.c'),
            uiOutput('fx.c'),
            uiOutput('sx.c'),
            uiOutput('clx.c'),

            h5("Additional terms (confounding or interaction)"), 
            helpText("Start with '+'. For interception term, please type +as.factor(cyl):wt"), 
            tags$textarea(id='conf.c', cols=40, " " ), 
            p(br()),
            actionButton("F.c", "First: Create formula"),
            verbatimTextOutput("formula.c"),
            hr(),

  # K-M plot##-------Basic Plot -------## 
            h4(tags$b("Exploration of Variables")),  
            actionButton("Y.c", "Plot after the creation of formula"),
            p(br()),
            tags$b("1. K-M Survival Plot (null model)"), 
            helpText("Formula: Surv(time, status)~1 "),
            plotOutput("p0.c", width = "400px", height = "400px"),

            tags$b("2. K-M Survival Plot (by group)"), 
            helpText("Formula: Surv(time, status) ~ group"),
            uiOutput('tx.c'),
            plotOutput("p1.c", width = "400px", height = "400px"),

            tags$b("3. Histogram"), 
            uiOutput('hx.c'),
            plotOutput("p3.c", width = "400px", height = "400px"),
            sliderInput("bin.c", "The width of bins in histogram", min = 0.01, max = 5, value = 0.7)

            ), ## sidebarPanel(

          mainPanel( 
            h4(tags$b("Outputs")),
            tags$b("1. Data Display"), 
            dataTableOutput("table.c"), 
            tags$b("2. Basic Descriptives"), 
            helpText("Select the variables for descriptives"),

            tabsetPanel(
              tabPanel(
                "Continuous variables",
                uiOutput('cv.c'),
                actionButton("Bc.c", "Submit"),
                tableOutput("sum.c")
                ),
              tabPanel(
                "Discrete variables",
                uiOutput('dv.c'),
                actionButton("Bd.c", "Submit"),
                verbatimTextOutput("fsum.c")
                )
              ),
            hr(),
            h4(tags$b("Models")),
            
            tabsetPanel(
              tabPanel("Estimation", 
                p(br()),
                actionButton("B1.c", "Submit after the display of formula"),
                p(br()),
                tags$b("1. Regression Fitting"), 
                htmlOutput("fit.c"),
                p(br()),
                tags$b("2. ANOVA Table"), 
                tableOutput("anova.c")
                ),

              tabPanel("Diagnostics", 
                p(br()),
                tags$b("1. Check for constant hazard ratio over time"),
                tableOutput("zph.c"), 
                plotOutput("p2.c",width = "500px", height = "500px"),
                tags$b("2. Diagnostic Plot"), 
                radioButtons("res.c", "Residual type",
                   choices = c("Martingale" = "martingale",
                               "Deviance" = "deviance",
                               "Cox-Snell" = "Cox-Snell"),
                   selected = "martingale") ,
                plotOutput("p4.c", width = "400px", height = "400px"),
                tags$b("3. Estimated Fitting Values"), 
                dataTableOutput("fitdt.c")
               ),

              tabPanel("Prediction", 
                p(br()),
      #prediction part
      ##-------csv file for prediction -------##   
      # Input: Select a file ----
                fileInput("newfile.c", "Upload new .csv data set",
                  multiple = TRUE,
                  accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),

       # Input: Checkbox if file has header ----
                checkboxInput("newheader.c", "Header", TRUE),

                fluidRow(
                  column(3, 
                     # Input: Select separator ----
                    radioButtons("newsep.c", "Separator",
                       choices = c(Comma = ",",
                                   Semicolon = ";",
                                   Tab = "\t"),
                       selected = ",")),

                  column(3,
                  # Input: Select quotes ----
                    radioButtons("newquote.c", "Quote",
                       choices = c(None = "",
                                   "Double Quote" = '"',
                                   "Single Quote" = "'"),
                       selected = '"'))
                  ),
                actionButton("B2.c", "Submit"), 
                p(br()),
                tags$b("1. Data display with prediction results"), 
                p(br()),
                dataTableOutput("pred.c"),
                tags$b("2. Diagnostic plot of the predicted values"), 
                plotOutput("p6.c", width = "400px", height = "400px")
                )
              ) ##tabsetPanel(
            ) ## mainPanel(
          ) ## sidebarLayout(
        ) ## tabPanel(
      )
##-----------------------over
  )
)


