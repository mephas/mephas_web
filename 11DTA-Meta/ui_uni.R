library(shiny)
library(shinyWidgets)

  Uni_Fennel<-fluidPage(plotOutput("uni_fennel_meta"))
  Uni_Meta_Main<-mainPanel(width=9,fluidRow(column(6,DT::dataTableOutput("rawdata_uni"))),fluidRow(plotOutput("uni_forest_meta_cont"),withTags(label(
    span("popupを表示"),
    #   input(type="checkbox", name="checkbox"),
    div( id="popup",img("https://assets.techacademy.jp/public/logo.png" ,alt="TechAcademy")
    ))
  )))
  Uni_Meta<-fluidPage(sidebarLayout(
    sidebarPanel(width=3,
                 tags$h3("1. Meta "),
                 radioGroupButtons("Meta_OR_MD",choices = c("Mean Difference","Binary Outcome")),
                 uiOutput("varselect"),
                 conditionalPanel(condition="input.Meta_OR_MD=='Binary Outcome'",radioGroupButtons("metabin_sm",choices = c("OR","RR"))),
                  tags$h3("2. Data Input"),
                                radioButtons("manualInputTRUE_uni",choices = c("Manual input","File upload"),"choose input way",inline = TRUE),
                  conditionalPanel(condition="input.manualInputTRUE_uni=='File upload'",icon("fa-regular fa-file",lib = "font-awesome"),fileInput("filer_uni",label="csv,text",accept=c("text/csv"))),
                  conditionalPanel(condition="input.manualInputTRUE_uni=='Manual input'",icon("fa-regular fa-keyboard",lib="font-awesome"),textAreaInput(
                   inputId = "manualInput_uni", 
                   label = "Manually input data",
                   value = "study,n1,n0,md1,sd1,md0,sd0\n1,12,13,0.76,0.69,-0.1,0.63\n2,16,12,1.14,0.69,-0.36,0.97\n3,17,10,3.6,1.02,0.9,0.8\n4,13,20,1.8,0.67,-2.2,0.3",#\n5,4,0,21,225\n6,15,2,122,403\n7,45,5,28,34\n8,18,4,69,133\n9,5,0,11,34\n10,8,9,15,96\n11,5,0,7,63\n12,11,2,122,610\n13,5,1,6,145\n14,7,5,25,342",
                   rows = 10))
                 ,
                 tags$h3("3. Setting"),uiOutput("inputval"),
                 dropdown(checkboxInput("setvalue","byvar",value = FALSE),
                          conditionalPanel(condition = "input.setvalue=='1'",
                                           uiOutput("inputval_bybar")),
                          icon = icon("fa-solid fa-bookmark"),
                          label="other setting"
                          )),Uni_Meta_Main))
  Univariate_Body<-fluidPage(title = "Univiarite",tabsetPanel(tabPanel(title = "Meta",icon = icon("fa-solid fa-caret-right",lib = "font-awesome"),Uni_Meta),tabPanel(title = "Fennel",icon=icon("fa-solid fa-angle-right",lib = "font-awesome"),Uni_Fennel)))