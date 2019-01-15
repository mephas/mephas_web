##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Logistic regression
##
## Language: JP
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(
sidebarPanel(

h4(("Given that dataset has been imported, please design you model")),       
uiOutput('y.l'),    
uiOutput('x.l'),
uiOutput('fx.l'),
# select intercept
radioButtons("intercept.l", "定数項",
             choices = c("定数項を取り除く" = "-1",
                         "K定数項を取り除かない" = ""),
             selected = "-1"),
h5("Additional terms (confounding交絡因子 or interaction交互作用)"), 
helpText('Start with "+". For interception term, please type "+as.factor(var1):var2"'), 
tags$textarea(id='conf.l', column=40, ""), 
p(br()),
actionButton("F.l", "Create formula", style="color: #fff; background-color: #337ab7; border-color: #2e6da4")

), ## sidebarPanel(

mainPanel(

  h4(("Lロジスティック回帰")),

  tags$style(type='text/css', '#formula_l {background-color: rgba(0,0,255,0.10); color: blue;}'),
  verbatimTextOutput("formula_l", placeholder = TRUE),
  helpText("Note: '-1' in the formula indicates that intercept has been removed"),
  hr(),

  h4(("結果")),
  actionButton("B1.l", "Show the results"), 
  p(br()),
  tabsetPanel(
    tabPanel("Parameters' estimation", 
      p(br()),
      
      p(br()),
      tags$b("1. 偏回帰係数"), 
      htmlOutput("fit.l"), p(br()),
      tags$b("2. ANOVA テーブル"), tableOutput("anova.l"), p(br()),
      tags$b("3. Select a formula-based model by AIC"), verbatimTextOutput("step.l")
      ),

    tabPanel("回帰診断",
      p(br()),
      tags$b("ROC プロット"),
      
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
      checkboxInput("newheader.l", "ヘッダー", TRUE),

        fluidRow(
      column(3, 
         # Input: Select separator ----
      radioButtons("newsep.l", "区切り",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ",")),

      column(3,
        # Input: Select quotes ----
      radioButtons("newquote.l", "クオート",
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