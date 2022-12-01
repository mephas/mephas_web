sidebarLayout(
sidebarPanel(

tags$head(tags$style("#uiprob {background: white; color: #5A5A5A};")),
tags$head(tags$style("#p10list {background: white; color: #5A5A5A};")),
tags$style("#calculateSAUC {background:#4169e1;
color:white;}
#calculateStart:hover {
outline-color:#0000ff;
border-color: #000000;
background: #413E3D;
border-radius:3%;
color:white;}"
),

h3(tags$b("Assign marginal selection probabilities for SROC")), 
p(br()),
HTML(
'<b>1. Input marginal selection probabilities ($0 \\le p\\le 1$)<br></br>
<input type="text" id="plist" value="0.9,0.7,0.5" pattern="^[\\d,　.]+$">
</b>'), 
p(br()),
verbatimTextOutput("uiprob"), 

helpText(HTML("Note: the marginal selection probability ($p$) is the sensitivity parameter.
It indicate the expected proportion of the published studies from the population.
See more details in Help above
")),

radioGroupButtons(
inputId = "Sauc1",
label = "2. Choose SROC type",
choices = list("SROC" ="sroc", "HSROC"="hsroc"),
selected = "sroc",
justified = TRUE,
checkIcon = list(
yes = icon("ok",
lib = "glyphicon"))
), 
helpText(HTML("Note: the HSROC curve is given by the SROC curve with $\\rho=-1$")),

hr(),
h3(tags$b("Assign a sequence of marginal selection probabilities for SAUC")), 
p(br()),
sliderInput("plistsauc","1. Choose the size the gap in the sequence",0,1,0.1,step=0.01),
verbatimTextOutput("p10list"), 
p(br()),
actionButton("calculateSAUC",
tags$b(HTML("Click to calculate SAUC")),
icon = icon("rotate-right")),
helpText("Note: it may take a while"),
p(br()),

hr(),
h3(tags$b("Configurations of the ggplots")), 
p(br()),
pickerInput(
inputId="sensisetting",
"1. Choose SROC or SAUC plots",
choices=c("SROC in ggplots","Dynamic SAUC in plotly")
),
pickerInput(
inputId="ggplot_theme",
label="2. Select ggplot theme",
choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))
),
hr(),
conditionalPanel(condition="input.sensisetting=='SROC in ggplots'",
# radioGroupButtons(
# inputId = "batch",
# label = h4("Configure all SROC in the batch way?"), 
# choices = list("In the batch way" =TRUE, "In each plot"=FALSE),
# selected = "TRUE",
# justified = TRUE
# # checkIcon = list("TRUE" = icon("ok", lib = "glyphicon"), "FALSE" = icon("remove", lib = "glyphicon"))
# ),

h4(prettyCheckbox(
  inputId = "batch", label = "Configure all SROC in the batch way?",
  shape = "round", outline = TRUE, status = "info", value=FALSE
)),

h4(prettyCheckbox(
  inputId = "batch_sig", label = "Configure each SROC separately?",
  shape = "round", outline = TRUE, status = "info", value=FALSE
)),

h4(textInput("xlim","1. Label of the x-axis","1-Specificity")),
h4(textInput("ylim","2. Label of the y-axis","Sensitivity")),

conditionalPanel(condition="input.batch",
h4(tags$b("3. Points of each study in the data")),
colorPickr("each_point_color",  "Points' color",selected="#000000"),#47848C
sliderInput("each_point_radius","Points' radius",min = 0,max=10,value = 3),
sliderInput("each_point_shape", "Points' shape",min = 0,max=25,value = 1),
p(br()),
h4(tags$b("4. Estimated summary point accounting for PB")),
colorPickr("sroc_point_color",  "Point's color",selected="#0A99BD"),
sliderInput("sroc_point_radius","Point radius",min = 0,max=10,value = 5),
sliderInput("sroc_point_shape", "Point shape",min = 0,max=25,value = 18),
p(br()),
h4(tags$b("5. Estimated SROC accounting for PB")),
colorPickr("sroc_curve_color","SROC curve's color",selected="#39377A"),
sliderInput("sroc_curve_thick","SROC curve's thickness",min = 0,max=10,value = 1),
sliderTextInput(paste0("sroc_curve_shape"),grid = TRUE,label = "SROC curve's shape",choices = c("blank","solid","dashed","dotted","dotdash","longdash","twodash"),selected = "solid")
),

conditionalPanel(condition="input.batch_sig",
h4("For the plot of $(\\hat c_1, \\hat c_2)$ "),
ui.plot_baseset_drop("c1c2_estimate"),uiOutput("srocBsetting_curve"),
h4("For the plot of $c_1 = c_2$"),
ui.plot_baseset_drop("c1c2_11"),uiOutput("srocCsetting_curve_11"),
h4("For the plot of $(c_1, c_2)=(1,0)$"),
ui.plot_baseset_drop("c1c2_10"),uiOutput("srocCsetting_curve_10"),
h4("For the plot of $(c_1, c_2)=(0,1)$"),
ui.plot_baseset_drop("c1c2_01"),uiOutput("srocCsetting_curve_01"),
h4("For the plot of user-specified $c_1^2, c_2^2$"),
# ui.plot_baseline_drop("c1c2_manul",plot_title = "Specified $c_1^2$", x_axis = "1-Specificity",y_axis = "Sensitivity"),
ui.plot_baseset_drop("c1c2_manul"),uiOutput("srocDsetting_curve")
)),
h4(prettyCheckbox(
  inputId = "SettingParamater", label = "Configure More detail Caluculation Setting?",
  shape = "round", outline = TRUE, status = "info", value=FALSE
)),
conditionalPanel(condition="input.SettingParamater",
sliderInput("alpha", label = h4("Alpha lange"), min = -10, 
        max = 10, value = c(-3, 3))
,
sliderInput("beta", label = h4("Beta lange"), min = 0, 
        max = 10, value = c(0,2))
,uiOutput("beta0"),
actionButton("calculateSAUC",
tags$b(HTML("Click to calculate SAUC")),
icon = icon("rotate-right"))
)
),

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

