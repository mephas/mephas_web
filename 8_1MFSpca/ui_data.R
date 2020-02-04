#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("Data Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),
  selectInput("edata", tags$b("Use example data"), 
        choices =  c("Chemical","Mouse"), 
        selected = "Mouse")
  ),

tabPanel("Upload Data", p(br()),

fileInput('file', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")), 
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")), 
checkboxInput("col", "Yes", TRUE),

radioButtons("sep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("quote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
  )
  ),
hr(),

h4(tags$b("(Optional) Change the types of some variable?")),
uiOutput("factor1"),
uiOutput("factor2"),
hr(),

h4(tags$b(actionLink("ModelPCA","Build PCA Model"))),
h4(tags$b(actionLink("ModelEFA","Build EFA Model")))
#h4(tags$b("Build Model in the Next Tab"))

),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),

hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variable)")

),

tabPanel("Linear fitting plot",p(br()),

HTML("<p><b>Linear fitting plot</b>: to roughly show the linear relation between any two numeric variable. Grey area is 95% confidence interval.</p>"),

uiOutput('tx'),
uiOutput('ty'),

plotly::plotlyOutput("p1", width = "80%")
),

tabPanel("Histogram", p(br()),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
p(tags$b("Histogram")),
plotly::plotlyOutput("p2", width = "80%"),
sliderInput("bin", "The number of bins in the histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins "),
p(tags$b("Density plot")),
plotly::plotlyOutput("p21", width = "80%"))

)

)

)