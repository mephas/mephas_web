##----------#----------#----------#----------
##
## 7MFSreg UI
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
  title = "Regression Model",

#----------0. dataset panel----------

tabPanel("Dataset",

  titlePanel("Data Preparation"),

  source("0data_ui.R", local=TRUE, encoding="UTF-8")$value

        ),

#----------1. LM regression panel----------
tabPanel("Linear Regression (Continuous Outcomes)",

  titlePanel("Linear Regression"),

  source("1lm_ui.R", local=TRUE, encoding="UTF-8")$value

), ## tabPanel

##-----------------------------------------------------------------------
## 2. logistic regression---------------------------------------------------------------------------------
tabPanel("Logistic Regression (1-0 Outcomes)",

  titlePanel("Logistic Regression"),

  source("2lr_ui.R", local=TRUE, encoding="UTF-8")$value

), ## tabPanel(

##----------------------------------------------------------------------
## 3. cox regression---------------------------------------------------------------------------------
tabPanel("Cox Regression (Time-Event Outcomes)",

  titlePanel("Cox Regression"),

  source("3cr_ui.R", local=TRUE, encoding="UTF-8")$value


) ## tabPanel(
,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help7.R",local=TRUE, encoding="UTF-8")$value

)
##-----------------------over
)
)


