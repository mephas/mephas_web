#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("Training Set Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),

  #selectInput("edata", tags$b("Use example data"),
  #      choices =  c("Birth weight"),
  #      selected = "Birth weight")

  shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("Use example data"),
   choices =  c("Birth weight"),
   selected = "Birth weight",
   checkIcon = list(
    yes = tags$i(class = "fa fa-check-square", 
    style = "color: steelblue"),
   no = tags$i(class = "fa fa-square-o", 
  style = "color: steelblue"))
)
  ),

tabPanel.upload(file ="file", header="header", col="col", sep="sep", quote="quote")

  ),

hr(),

h4(tags$b("(Optional) Change the types of some variable?")),

#p(tags$b("Choice 1. Change Real-valued Variables into Categorical Variable")),

uiOutput("factor1"),

#p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2"),

h4(tags$b("(Optional) Change the referential level for categorical variable?")),

uiOutput("lvl"),

p(tags$b("2. Input the referential level, each line for one variable")),

tags$textarea(id='ref',""),
hr(),

h4(tags$b(actionLink("Model","Build Model")))
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
h4(tags$b("Output 2. Descriptive Results")),

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

plotly::plotlyOutput("p1")
),

tabPanel("Histogram", p(br()),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
p(tags$b("Histogram")),
plotly::plotlyOutput("p2"),
sliderInput("bin", "The number of bins in the histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins "),
p(tags$b("Density plot")),
plotly::plotlyOutput("p21"))

)))
