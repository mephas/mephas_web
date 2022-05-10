
DTA_Meta_Main<-mainPanel(width =9 ,
                         fluidRow(column(width=12,tabsetPanel(tabPanel(title = "Raw Input Data","Raw Input Data",DT::dataTableOutput("RawData")),
                                                    tabPanel(title = "Logit-transformed Data","Logit-transformed Data",DT::dataTableOutput("LogitData"))
                         )),
                         column(width = 12,tabsetPanel(tabPanel(title = "Meta-Sensitivity/Specificity",
                                plotOutput("meta_sesp")),
                                tabPanel(title = "Meta-LDOR",plotOutput("meta_LDOR")),
                                  tabPanel(title = "Plot",column(width=6,checkboxInput("ROCellipse", "95%CI",value = FALSE),checkboxInput("mslSROC", "mslSROC",value = FALSE),checkboxInput("rsSROC", "rsSROC",value = FALSE)),column(width = 6,checkboxInput("mrfit", "mrfit",value = FALSE)),plotOutput("plot_FRP"),column(width=6,downloadButton("downloadFRP1","Download FRP Plot"))
                                           ,conditionalPanel(condition = "input.mrfit=='1'",column(width=6,downloadButton("downloadFRP2","Download mrfit"))))
                                ))
                         ))
DTA_Meta<-fluidPage(
  sidebarLayout(
    sidebarPanel(width = 3,tags$h3("2. Data Input"),
                 radioButtons("manualInputTRUE",choices = c("Manual input","File upload"),"choose input way",inline = TRUE),

                 conditionalPanel(condition = "input.manualInputTRUE=='File upload'",icon("fa-regular fa-file",lib = "font-awesome"),fileInput("filer",label = "csv,txt",accept = c("text/csv"))),
                 conditionalPanel(condition = "input.manualInputTRUE=='Manual input'",icon("fa-regular fa-keyboard",lib="font-awesome"),textAreaInput(
                   inputId = "manualInput", 
                   label = "Manually input data",
                   value = "study,TP,FN,FP,TN\n1,12,0,29,289\n2,10,2,14,72\n3,17,1,36,85\n4,13,0,18,67\n5,4,0,21,225\n6,15,2,122,403\n7,45,5,28,34\n8,18,4,69,133\n9,5,0,11,34\n10,8,9,15,96\n11,5,0,7,63\n12,11,2,122,610\n13,5,1,6,145\n14,7,5,25,342",
                   rows = 10)),
                 numericInput("mochi","mo",1,min = 0,max = 1,0.01)
    ),
    DTA_Meta_Main
  )
)
DTA_Sensi_Main<-mainPanel(width =9  ,fluidRow(column(width = 6,"SROC1","Estimated SROC when c11 and c22 are assigned by the specific values",
                                                     plotOutput("srocA"
                                                                #, width = "400px", height = "400px"
                                                     ),
                                                     downloadButton("downloadsrocA","Save Image"))
                                              ,column(width = 6,"Probit of α and β","Estimated SROC when c11 and c22 are estimated",
                                                      plotOutput("sauc"
                                                                 #, width = "400px", height = "400px"
                                                      ),
                                                      downloadButton("downloadsauc","Save Image"))
                                              ,column(width = 6,"SAUC","Estimates when c11 and c22 are assigned by the specific values",
                                                      plotOutput("curveAandB"),
                                                      downloadButton("downloadcurveAandB","Save Image")))
)
DTA_Sensi <- fluidPage(
  sidebarLayout(
    sidebarPanel(width = 3,
                 icon("keyboard"),
                 textAreaInput(inputId = "plist","Multiple Selection Probabilities(0<p<1)",value = "1, 0.8, 0.6, 0.4"),
                 icon("calendar"),
                 radioGroupButtons(
                   inputId = "Sauc1",
                   label = "Sauc type",
                   choices = c("sroc", "hsroc"),
                   justified = TRUE,
                   checkIcon = list(
                     yes = icon("ok",
                                lib = "glyphicon"))
                 ),
                 icon = icon("calendar"),
                 radioGroupButtons(
                   inputId = "allsingle",
                   label = "Sauc type",
                   choices = c("all", "single"),
                   selected = "single",
                   justified = TRUE,
                   checkIcon = list(
                     yes = icon("ok",
                                lib = "glyphicon"))
                 )
    )
    ,DTA_Sensi_Main
  )
)


  DTA_Body<-fluidPage("Digostic Test Analysis",actionButton("calculateStart","Start Calculation",icon = icon("fa-solid fa-wave-square",lib = "font-awesome")),tabsetPanel(tabPanel("Meta-Analysis",DTA_Meta),tabPanel("Sensitivity-Analysis",DTA_Sensi)))
