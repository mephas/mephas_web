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
tags$style("#calculateSROC {background:#4169e1;
color:white;}
#calculateStart:hover {
outline-color:#0000ff;
border-color: #000000;
background: #413E3D;
border-radius:3%;
color:white;}"
),

#----------------------------------------------------------------------------------------
h3(("Sensitivity analysis on SROC")), 

HTML(
'<h5>1. Input marginal selection probability ($0 \\le p\\le 1$)</h5>
<b><input type="text" id="plist" value="1,0.8,0.6" pattern="^[\\d,　.]+$">
</b>'), 
p("Check inputs"),
verbatimTextOutput("uiprob"), 

# helpText(HTML("<i>Note:</i>
# the marginal selection probability ($p$) is the sensitivity parameter.
# It indicate the expected proportion of the published studies from the population.
# See more details in Help above
# ")),

prettyRadioButtons(
inputId = "Sauc1",
label = h5("2. Choose SROC type"),
choices = list("SROC" ="sroc", "HSROC"="hsroc"),
selected = "sroc",
shape = "square",
icon = icon("check"),
fill = TRUE
), 
helpText(HTML("<i>Note:</i> 
    the HSROC curve is given by the SROC curve with $\\rho=-1$")),

# prettyCheckbox(
#   inputId = "SettingParamater", 
#   label = ("3. More configurations in the optimization"),
#   shape = "round", outline = TRUE, status = "info", value=FALSE
# ),

prettySwitch(
inputId = "SettingParamater",
label = ("3. More configurations in the optimization"),
value = FALSE,
fill = TRUE,
status = "primary"
),

conditionalPanel(condition="input.SettingParamater",

helpText(HTML("<i>Note:</i> 
    The following parameters are in the selection function.
    See more details in <b>Help and Download</b> panel")),
sliderInput("beta", label = HTML("Estimating range of $\\beta$"), min = 0, 
        max = 4, value = c(0,2), step=0.05),
helpText(HTML("<i>Note:</i> 
    $\\beta$ will be estimated within this range")),
sliderInput("beta0", label = HTML("Initial value of $\\beta$"), min = 0, 
        max = 2, value = 1, step=0.05),
helpText(HTML("<i>Note:</i> 
    $\\beta$'s range is too large or initial value may make cause non-convergence")),
# uiOutput("beta0"),
# helpText(HTML("<i>Note:</i> 
#     the start values for estimating $\\beta$")),

sliderInput("alpha", label = HTML("Estimating range of $\\alpha$"), min = -10, 
        max = 10, value = c(-3, 3)),
helpText(HTML("<i>Note:</i> 
    $\\alpha$ will be estimated within this range")),
sliderInput("c0",label = HTML("Initial value for estimating $c_1^2$"), min = 0.1, 
        max = 0.9, value = 0.5, step=0.1),

helpText(HTML("<i>Note:</i> $c_2^2=1-c_!^2$. 
    The start values for estimating $c_1, c_2$"))
# uiOutput("beta0")

),

actionButton("calculateSROC",
(HTML("Click to get SROC")),
icon = icon("rotate-right")),
helpText(HTML("<i>Note:</i>
    it may take more time if you input many $p$'s. 
    If you change the parameters, please click the button to re-calculate")),


hr(),
h3(("Sensitivity analysis on SAUC")), 

sliderInput("plistsauc",HTML("<h5>Set the increment of the sequence of $p$</h5>"),0,1,0.1,step=0.01),
p("Check inputs"),
verbatimTextOutput("p10list"), 


actionButton("calculateSAUC",
(HTML("Click to get SAUC")),
icon = icon("rotate-right")),
helpText(HTML("<i>Note:</i>
    it may take more time if the sequence of $p$ is long. If you change the parameters above, please click the button to re-calculate")),


hr(),
h3(("Configurations of the dynamic plots")), 
selectInput(
inputId="sensisetting",
h5("1. Choose SROC or SAUC plots"),
choices=c("Neither","Dynamic SROC","Dynamic SAUC")
),
# selectInput(
# inputId="ggplot_theme",
# label=h5("2. Select ggplot theme"),
# choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))
# ),

conditionalPanel(condition="input.sensisetting=='Dynamic SAUC'",
selectInput(
inputId="ggplot_theme2",
label=h5("2. Select ggplot theme"),
choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))
)
),

conditionalPanel(condition="input.sensisetting=='Dynamic SROC'",
# radioGroupButtons(
# inputId = "batch",
# label = h4("Configure all SROC in the batch way?"), 
# choices = list("In the batch way" =TRUE, "In each plot"=FALSE),
# selected = "TRUE",
# justified = TRUE
# # checkIcon = list("TRUE" = icon("ok", lib = "glyphicon"), "FALSE" = icon("remove", lib = "glyphicon"))
# ),
selectInput(
inputId="ggplot_theme",
label=h5("2. Select ggplot theme"),
choices=paste0("theme_",c("bw","classic","light","linedraw","minimal","test","void","default"))
),
selectInput("xlim", label = h5("3. Label for x-axis"), choices = c("1-Specificity","FPR"), selected = "1-Specificity"),
selectInput("ylim",label = h5("4. Label for y-axis"), choices = c("Sensitivity","TPR"), selected = "Sensitivity"),

prettySwitch(
  inputId = "batch", label = "Edit all SROC in the batch way?",
  value = TRUE,
   fill = TRUE,
   status = "primary"
),

# h4(prettyCheckbox(
#   inputId = "batch_sig", label = "Configure each SROC separately?",
#   shape = "round", outline = TRUE, status = "info", value=FALSE
# )),

# prettyRadioButtons(
#    inputId = "batch",
#    label = "How would you edit the plot", 
#    selected ='A',
#   choiceNames = c("a","b","c"),
#   choiceValues = c("a","b","c")
#     # choices = list("Do nothing"="A", 
#     #     "Edit all SROC in the batch way"="B", 
#     #     "Configure each SROC separately"="C")
# ),

# conditionalPanel(condition="input.batch=='a'"),

conditionalPanel(condition="input.batch",
(h5("5. Points of each study in the data")),
colorPickr("each_point_color",  "Points' color",selected="#000000"),#47848C
sliderInput("each_point_radius","Points' radius",min = 0,max=10,value = 2, step=0.1),
sliderInput("each_point_shape", "Points' shape",min = 0, max=25,value = 1, step=1),
uiOutput("each_point_id"),

(h5("6. Estimated summary point accounting for PB")),
colorPickr("sroc_point_color",  "Point's color",selected="#0A99BD"),
sliderInput("sroc_point_radius","Point radius",min = 0,max=10,value = 2, step=0.1),
sliderInput("sroc_point_shape", "Point shape", min = 0,max=25,value = 18,step=1),

(h5("7. Estimated SROC accounting for PB")),
colorPickr("sroc_curve_color","SROC curve's color",selected="#39377A"),
sliderInput("sroc_curve_thick","SROC curve's thickness",min = 0,max=10,value = 0.5, step=0.1),
sliderTextInput(paste0("sroc_curve_shape"),grid = TRUE,label = "SROC curve's shape",choices = c("blank","solid","dashed","dotted","dotdash","longdash","twodash"),selected = "solid")
),

conditionalPanel(condition="!input.batch",
h5("3. For the plot of $(\\hat c_1, \\hat c_2)$ "),
ui.plot_baseset_drop("c1c2_estimate"),uiOutput("srocBsetting_curve"),
h5("4. For the plot of $c_1 = c_2$"),
ui.plot_baseset_drop("c1c2_11"),uiOutput("srocCsetting_curve_11"),
h5("5. For the plot of $(c_1, c_2)=(1,0)$"),
ui.plot_baseset_drop("c1c2_10"),uiOutput("srocCsetting_curve_10"),
h5("6. For the plot of $(c_1, c_2)=(0,1)$"),
ui.plot_baseset_drop("c1c2_01"),uiOutput("srocCsetting_curve_01"),
h5("7. For the plot of user-specified $c_1^2, c_2^2$"),
# ui.plot_baseline_drop("c1c2_manul",plot_title = "Specified $c_1^2$", x_axis = "1-Specificity",y_axis = "Sensitivity"),
ui.plot_baseset_drop("c1c2_manul"),uiOutput("srocDsetting_curve")
))
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

tabPanel("Dynamic SROC",
h5("Sensitivity analysis on SROC curves under four scenarios of selective publication mechanisms"),
helpText(HTML("<i>Note:</i>
    there may be issues of non-convergence in the results; in such case, some results are missing. 
    <p>For the detailed estimates, please check the results table in the <b>Results Table</b>.</p>")),
fluidRow(
column(width = 6,
HTML("<h4>A. c<sub>1</sub>, c<sub>2</sub> are estimated</h4>"),
# plotOutput("srocB",  width = "500px", height = "500px")
plotly::plotlyOutput("srocB", width = "500px", height = "500px")

)
,column(width = 6, 
HTML("<h4>B. c<sub>1</sub>=c<sub>2</sub></h4>"),
# plotOutput("srocC_11", width = "500px", height = "500px")
plotly::plotlyOutput("srocC_11", width = "500px", height = "500px")

)
,column(width = 6,
HTML("<h4>C. c<sub>1</sub>=1, c<sub>2</sub>=0</h4>"),
# plotOutput("srocC_10", width = "500px", height = "500px")
plotly::plotlyOutput("srocC_10", width = "500px", height = "500px")

)
,column(width = 6,
HTML("<h4>D. c<sub>1</sub>=0, c<sub>2</sub>=1</h4>"),
# plotOutput("srocC_01", width = "500px", height = "500px")
plotly::plotlyOutput("srocC_01", width = "500px", height = "500px")

)
,column(width = 6,
HTML("<h4>E. c<sub>1</sub>, c<sub>2</sub> are specified</h4>"),
# downloadButton("download_c1c2_manul","Save Image"),
sliderInput("c1c2_set",HTML("$c_1^2$"),0,1,0.5),
# plotOutput("srocD", width = "500px", height = "500px")
plotly::plotlyOutput("srocD", width = "500px", height = "500px")


)
)),

tabPanel("SROC", p(br()),

h5("Sensitivity analysis on SROC curves under four scenarios of selective publication mechanisms"),
helpText(HTML("<i>Note:</i>
    there may be issues of non-convergence in the results; in such case, some results are missing. 
   <p>For the detailed estimates, please check the results table in the <b>Results Table</b>.</p>")),
p(br()),
plotOutput("srocA" , width = "900px", height = "900px")
),

tabPanel("Dynamic SAUC",
h5("Sensitivity analysis on SAUC under four scenarios of selective publication mechanisms"),
helpText(HTML("<i>Note:</i>
    click the button to start calculation at the first time.
    <p>There may be issues of non-convergence in the results; in such case, some results are missing.</p>")),

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
# helpText(HTML("Note: click the button to start calculation at the first time.")),
h5("Sensitivity analysis on SAUC under four scenarios of selective publication mechanisms"),
helpText(HTML("Note: there may be issues of non-convergence in the results; in such case, some results are missing.")),
p(br()),
plotOutput("sauc", width = "900px", height = "900px")
),

tabPanel("Estimates Table",
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

               #  ("Sensitivity analysis on SROC curves under four scenarios of selective publication mechanisms"),
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