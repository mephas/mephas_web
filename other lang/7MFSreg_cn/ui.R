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
source("../0tabs/font_cn.R",local=TRUE, encoding="UTF-8")$value,
navbarPage(
  title = "回归模型",

#----------0. dataset panel----------

tabPanel("数据",

  titlePanel("数据准备"),

  source("0data_ui.R",local=TRUE, encoding="UTF-8")

        ),

#----------1. LM regression panel----------
tabPanel("线性回归 (连续型 结局)",

  titlePanel("线性回归"),

  source("1lm_ui.R", local=TRUE, encoding="UTF-8")

), ## tabPanel

##-----------------------------------------------------------------------
## 2. logistic regression---------------------------------------------------------------------------------
tabPanel("逻辑回归 (1-0 结局)",

  titlePanel("Logistic Regression"),

  source("2lr_ui.R", local=TRUE, encoding="UTF-8")

), ## tabPanel(

##----------------------------------------------------------------------
## 3. cox regression---------------------------------------------------------------------------------
tabPanel("Cox 回归 (时间-事件 结局)",

  titlePanel("Cox Regression"),

  source("3cr_ui.R", local=TRUE, encoding="UTF-8")


) ## tabPanel(
,
##---------- other panels ----------

source("../0tabs/home_cn.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/stop_cn.R",local=TRUE, encoding="UTF-8")$value,
source("../0tabs/help7.R",local=TRUE, encoding="UTF-8")$value
)
##-----------------------over
)
)


