#****************************************************************************************************************************************************pls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Prediction")),
p("Prepare model first"),
hr(),

h4(tags$b("Step 3. Test Set Preparation")),
tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: NKI"))

  ),

tabPanel("Upload Data", p(br()),
p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

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
)
),

hr(),

h4(tags$b("Step 4. If the model and new data are ready, click the blue button to generate prediction results.")),

#actionButton("B.pls", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("B.pls", (tags$b("Show Prediction >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),


mainPanel(

h4(tags$b("Output. Model Results")),

tabsetPanel(
tabPanel("Predicted dependent variables",p(br()),

DT::DTOutput("pred.lp.pls")
),

tabPanel("Predicted Components",p(br()),
DT::DTOutput("pred.comp.pls")
),
tabPanel("Test Data",p(br()),
DT::DTOutput("newX.pls")
)
) 
) 
)