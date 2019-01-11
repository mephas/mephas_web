##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Cox regression
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(

 
  ##<<-----------------------------<<

  ##>>---------cox formula---------->>
  h4(tags$b("Given that dataset has been imported, please design you model")),
  uiOutput('t1.c'),
  uiOutput('t2.c'),
  uiOutput('c.c'),    
  uiOutput('x.c'),
  uiOutput('fx.c'),
  uiOutput('sx.c'),
  uiOutput('clx.c'),

  h5("Additional terms (confounding or interaction)"), 
  helpText('Note: Start with "+". For interactive term, please type "+ as.factor(var1):var2"'), 
  tags$textarea(id='conf.c', cols=40, " " ), 
  p(br()),
  actionButton("F.c", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")
  
), ## sidebarPanel(

mainPanel( 

  h4(tags$b("Cox Regression Model")),
  tags$style(type='text/css', '#formula_c {background-color: rgba(0,0,255,0.10); color: blue;}'),
  verbatimTextOutput("formula_c", placeholder = TRUE),
  hr(),

  h4(tags$b("Results of the linear regression")),
  actionButton("B1.c", "Show the results"),
  p(br()),

  tabsetPanel(
    tabPanel("Exploration of Variables",
      p(br()),
      actionButton("Y.c", "Plot after the creation of formula"),
      p(br()),
      tags$b("1. K-M Survival Plot (null model)"), 
      helpText("Formula: Surv(time, status)~1 "),
      plotOutput("p0.c", width = "400px", height = "400px"),

      tags$b("2. K-M Survival Plot (by group)"), 
      helpText("Formula: Surv(time, status) ~ group"),
      uiOutput('tx.c'),
      plotOutput("p1.c", width = "400px", height = "400px")
      ),
    tabPanel("Parameters' estimation", 
      p(br()),
  
      tags$b("1. Regression's coefficients"), 
      htmlOutput("fit.c"), p(br()),
      tags$b("2. ANOVA Table"), tableOutput("anova.c"),p(br()),
      tags$b("3. Select a formula-based model by AIC"), verbatimTextOutput("step.c")
      ),
    tabPanel("Model's diagnostics", 
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
      plotOutput("p4.c", width = "400px", height = "400px")),

    tabPanel("Estimated fitting values",
      p(br()),
      tags$b("Estimation is based on import dataset"),
      dataTableOutput("fitdt.c")),

    tabPanel("Prediction on new data", 
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
      tags$b("Data display with prediction results"), 
      p(br()),
      dataTableOutput("pred.c")
      )
    ) ##tabsetPanel(
) ## mainPanel(

) ## sidebarLayout(