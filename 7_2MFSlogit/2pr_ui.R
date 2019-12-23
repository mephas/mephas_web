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
checkboxInput("newcol", "Yes", FALSE),

     # Input: Select separator ----
radioButtons("newsep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", ";", " ", "\t")
  ),

radioButtons("newquote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensures data input successfully")
),


mainPanel(

h4(tags$b("Output 1. Prediction Results")),

actionButton("B2", tags$b("Given That Model and New Data are Ready, Click to Get Results / Refresh"), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
p("If no new data, the existed data for modeling will be presented."),
DT::dataTableOutput("pred"),
downloadButton("download12", "Download Results")

# h4(tags$b("Output 2. Prediction Plot between one independent variable (X) and dependent variable (Y)")),
# uiOutput('sx'),  
# plotOutput("p.s", width = "500px", height = "400px")


) 


)
