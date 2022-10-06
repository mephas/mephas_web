sidebarLayout(
	sidebarPanel(width=3,
    tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
    tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
    h4(tags$b("Step5. Sensitivity Analysis Setting")),
    h4(tags$b("4. Edit Selection Probabilities")),
    HTML('<b>Multiple Selection Probabilities(0&#60;p&#x2266;1)<br>

	     <input type="text" id="plist" value="1,0.8,0.6,0.4" pattern="^[\\d,.]+$">

	     </b>'),
    verbatimTextOutput("uiprob"),
  	radioGroupButtons(
    inputId = "Sauc1",
    label = "Sauc type",
    choices = c("sroc", "hsroc"),
    justified = TRUE,
    checkIcon = list(
      yes = icon("ok",
                 lib = "glyphicon"))
  	),

    hr(),
    pickerInput(inputId="sensisetting","Setting switch Tab",
    	choices=c("SROC","SAUC","Results","Plot Summary","Reproducible R codes")
    	),
    conditionalPanel(condition="input.sensisetting=='SROC'",
    	shinyWidgets::prettyCheckbox(
			   inputId = "batch",
			   label = "All SROC Setting in batch way?", 
			   status = "info",
			   value = TRUE,

			  ),
        h4(textInput("xlim","Label of the x-axis","1-Specificity"),textInput("ylim","Label of the y-axis","Sensitivity")),
    	conditionalPanel(condition="input.batch==true",
    		shinyWidgets::colorPickr("each_point_color","Each study point colour",selected="#000000"),#47848C
  			sliderInput("each_point_radius","Each Point Radius",min = 0,max=10,value = 3),
  			sliderInput("each_point_shape","Each Point Shape",min = 0,max=25,value = 1),
            shinyWidgets::colorPickr("sroc_point_color","Summary Point Colour",selected="#0A99BD"),
            sliderInput("sroc_point_radius","Summary Point Radius",min = 0,max=10,value = 5),
            sliderInput("sroc_point_shape","Summary Point Shape",min = 0,max=25,value = 18),
            shinyWidgets::colorPickr("sroc_curve_color","SROC Curve color",selected="#39377A"),
            sliderInput("sroc_curve_thick","SROC Curve thickness",min = 0,max=10,value = 1),
            sliderTextInput(paste0("sroc_curve_shape"),grid = TRUE,label =  "SROC Curve shape",choices = c("blank","solid","dashed","dotted","dotdash","longdash","twodash"),selected = "solid")
            
    		
    		),
    	conditionalPanel(condition="input.batch==false",
        h4("c1c2_estimate"),
    	ui.plot_baseset_drop("c1c2_estimate"),uiOutput("srocBsetting_curve"),
        h4("c1c2_11"),
    	ui.plot_baseset_drop("c1c2_11"),uiOutput("srocCsetting_curve_11"),
        h4("c1c2_10"),
    	ui.plot_baseset_drop("c1c2_10"),uiOutput("srocCsetting_curve_10"),
        h4("c1c2_01"),
    	ui.plot_baseset_drop("c1c2_01"),uiOutput("srocCsetting_curve_01"),
        h4("c1c2_manul"),
    	ui.plot_baseline_drop("c1c2_manul",plot_title = "C1C2",x_axis = "1-sp",y_axis = "se"),
        ui.plot_baseset_drop("c1c2_manul"),uiOutput("srocDsetting_curve"))
    	),
	conditionalPanel(condition="input.sensisetting=='Reproducible R codes'",
    	radioGroupButtons(
                inputId = "Rmd_document",
                label = "Choose document type",
                # choiceNames = c("Correction for sigle study", "Correction for all studies"),
                # choiceValues = c("single", "all"),
                choices=c("html","pdf","word"),
                selected = "html",
                justified = TRUE,
                checkIcon = list(
                  yes = icon("ok", lib = "glyphicon")),
                direction = "horizontal"
              ),
        textInput("Rmd_title","Rmd title","DTA-Meta")
    	),
    br(),
    h4(
        hr(),
        pickerInput(inputId="ggplot_theme",
        label="select plot theme",
        choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default")))
    )),
   mainPanel(
    	    tabsetPanel(id="Sensitivity_Panel",
                           tabPanel("SROC",
                                    fluidRow(column(width = 6,HTML("$(\\hat{c}_1, \\, \\hat{c}_2)$H<sub>2</sub>O"),h4("c<sub>1</sub>c<sub>2</sub>","estimate",downloadButton("downloadsauc_gg_estimate","Save Image")),
                                                    plotOutput("srocB")
                                                    #,flowLayout(ui.plot_baseset_drop("c1c2_estimate"),uiOutput("srocBsetting_curve"))
                                    )
                                    ,column(width = 6,h4("c<sub>1</sub>c<sub>2</sub>","c<sub>1</sub>=c<sub>2</sub>",downloadButton("download_srocC_11","Save Image")),
                                            plotOutput("srocC_11")
                                            #,flowLayout(ui.plot_baseset_drop("c1c2_11"),uiOutput("srocCsetting_curve_11"))
                                            )
                                    ,column(width = 6,h4("c<sub>1</sub>c<sub>2</sub>","c<sub>1</sub>=1,c<sub>2</sub>=0",downloadButton("download_srocC_10","Save Image")),
                                            plotOutput("srocC_10")#,flowLayout(ui.plot_baseset_drop("c1c2_10"),uiOutput("srocCsetting_curve_10"))
                                            )
                                    ,column(width = 6,h4("c<sub>1</sub>c<sub>2</sub>","c<sub>1</sub>=0,c<sub>2</sub>=1",downloadButton("download_srocC_01","Save Image")),
                                            plotOutput("srocC_01")#,flowLayout(ui.plot_baseset_drop("c1c2_01"),uiOutput("srocCsetting_curve_01"))
                                            )
                                    ,column(width = 6,h4("c<sub>1</sub>c<sub>2</sub>","Manual set",downloadButton("download_c1c2_manul","Save Image")),
                                            sliderInput("c1c2_set","c1::",0,1,0.5),actionButton("c1c2_set_button","c1c2"),
                                            plotOutput("srocD")
                                            # ,flowLayout(ui.plot_baseline_drop("c1c2_manul",plot_title = "C1C2",x_axis = "1-sp",y_axis = "se"),
                                            #            ui.plot_baseset_drop("c1c2_manul"),uiOutput("srocDsetting_curve"))
                                            
                                    )
                                    )),
                           tabPanel("SAUC",
                             column(width=6,plotly::plotlyOutput("sauc_gg_estimate")),
                             column(width=6,plotly::plotlyOutput("sauc_gg_c11")),
                             column(width=6,plotly::plotlyOutput("sauc_gg_c10")),
                             column(width=6,plotly::plotlyOutput("sauc_gg_c01"))
                           ),

                           tabPanel("Results",column(width = 12,h4("Logit-transformed Data"),DT::dataTableOutput("LogitData")
                                                     ,h4("Results"),DT::dataTableOutput("Results"))),
                           tabPanel("Plot Summary",
                                    fluidRow(column(width = 6,h4("SROC1","Estimated SROC when c11 and c22 are assigned by the specific values"),
                                                    plotOutput("srocA"
                                                               #, width = "400px", height = "400px"
                                                    ),
                                                    downloadButton("downloadsrocA","Save Image"))
                                             ,column(width = 6,h4("Probit of α and β","Estimated SROC when c11 and c22 are estimated"),
                                                     plotOutput("sauc"
                                                                #, width = "400px", height = "400px"
                                                     ),
                                                     downloadButton("downloadsauc","Save Image"))
                                             ,column(width = 6,h4("SAUC","Estimates when c11 and c22 are assigned by the specific values"),
                                                     plotOutput("curveAandB"),
                                                     downloadButton("downloadcurveAandB","Save Image"))))
                           ,tabPanel("Reproducible R codes",
                                     actionButton("RMDdownload","Rmd download",icon = icon("download"))
                                     ,actionButton("HTMLdownload","html download",icon = icon("download"))
                                     ,tags$style(
                                         "#RMDdownload:hover {
                                         outline-color:#0000ff;
                                       border-color: #000000;
                                       background: #4169e1;
                                       border-radius:3%;
                                                  color:white;}"
                                          )
                                      ,tags$style(#"#downloadreport {
                                        #background:black;
                                        #color:yellow;
                                        #font-size:20rem;}
                                        #   "#downloadreport:hover {
                                        # background-color: yellow;
                                        #            color:black;}"
                                         "#HTMLdownload:hover {
                                         outline-color:#0000ff;
                                       border-color: #000000;
                                       background: #4169e1;
                                       border-radius:3%;
                                                  color:white;}"

                                          )
                                     ,verbatimTextOutput("Rmd")
                                     )
    	)
                     
                      

    	

    ))