##----------#----------#----------#----------
##
## 8MFSpcapls UI
##
## Language: EN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(


title = "Dimensional Analysis 2",

##########----------##########----------##########

tabPanel("Data",

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

<i><h4>Case Example: NKI data</h4>

Suppose in one study, we wanted to explore some lymph node positive breast cancer patients on metastasis-free survival. 
Data contained the clinical risk factors: (1) Age: Patient age at diagnosis (years) and (2) the year until relapse; 
and gene expression measurements of 70 genes found to be prognostic for metastasis-free survival in an earlier study.
In this example, we wanted to create a model that could find the relations between age, year until release, and gene expression measurements. 

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
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
<li> To get the factors and loadings distribution plots in 2D and 3D
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
source("ui_pcr.R", local=TRUE, encoding="UTF-8")$value,
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
source("ui_pcr_pr.R", local=TRUE, encoding="UTF-8")$value,
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
<li> To get the factors and loadings distribution plots in 2D and 3D
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
source("ui_pls.R", local=TRUE, encoding="UTF-8")$value,
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
source("ui_pls_pr.R", local=TRUE, encoding="UTF-8")$value,
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
<li> To get the factors and loadings distribution plots in 2D and 3D
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
source("ui_spls.R", local=TRUE, encoding="UTF-8")$value,
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
source("ui_spls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),
##########----------##########----------##########

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value

))
)



