#****************************************************************************************************************************************************fa

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x_fa {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#fa {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#tdtrace.fa {overflow-y:scroll; height: 150px; background: white};")),

h4(tags$b("Build the Model")),
p("Prepare the data in the Data tab"),
p("The number of variables (columns) should be < the number of samples (rows)"),
p(tags$i("Example data here is Mouse")),


hr(),     

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.fa'), 

numericInput("ncfa", "2. How many factors (A < dimension of X)", 3, min = 1, max = NA),
p(tags$i("According to the suggested results from the parallel analysis, we chose to generate 3 factors from the data")),
hr(),
h4(tags$b("Step 2. If data and model are ready, click the blue button to generate model results.")),

#actionButton("pca1.fa", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pca1.fa", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. Data Explores")),

tags$b("Part of Data"),
p("Please edit data in Data tab"),
DT::DTOutput("table.x.fa"),

hr(),

h4(tags$b("Output 2. Model Results")),
#actionButton("pca1.fa", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
# p(br()),

tabsetPanel(
tabPanel("Factors Result",p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the factor relations to the variables</li>
<li> Results in the window show the statistical test for the sufficiency of factors.</li>
</ul>

  "),
    hr(),
  plotOutput("pca.ind.fa"),
  verbatimTextOutput("fa")),

tabPanel("Factors", p(br()),
HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the relations from two factors, you can use the score plot to assess the data structure and detect clusters, outliers, and trends</li>
<li> Groupings of data on the plot may indicate two or more separate distributions in the data</li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
</ul>
"),
hr(),

uiOutput('g.fa'), 
uiOutput('type.fa'),
p(tags$b("2. When A >=2, choose 2 factors to show component and loading 2D plot")),
numericInput("c1.fa", "2.1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.fa", "2.2. Component at y-axis", 2, min = 1, max = NA),
conditionalPanel(
condition = "input.explain_on_off",
tags$i("In the plot of ML1 and ML2, we could find some outliers, for example, 169 and 208. We can remove these points in Data tab.
If we chose type and add group circle in Euclid distance, we could find B group was somewhat different. Not all the groups had circles due to the number of points were too less.")
),
plotly::plotlyOutput("fa.ind", ),

DT::DTOutput("comp.fa")
  ),

tabPanel("Loading", p(br()),
	    HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)</li>
<li> Red indicates negative and blue indicates positive effects</li>
<li> Use the proportion of variance (in the variance table) to determine the amount of variance that the factors explain. </li>
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained. </li>
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the factors.</li>
</ul>

  "),
      hr(),
	plotly::plotlyOutput("pca.ind.fa2"),
	p(tags$b("Loadings")),
  DT::DTOutput("load.fa"),
  p(tags$b("Variance table")),
  DT::DTOutput("var.fa")  ),

tabPanel("Factors and Loading 2D Plot" ,p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot (biplots) overlays the factors and the loadings (choose PC in the left panel)</li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
<li> Loadings identify which variables have the largest effect on each component</li>
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.</li>
</ul>
  "),
    hr(),
p(tags$b("When A >=2, choose 2 factors to show factors and loading 2D plot")),
numericInput("c1.fa", "1. Factor at x-axis", 1, min = 1, max = NA),
numericInput("c2.fa", "2. Factor at y-axis", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
tags$i("After removing the points 169 and 208, we could find chem2 have comparatively strong relation to ML2.")
),

plotly::plotlyOutput("fa.bp")

),

tabPanel("Factors and Loading 3D Plot" ,p(br()),
HTML("
  <b>Explanations</b>
<ul>
<li> This is the extension for 2D plot. This plot overlays the factors and the loadings for 3 PCs (choose PCs and the length of lines in the left panel)</li>
<li> We can find the outliers in the plot. </li>
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero</li>
<li> Loadings identify which variables have the largest effect on each component</li>
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.</li>
</ul>

  "),
hr(),
p(tags$b("This plot needs some time to load for the first time")),
p(tags$b("When A >=3, choose 3 factors to show factors and loading 3D plot")),
p(tags$i("The default is to show the first 3 factors in the 3D plot")),
numericInput("td1.fa", "1. Factor at x-axis", 1, min = 1, max = NA),
numericInput("td2.fa", "2. Factor at y-axis", 2, min = 1, max = NA),
numericInput("td3.fa", "3. Factor at z-axis", 3, min = 1, max = NA),

numericInput("lines.fa", "4. (Optional) Change line scale (length)", 10, min = 1, max = NA),
plotly::plotlyOutput("tdplot.fa"),
p(tags$b("Trace legend")),
verbatimTextOutput("tdtrace.fa")
)

)

)
)