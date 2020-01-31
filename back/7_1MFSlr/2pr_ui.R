#****************************************************************************************************************************************************pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Test Set Preparation")),
p("Prepare model in the previous Model tab"),

tabsetPanel(

tabPanel("Example data", p(br()),

 h4(tags$b("Data: Birth Weight"))

  ),

tabPanel("Upload Data", p(br()),

p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

fileInput('newfile', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
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

p("Correct separator and quote ensure the successful data input")

)
),

hr(),

h4(tags$b("If the model and new data are ready, click the blue button to generate prediction results.")),

actionButton("B2", h4(tags$b("Show Prediction >>")), class = "btn btn-primary")


),


mainPanel(
h4(tags$b("Output. Prediction Results")),
#actionButton("B2", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Prediction",p(br()),
p("Predicted dependent variable is shown in the 1st column"),
DT::DTOutput("pred")
),

tabPanel("Evaluation Plot",p(br()),
p(tags$b("Prediction vs True Dependent Variable Plot")),
p("This plot is shown when new dependent variable is provided in the test data."),
p("This plot shows the relation between predicted dependent variable and new dependent variable, using linear smooth. Grey area is confidence interval."),
plotly::plotlyOutput("p.s", width = "80%")
)
) 
) 
)
