##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#pls {overflow-y:scroll; height: 300px; background: white};")),
tags$head(tags$style("#pls_tdtrace {overflow-y:scroll; height: 200px; background: white};")),


h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.r'), 
uiOutput('y.r'), 

numericInput("nc.r", "4. How many new components", 4, min = 1, max = NA),
#p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

hr(),
h4(tags$b("Choose components to show factor and loading 2D plot")),
numericInput("c1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.r", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),


hr(),
h4(tags$b("Choose components to show factor and loading 3D plot")),
numericInput("td1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2.r", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3.r", "3. Component at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.r", "4. (Optional) Change line scale (length)", 0.1, min = 1, max = NA)
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(br()),
p(tags$b("Browse")),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("pls.x"),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("pls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Result",p(br()),
radioButtons("val.r", "Whether to do cross-validation",
choices = c("No cross-validation" = 'none',
           "10-fold cross-validation" = "CV",
           "Leave-one-out cross-validation" = "LOO"),
selected = 'none'),


radioButtons("method.r", "Which PLS algorithm",
  choices = c("SIMPLS: simple and fast" = 'simpls',
           "Kernel algorithm" = "kernelpls",
           "Wide kernel algorithm" = "widekernelpls",
           "Classical orthogonal scores algorithm" = "oscorespls"),
selected = 'simpls'),


verbatimTextOutput("pls")
  ),

tabPanel("Data Fitting",p(br()),
DT::DTOutput("pls.pres"),br(),
DT::DTOutput("pls.resi")
),

tabPanel("Components", p(br()),
  plotOutput("pls.s.plot", width = "80%"),
  DT::DTOutput("pls.s")
  ),

tabPanel("Loading", p(br()),
  plotOutput("pls.l.plot", width = "80%"),
  DT::DTOutput("pls.l")
  ),

tabPanel("Component and Loading 2D Plot", p(br()),
  plotOutput("pls.bp", width = "80%")
  #DT::DTOutput("pls.l")
  ),

tabPanel("Component and Loading 3D Plot" ,p(br()),
plotly::plotlyOutput("pls.tdplot"),
p(tags$b("Trace legend")),
verbatimTextOutput("pls_tdtrace")
)
)

)

)