mainPanel(

tabsetPanel(id="Sensitivity_Panel",


tabPanel("SROC in ggplots",
fluidRow(
column(width = 6,
HTML("<h4>A. c<sub>1</sub>, c<sub>2</sub> are estimated</h4>"),
plotOutput("srocB",  width = "500px", height = "500px")

)
,column(width = 6, 
HTML("<h4>B. c<sub>1</sub>=c<sub>2</sub></h4>"),
plotOutput("srocC_11", width = "500px", height = "500px")
)
,column(width = 6,
HTML("<h4>C. c<sub>1</sub>=1, c<sub>2</sub>=0</h4>"),
plotOutput("srocC_10", width = "500px", height = "500px")

)
,column(width = 6,
HTML("<h4>D. c<sub>1</sub>=0, c<sub>2</sub>=1</h4>"),
plotOutput("srocC_01", width = "500px", height = "500px")

)
,column(width = 6,
HTML("<h4>E. c<sub>1</sub>, c<sub>2</sub> are specified</h4>"),
# downloadButton("download_c1c2_manul","Save Image"),
sliderInput("c1c2_set",HTML("$c_1^2$"),0,1,0.5),
plotOutput("srocD", width = "500px", height = "500px")


)
)),

tabPanel("SROC", p(br()),

h4("Sensitivity analysis on SROC curves under four scenarios of selective publication mechanisms"),
p(br()),
plotOutput("srocA" , width = "900px", height = "900px")
),

tabPanel("Dynamic SAUC in plotly",
helpText("Note: click the button to start calculation at the first time."),

column(width=6,
HTML("<h4>A. c<sub>1</sub>, c<sub>2</sub> are estimated</h4>"),
plotly::plotlyOutput("sauc_gg_estimate", width = "500px", height = "500px")
),
column(width=6,
HTML("<h4>B. c<sub>1</sub>=c<sub>2</sub></h4>"),
plotly::plotlyOutput("sauc_gg_c11", width = "500px", height = "500px")
),
column(width=6,
HTML("<h4>C. c<sub>1</sub>=1, c<sub>2</sub>=0</h4>"),
plotly::plotlyOutput("sauc_gg_c10", width = "500px", height = "500px")
),
column(width=6,
HTML("<h4>D. c<sub>1</sub>=0, c<sub>2</sub>=1</h4>"),
plotly::plotlyOutput("sauc_gg_c01", width = "500px", height = "500px")
),
column(width=6,
HTML("<h4>E. c<sub>1</sub>, c<sub>2</sub> are specified</h4>"),
actionButton("c1c2_set_button",
    HTML("After c<sub>1</sub> is set, click to update SAUC"),
    icon=icon("rotate-right")),
plotly::plotlyOutput("sauc_gg_cset", width = "500px", height = "500px")
)
),

tabPanel("SAUC", p(br()),
helpText("Note: click the button to start calculation at the first time."),

h4("Sensitivity analysis on SAUC under four scenarios of selective publication mechanisms"),
p(br()),
plotOutput("sauc", width = "900px", height = "900px")
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