#****************************************************************************************************************************************************pls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Use example data (test set)")),
h4("Click the Output"),

hr(),

h4(tags$b("Use my own data (test set)")),
p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

h4(tags$b("Step 1. Upload New Data File")),      

fileInput('newfile.pls', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader.pls", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol.pls", "Yes", TRUE),
radioButtons("newsep.pls", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote.pls", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input")
),


mainPanel(

h4(tags$b("Output. Data Preview")),
DT::DTOutput("newX.pls"),
hr(),
actionButton("B.pls", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Prediction",p(br()),

DT::DTOutput("pred.lp.pls")
),

tabPanel("Predicted Components",p(br()),
DT::DTOutput("pred.comp.pls")
)
) 
) 
)
