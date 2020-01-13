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

#tags$head(tags$style("#x_fa {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#fa {overflow-y:scroll; height: 300px; background: white};")),
tags$head(tags$style("#tdtrace.fa {overflow-y:scroll; height: 150px; background: white};")),

h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.fa'), 
p("If no need to remove, please choose NULL"),

#tags$b('2. Check the variables used in the model, numeric only'),

#verbatimTextOutput("x_fa"),   

#checkboxInput("scale1.fa", tags$b("3. Whether to scale the data"), TRUE),

numericInput("ncfa", "2. How many factors", 4, min = 2, max = NA),
#p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

hr(),
h4(tags$b("Choose factors to show in factor and loading 2D plot")),
numericInput("c1.fa", "1. Factor at x-axis", 1, min = 1, max = NA),
numericInput("c2.fa", "2. Factor at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
#p(br()),
#checkboxInput("frame", tags$b("3. Add group circle in the plot"), FALSE),
#uiOutput('g'), 

hr(),
h4(tags$b("Choose factors to show in factor and loading 3D plot")),
numericInput("td1.fa", "1. Factor at x-axis", 1, min = 1, max = NA),
numericInput("td2.fa", "2. Factor at y-axis", 2, min = 1, max = NA),
numericInput("td3.fa", "3. Factor at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.fa", "4. (Optional) Change line scale (length)", 10, min = 1, max = NA)
),

mainPanel(

h4(tags$b("Output 1. Data Explores")),

tabsetPanel(

tabPanel("Browse", p(br()),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("table.x.fa")
),
tabPanel("Parallel Analysis", p(br()),
plotOutput("fa.plot", width = "600px", height = "400px"),
verbatimTextOutput("fancomp")
),
tabPanel("Correlation Matrix", p(br()),
plotOutput("cor.fa.plot", width = "600px", height = "400px"),p(br()),
DT::DTOutput("cor.fa")
)
  ),
hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("pca1.fa", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Factors Result",p(br()),
  
  plotOutput("pca.ind.fa", width = "600px", height = "400px"),
  verbatimTextOutput("fa")),

tabPanel("Factors", p(br()),
  DT::DTOutput("comp.fa")
  ),

tabPanel("Loading", p(br()),
	plotOutput("pca.ind.fa2", width = "600px", height = "400px"),
  DT::DTOutput("load.fa"),
  DT::DTOutput("var.fa")  ),

tabPanel("Factors and Loading 2D Plot" ,p(br()),

plotOutput("fa.bp", width = "600px", height = "600px")

),

tabPanel("Factors and Loading 3D Plot" ,p(br()),
plotly::plotlyOutput("tdplot.fa", width = "800px", height = "800px"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace.fa")
)

)

)
)