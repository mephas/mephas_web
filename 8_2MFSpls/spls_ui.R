##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#pcr {overflow-y:scroll; height: 300px; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; height: 200px; background: white};")),

h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.s'), 
uiOutput('y.s'), 

numericInput("nc.s", "4. How many new components", 4, min = 1, max = NA),
numericInput("nc.eta", "5. Parameter for selection range (larger number chooses less variables)", 0.9, min = 0, max = 1, step=0.1),
#p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

#hr(),
#h4(tags$b("Choose components to show factor and loading 2D plot")),
##numericInput("c1.s", "1. Component at x-axis", 1, min = 1, max = NA),
#numericInput("c2.s", "2. Component at y-axis", 2, min = 1, max = NA),
#p("x and y must be different"),


hr(),
h4(tags$b("Choose components to show factor and loading 3D plot")),
numericInput("td1.s", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2.s", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3.s", "3. Component at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.s", "4. (Optional) Change line scale (length)", 2, min = 1, max = NA)
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),

tabsetPanel(

tabPanel("Browse", p(br()),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("spls.x")
),
tabPanel("Cross-validated SPLS", p(br()),
numericInput("cv.s", "4. Maximum new components", 10, min = 1, max = NA),
numericInput("cv.eta", "5. Parameter for selection range (larger number chooses less variables)", 0.9, min = 0, max = 1, step=0.1),
#plotOutput("heat.cv", width = "600px", height = "600px"),
verbatimTextOutput("spls.cv")
  )
),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("spls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Result",p(br()),

radioButtons("method.s", "Which PLS algorithm",
  choices = c("SIMPLS: simple and fast" = 'simpls',
           "Kernel algorithm" = "kernelpls",
           "Wide kernel algorithm" = "widekernelpls",
           "Classical orthogonal scores algorithm" = "oscorespls"),
selected = 'simpls'),

verbatimTextOutput("spls")
),

tabPanel("Selection",p(br()),
plotOutput("spls.bp", width = "600px", height = "600px"),
DT::DTOutput("spls.coef")
),

tabPanel("Data Fitting",p(br()),
DT::DTOutput("spls.pres"),
DT::DTOutput("spls.sv")
),

tabPanel("Components", p(br()),
  #plotOutput("spls.s.plot", width = "600px", height = "400px"),
  DT::DTOutput("spls.s")
  ),

tabPanel("Loading", p(br()),
  #plotOutput("spls.l.plot", width = "600px", height = "600px"),
  DT::DTOutput("spls.l")
  ),

tabPanel("Component and Loading 3D Plot" ,p(br()),
plotly::plotlyOutput("tdplot.s", width = "800px", height = "800px"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace.s")
)
)

)

)