##'
##' MFSpls includes 
##' (1) principal component regression
##' (2) partial least squares regression
##' and (3) sparse partial least squares regression
##'
##' @title MEPHAS: Dimensional analysis 2 (Advanced Method)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom pls mvr R2 MSEP RMSEP
##' @importFrom spls cv.spls spls
##'
##' @examples
##' # mephas::MFSpls()
##' #
##' # library(mephas)
##' # MFSpls()

##' @export
MFSpls <- function(){

requireNamespace("shiny")
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(


title = "Dimensional Analysis 2",

##########----------##########----------##########

tabPanel("Dataset",

titlePanel("Data Preparation"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> The data need to be all numeric
<li> The data used to build model is called <b>training set</b>
</ul> 

<i><h4>Case Example 1: NKI data</h4>

Suppose we wanted to explore 100 lymph node positive breast cancer patients on metastasis-free survival. 
Data contained the clinical risk factors: (1) Age: Patient age at diagnosis (years) and (2) the year until relapse; 
and gene expression measurements of 70 genes found to be prognostic for metastasis-free survival in an earlier study.
In this example, we wanted to create a model that could find the relations between risk factors and gene expression measurements. 

</i>

<i><h4>Case Example 2 Liver toxicity data</h4>

This data set contains the expression measure of 3116 genes and 10 clinical measurements for 64 subjects (rats) that were exposed to non-toxic, moderately toxic or severely toxic doses of acetaminophen in a controlled experiment.

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
#source("0data_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; height: 100px; background: white};")),

selectInput("edata", h4(tags$b("Use example data (training set)")), 
        choices =  c("NKI", "Liver"), 
        selected = "NKI"),
hr(),

h4(tags$b("Use my own data (training set)")),
p("We suggested putting the dependent variable (Y) in the left side of all independent variables (X) "),

h4(tags$b("Step 1. Upload Data File")), 

fileInput('file', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")), 
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")), 
checkboxInput("col", "Yes", TRUE),

radioButtons("sep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("quote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets"),

h4(tags$b("(Optional) Change the types of some variable?")),

#p(tags$b("Choice 1. Change Real-valued Variables into Categorical Variable")), 

uiOutput("factor1"),

#p(tags$b("Choice 2. Change Categorical Variable (Numeric Factors) into Numeric Variables (Numbers)")),

uiOutput("factor2")

),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")), 
p(br()),
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),

hr(),   
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variable)")

),

tabPanel("Linear fitting plot",p(br()),

HTML("<p><b>Linear fitting plot</b>: to roughly show the linear relation between any two numeric variable. Grey area is 95% confidence interval.</p>"),

uiOutput('tx'),
uiOutput('ty'),

plotOutput("p1", width = "80%")
),

tabPanel("Histogram", p(br()),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
p(tags$b("Histogram")),
plotOutput("p2", width = "80%"),
sliderInput("bin", "The width of bins in the histogram", min = 0, max = 2, value = 0.05),
p(tags$b("Density plot")),
plotOutput("p21", width = "80%"))

)

)

),
hr()

),


