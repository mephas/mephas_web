#****************************************************************************************************************************************************pca

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; max-height: 150px; background: white};")),

h4(tags$b("Build the Model")),
p("Prepare the data in the Data tab"),
hr(),       

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x'), 
p("The number of X should be < the number of samples (rows)"),

numericInput("nc", "2. How many components (a)", 4, min = 1, max = NA),
p(tags$i("According to the suggested results from parallel analysis, we chose to generate 4 components from the data")),

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

<i> Click the button to show and update the result. 
<ul>
<li> In the plot of PC1 and PC2 (without group circle), we could find some outliers in the up. After soring PC2 in the table, we could see 107 and 108 are two of the outliers.</li>
<li> In the plot of PC1 and PC2 (add group circle in Euclid distance), we could find chem2 is separated from chem3 and 5, and from others. </li>

</ul></i>
  "),
  hr(),
#checkboxInput("frame", tags$b("1. Add group circle in the component plot"), FALSE),
uiOutput('g'), 
radioButtons("type", "The type of ellipse",
 choices = c("T: assumes a multivariate t-distribution" = 't',
             "Normal: assumes a multivariate normal-distribution" = "norm",
             "Euclid: the euclidean distance from the center" = "euclid"),
 selected = 'euclid',
 width="500px"),
p(tags$b("2. When components >=2, choose 2 components to show component and loading 2D plot")),
p(tags$i("The default is to show the first 2 PCs for all the 2D plot")),
numericInput("c1", "2.1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "2.2. Component at y-axis", 2, min = 1, max = NA),
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
<i> Click the button to show and update the result. </li>
<ul>
<li> In the plot of PC1 and PC2, we could find chem1,7 have comparatively strong negative effect to PC1, and chem 4 has comparatively strong positive effect on PC1. For PC2, chem 8 has strong positive effect and chem3 has strong negative effect. 
The results are corresponding to the loading plot</li>
</ul></i>

  "),
p(tags$b("When components >=2, choose 2 components to show component and loading 2D plot")),
p(tags$i("The default is to show the first 2 PCs for all the 2D plot")),
numericInput("c11", "2.1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c22", "2.2. Component at y-axis", 2, min = 1, max = NA),
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
p(tags$b("When components >=3, choose 3 components to show component and loading 3D plot")),
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