#****************************************************************************************************************************************************pcr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pcr {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pcr_r {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pcr_rmsep {overflow-y:scroll;background: white};")),
tags$head(tags$style("#pcr_msep {overflow-y:scroll; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; height: 200px; background: white};")),

h4(tags$b("Prepare the Model")),
p("Prepare the data in the Data tab"),
hr(),    

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x'), 
uiOutput('y'), 

numericInput("nc", "4. How many new components (a)", 4, min = 1, max = NA),
#p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),
radioButtons("val", "5. Whether to do cross-validation",
choices = c("No" = 'none',
           "10-fold cross-validation" = "CV",
           "Leave-one-out cross-validation" = "LOO"),
selected = 'none'),
hr(),

h4(tags$b("Step 2. If data and model are ready, click the blue button to generate model results.")),
actionButton("pcr1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))

),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(br()),
p(tags$b("Part of Data")),
 p("Please edit data in Data tab"),
DT::DTOutput("pcr.x"),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
#sactionButton("pcr1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
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

verbatimTextOutput("pcr"),
p(tags$b("R^2")),
verbatimTextOutput("pcr_r"),
p(tags$b("Mean square error of prediction (MSEP)")),
verbatimTextOutput("pcr_msep"),
p(tags$b("Root mean square error of prediction (RMSEP)")),
verbatimTextOutput("pcr_rmsep")

),

tabPanel("Data Fitting",p(br()),
  p("The first column (1 comps) is predicted using the 1st component, the second column (2 comps) are predicted using the 1st and 2nd components, and so forth."),
  p(tags$b("Predicted dependent variables")),
DT::DTOutput("pcr.pres"),br(),
  p(tags$b("Coefficient")),
DT::DTOutput("pcr.coef"),br(),
  p(tags$b("Residuals table (= predicted dependent variable - dependent variable)")),
DT::DTOutput("pcr.resi")
),

tabPanel("Component", p(br()),
HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two scores, you can use the score plot to assess the data structure and detect clusters, outliers, and trends
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
</ul>

<i> Click the button to show and update the result. 
<ul>
<li> In the plot of PC1 and PC2 (without group circle), we could find some outliers in the right. After soring PC1 in the table, we could see 70 is one of the outliers.
</ul></i>
  "),
hr(),
p(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
  plotly::plotlyOutput("pcr.s.plot", width = "80%"),
  DT::DTOutput("pcr.s")
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
  plotly::plotlyOutput("pcr.l.plot", width = "80%"),
  DT::DTOutput("pcr.l")
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
p(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c11", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c22", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
  plotly::plotlyOutput("pcr.bp", width = "80%")
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
numericInput("td1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3", "3. Component at z-axis", 3, min = 1, max = NA),
p("x y z must be different"),

numericInput("lines", "4. (Optional) Change line scale (length)", 20, min = 1, max = NA),
plotly::plotlyOutput("tdplot"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace")
)
)

)

)