##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Logistic regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(
sidebarPanel(

h4(tags$b("Given that dataset has been imported, please design you model")),       
uiOutput('y.l'),    
uiOutput('x.l'),
uiOutput('fx.l'),
# select intercept
radioButtons("intercept.l", "Intercept",
             choices = c("Remove Intercept" = "-1",
                         "Keep intercept" = ""),
             selected = "-1"),
h5("Additional terms (confounding or interaction)"), 
helpText('Start with "+". For interception term, please type "+as.factor(var1):var2"'), 
tags$textarea(id='conf.l', column=40, ""), 
p(br()),
actionButton("F.l", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel(

  h4(tags$b("Logistics Regression Model")),

  tags$style(type='text/css', '#formula_l {background-color: rgba(0,0,255,0.10); color: blue;}'),
  verbatimTextOutput("formula_l", placeholder = TRUE),
  helpText("Note: '-1' in the formula indicates that intercept has been removed"),
  hr(),

  h4(tags$b("Results of the logistic regression")),
  actionButton("B1.l", "Show the results"), 
  p(br()),
  tabsetPanel(
    tabPanel("Parameters' estimation", 
      p(br()),
      
      p(br()),
      tags$b("1. Regression's coefficients"), 
      htmlOutput("fit.l"), p(br()),
      tags$b("2. ANOVA Table"), tableOutput("anova.l"), p(br()),
      tags$b("3. Select a formula-based model by AIC"), verbatimTextOutput("step.l")
      ),

    tabPanel("Model's diagnostics",
      p(br()),
      tags$b("ROC Plot"),
      
      plotOutput("p2.l", width = "400px", height = "400px"),
      verbatimTextOutput("auc")
      ),

    tabPanel("Estimated fitting values",
      tags$b("Estimation is based on import dataset"), 
      dataTableOutput("fitdt")
      ),

    tabPanel("Prediction on new data", 
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
      helpText("If no data is uploaded, the example testing data (the first 10 rows of import dataset) will be shown."),
       
      p(br()),
      tags$b("Data display with prediction results"), 
      p(br()),
      dataTableOutput("preddt.l")
      ) ##  tabPanel("Prediction"
    ) ## tabsetPanel(
) ## mainPanel(
) ## sidebarLayout(