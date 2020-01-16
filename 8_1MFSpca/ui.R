
shinyUI(

tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(


title = "Dimensional Analysis 1",

##########----------##########----------##########

tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables
<li> To prepare the survival object as 'dependent variable' for building model
</ul>

<h4><b> 2. About your data</b></h4>

<ul>
<li> Your data need to have more rows than columns
<li> Your data need to be all numeric 
</ul> 

<i><h4>Case Example 1: Chemical data</h4>

SUppose in one study, people measured the 9 chemical attributes of 7 types of drugs. However, not all the attributes are important.
We wanted to explore the important or principal components from the chemical attributes matrix.

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),
hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

),


##########----------##########----------##########
tabPanel("PCA",

headerPanel("Principal Component Analysis"),

HTML(
"
<b>Principal components analysis (PCA)</b> is a data reduction technique that transforms a larger number of correlated variables into a much smaller set of uncorrelated variables called principal components.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> From <parallel analysis> to estimate the number of components
<li> To get correlation matrix and plot
<li> To the components and loadings result table and plot
<li> To conduct pairwise log-rank test to compare the survival curves from more than two groups
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> The independent variable is categorical
<li> Please prepare the survival object in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
source("pca_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()

), #penal tab end

##########----------##########----------##########
tabPanel("EFA",

headerPanel("Exploratory Factor Analysis"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To get Kaplan-Meier survival probability estimate
<li> To get Kaplan-Meier survival curves, cumulative events distribution curves, and cumulative hazard curves by group variable
<li> To conduct log-rank test to compare the survival curves from 2 groups
<li> To conduct pairwise log-rank test to compare the survival curves from more than two groups
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> The independent variable is categorical
<li> Please prepare the survival object in the Data tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
source("fa_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########


source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value

))
)



