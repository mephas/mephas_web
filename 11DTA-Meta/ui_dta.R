
sidebarLayout(
  sidebarPanel(
    tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
    tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
    h4(tags$b("Step 1. Data Preparation")),
    radioButtons("manualInputTRUE",choices = c("Manual input","File upload"),"1. choose input way",inline = TRUE),
    tags$style("#radioSelect:checked {
  box-shadow: 0 0 0 3px orange;
}"),
    conditionalPanel(condition = "input.manualInputTRUE=='File upload'",icon("fa-regular fa-file",lib = "font-awesome"),fileInput("filer",label = "csv,txt",accept = c("text/csv"))),
    icon("fa-regular fa-keyboard",lib="font-awesome")
    ,shinyWidgets::prettyRadioButtons(
      inputId = "Delimiter",
      label = "2. Which Delimiter for data?", 
      status = "info",
      fill = TRUE,
      icon = icon("check"),
      choiceNames = list(
        HTML("Comma (,): CSV often uses this"),
        HTML("One Tab (->|): TXT often uses this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
      ),
      choiceValues = list(",", "\t", ";", " ")
                                      )
      ,p(tags$b("3. Edit Data"))
      ,aceEditor("manualInput"
                 ,value = "study,TP,FN,FP,TN\n1,12,0,29,289\n2,10,2,14,72\n3,17,1,36,85\n4,13,0,18,67\n5,4,0,21,225\n6,15,2,122,403\n7,45,5,28,34\n8,18,4,69,133\n9,5,0,11,34\n10,8,9,15,96\n11,5,0,7,63\n12,11,2,122,610\n13,5,1,6,145\n14,7,5,25,342"
                 ,mode = "r"
                 ,theme="eclipse"
      )
      ,p(tags$b("4. Edit Selection Probabilities"))
      ,HTML('<b>Multiple Selection Probabilities(0&#60;p&#x2266;1)<br>

                         <input type="text" id="plist" value="1,0.8,0.6,0.4" pattern="^[\\d,.]+$">

                         </b>'),
      verbatimTextOutput("uiprob"),
      numericInput("ci.level", label = "Confidence interval level", value = 0.95, min = 0.01, max = 0.99),

      selectInput("ci.method", label = "Methods for confidence interval", 
      choices = list("wald" = "wald", "wilson" = "wilson", "agresti-coull" = "agresti-coull", "jeffreys" = "jeffreys",
        "modified wilson" = "modified wilson", "modified jeffreys" = "modified jeffreys", "clopper-pearson" = "clopper-pearson", 
        "arcsine" = "arcsine", "logit" = "logit", "witting" = "witting"), 
      selected = "wald")
      ,pickerInput(inputId="ggplot_theme",
        label="select plot theme",
        choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))),
  icon("keyboard"),
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
                label = "Continuity correction type",
                choiceNames = c("Correction for sigle study", "Correction for all studies"),
                choiceValues = c("single", "all"),
                selected = "single",
                justified = TRUE,
                checkIcon = list(
                  yes = icon("ok", lib = "glyphicon")),
                direction = "vertical"
              ),
  actionButton("calculateStart",tags$b(HTML("Reload DATA TO Calculation&#x2192;")),icon = icon("fa-solid fa-wave-square",lib = "font-awesome")
),tags$style("#calculateStart {background:#4169e1;
                              color:white;}
              #calculateStart:hover {
              outline-color:#0000ff;
            border-color: #000000;
            background: #413E3D;
            border-radius:3%;
                      color:white;}"
              
    )
                         
    ),
    mainPanel(
    h4(tags$b("Outputs")),

    tabsetPanel(
      tabPanel("Data Preview", p(br()),
        DT::dataTableOutput("RawData")),
      
      tabPanel("Descriptive Statistics", p(br()),
        verbatimTextOutput("md.text")),
                                  
      tabPanel("Forest Plots for Se/Sp", p(br()),
        uiOutput("meta_sesp_plot"),
        textInput("se.title", label = "Input title for plot 1", value = "Sensitivity"),
        textInput("sp.title", label = "Input title for plot 2", value = "Specificity")

        ),
      
      tabPanel(title = "Forest Plots for Univariate measures",p(br()),
        uiOutput("meta_uni_plot"),
        awesomeCheckbox(
             inputId = "uni.log",
             label = "Log-transformed results", 
              value = TRUE
          ),
        textInput("u1.title", label = "Input title for plot 1", value = "Log diagnostic odds ratio"),
        textInput("u2.title", label = "Input title for plot 2", value = "Log negative LR"),
        textInput("u3.title", label = "Input title for plot 3", value = "Log positive LR")),

      tabPanel(title = "SROC",

        uiOutput("meta_sroc_plot")
        )

  ))
  # mainPanel(
  #   tabsetPanel(tabPanel("Meta-Analysis",
  #                        fluidRow(column(width=12,h3("Raw Input Data"),DT::dataTableOutput("RawData")),
                                  
  #                                 column(width = 12,tabsetPanel(tabPanel(title = "Meta-Sensitivity/Specificity",
  #                                                                        uiOutput("meta_sesp_plot")
  #                                 ),
  #                                 tabPanel(title = "Meta-LDOR",plotOutput("meta_LDOR")),
  #                                 tabPanel(title = "Plot",column(width=6,checkboxInput("ROCellipse", "95%CI",value = FALSE),checkboxInput("mslSROC", "mslSROC",value = FALSE),checkboxInput("rsSROC", "rsSROC",value = FALSE)),column(width = 6,checkboxInput("mrfit", "mrfit",value = FALSE)),plotOutput("plot_FRP"),column(width=6,downloadButton("downloadFRP1","Download FRP Plot"))
  #                                          ,conditionalPanel(condition = "input.mrfit=='1'",column(width=6,downloadButton("downloadFRP2","Download mrfit"))))
  #                                 ))
  #                        ))
  #               ,
  #               tabPanel("Sensitivity-Analysis",
  #                        tabsetPanel(
  #                          tabPanel("SROC",
  #                                   fluidRow(column(width = 6,h4("c1c2","estimate",downloadButton("downloadsauc_gg_estimate","Save Image")),
  #                                                   plotOutput("srocB"),
  #                                                   flowLayout(ui.plot_baseset_drop("c1c2_estimate"),uiOutput("srocBsetting_curve"))
  #                                   )
  #                                   ,column(width = 6,h4("c1c2","c1=c2",downloadButton("download_srocC_11","Save Image")),
  #                                           plotOutput("srocC_11"),
  #                                           flowLayout(ui.plot_baseset_drop("c1c2_11"),uiOutput("srocCsetting_curve_11")))
  #                                   ,column(width = 6,h4("c1c2","c1=1,c2=0",downloadButton("download_srocC_10","Save Image")),
  #                                           plotOutput("srocC_10"),flowLayout(ui.plot_baseset_drop("c1c2_10"),uiOutput("srocCsetting_curve_10")
  #                                           ))
  #                                   ,column(width = 6,h4("c1c2","c1=0,c2=1",downloadButton("download_srocC_01","Save Image")),
  #                                           plotOutput("srocC_01"),flowLayout(ui.plot_baseset_drop("c1c2_01"),uiOutput("srocCsetting_curve_01")
  #                                           ))
  #                                   ,column(width = 6,h4("c1c2","Manual set",downloadButton("download_c1c2_manul","Save Image")),
  #                                           sliderInput("c1c2_set","c1::",0,1,0.5),actionButton("c1c2_set_button","c1c2"),
  #                                           plotOutput("srocD"),
  #                                           flowLayout(ui.plot_baseline_drop("c1c2_manul",plot_title = "C1C2",x_axis = "1-sp",y_axis = "se"),
  #                                                      ui.plot_baseset_drop("c1c2_manul"),uiOutput("srocDsetting_curve"))
                                            
  #                                   ))),
  #                          tabPanel("SAUC",flowLayout( 
  #                            plotly::plotlyOutput(width="600px","sauc_gg_estimate"),br(),br(),
  #                            plotly::plotlyOutput(width="300%","sauc_gg_c11"),br(),br(),
  #                            plotly::plotlyOutput(width="300%","sauc_gg_c10"),br(),br(),
  #                            plotly::plotlyOutput(width="300%","sauc_gg_c01")
  #                          )),
  #                          tabPanel("Results",column(width = 12,h4("Logit-transformed Data"),DT::dataTableOutput("LogitData")
  #                                                    ,h4("Results"),DT::dataTableOutput("Results"))),
  #                          tabPanel("Plot Summary",
  #                                   fluidRow(column(width = 6,h4("SROC1","Estimated SROC when c11 and c22 are assigned by the specific values"),
  #                                                   plotOutput("srocA"
  #                                                              #, width = "400px", height = "400px"
  #                                                   ),
  #                                                   downloadButton("downloadsrocA","Save Image"))
  #                                            ,column(width = 6,h4("Probit of α and β","Estimated SROC when c11 and c22 are estimated"),
  #                                                    plotOutput("sauc"
  #                                                               #, width = "400px", height = "400px"
  #                                                    ),
  #                                                    downloadButton("downloadsauc","Save Image"))
  #                                            ,column(width = 6,h4("SAUC","Estimates when c11 and c22 are assigned by the specific values"),
  #                                                    plotOutput("curveAandB"),
  #                                                    downloadButton("downloadcurveAandB","Save Image"))))
  #                          ,tabPanel("Reproducible R codes",
  #                                    actionButton("RMDdownload","Rmd download",icon = icon("download"))
  #                                    ,actionButton("HTMLdownload","html download",icon = icon("download"))
  #                                    ,tags$style(
  #                                        "#RMDdownload:hover {
  #                                        outline-color:#0000ff;
  #                                      border-color: #000000;
  #                                      background: #4169e1;
  #                                      border-radius:3%;
  #                                                 color:white;}"
  #                                         )
  #                                     ,tags$style(#"#downloadreport {
  #                                       #background:black;
  #                                       #color:yellow;
  #                                       #font-size:20rem;}
  #                                       #   "#downloadreport:hover {
  #                                       # background-color: yellow;
  #                                       #            color:black;}"
  #                                        "#HTMLdownload:hover {
  #                                        outline-color:#0000ff;
  #                                      border-color: #000000;
  #                                      background: #4169e1;
  #                                      border-radius:3%;
  #                                                 color:white;}"

  #                                         )
  #                                    ,verbatimTextOutput("Rmd")
  #                                    )
  #                     ))
  #             )
  #           )

)