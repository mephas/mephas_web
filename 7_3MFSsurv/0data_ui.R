##----------#----------#----------#----------
##
## 7MFSreg UI
##
##    >data
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

selectInput("edata", "Example Data", 
        choices =  c("NKI70"), 
        selected = "NKI70"),

h4(tags$b("Step 1. Upload Data File")), 
##-------csv file-------##   
p("We suggest the first variable is the dependent variable (Y) / outcome /response "),
fileInput('file', "Choose CSV/TXT file",
          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#helpText("The columns of X are not suggested greater than 500"),
# Input: Checkbox if file has header ----
p(tags$b("2. Show 1st row as column names?")),
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("col", "Yes", TRUE),

     # Input: Select separator ----
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

h4(tags$b("Step 2. Create a Survival Object")), 

p(tags$b("1. Choose a Time Variable")),      

radioButtons("time", "What kind of time do you use?", select="A",
  choiceNames = list(
    HTML("Choice 1. Right-censored time: time-duration / follow-up"),
    HTML("Choice 2. left-truncated right-censored time: start-end time-point")
    ),
  choiceValues = list("A", "B" )
  ),

uiOutput('t'),

p(tags$b("Choice 2. Choose start-end time-points")),      
uiOutput('t1'),
uiOutput('t2'),

uiOutput('c'),

tags$style(type='text/css', '#surv {background-color: rgba(0,0,255,0.10); color: blue;}'),
verbatimTextOutput("surv", placeholder = TRUE),


hr(),


p(tags$b("Do you need to change the attribute or type of some variables?")),

p(tags$b("Choice 1. Change Numeric Variables (Numbers) into Categorical Variable (Factors)")), 

uiOutput("factor1"),

p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

p(tags$b("Choice 3. Change the Base/Referential Level for Categorical Variable (Factors)")), 

uiOutput("lvl"),

p("2. Input the  Base/Referential Level, one line for one variable"),

tags$textarea(id='ref', column=40, "")


),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
p(br()),
DT::dataTableOutput("Xdata"),

p(tags$b("1. Continuous variable information list")),
verbatimTextOutput("strnum"),
tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),


p(tags$b("2. Factor/ Catrorical variable information list")),
verbatimTextOutput("strfac"),
tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 200px; background: white};")),


hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. Continuous variables")),

DT::dataTableOutput("sum"),

p(tags$b("2. Categorical variables")),
verbatimTextOutput("fsum"),
tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 200px; background: white};")),


downloadButton("download1", "Download Results (Continuous variables)"),
downloadButton("download2", "Download Results (Categorical variables)")

),

tabPanel("Survival Probability Plot",  p(br()),
  radioButtons("fun1", "Which plot do you want to see?", 
  choiceNames = list(
    HTML("1. Survival Probability"),
    HTML("2. Cumulative Events"),
    HTML("3. Cumulative Hazard")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
plotOutput("km.a", width = "600px", height = "400px"),
verbatimTextOutput("kmat1"),
tags$head(tags$style("#kmat1 {overflow-y:scroll; max-height: 200px; background: white};"))
     ),

tabPanel("Survival Probability Table",  p(br()),
  p(tags$b("For all samples")),
    verbatimTextOutput("kmat"),
tags$head(tags$style("#kmat {overflow-y:scroll; max-height: 400px; background: white};"))
     ),

tabPanel("Histogram", p(br()),

p("This is to show the distribution of any numeric variable"),
uiOutput('hx'),
plotOutput("p2", width = "500px", height = "400px"),
sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 50, value = 1))

)

)

)