##########----------##########----------##########
tabPanel("PCR",

titlePanel("Principal Component Regression"),
HTML(
"
<b>Principal component regression (PCR)</b> is a regression analysis technique that is based on principal component analysis (PCA). It finds hyperplanes of maximum variance between the response and independent variables.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get correlation matrix and plot
<li> To get the results from model 
<li> To get the factors and loadings result tables and 
<li> To get the factors and loadings distribution plots 
<li> To get the predicted dependent variables 
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> Data used to build the model is called <b>training set</b>

</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
#source("pcr_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************pcr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pcr {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pcr_r {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pcr_rmsep {overflow-y:scroll;background: white};")),
tags$head(tags$style("#pcr_msep {overflow-y:scroll; background: white};")),
tags$head(tags$style("#tdtrace {overflow-y:scroll; height: 200px; background: white};")),

h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x'), 
uiOutput('y'), 

numericInput("nc", "4. How many new components (a)", 4, min = 1, max = NA),
#p("If data are complete, 'pca' uses Singular Value Decomposition; if there are some missing values, it uses the NIPALS algorithm."),

hr(),
h4(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different")

),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(br()),
p(tags$b("Browse")),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("pcr.x"),

hr(),
#p("Please make sure both X and Y have been prepared. If Error happened, please check your X and Y data."),
actionButton("pcr1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Result",p(br()),
radioButtons("val", "Whether to do cross-validation",
choices = c("No" = 'none',
           "10-fold cross-validation" = "CV",
           "Leave-one-out cross-validation" = "LOO"),
selected = 'none'),
p("10-fold cross-validation randomly split the data into 10 fold every time, so the results will not be exactly the same after refresh."),

verbatimTextOutput("pcr"),
p(tags$b("R^2")),
verbatimTextOutput("pcr_r"),
p(tags$b("Mean square error of prediction (MSEP)")),
verbatimTextOutput("pcr_msep"),
p(tags$b("Root mean square error of prediction (RMSEP)")),
verbatimTextOutput("pcr_rmsep"),

HTML(
"
Explanations

<ul>
<li> The results from 1 component, 2 component, ... n components are given
<li> 'CV' is the cross-validation estimate
<li> 'adjCV' (for RMSEP and MSEP) is the bias-corrected cross-validation estimate
<li> R^2 is equivalent to the squared correlation between the fitted values and the response
<li> The number of components are recommended with high R^2 and low MSEP / RSMEP
</ul>
"
)
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
  plotOutput("pcr.s.plot", width = "80%"),
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
  plotOutput("pcr.l.plot", width = "80%"),
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
  plotOutput("pcr.bp", width = "80%")
  )
)

)

),
hr()

), 

##########----------##########----------##########


tabPanel("Prediction1",

titlePanel("Prediction after Principal Component Regression"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in the same study, we got more measurements and wanted to predict the outcome.

</h4></i>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),

hr(),
#source("pr1_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************pcr-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Use example data (test set)")),
h4("Click the Output"),

hr(),

h4(tags$b("Use my own data (test set)")),
p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

h4(tags$b("Step 1. Upload New Data File")),      

fileInput('newfile', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol", "Yes", TRUE),

radioButtons("newsep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input")
),


mainPanel(

h4(tags$b("Output. Data Preview")),
DT::DTOutput("newX"),
hr(),
actionButton("B.pcr", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Predicted Dependent Variable",p(br()),
p("The first column (1 comps) is predicted value when #comp is 1, the second column (2 comps) is predicted value when #comp is 2, and so forth."),
DT::DTOutput("pred.lp")
),

tabPanel("Predicted Components",p(br()),
DT::DTOutput("pred.comp")
)
) 
) 
),
hr()

),

##########----------##########----------##########
tabPanel("PLSR",

titlePanel("Partial Least Squares Regression"),
HTML(
"
<b>Partial least squares regression (PLSR)</b> is a regression analysis technique that finds a linear regression model by projecting the predicted variables and the observable variables to a new space.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get correlation matrix and plot
<li> To get the results from model 
<li> To get the factors and loadings result tables and 
<li> To get the factors and loadings distribution plots 
<li> To get the predicted dependent variables 
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> Data used to build the model is called <b>training set</b>

</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),

hr(),
#source("plsr_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************plsr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pls {overflow-y:scroll; height: 300px; background: white};")),
tags$head(tags$style("#pls_r {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pls_rmsep {overflow-y:scroll;background: white};")),
tags$head(tags$style("#pls_msep {overflow-y:scroll; background: white};")),
tags$head(tags$style("#pls_tdtrace {overflow-y:scroll; height: 200px; background: white};")),


h4("Example data is upload in Data tab"),      

h4(tags$b("Step 1. Choose parameters to build the model")),    

uiOutput('x.r'), 
uiOutput('y.r'), 

numericInput("nc.r", "4. How many new components (a)", 4, min = 1, max = NA),

hr(),
h4(tags$b("When #comp >=2, choose components to show factor and loading 2D plot")),
numericInput("c1.r", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2.r", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different")
),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
p(br()),
p(tags$b("Browse")),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("pls.x"),

