
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
</ul>

<h4><b> 2. About your data</b></h4>

<ul>
<li> Your data need to have more rows than columns
<li> Your data need to be all numeric 
</ul> 

<i>

<h4>Case Example 1: Mouse gene expression data</h4>

This data measured the gene expression of 20 mouses in a diet experiment. Some mouses showed same genotype and some gene variables were correlated. 
We wanted to compute the principal components which were linearly uncorrelated from the gene expression data.

<h4>Case Example 2: Chemical data</h4>

Suppose in one study, people measured the 9 chemical attributes of 7 types of drugs. Some chemicals had latent association.
We wanted to explore the latent relational structure among the set of chemical variables and narrow down to smaller number of variables.

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),
hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
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
<li> To get the principal components and loadings result tables and 
<li> To get the principal components and loadings distribution plots in 2D and 3D
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> More samples size than the number of independent variables, that is, he number of rows is greater than the number of columns
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
source("ui_pca.R", local=TRUE, encoding="UTF-8")$value,
hr()

), #penal tab end

##########----------##########----------##########
tabPanel("EFA",

headerPanel("Exploratory Factor Analysis"),

HTML(
"
<b>Exploratory Factor analysis (EFA)</b> is a statistical method used to describe variability among observed, correlated variables in terms of a potentially lower number of unobserved variables called factors.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> From <parallel analysis> to estimate the number of components
<li> To get correlation matrix and plot
<li> To get the factors and loadings result tables and 
<li> To get the factors and loadings distribution plots in 2D and 3D
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> More samples size than the number of independent variables, that is, he number of rows is greater than the number of columns
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
source("ui_fa.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########


source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value

))
)



