#****************************************************************************************************************************************************spls
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#spls {overflow-y:scroll; height: 300px; background: white};")),
tags$head(tags$style("#spls_cv {overflow-y:scroll; height: 300px; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; height: 200px; background: white};")),

h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.s'), 
uiOutput('y.s'), 

numericInput("nc.s", "4. How many new components", 4, min = 1, max = NA),
numericInput("nc.eta", "5. Parameter for selection range (larger number chooses less variables)", 0.9, min = 0, max = 1, step=0.1),
hr(),
h4(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c1.s", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.s", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
hr(),
h4(tags$b("When #comp >=3, choose components to show factor and loading 3D plot")),
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
p("Choose optimal parameters from the following settings"),
numericInput("cv.s", "Maximum new components", 10, min = 1, max = NA),
numericInput("cv.eta", "Parameter for selection range (larger number chooses less variables)", 0.9, min = 0, max = 1, step=0.1),
p("This result chooses optimal parameters using 10-fold cross-validation which split data randomly, so the result will not be exactly the same every time."),
verbatimTextOutput("spls_cv")
  )
),

hr(),
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
plotOutput("spls.bp", width = "80%"),
p(tags$b("Coefficient")),
DT::DTOutput("spls.coef")
),

tabPanel("Data Fitting",p(br()),
p(tags$b("Predicted dependent variables")),
DT::DTOutput("spls.pres"),
p(tags$b("Selected variables")),
DT::DTOutput("spls.sv")
),

tabPanel("Components", p(br()),
	p("This is components derived based on the selected variables"),
	  HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two scores, you can use the score plot to assess the data structure and detect clusters, outliers, and trends
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
</ul>
  "),
	plotOutput("spls.s.plot", width = "80%"),
  DT::DTOutput("spls.s")
  ),

tabPanel("Loading", p(br()),
	p("This is loadings derived based on the selected variables"),
	  HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)
<li> Red indicates negative and blue indicates positive effects
<li> Use the cumulative proportion of variance (in the variance table) to determine the amount of variance that the factors explain. 
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained. 
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the factors.
</ul>
  "),
	plotOutput("spls.l.plot", width = "80%"),
  DT::DTOutput("spls.l")
  ),

tabPanel("Component and Loading 3D Plot" ,p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot overlays the components and the loadings (choose PC in the left panel)
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
<li> Loadings identify which variables have the largest effect on each component.
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.
</ul>

  "),
plotly::plotlyOutput("tdplot.s"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace.s")
)
)

)

)