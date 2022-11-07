sidebarLayout(
	sidebarPanel(
    # tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
    # tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
    
    h4(tags$b("Sensitivity Analysis Setting")), 
    p(br()),

    h4(tags$b("Set selection probabilities (p) for SROC")), 
    p(br()),
    HTML('<b>Input selection probabilities (0&#60; p &#x2266;1)<br><br>
	     <input type="text" id="plist" value="0.9,0.7,0.5" pattern="^[\\d,　.]+$">
	     </b>'), 
    p(br()),

    verbatimTextOutput("uiprob"), 
    p(br()),
    h4(tags$b("Set selection probabilities (p) for SAUC")), 
    p(br()),
    sliderInput("plistsauc","",0,1,0.1,step=0.01),
    verbatimTextOutput("p.10list"), 
    p(br()),
    actionButton("calculateSAUC",
	tags$b(HTML("Calculate SAUC, it takes a while...")),
	icon = icon("rotate-right")),
    p(br()),

    # HTML('<b>Multiple selection probabilities (0&#60; p &#x2266;1) for SAUC<br>

    #      <input type="text" id="plist2" value="0.9,0.7,0.5,0.3,0.1" pattern="^[\\d,.]+$">

    #      </b>'), p(br()),

    # verbatimTextOutput("uiprob2"), p(br()),

  	radioGroupButtons(
    inputId = "Sauc1",
    label = "Choose SAUC type",
    choices = list("SROC" ="sroc", "HSROC"="hsroc"),
    selected = "sroc",
    justified = TRUE,
    checkIcon = list(
        yes = icon("ok",
        lib = "glyphicon"))
  	), 

    # actionButton("sroc.saplot", tags$b("Plot SROC Curves >>"), 
    #   class =  "btn-primary",
    #   icon  = icon("chart-column")),

    hr(),
    h4(tags$b("Plot Setting")), 
    p(br()),
    pickerInput(
        inputId="sensisetting",
        "Setting switch Tab",
    	choices=c("SROC in ggplots","Dynamic SAUC in plotly")
    	),
    p(br()),
        pickerInput(
            inputId="ggplot_theme",
            label="select plot theme",
            choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))
        ),
        p(br()),
    conditionalPanel(condition="input.sensisetting=='SROC in ggplots'",
    	prettyCheckbox(
			   inputId = "batch",
			   label = "All SROC Setting in batch way?", 
			   status = "info",
			   value = TRUE,

			  ),
        h4(textInput("xlim","Label of the x-axis","1-Specificity"),textInput("ylim","Label of the y-axis","Sensitivity")),
    	
        conditionalPanel(condition="input.batch==true",
    		colorPickr("each_point_color","Each study point colour",selected="#000000"),#47848C
  			sliderInput("each_point_radius","Each Point Radius",min = 0,max=10,value = 3),
  			sliderInput("each_point_shape","Each Point Shape",min = 0,max=25,value = 1),
            colorPickr("sroc_point_color","Summary Point Colour",selected="#0A99BD"),
            sliderInput("sroc_point_radius","Summary Point Radius",min = 0,max=10,value = 5),
            sliderInput("sroc_point_shape","Summary Point Shape",min = 0,max=25,value = 18),
            colorPickr("sroc_curve_color","SROC Curve color",selected="#39377A"),
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
    	)

	# conditionalPanel(condition="input.sensisetting=='Reproducible R codes'",
 #    	radioGroupButtons(
 #                inputId = "Rmd_document",
 #                label = "Choose document type",
 #                # choiceNames = c("Correction for sigle study", "Correction for all studies"),
 #                # choiceValues = c("single", "all"),
 #                choices=c("html","pdf","word"),
 #                selected = "html",
 #                justified = TRUE,
 #                checkIcon = list(
 #                  yes = icon("ok", lib = "glyphicon")),
 #                direction = "horizontal"
 #              ),
 #        textInput("Rmd_title","Rmd title","DTA-Meta")
 #    	),
    # br(),
    
        # hr(),
        # pickerInput(
        #     inputId="ggplot_theme",
        #     label="select plot theme",
        #     choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))
        # )
    ),

mainPanel(

tabsetPanel(id="Sensitivity_Panel",

    tabPanel("SROC", p(br()),

            tags$b("Sensitivity analysis on SROC curves under four scenarios of selective publication mechanisms"),
            p(br()),
            plotOutput("srocA" , width = "900px", height = "900px")
                ),

   tabPanel("SROC in ggplots",
            fluidRow(
                column(width = 6,
                HTML("<h4>A. c<sub>1</sub>, c<sub>2</sub> are estimated</h4>"),#p(br()),

                # downloadButton("downloadsauc_gg_estimate","Save Image"),
                            
                plotOutput("srocB")

            )
            ,column(width = 6, 
                HTML("<h4>B. c<sub>1</sub>=c<sub>2</sub></h4>"),#p(br()),
                # downloadButton("download_srocC_11","Save Image"),
                
                plotOutput("srocC_11")
                    )
            ,column(width = 6,
                HTML("<h4>C. c<sub>1</sub>=1, c<sub>2</sub>=0</h4>"), #p(br()),

                # downloadButton("download_srocC_10","Save Image"),
                plotOutput("srocC_10")

                    )
            ,column(width = 6,
                HTML("<h4>D. c<sub>1</sub>=0, c<sub>2</sub>=1</h4>"), #p(br()),
                # downloadButton("download_srocC_01","Save Image"),
                    plotOutput("srocC_01")

                    )
            ,column(width = 6,HTML("<h4>E. <h4>c<sub>1</sub>, c<sub>2</sub> are specified</h4>"),p(br()),
                # downloadButton("download_c1c2_manul","Save Image"),
                    sliderInput("c1c2_set",HTML("c<sub>1</sub><sup>2</sup>="),0,1,0.5),
                    plotOutput("srocD")
   
                    
            )
            )),

            tabPanel("SAUC", p(br()),

                h4("Sensitivity analysis on SAUC under four scenarios of selective publication mechanisms"),
                p(br()),
                plotOutput("sauc", width = "900px", height = "900px")
                ),


               tabPanel("Dynamic SAUC in plotly",
                 column(width=6,
                     HTML("<h4>A. c<sub>1</sub>, c<sub>2</sub> are estimated</h4>"),
                    plotly::plotlyOutput("sauc_gg_estimate")
                    ),
                 column(width=6,
                    HTML("<h4>B. c<sub>1</sub>=c<sub>2</sub></h4>"),
                    plotly::plotlyOutput("sauc_gg_c11")
                    ),
                 column(width=6,
                    HTML("<h4>C. c<sub>1</sub>=1, c<sub>2</sub>=0</h4>"),
                    plotly::plotlyOutput("sauc_gg_c10")
                    ),
                 column(width=6,
                    HTML("<h4>D. c<sub>1</sub>=0, c<sub>2</sub>=1</h4>"),
                    plotly::plotlyOutput("sauc_gg_c01")
                    ),
                column(width=6,
                HTML("manual set c<sub>1</sub>, c<sub>2</sub>"),
                    actionButton("c1c2_set_button",HTML("c<sub>1</sub> is set calculate SAUC"),icon=icon("rotate-right")),
                    plotly::plotlyOutput("sauc_gg_cset")
                )
               ),

               tabPanel("Results Table",
                p(br()),
                h4("Summary of the estimates"),
                p(br()),
                HTML("<h4>A. c<sub>1</sub>, c<sub>2</sub> are estimated</h4>"),
                dataTableOutput("Results.est"),
                p(br()),
                HTML("<h4>B. c<sub>1</sub>=c<sub>2</sub></h4>"),
                dataTableOutput("Results11"),
                p(br()),
                HTML("<h4>C. c<sub>1</sub>=1, c<sub>2</sub>=0</h4>"),
                dataTableOutput("Results10"),
                p(br()),
                HTML("<h4>D. c<sub>1</sub>=0, c<sub>2</sub>=1</h4>"),
                dataTableOutput("Results01")

               
            )
               )


               
               # tabPanel("Download Plot", p(br()),

               #  tags$b("Sensitivity analysis on SROC curves under four scenarios of selective publication mechanisms"),
               #  p(br()),
               #  plotOutput("srocA" , width = "700px", height = "700px"),
               #  # downloadButton("downloadsrocA","Save Image"),

               #  p(br()),
               #  h4("Sensitivity analysis on SAUC under four scenarios of selective publication mechanisms"),
               #  p(br()),
               #  plotOutput("sauc", width = "700px", height = "700px"),
                # downloadButton("downloadsauc","Save Image")

                                    # fluidRow(column(width = 6,h4("SROC1","Estimated SROC when c11 and c22 are assigned by the specific values"),
                                    #                 plotOutput("srocA"
                                    #                            #, width = "400px", height = "400px"
                                    #                 ),
                                    #                 downloadButton("downloadsrocA","Save Image"))
                                    #          ,column(width = 6,h4("Probit of α and β","Estimated SROC when c11 and c22 are estimated"),
                                    #                  plotOutput("sauc"
                                    #                             #, width = "400px", height = "400px"
                                    #                  ),
                                    #                  downloadButton("downloadsauc","Save Image"))
                                    #          ,column(width = 6,h4("SAUC","Estimates when c11 and c22 are assigned by the specific values"),
                                    #                  plotOutput("curveAandB"),
                                    #                  downloadButton("downloadcurveAandB","Save Image")))

                                    # )

                           # ,

                           # tabPanel("Reproducible R codes",
                           #           actionButton("RMDdownload","Rmd download",icon = icon("download"))
                           #           ,actionButton("HTMLdownload","html download",icon = icon("download"))
                           #           ,tags$style(
                           #               "#RMDdownload:hover {
                           #               outline-color:#0000ff;
                           #             border-color: #000000;
                           #             background: #4169e1;
                           #             border-radius:3%;
                           #                        color:white;}"
                           #                )
                           #            ,tags$style(#"#downloadreport {
                           #              #background:black;
                           #              #color:yellow;
                           #              #font-size:20rem;}
                           #              #   "#downloadreport:hover {
                           #              # background-color: yellow;
                           #              #            color:black;}"
                           #               "#HTMLdownload:hover {
                           #               outline-color:#0000ff;
                           #             border-color: #000000;
                           #             background: #4169e1;
                           #             border-radius:3%;
                           #                        color:white;}"

                           #                )
                           #           ,verbatimTextOutput("rmd")
                           #           )
    	
                     
                      

    	

    ))