hr(),
actionButton("pls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Result",p(br()),
radioButtons("val.r", "Whether to do cross-validation",
choices = c("No cross-validation" = 'none',
           "10-fold cross-validation" = "CV",
           "Leave-one-out cross-validation" = "LOO"),
selected = 'none'),
p("10-fold cross-validation randomly split the data into 10 fold every time, so the results will not be exactly the same after refresh."),

radioButtons("method.r", "Which PLS algorithm",
  choices = c("SIMPLS: simple and fast" = 'simpls',
           "Kernel algorithm" = "kernelpls",
           "Wide kernel algorithm" = "widekernelpls",
           "Classical orthogonal scores algorithm" = "oscorespls"),
selected = 'simpls'),


verbatimTextOutput("pls"),
p(tags$b("R^2")),
verbatimTextOutput("pls_r"),
p(tags$b("Mean square error of prediction (MSEP)")),
verbatimTextOutput("pls_msep"),
p(tags$b("Root mean square error of prediction (RMSEP)")),
verbatimTextOutput("pls_rmsep"),
HTML(
"
Explanations

<ul>
<li> The results from 1 component, 2 component, ... n components are given
<li> 'CV' is the cross-validation estimate
<li> 'adjCV' (for RMSEP and MSEP) is the bias-corrected cross-validation estimate
<li> R^2 is equivalent to the squared correlation between the fitted values and the response
<li> The number of components are recommended with high R^2 and low MSEP / RSMEP
</ul>
"
)
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
  plotOutput("pls.s.plot", width = "80%"),
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
  plotOutput("pls.l.plot", width = "80%"),
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
  plotOutput("pls.bp", width = "80%")
  )
)

)

),
hr()
),

##########----------##########----------##########


tabPanel("Prediction2",

titlePanel("Prediction after Partial Least Squares Regression"),
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in the same study, we got more measurements and wanted to predict the outcome.

</h4></i>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
#source("pr2_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************pls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Use example data (test set)")),
h4("Click the Output"),

hr(),

h4(tags$b("Use my own data (test set)")),
p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

h4(tags$b("Step 1. Upload New Data File")),      

fileInput('newfile.pls', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader.pls", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol.pls", "Yes", TRUE),
radioButtons("newsep.pls", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote.pls", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input")
),


mainPanel(

h4(tags$b("Output. Data Preview")),
DT::DTOutput("newX.pls"),
hr(),
actionButton("B.pls", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),
tabsetPanel(
tabPanel("Predicted dependent variables",p(br()),

DT::DTOutput("pred.lp.pls")
),

tabPanel("Predicted Components",p(br()),
DT::DTOutput("pred.comp.pls")
)
) 
) 
),
hr()

),

##########----------##########----------##########
tabPanel("SPLSR",

titlePanel("Sparse Partial Least Squares Regression"),
HTML(
"
<b>Sparse partial least squares regression (SPLSR)</b> is a regression analysis technique that aims simultaneously to achieve good predictive performance and variable selection by producing sparse linear combinations of the original predictors.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get correlation matrix and plot
<li> To get the results from model 
<li> To get the factors and loadings result tables and 
<li> To get the factors and loadings distribution plots 
<li> To get the predicted dependent variables 
</ul>

<h4><b> 2. About your data (training set) </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> Data used to build the model is called <b>training set</b>
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
#source("spls_ui.R", local=TRUE, encoding="UTF-8")$value
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
p("x and y must be different")
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
  )
)

)

),
hr()
),

