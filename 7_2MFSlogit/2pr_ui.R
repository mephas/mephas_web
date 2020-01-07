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
fileInput('newfile', "Choose CSV/TXT file",
          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol", "Yes", TRUE),

     # Input: Select separator ----
radioButtons("newsep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
          choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensures data input successfully")
),


mainPanel(

actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Prediction Table",p(br()),
DT::DTOutput("pred")
),

tabPanel("ROC Plot",p(br()),
p("This is to show the ROC plot between predicted values and true values, based on the new data not used in the model."),
plotOutput("p.s", width = "500px", height = "400px")
),

tabPanel(
p("This is based on the new data not used in the model."),
DT::DTOutput("sst.s")

  )
)


# h4(tags$b("Output 2. Prediction Plot between one independent variable (X) and dependent variable (Y)")),
# uiOutput('sx'),  
# plotOutput("p.s", width = "500px", height = "400px")


) 


)
