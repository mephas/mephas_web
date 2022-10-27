sidebarLayout(
sidebarPanel(
tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("Step 1. Data preparation")),
fileInput("filer",label = "upload file",accept = c("text","csv","xlsx")),
uiOutput("dataselect"),

h4(tags$b("Step 2. Data preparation")),
radioGroupButtons(
inputId = "period",
label = "time period",
choiceNames = c("year", "month"),
choiceValues = c(1, 12),
selected = 1,
justified = TRUE,
checkIcon = list(
yes = icon("ok", lib = "glyphicon")),
direction = "horizontal"
),
uiOutput("HRselect"),uiOutput("OSselect"),uiOutput("MCTselect"),uiOutput("HRdataselect"),uiOutput("yearselect")

),
mainPanel(
dataTableOutput("data"),
dataTableOutput("mergedata")
)
)