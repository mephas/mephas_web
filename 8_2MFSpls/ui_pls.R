#****************************************************************************************************************************************************plsr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_r {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_rmsep {overflow-y:scroll;max-height: 300px; background: white};")),
tags$head(tags$style("#pls_msep {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),


h4(tags$b("Build the Model")),
p("Prepare the data in the Data tab"),
hr(), 
h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('y.r'), 
uiOutput('x.r'), 


numericInput("nc.r", "4. How many new components (A <= dimension of X)", 4, min = 1, max = NA),

radioButtons("val.r", "5. Whether to do cross-validation",
choices = c("No cross-validation" = 'none',
           "10-fold cross-validation" = "CV",
           "Leave-one-out cross-validation" = "LOO"),
selected = 'CV'),

radioButtons("method.r", "6. Which PLS algorithm",
  choices = c("SIMPLS: simple and fast" = 'simpls',
           "Kernel algorithm" = "kernelpls",
           "Wide kernel algorithm" = "widekernelpls",
           "Classical orthogonal scores algorithm" = "oscorespls"),
selected = 'simpls'),
p("These algorithms do not have much difference in the results"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("PLSR can use more than one dependent variables and find the linear relation between Y matrix and X matrix. 
  Thus, in this example, we used time, Diam, and Age as dependent variables, and other variables are independent variables.")),
p(tags$i("We wanted to find the components that had good predictive ability.")),
p(tags$i("From the data tab, we knew that X is a 20 by 25 matrix, so the maximum of a is 19. There will be error if A=20.")),
p(tags$i("In this example, we decided to choose 3 components (A=3), according to the MSEP and RMSEP. We used 10-fold CV and a simple and fast algorithm."))
),

hr(),

h4(tags$b("Step 2. If data and model are ready, click the blue button to generate model results.")),
#actionButton("pls1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pls1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(tags$b("Part of Data")),
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
<li> The results from 1 component, 2 component, ..., n components are given</li>
<li> 'CV' is the cross-validation estimate</li>
<li> 'adjCV' (for RMSEP and MSEP) is the bias-corrected cross-validation estimate</li>
<li> R^2 is equivalent to the squared correlation between the fitted values and the response. R^2 shown in train is the unadjusted one, while shown in CV is the adjusted one.</li>
<li> The number of components is recommended with high R^2 and low MSEP / RSMEP</li>
</ul>
"
),
p("10-fold cross-validation randomly split the data into 10 fold every time, so the results will not be exactly the same after a refresh."),
hr(),
verbatimTextOutput("pls"),
p(tags$b("R^2")),
verbatimTextOutput("pls_r"),
p(tags$b("Mean square error of prediction (MSEP)")),
verbatimTextOutput("pls_msep"),
p(tags$b("Root mean square error of prediction (RMSEP)")),
verbatimTextOutput("pls_rmsep"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("Because we chose more than one dependent variables (Y), the results were showed by each Y.")),
p(tags$i("PLSR generate new variables from both Y and X, so R^2 is better than PCR. Variance explained (%) in Y is also higher than PCR."))
)

),

tabPanel("Data Fitting",p(br()),

p(tags$b("Predicted Y")),
DT::DTOutput("pls.pres"),br(),
p(tags$b("Residuals (Y-Predicted Y)")),
DT::DTOutput("pls.resi"),br(),
p(tags$b("Coefficient")),
DT::DTOutput("pls.coef")

),

tabPanel("Component", p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two scores, you can use the score plot to assess the data structure and detect clusters, outliers, and trends</li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
</ul>
  "),
  hr(),

p(tags$b("When A >=2, choose 2 different components to show component and loading 2D plot")),
numericInput("c1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.r", "2. Component at y-axis", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("In this plot, we plot the scatter points of component1 and component2, and found 277 was one of the outliers."))
),
  plotly::plotlyOutput("pls.s.plot"),
  DT::DTOutput("pls.s")
  ),

tabPanel("Loading", p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)</li>
<li> Red indicates negative and blue indicates positive effects</li>
<li> Use the cumulative proportion of variance (in the variance table) to determine the amount of variance that the components explain. </li>
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained. </li>
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the components.</li>
</ul>
  "),
  hr(),
  plotly::plotlyOutput("pls.l.plot"),
  DT::DTOutput("pls.l")
  ),

tabPanel("Component and Loading 2D Plot", p(br()),
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
numericInput("c11.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c22.r", "2. Component at y-axis", 2, min = 1, max = NA),
  plotly::plotlyOutput("pls.bp")
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

p(tags$b("When A >=3, choose 3 different components to show component and loading 3D plot")),
numericInput("td1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2.r", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3.r", "3. Component at z-axis", 3, min = 1, max = NA),

numericInput("lines.r", "4. (Optional) Change line scale (length)", 0.1, min = 1, max = NA),
plotly::plotlyOutput("pls.tdplot"),
p(tags$b("Trace legend")),
verbatimTextOutput("pls_tdtrace")
)
)

)

)