#****************************************************************************************************************************************************spls
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#spls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#spls_cv {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),

h4(tags$b("Build the Model")),
p("Prepare the data in the Data tab"),
hr(),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('y.s'), 
uiOutput('x.s'), 


numericInput("nc.s", "3. How many new components? (A, larger number chooses more variables)", 3, min = 1, max = NA),
numericInput("nc.eta", "4. Parameter for selection range (larger number chooses less variables)", 0.5, min = 0, max = 1, step=0.1),

radioButtons("method.s", "5. Which PLS algorithm?",
  choices = c("SIMPLS: simple and fast" = 'simpls',
           "Kernel algorithm" = "kernelpls",
           "Wide kernel algorithm" = "widekernelpls",
           "Classical orthogonal scores algorithm" = "oscorespls"),
selected = 'simpls'),

shinyWidgets::prettySwitch(
   inputId = "scale.s",
   label = tags$b("Scale the data?"), 
   value=TRUE,
   status = "info",
   fill = TRUE
  ),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("SPLS adds a penalty to make variable selection available. The penalty will select the variables that may be good for the prediction. The components are generated based on the selected variables.")),
p(tags$i("In the example of NKI data, we used time as dependent variable (Y), and variable from TSPYL5 ...are used as independent variables.
  The default is to put all variables other than Y into X. Thus, we need to remove Diam and Age variables.")),
p(tags$i("From the data tab, we knew that X is a 20 by 25 matrix, so the maximum of a is 19. There will be error if A=20."))
),

hr(),

h4(tags$b("Step 2. If data and model are ready, click the blue button to generate model results.")),
#actionButton("spls1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("spls1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),

tabsetPanel(

tabPanel("Cross-validated SPLS", p(br()),
p("Choose optimal parameters from the following ranges"),
numericInput("cv.s", "Maximum new components (default: 1 to 10)", 10, min = 1, max = NA),
numericInput("cv.eta", "Parameter for selection range (larger number chooses less variables, default: 0.1 to 0.9)", 0.9, min = 0, max = 1, step=0.1),
#p("This result chooses optimal parameters using 10-fold cross-validation which split data randomly, so the result will not be exactly the same every time."),
p("Cross-validation will choose the parameters according to the minimum error, giving some suggestions to choose parameters."),
actionButton("splscv", (tags$b("Show CV Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
verbatimTextOutput("spls_cv")
  ),
tabPanel("Part of Data", br(),
 p("Please edit data in Data tab"),
DT::DTOutput("spls.x")
)
),

hr(),
#actionButton("spls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 1. Model Results")),

tabsetPanel(
tabPanel("Selection",p(br()),
verbatimTextOutput("spls"),
p(br()),
p(tags$b("Selected variables")),
DT::DTOutput("spls.sv")
),

tabPanel("Data Fitting",p(br()),
p(tags$b("Predicted Y")),
DT::DTOutput("spls.pres"),
p(br()),
p(tags$b("This plot shows how the coefficients changed to choose variables")),
numericInput("spls.y", "Which response (N'th dependent variable) to plot", 1, min = 1, step=1),
plotOutput("spls.bp"),
p(tags$b("Coefficient")),
DT::DTOutput("spls.coef")

),

tabPanel("Components", p(br()),
	p("This is components derived based on the selected variables"),
	  HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two scores, you can use the score plot to assess the data structure and detect clusters, outliers, and trends</li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
</ul>
  "),
    hr(),
uiOutput("g.s"),
uiOutput("type.s"),
p(tags$b("When A >=2, choose 2 different components to show component and loading 2D plot")),
numericInput("c1.s", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.s", "2. Component at y-axis", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("In this plot, we plot the scatter points of component1 and component2, and found 378 was outliers."))
),

	plotly::plotlyOutput("spls.s.plot"),
  DT::DTOutput("spls.s")
  ),

tabPanel("Loading", p(br()),
  p(tags$b("This is loadings derived based on the selected variables")),
	  HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)</li>
<li> Red indicates negative and blue indicates positive effects</li>
<li> Use the cumulative proportion of variance (in the variance table) to determine the amount of variance that the factors explain.</li>
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained. </li>
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the factors.</li>
</ul>
  "),
    hr(),
	plotly::plotlyOutput("spls.l.plot"),
  DT::DTOutput("spls.l")
  ),

tabPanel("Component and Loading 2D Plot", p(br()),
  p(tags$b("This is loadings derived based on the selected variables")),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot (biplots) overlays the components and the loadings (choose PC in the left panel)</li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
<li> Loadings identify which variables have the largest effect on each component.</li>
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.</li>
</ul>
  "),
    hr(),
p(tags$b("When A >=2, choose 2 different components to show component and loading 2D plot")),
numericInput("c11.s", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c22.s", "2. Component at y-axis", 2, min = 1, max = NA),
  plotly::plotlyOutput("spls.biplot")
  ),

tabPanel("Component and Loading 3D Plot" ,p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This is the extension for 2D plot. This plot overlays the components and the loadings for 3 PCs (choose PCs and the length of lines in the left panel)</li>
<li> This plot has similar functionality with 2D plots. Trace is the variables which can be hidden when click. </li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
<li> Loadings identify which variables have the largest effect on each component</li>
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.</li>
</ul>

  "),
hr(),
p(tags$b("This plot needs some time to load for the first time")),

p(tags$b("When A >=3, choose components to show factor and loading 3D plot")),
numericInput("td1.s", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2.s", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3.s", "3. Component at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.s", "4. (Optional) Change line scale (length)", 2, min = 1, max = NA),
plotly::plotlyOutput("tdplot.s"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace.s")
)
)

)

)