##########----------##########----------##########

tabPanel("Prediction3",

    titlePanel("Prediction after Partial Least Squares Regression"),
HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in the same study, we got more measurements and wanted to predict the outcome.

</h4></i>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),


hr(),
#source("pr3_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************spls-pred

sidebarLayout(

sidebarPanel(

h4(tags$b("Use example data (test set)")),
h4("Click the Output"),

hr(),

h4(tags$b("Use my own data (test set)")),
p("New data should include all the variables in the model"),
p("We suggested putting the dependent variable (Y) (if existed) in the left side of all independent variables (X)"),

h4(tags$b("Step 1. Upload New Data File")),      

fileInput('newfile.spls', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")),
checkboxInput("newheader.spls", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("newcol.spls", "Yes", TRUE),

     # Input: Select separator ----
radioButtons("newsep.spls", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often use this"),
    HTML("One Tab (->|): TXT often use this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("newquote.spls", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input")
),


mainPanel(

h4(tags$b("Output. Data Preview")),
DT::DTOutput("newX.spls"),
hr(),
actionButton("B.spls", h4(tags$b("Click 2: Output. Prediction Results / Refresh, given model and new data are ready. ")), style="color: #fff; background-color: #337ab7; border-color: #2e6da4"), 
p(br()),

DT::DTOutput("pred.lp.spls")

) 
),
hr()

),

##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

#source("0data_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************

#load("pls.RData")


data <- reactive({
                switch(input$edata,
               "NKI" = nki2.train,
               "Liver" = liver.train)
               #"Independent variable matrix (Gene sample2)" = genesample2)
        })

DF0 <- reactive({
  # req(input$file)
  inFile <- input$file
  if (is.null(inFile)){
    x<-data()
    }
  else{
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})

type.num0 <- reactive({
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. Convert real-valued numeric variable into categorical variable'),
  selected = NULL,
  choices = type.num0(),
  multiple = TRUE
)
})

DF1 <- reactive({
df <-DF0() 
df[input$factor1] <- as.data.frame(lapply(df[input$factor1], factor))
return(df)
  })

type.fac1 <- reactive({
colnames(DF1()[unlist(lapply(DF1(), is.factor))])
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  HTML('2. Convert categorical variable into real-valued numeric variable'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.fac1(),
  multiple = TRUE
)
})

X <- reactive({
  df <-DF1() 
df[input$factor2] <- as.data.frame(lapply(df[input$factor2], as.numeric))
return(df)
  })

type.fac2 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

 output$Xdata <- DT::renderDT({
  if (ncol(X())>1000 || nrow(X())>1000) {X()[,1:1000]}
  else { X()}
  }, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))


type.num3 <- reactive({
colnames(X()[unlist(lapply(X(), is.numeric))])
})

type.fac3 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$strnum <- renderPrint({str(X()[,type.num3()])})
output$strfac <- renderPrint({Filter(Negate(is.null), lapply(X(),levels))})

sum <- reactive({
  x <- X()[,type.num3()]
  res <- as.data.frame(psych::describe(x))[,-c(1,6,7)]
  rownames(res) = names(x)
  colnames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$sum <- DT::renderDT({sum()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

fsum = reactive({
  x <- X()[,type.fac3()]
  summary(x)
  })

output$fsum = renderPrint({fsum()})

 output$download2 <- downloadHandler(
     filename = function() {
       "lr.des2.txt"
     },
     content = function(file) {
       write.table(fsum(), file, row.names = TRUE)
     }
   )

# First Exploration of Variables

output$tx = renderUI({
   selectInput(
     'tx', 
     tags$b('1. Choose a numeric variable for the x-axis'),
     selected=type.num3()[2],
     choices = type.num3())
   })
 
 output$ty = renderUI({
   selectInput(
     'ty',
     tags$b('2. Choose a numeric variable for the y-axis'),
     selected = type.num3()[1],
     choices = type.num3())
   
 })

 output$p1 = renderPlot({

   ggplot(X(), aes(x = X()[, input$tx], y = X()[, input$ty])) + geom_point(shape = 1) + 
     geom_smooth(method = "lm") + xlab(input$tx) + ylab(input$ty) + theme_minimal()
   })

## histogram
output$hx = renderUI({

  selectInput(
    'hx',
     tags$b('Choose a numeric variable'),
     selected = type.num3()[1], 
     choices = type.num3())
})

output$p2 = renderPlot({
   ggplot(X(), aes(x = X()[, input$hx])) + 
     geom_histogram(binwidth = input$bin, colour = "black",fill = "grey") + 
     #geom_density()+
     xlab("") + theme_minimal() + theme(legend.title = element_blank())
   })

output$p21 = renderPlot({
   ggplot(X(), aes(x = X()[, input$hx])) + 
     #geom_histogram(binwidth = input$bin, colour = "black",fill = "white") + 
     geom_density() + 
     xlab("") + theme_minimal() + theme(legend.title = element_blank())
   })

#source("pcr_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************pcr

output$x = renderUI({
selectInput(
'x',
tags$b('1. Choose independent variable matrix (X)'),
selected = type.num3()[-c(1:3)],
choices = type.num3(),
multiple = TRUE
)
})

DF4 <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$x))]
return(df)
  })

