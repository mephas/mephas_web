#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; max-height: 100px; background: white};")),

h4(tags$b("Data Preparation")),

tabsetPanel(

tabPanel("Example data", p(br()),
  #selectInput("edata", tags$b("Use example data"),
  #      choices =  c("Mouse","Chemical"),
  #      selected = "Mouse")
  shinyWidgets::radioGroupButtons(
   inputId = "edata",
   label = tags$b("Use example data"),
   choices = c("Mouse (PCA)","Chemical (EFA)"),
   selected = "Mouse (PCA)",
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
  shinyWidgets::prettySwitch(
   inputId = "transform",
   label = "Transform the data?", 
   status = "info",
   fill = TRUE
  ),

hr(),

h4(tags$b("(Optional) Change the types of some variable?")),
uiOutput("factor1"),
uiOutput("factor2"),
hr(),

uiOutput("rmrow"),

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

HTML("<p><b>Linear fitting plot</b>: to roughly show the linear relation between any two numeric variable."),
HTML("Grey area is 95% confidence interval.</p>"),
hr(),

uiOutput('tx'),
uiOutput('ty'),
p(tags$b("3. Change the labels of X and Y axes")),
tags$textarea(id = "xlab", rows = 1, "X"),
tags$textarea(id = "ylab", rows = 1, "Y"),

plotly::plotlyOutput("p1", width = "80%")
),

tabPanel("Histogram", p(br()),

HTML("<p><b>Histogram</b>: to roughly show the probability distribution of a variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
HTML("<p><b>Density plot</b>: to show the distribution of a variable</p>"),
hr(),

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
