#****************************************************************************************************************************************************
sidebarLayout(

sidebarPanel(
  tags$head(tags$style("#strnum {overflow-y:scroll; height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; height: 100px; background: white};")),

selectInput("edata", h4(tags$b("Use example data (training set)")), 
        choices =  c("Breast Cancer"), 
        selected = "Breast Cancer"),
hr(),

h4(tags$b("Use my own data (training set)")),
p("We suggested putting the dependent variable (Y) in the left side of all independent variables (X) "),

fileInput('file', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")),
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("col", "Yes", TRUE),

radioButtons("sep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
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

p("Correct separator and quote ensures data input successfully"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets"),

hr(),

h4(tags$b("(Optional) Change the types of some variable?")),
uiOutput("factor1"),
uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")), 

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref',"")


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

tabPanel("Basic Descriptives", br(),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variables)")
),

tabPanel("Logit Plot",br(),

uiOutput('tx'),
uiOutput('ty'),

plotOutput("p1", width = "80%")
),

tabPanel("Histogram", br(),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
plotOutput("p2", width = "80%"),
sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 5, value = 1))

)))