output$y = renderUI({
selectInput(
'y',
tags$b('2. Choose one dependent variable (Y)'),
selected = names(DF4())[1],
choices = names(DF4()),
multiple = FALSE
)
})


output$pcr.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

#output$nc <- renderText({input$nc})
# model
pcr <- eventReactive(input$pcr1,{

  Y <- as.matrix(X()[,input$y])
  X <- as.matrix(X()[,input$x])
  validate(need(min(ncol(X), nrow(X))>input$nc, "Please input enough independent variables"))
  validate(need(input$nc>=1, "Please input correct number of components"))
  pls::mvr(Y~X, ncomp=input$nc, validation=input$val, model=FALSE, method = "svdpc",scale = TRUE, center = TRUE)
  })

#pca.x <- reactive({ pca()$x })

#output$fit  <- renderPrint({
#  res <- rbind(pca()$explained_variance,pca()$cum.var)
#  rownames(res) <- c("explained_variance", "cumulative_variance")
#  res})
output$pcr  <- renderPrint({
  summary(pcr())
  })

output$pcr_r  <- renderPrint({
  pls::R2(pcr(),estimate = "all")
  })

output$pcr_msep  <- renderPrint({
  pls::MSEP(pcr(),estimate = "all")
  })

output$pcr_rmsep  <- renderPrint({
  pls::RMSEP(pcr(),estimate = "all")
  })

