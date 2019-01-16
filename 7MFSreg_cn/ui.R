##----------#----------#----------#----------
##
## 7MFSreg UI
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------


shinyUI(
tagList(

navbarPage(
  title = "Regression Model",

#----------0. dataset panel----------

tabPanel("Dataset",

  titlePanel("Data Preparation"),

  source("0data_ui.R", local=TRUE)

        ),

#----------1. LM regression panel----------
tabPanel("Linear Regression (Continuous Outcomes)",

  titlePanel("Linear Regression"),

  source("1lm_ui.R", local=TRUE)

), ## tabPanel

##-----------------------------------------------------------------------
## 2. logistic regression---------------------------------------------------------------------------------
tabPanel("Logistic Regression (1-0 Outcomes)",

  titlePanel("Logistic Regression"),

  source("2lr_ui.R", local=TRUE)

), ## tabPanel(

##----------------------------------------------------------------------
## 3. cox regression---------------------------------------------------------------------------------
tabPanel("Cox Regression (Time-Event Outcomes)",

  titlePanel("Cox Regression"),

  source("3cr_ui.R", local=TRUE)


) ## tabPanel(
,
##---------- other panels ----------

source("../0tabs/home_cn.R",local=TRUE)$value,
source("../0tabs/stop_cn.R",local=TRUE)$value
)
##-----------------------over
)
)


