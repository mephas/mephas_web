if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")
shinyUI(
tagList(
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(

title = "Linear Regression",
#collapsible = TRUE,
##########----------##########----------##########


tabPanel("Data",

headerPanel("Data Preparation"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>Linear regression</b> is a linear approach to modeling the relationship between a dependent variable and one or more independent variables. 
The case of one explanatory variable is called simple <b>linear regression</b>. 
For more than one explanatory variable, the process is called <b>multiple linear regression</b>.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input 
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables 
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> Your data need to include <b>one dependent variable (denoted as Y)</b> and <b> at least one independent variables (denoted as X)</b>
<li> Your data need to have more rows than columns
<li> Do not mix character and numbers in the same column 
<li> The data used to build model is called <b>training set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in one study, the doctors recorded the birth weight of 10 infants, together with age (month), age group (a: age < 4 month, b; other wise), and SBP.
We were interested (1) to predict the birth weight of a infants, 
and (2) find the relations between birth weight and the other variables, that is, to find out which variable contributes greatly to the dependent variable.

</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please build the model in the next tab.</h4>
"
)
),

hr(),
source("0data_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

##########----------##########----------##########
tabPanel("Model",

headerPanel("Linear Regression"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To build a simple or multiple linear regression model
<li> To get the estimates of regressions, including (1) estimate of coefficients with t test, p value, and 95% CI, (2) R<sup>2</sup> and adjusted R<sup>2</sup>, and (3) F-Test for overall significance in Regression 
<li> To get additional information: (1) predicted dependent variable and residuals, (2) ANOVA table of model, (3) AIC-based variable selection, and (4) diagnostic plot based from the residuals and predicted dependent variable 
</ul>

<h4><b> 2. About your data (training set)</b></h4>

<ul>
<li> The dependent variable is real-valued and continuous with underlying normal distribution.
<li> Please prepare the training set data in the previous <b>Data</b> tab
</ul> 

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Prediction",

headerPanel("Prediction from Model"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload new data and get the prediction
<li> To get the evaluation if new data contains new dependent variable
</ul>

<h4><b> 2. About your data (test set)</b></h4>

<ul>
<li> New data cover all the independent variables used in the model.
<li> New data not used to build the model is called <b>test set</b>
</ul> 

<i><h4>Case Example</h4>

Suppose in the same study, the doctors got another 6 infants data, and wanted to predict their birth weights based on the model we build.

</h4></i>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"
)
),

hr(),
source("2pr_ui.R", local=TRUE, encoding="UTF-8")$value,
hr()
),
##########----------##########----------##########

source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/onoff.R",local=TRUE, encoding="UTF-8")$value

)
)
)


