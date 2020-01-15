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

  tags$style(type='text/css', '#surv {background-color: rgba(0,0,255,0.10); color: blue;}'),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#kmat1 {overflow-y:scroll; max-height: 200px; background: white};")),

selectInput("edata", h4(tags$b("Use example data (training set)")), 
        choices =  c("Diabetes","NKI70"), 
        selected = "Diabetes"),

hr(),

h4(tags$b("Use my own data (training set)")),
p("We suggested putting the survival time variable and censoring variable in the left side of all independent variables (X) "),

h4(tags$b("Step 1. Upload Data File")), 

fileInput('file', "1. Choose CSV/TXT file",
          accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

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

h4(tags$b("Step 2. Create a Survival Object")), 

#p(tags$b("1. Choose a Time Variable")),   

uiOutput('c'),

radioButtons("time", "2. Set Survival Time", select="A",
  choiceNames = list(
    HTML("Choice 1. <b>Right-censored time</b>: needs time duration / follow-up"),
    HTML("Choice 2. <b>Left-truncated right-censored time</b>: needs start and end time points")
    ),
  choiceValues = list("A", "B" )
  ),

tabsetPanel(
  tabPanel("Right-censored", br(),
    uiOutput('t')
    ),
  tabPanel("Left-truncated Right-censored", br(),
    uiOutput('t1'),
    uiOutput('t2')
    )
  ),
hr(),
h4(tags$b("Step 3. Check the Survival Object")),      

verbatimTextOutput("surv", placeholder = TRUE),


hr(),


h4(tags$b("(Optional) Change the types of some variable?")),

#p(tags$b("Choice 1. Change Numeric Variables (Numbers) into Categorical Variable (Factors)")), 

uiOutput("factor1"),

#p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")), 

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref', column=40, "")


),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
p(br()),
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


#downloadButton("download1", "Download Results (Continuous variables)"),
downloadButton("download2", "Download Results (Categorical variables)")

),

tabPanel("Survival Curves",  p(br()),
  radioButtons("fun1", "Choose one plot", 
  choiceNames = list(
    HTML("1. Survival Probability"),
    HTML("2. Cumulative Events"),
    HTML("3. Cumulative Hazard")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
plotOutput("km.a", width = "80%"),
verbatimTextOutput("kmat1")
     ),

tabPanel("Life Table",  p(br()),
  #p(tags$b("For all samples")),
DT::DTOutput("kmat")
#tags$head(tags$style("#kmat {overflow-y:scroll; max-height: 400px; background: white};"))
     ),

tabPanel("Histogram", p(br()),

p("This is to show the distribution of any numeric variable"),
uiOutput('hx'),
plotOutput("p2", width = "80%"),
sliderInput("bin", "The width of bins in the histogram", min = 0.01, max = 50, value = 1))

)

)

)