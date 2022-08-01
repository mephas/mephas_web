sidebarLayout(
	sidebarPanel(
    tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
    tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),
    h4(tags$b("Step5. Setting"))
    ),
    mainPanel(
    	    tabsetPanel(
                           tabPanel("SROC",
                                    fluidRow(column(width = 6,h4("c1c2","estimate",downloadButton("downloadsauc_gg_estimate","Save Image")),
                                                    plotOutput("srocB"),
                                                    flowLayout(ui.plot_baseset_drop("c1c2_estimate"),uiOutput("srocBsetting_curve"))
                                    )
                                    ,column(width = 6,h4("c1c2","c1=c2",downloadButton("download_srocC_11","Save Image")),
                                            plotOutput("srocC_11"),
                                            flowLayout(ui.plot_baseset_drop("c1c2_11"),uiOutput("srocCsetting_curve_11")))
                                    ,column(width = 6,h4("c1c2","c1=1,c2=0",downloadButton("download_srocC_10","Save Image")),
                                            plotOutput("srocC_10"),flowLayout(ui.plot_baseset_drop("c1c2_10"),uiOutput("srocCsetting_curve_10")
                                            ))
                                    ,column(width = 6,h4("c1c2","c1=0,c2=1",downloadButton("download_srocC_01","Save Image")),
                                            plotOutput("srocC_01"),flowLayout(ui.plot_baseset_drop("c1c2_01"),uiOutput("srocCsetting_curve_01")
                                            ))
                                    ,column(width = 6,h4("c1c2","Manual set",downloadButton("download_c1c2_manul","Save Image")),
                                            sliderInput("c1c2_set","c1::",0,1,0.5),actionButton("c1c2_set_button","c1c2"),
                                            plotOutput("srocD"),
                                            flowLayout(ui.plot_baseline_drop("c1c2_manul",plot_title = "C1C2",x_axis = "1-sp",y_axis = "se"),
                                                       ui.plot_baseset_drop("c1c2_manul"),uiOutput("srocDsetting_curve"))
                                            
                                    ))),
                           tabPanel("SAUC",flowLayout( 
                             plotly::plotlyOutput(width="600px","sauc_gg_estimate"),br(),br(),
                             plotly::plotlyOutput(width="300%","sauc_gg_c11"),br(),br(),
                             plotly::plotlyOutput(width="300%","sauc_gg_c10"),br(),br(),
                             plotly::plotlyOutput(width="300%","sauc_gg_c01")
                           )),
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