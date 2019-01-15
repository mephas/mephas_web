##----------#----------#----------#----------
##
## 7MFSreg UI
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(
tagList(

navbarPage(
  title = "回帰分析",

#----------0. dataset panel----------

tabPanel("データセット",

  titlePanel("データ挿入"),

  source("0data_ui.R", local=TRUE,encoding = "UTF-8")$value

        ),

#----------1. LM regression panel----------
tabPanel("線形回帰 (連続目的変数)",

  titlePanel("線形回帰"),

  source("1lm_ui.R", local=TRUE,encoding = "UTF-8")$value

), ## tabPanel

##-----------------------------------------------------------------------
## 2. logistic regression---------------------------------------------------------------------------------
tabPanel("Lロジスティック回帰 (1-0 目的変数)",

  titlePanel("ロジスティック回帰"),

  source("2lr_ui.R", local=TRUE,encoding = "UTF-8")$value

), ## tabPanel(

##----------------------------------------------------------------------
## 3. cox regression---------------------------------------------------------------------------------
tabPanel("Cox 回帰(Time-Event 目的変数)",

  titlePanel("Cox 回帰"),

  source("3cr_ui.R", local=TRUE)$value


) ## tabPanel(
,
##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_jp.R",local=TRUE,encoding = "UTF-8")$value

)
##-----------------------over
)
)


