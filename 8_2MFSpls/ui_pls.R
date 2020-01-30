#****************************************************************************************************************************************************plsr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_r {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_rmsep {overflow-y:scroll;max-height: 300px; background: white};")),
tags$head(tags$style("#pls_msep {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),


h4(tags$b("Prepare the Model")),
p("Prepare the data in the Data tab"),
hr(), 
h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.r'), 
uiOutput('y.r'), 

numericInput("nc.r", "4. How many new components (a)", 4, min = 1, max = NA),

radioButtons("val.r", "5. Whether to do cross-validation",
choices = c("No cross-validation" = 'none',
           "10-fold cross-validation" = "CV",
           "Leave-one-out cross-validation" = "LOO"),
selected = 'none'),

radioButtons("method.r", "6. Which PLS algorithm",
  choices = c("SIMPLS: simple and fast" = 'simpls',
           "Kernel algorithm" = "kernelpls",
           "Wide kernel algorithm" = "widekernelpls",
           "Classical orthogonal scores algorithm" = "oscorespls"),
selected = 'simpls'),
hr(),

h4(tags$b("Step 2. If data and model are ready, click the blue button to generate model results.")),
actionButton("pls1", h4(tags$b("Show Results >>")), class = "btn btn-primary")

),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(tags$b("First Part of Data"),
 p("Please edit data in Data tab"),
DT::DTOutput("pls.x"),

hr(),
#actionButton("pls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. Model Results")),

tabsetPanel(
tabPanel("Result",p(br()),

HTML(
"
<b>Explanations</b>

<ul>
<li> The results from 1 component, 2 component, ... n components are given
<li> 'CV' is the cross-validation estimate
<li> 'adjCV' (for RMSEP and MSEP) is the bias-corrected cross-validation estimate
<li> R^2 is equivalent to the squared correlation between the fitted values and the response
<li> The number of components are recommended with high R^2 and low MSEP / RSMEP
</ul>
"
),
p("10-fold cross-validation randomly split the data into 10 fold every time, so the results will not be exactly the same after refresh."),

verbatimTextOutput("pls"),
p(tags$b("R^2")),
verbatimTextOutput("pls_r"),
p(tags$b("Mean square error of prediction (MSEP)")),
verbatimTextOutput("pls_msep"),
p(tags$b("Root mean square error of prediction (RMSEP)")),
verbatimTextOutput("pls_rmsep")

),

tabPanel("Data Fitting",p(br()),
p("The first column (1 comps) is predicted using the 1st component, the second column (2 comps) are predicted using the 1st and 2nd components, and so forth."),

p(tags$b("Predicted dependent variables")),
DT::DTOutput("pls.pres"),br(),
p(tags$b("Coefficient")),
DT::DTOutput("pls.coef"),br(),
p(tags$b("Residuals table (= predicted dependent variable - dependent variable)")),
DT::DTOutput("pls.resi")
),

tabPanel("Components", p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two scores, you can use the score plot to assess the data structure and detect clusters, outliers, and trends
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
</ul>
  "),
  hr(),

h4(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.r", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),

  plotly::plotlyOutput("pls.s.plot", width = "80%"),
  DT::DTOutput("pls.s")
  ),

tabPanel("Loading", p(br()),
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
  plotly::plotlyOutput("pls.l.plot", width = "80%"),
  DT::DTOutput("pls.l")
  ),

tabPanel("Component and Loading 2D Plot", p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot (biplots) overlays the components and the loadings (choose PC in the left panel)
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
<li> Loadings identify which variables have the largest effect on each component.
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.
</ul>

  "),
    hr(),

h4(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c11.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c22.r", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
  plotly::plotlyOutput("pls.bp", width = "80%")
  ),

tabPanel("Component and Loading 3D Plot" ,p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This is the extension for 2D plot. This plot overlays the components and the loadings for 3 PCs (choose PCs and the length of lines in the left panel)
<li> We can find the outliers in the plot. 
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
<li> Loadings identify which variables have the largest effect on each component
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.
</ul>
  "),
hr(),
p(tags$b("This plot needs some time to load for the first time")),

p(tags$b("When #comp >=3, choose components to show factor and loading 3D plot")),
numericInput("td1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2.r", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3.r", "3. Component at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines.r", "4. (Optional) Change line scale (length)", 0.1, min = 1, max = NA),
plotly::plotlyOutput("pls.tdplot"),
p(tags$b("Trace legend")),
verbatimTextOutput("pls_tdtrace")
)
)

)

)