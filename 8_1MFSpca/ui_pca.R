#****************************************************************************************************************************************************pca

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 150px; background: white};")),

h4(tags$b("Build the Model")),
p("Prepare the data in the Data tab"),
p("The number of variables (columns) should be < the number of samples (rows)"),
p(tags$i("Example data here is Chemical")),
hr(),       

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x'), 

numericInput("nc", "2. How many components (A < dimension of X)", 3, min = 1, max = NA),

hr(),

h4(tags$b("Step 2. If data and model are ready, click the blue button to generate model results.")),
#actionButton("pca1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pca1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()

),

mainPanel(

h4(tags$b("Output 1. Data Explores")),
tabsetPanel(
tabPanel("Parallel Analysis", p(br()),
plotOutput("pc.plot", ),
verbatimTextOutput("pcncomp")
),
tabPanel("Correlation Matrix", p(br()),
plotOutput("cor.plot", ),p(br()),
DT::DTOutput("cor")
),

tabPanel("Part of Data", br(),
 p("Please edit data in Data tab"),
DT::DTOutput("table.x")
)

  ),

hr(),
h4(tags$b("Output 2. Model Results")),
#actionButton("pca1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 #p(br()),

tabsetPanel(

tabPanel("Components", p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two components, you can use the score plot to assess the data structure and detect clusters, outliers, and trends</li>
<li> Groupings of data on the plot may indicate two or more separate distributions in the data</li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
</ul>
  "),
  hr(),

uiOutput('g'), 
uiOutput('type'),

p(tags$b("2. When A >=2, choose 2 components to show component and loading 2D plot")),
numericInput("c1", "2.1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "2.2. Component at y-axis", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("In the plot of PC1 and PC2 (without group circle), we could find some outliers, for example, 11 and 23.
If we chose diet and add group circle in Euclid distance, we could find diet type sun was separated from others.")
),
plotly::plotlyOutput("pca.ind", ),
DT::DTOutput("comp")
  ),

tabPanel("Loading", p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)</li>
<li> Red indicates negative and blue indicates positive effects</li>
<li> Use the cumulative proportion of variance (in the variance table) to determine the amount of variance that the factors explain. </li>
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained. </li>
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the factors.</li>
</ul>
  "),
    hr(),
  plotly::plotlyOutput("pca.ind2", ),
  p(tags$b("Loadings")),
  DT::DTOutput("load"),
  p(tags$b("Variance table")),
  DT::DTOutput("var")
  ),
tabPanel("Component and Loading 2D Plot" ,p(br()),
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
p(tags$b("When A >=2, choose 2 components to show component and loading 2D plot")),
numericInput("c11", "2.1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c22", "2.2. Component at y-axis", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("In the plot of PC1 and PC2, we could find ACAT2 have comparatively strong negative effect to PC1, and PKD4 has strong positive effect on PC1. 
For PC2, THIOL has strong positive effect and VDR has strong negative effect. 
The results are corresponding to the loading plot")
),

plotly::plotlyOutput("pca.bp", )

),

tabPanel("Component and Loading 3D Plot" ,p(br()),
HTML("
  <b>Explanations</b>
<ul>
<li> This is the extension for 2D plot. This plot overlays the components and the loadings for 3 PCs (choose PCs and the length of lines in the left panel)</li>
<li> We can find the outliers in the plot. </li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
<li> Loadings identify which variables have the largest effect on each component</li>
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.</li>
</ul>

  "),
hr(),
p(tags$b("This plot needs some time to load for the first time")),
p(tags$b("When A >=3, choose 3 components to show component and loading 3D plot")),
p(tags$i("The default is to show the first 3 PC in the 3D plot")),
numericInput("td1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("td2", "2. Component at y-axis", 2, min = 1, max = NA),
numericInput("td3", "3. Component at z-axis", 3, min = 1, max = NA),

numericInput("lines", "4. (Optional) Change line scale (length)", 10, min = 1, max = NA),
plotly::plotlyOutput("tdplot"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace")
)
)

)

)