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
##----------
tabPanel((a("ホーム",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/", "index_jp.html")))),

tabPanel(
      tags$button(
      id = 'close',
     style = "margin-top:-10px;",
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止"))


)
##-----------------------over
)
)


