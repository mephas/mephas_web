##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >Linear regression
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

sidebarLayout(

sidebarPanel(

h4("Prediction is based on the accomplishment of model"),      

h4(tags$b("Step 1. Upload New Data File")),      

p("New data should include all the variables in the model"),
fileInput('newfile2', "Choose CSV/TXT file",
          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader2", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol2", "Yes", TRUE),

     # Input: Select separator ----
radioButtons("newsep2", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote2", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensures data input successfully")
),


mainPanel(

actionButton("B2.1", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Prediction Table",p(br()),
DT::DTOutput("pred2")
),

tabPanel("Brier Score",p(br()),

numericInput("ss", HTML("Set time series start point"), value = 1, min = 0),
numericInput("ee", HTML("Set time series end point"), value = 10, min = 1),
numericInput("by", HTML("Set time series sequence"), value = 1, min = 0),

plotOutput("bsplot", width = "500px", height = "400px"),

DT::DTOutput("bstab")

),

tabPanel("Time Dependent AUC",p(br()),

numericInput("ss1", HTML("Set time series start point"), value = 1, min = 0),
numericInput("ee1", HTML("Set time series end point"), value = 10, min = 1),
numericInput("by1", HTML("Set time series sequence"), value = 1, min = 0),

radioButtons("auc", "Choose one AUC estimator",
  choiceNames = list(
    HTML("Chambless and Diao"),
    HTML("Hung and Chiang"),
    HTML("Song and Zhou)"),
    HTML("Uno et al.")
    ),
  choiceValues = list("a", "b", "c", "d")
  ),

plotOutput("aucplot", width = "500px", height = "400px"),

DT::DTOutput("auctab")

)
)


) 


)
