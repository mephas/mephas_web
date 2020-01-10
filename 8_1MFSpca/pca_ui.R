##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
##		>pca
##
## Language: EN
## 
## DT: 2019-05-04
##
##----------#----------#----------#----------
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; height: 150px; background: white};")),

h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('y'), 
p("If no need to remove, please choose NULL"),

tags$b('2. Check the variables used in the model, numeric only'),

verbatimTextOutput("x"),   

checkboxInput("scale1", tags$b("3. Whether to scale the data"), TRUE),

numericInput("nc", "4. How many new components", 5, min = 2, max = NA),
p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

hr(),
h4(tags$b("Choose components to show in Component Plot and Loading Plot")),
numericInput("c1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
p(br()),
checkboxInput("frame", tags$b("3. Add group circle in the plot"), FALSE),
uiOutput('g'), 

hr(),
h4(tags$b("Choose components to show in 3D Plot")),
numericInput("td1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3", "3. Component at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines", "4. (Optional) Change line scale (length)", 10, min = 1, max = NA)
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(br()),
p(tags$b("Browse")),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("table.x"),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("pca1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Variance Table",p(br()),
	plotOutput("pca.plot", width = "600px", height = "400px"),

  DT::DTOutput("fit")),

tabPanel("New components", p(br()),
  DT::DTOutput("comp")
  #downloadButton("downloadData", "Download")
  ),
tabPanel("Component Plot" ,p(br()),
plotOutput("pca.ind", width = "600px", height = "400px"),

radioButtons("type", "The type of ellipse",
 choices = c("T: assumes a multivariate t-distribution" = 't',
             "Normal: assumes a multivariate normal-distribution" = "norm",
             #Convex = "convex",
             "Euclid: the euclidean distance from the center" = "euclid"),
 selected = 't')
),
tabPanel("Loading Table", p(br()),
  DT::DTOutput("load")
  #downloadButton("downloadData", "Download")
  ),
tabPanel("Loading Plot" ,p(br()),

plotOutput("pca.bp", width = "600px", height = "600px")

),

tabPanel("3D Plot" ,p(br()),
plotly::plotlyOutput("tdplot", width = "800px", height = "800px"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace")
)
)

)

)