output$pcr.s <- DT::renderDT({as.data.frame(pcr()$scores[,1:pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.l <- DT::renderDT({as.data.frame(pcr()$loadings[,1:pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.pres <- DT::renderDT({as.data.frame(pcr()$fitted.values[,,1:pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.coef <- DT::renderDT({as.data.frame(pcr()$coefficients)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pcr.resi <- DT::renderDT({as.data.frame(pcr()$residuals[,,1:pcr()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$pcr.s.plot  <- renderPlot({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
df <- as.data.frame(pcr()$scores[,1:pcr()$ncomp])

  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Score", input$c1))+ylab(paste0("Score", input$c2))

  })

output$pcr.l.plot  <- renderPlot({ 
ll <- as.data.frame(pcr()$loadings[,1:pcr()$ncomp])
ll$group <- rownames(ll)
loadings.m <- reshape::melt(ll, id="group",
                   measure=colnames(ll)[1:pcr()$ncomp])

ggplot(loadings.m, aes(loadings.m$group, abs(loadings.m$value), fill=loadings.m$value)) + 
  facet_wrap(~ loadings.m$variable, nrow=1) + #place the factors in separate facets
  geom_bar(stat="identity") + #make the bars
  coord_flip() + #flip the axes so the test names can be horizontal  
  #define the fill color gradient: blue=positive, red=negative
  scale_fill_gradient2(name = "Loading", 
                       high = "blue", mid = "white", low = "red", 
                       midpoint=0, guide=F) +
  ylab("Loading Strength") + #improve y-axis label
  theme_bw(base_size=10)

  })

output$pcr.bp   <- renderPlot({ 
validate(need(input$nc>=2, "The number of components must be >= 2"))
plot(pcr(), plottype = c("biplot"), comps=c(input$c1,input$c2),var.axes = TRUE, main="")
})


#source("pr1_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************pcr-pred

newX = reactive({
  inFile = input$newfile
  if (is.null(inFile)){
    if (input$edata=="NKI") {x <- nki2.test}
    else {x<- liver.test}
    }
  else{
if(!input$newcol){
    csv <- read.csv(inFile$datapath, header = input$newheader, sep = input$newsep, quote=input$newquote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader, sep = input$newsep, quote=input$newquote, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})
#prediction plot
# prediction
output$newX  = DT::renderDT({newX()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

pred.lp = eventReactive(input$B.pcr,
{ as.data.frame(predict(pcr(), newdata = as.matrix(newX())[,input$x], type="response")[,,1:pcr()$ncomp])
})

pred.comp = eventReactive(input$B.pcr,
{as.data.frame(predict(pcr(), newdata = as.matrix(newX())[,input$x], type="scores"))
})



output$pred.lp = DT::renderDT({
pred.lp()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

output$pred.comp = DT::renderDT({
pred.comp()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


#source("plsr_server.R", local=TRUE, encoding="UTF-8") 
#****************************************************************************************************************************************************plsr

output$x.r = renderUI({
selectInput(
'x.r',
tags$b('1. Choose independent variable matrix (X)'),
selected = type.num3()[-c(1:3)],
choices = type.num3(),
multiple = TRUE
)
})

DF4.r <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$x.r))]
return(df)
  })

output$y.r = renderUI({
selectInput(
'y.r',
tags$b('2. Choose one or more dependent variables (Y)'),
selected = names(DF4.r())[1],
choices = names(DF4.r()),
multiple = TRUE
)
})


output$pls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

#output$nc.r <- renderText({input$nc.r})
# model
pls <- eventReactive(input$pls1,{

  Y <- as.matrix(X()[,input$y.r])
  X <- as.matrix(X()[,input$x.r])
  validate(need(min(ncol(X), nrow(X))>input$nc.r, "Please input enough independent variables"))
  validate(need(input$nc.r>=1, "Please input correct number of components"))
  pls::mvr(Y~X, ncomp=input$nc.r, validation=input$val.r, model=FALSE, method = input$method.r,scale = TRUE, center = TRUE)
  })

output$pls  <- renderPrint({
  summary(pls())
  })

output$pls_r  <- renderPrint({
  pls::R2(pls(),estimate = "all")
  })

output$pls_msep  <- renderPrint({
  pls::MSEP(pls(),estimate = "all")
  })

output$pls_rmsep  <- renderPrint({
  pls::RMSEP(pls(),estimate = "all")
  })

output$pls.s <- DT::renderDT({as.data.frame(pls()$scores[,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.l <- DT::renderDT({as.data.frame(pls()$loadings[,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.pres <- DT::renderDT({as.data.frame(pls()$fitted.values[,,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.coef <- DT::renderDT({as.data.frame(pls()$coefficients)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$pls.resi <- DT::renderDT({as.data.frame(pls()$residuals[,,1:pls()$ncomp])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$pls.s.plot  <- renderPlot({ 
validate(need(input$nc.r>=2, "The number of components must be >= 2"))
df <- as.data.frame(pls()$scores[,1:input$nc.r])

  ggplot(df, aes(x = df[,input$c1], y = df[,input$c2]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Comp", input$c1))+ylab(paste0("Comp", input$c2))

  })

output$pls.l.plot  <- renderPlot({ 
ll <- as.data.frame(pls()$loadings[,1:input$nc.r])
ll$group <- rownames(ll)
loadings.m <- reshape::melt(ll, id="group",
                   measure=colnames(ll)[1:input$nc.r])

ggplot(loadings.m, aes(loadings.m$group, abs(loadings.m$value), fill=loadings.m$value)) + 
  facet_wrap(~ loadings.m$variable, nrow=1) + #place the factors in separate facets
  geom_bar(stat="identity") + #make the bars
  coord_flip() + #flip the axes so the test names can be horizontal  
  #define the fill color gradient: blue=positive, red=negative
  scale_fill_gradient2(name = "Loading", 
                       high = "blue", mid = "white", low = "red", 
                       midpoint=0, guide=F) +
  ylab("Loading Strength") + #improve y-axis label
  theme_bw(base_size=10)

  })

output$pls.bp   <- renderPlot({ 
  validate(need(input$nc.r>=2, "The number of components must be >= 2"))
plot(pls(), plottype = c("biplot"), comps=c(input$c1.r,input$c2.r),var.axes = TRUE)
})


#source("pr2_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************pls-pred

newX.pls = reactive({
  inFile = input$newfile.pls
  if (is.null(inFile)){
    if (input$edata=="NKI") {x <- nki2.test}
    else {x<- liver.test}
    }
  else{
if(!input$newcol.pls){
    csv <- read.csv(inFile$datapath, header = input$newheader.pls, sep = input$newsep.pls, quote=input$newquote.pls)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader.pls, sep = input$newsep.pls, quote=input$newquote.pls, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})
#prediction plot
# prediction
output$newX.pls  = DT::renderDT({newX.pls()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

pred.lp.pls = eventReactive(input$B.pls,
{x <- as.data.frame(predict(pls(), newdata = as.data.frame(newX.pls())[,input$x], type="response")[,,pls()$ncomp])
colnames(x) <- input$y.r
return(x)
})

pred.comp.pls = eventReactive(input$B.pls,
{as.data.frame(predict(pls(), newdata = as.data.frame(newX.pls())[,input$x], type="scores"))
})



output$pred.lp.pls = DT::renderDT({
pred.lp.pls()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

output$pred.comp.pls = DT::renderDT({
pred.comp.pls()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

#source("spls_server.R", local=TRUE, encoding="UTF-8") 
#****************************************************************************************************************************************************spls

output$x.s = renderUI({
selectInput(
'x.s',
tags$b('1. Choose independent variable matrix (X)'),
selected = type.num3()[-c(1:3)],
choices = type.num3(),
multiple = TRUE
)
})

DF4.s <- reactive({
  df <-X()[ ,-which(names(X()) %in% c(input$x.s))]
return(df)
  })

output$y.s = renderUI({
selectInput(
'y.s',
tags$b('2. Choose one or more dependent variable (Y)'),
selected = names(DF4.s())[1],
choices = names(DF4.s()),
multiple = TRUE
)
})


output$spls.x <- DT::renderDT({
    if (ncol(X())>50) {lim <- 50}
    else {lim <-ncol(X())}

    head(X()[,1:lim])}, options = list(scrollX = TRUE,dom = 't'))

output$spls_cv  <- renderPrint({
  Y <- as.matrix(X()[,input$y.s])
  X <- as.matrix(X()[,input$x.s])
  validate(need(min(ncol(X), nrow(X))>input$cv.s, "Please input enough independent variables"))
  validate(need(input$cv.s>=1, "Please input correct number of components"))
  validate(need(input$cv.eta>0 && input$nc.eta<1, "Please correct parameters"))
  spls::cv.spls(X,Y, eta = seq(0.1,input$cv.eta,0.1), K = c(1:input$cv.s),
    select="pls2", fit = input$method.s, plot.it = FALSE)
  
  })

spls <- eventReactive(input$spls1,{

  Y <- as.matrix(X()[,input$y.s])
  X <- as.matrix(X()[,input$x.s])
  validate(need(min(ncol(X), nrow(X))>input$nc.s, "Please input enough independent variables"))
  validate(need(input$nc.s>=1, "Please input correct number of components"))
  validate(need(input$nc.eta>0 && input$nc.eta<1, "Please correct parameters"))
  spls::spls(X, Y, K=input$nc.s, eta=input$nc.eta, kappa=0.5, select="pls2", fit=input$method.s)
  })


output$spls  <- renderPrint({
  print(spls())
  })

output$spls.bp   <- renderPlot({ 
plot(spls())
})

output$spls.coef <- DT::renderDT({
  x<-as.data.frame(spls()$betamat)
  colnames(x) <- paste0("At comp", 1:spls()$K)
  rownames(x) <- input$x.s
  return(x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.s <- DT::renderDT({data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection))}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.l <- DT::renderDT({as.data.frame(spls()$projection)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.pres <- DT::renderDT({
  x <- as.data.frame(predict(spls(), type="fit"))
  colnames(x) <- input$y.s
  return(x)}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$spls.sv <- DT::renderDT({as.data.frame(X()[spls()$A])}, 
  extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



output$spls.s.plot  <- renderPlot({ 
  validate(need(input$nc.s>=2, "The number of components must be >=2"))

df <- data.frame(as.matrix(X()[spls()$A])%*%as.matrix(spls()$projection))

  ggplot(df, aes(x = df[,input$c1.s], y = df[,input$c2.s]))+
  geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  theme_minimal()+
  xlab(paste0("Comp", input$c1.s))+ylab(paste0("Comp", input$c2.s))

  })

output$spls.l.plot  <- renderPlot({ 
ll <- as.data.frame(spls()$projection)
ll$group <- rownames(ll)
loadings.m <- reshape::melt(ll, id="group",
                   measure=colnames(ll)[1:spls()$K])

ggplot(loadings.m, aes(loadings.m$group, abs(loadings.m$value), fill=loadings.m$value)) + 
  facet_wrap(~ loadings.m$variable, nrow=1) + #place the factors in separate facets
  geom_bar(stat="identity") + #make the bars
  coord_flip() + #flip the axes so the test names can be horizontal  
  #define the fill color gradient: blue=positive, red=negative
  scale_fill_gradient2(name = "Loading", 
                       high = "blue", mid = "white", low = "red", 
                       midpoint=0, guide=F) +
  ylab("Loading Strength") + #improve y-axis label
  theme_bw(base_size=10)

  })

#source("pr3_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************spls-pred

newX.spls = reactive({
  inFile = input$newfile.spls
  if (is.null(inFile)){
    if (input$edata=="NKI") {x <- nki2.test}
    else {x<- liver.test}
    }
  else{
if(!input$newcol.spls){
    csv <- read.csv(inFile$datapath, header = input$newheader.spls, sep = input$newsep.spls, quote=input$newquote.spls)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$newheader.spls, sep = input$newsep.spls, quote=input$newquote.spls, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})


output$newX.spls  = DT::renderDT({newX.spls()},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))

pred.lp.spls = eventReactive(input$B.spls,
{x <- as.data.frame(predict(spls(), newdata = as.matrix(newX.spls())[,input$x], type="fit"))
colnames(x) <- input$y.s
return(x)
})

output$pred.lp.spls = DT::renderDT({
pred.lp.spls()
},
extensions = 'Buttons', 
options = list(
dom = 'Bfrtip',
buttons = c('copy', 'csv', 'excel'),
scrollX = TRUE))


observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
