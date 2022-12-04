
sidebarLayout(

sidebarPanel(

tags$style("#calculateStart {background:#4169e1;
color:white;}
#calculateStart:hover {
outline-color:#0000ff;
border-color: #000000;
background: #413E3D;
border-radius:3%;
color:white;}"

),

h3(tags$b("Prepare data for meta-analysis")),

prettyRadioButtons(
inputId = "manualInputTRUE",
label = "1. Choose input way",
icon = icon("check"),
choices = c("Manually input data", "Upload file from local"),
fill = TRUE
),

prettyRadioButtons(
inputId = "Delimiter",
label = "2. Choose delimiter that separates the values", 
# status = "info",
# fill = TRUE,
icon = icon("check"),
choiceNames = list(
HTML("Comma (,) which is default in *.csv file"),
HTML("One Tab (->|) which is default in *.txt txt file"),
HTML("Semicolon (;)"),
HTML("One Space (_)")
),
choiceValues = list(",", "\t", ";", " "),
fill = TRUE
),

conditionalPanel(
	condition = "input.manualInputTRUE=='Upload file from local'",
	icon("file-excel"),
	helpText(HTML("<i>Note:</i> you can revise the data directly, 
		and please make sure the variable names contain <b>TP, FN, FP, TN</b>")),
	fileInput("filer",
		label = "Upload your csv and txt files, and data will be shown in the box", 
		accept = "application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,text/csv")),


tags$b("3. Edit data here"),
helpText(HTML("<i>Note:</i> 
	please make sure the data are named as <b>TP, FN, FP, TN</b>.
	<br></br>
	If you upload your data, please click the button to load your data")),

aceEditor("manualInput"
,value = "study,TP,FN,FP,TN\n1,12,0,29,289\n2,10,2,14,72\n3,17,1,36,85\n4,13,0,18,67\n5,4,0,21,225\n6,15,2,122,403\n7,45,5,28,34\n8,18,4,69,133\n9,5,0,11,34\n10,8,9,15,96\n11,5,0,7,63\n12,11,2,122,610\n13,5,1,6,145\n14,7,5,25,342
15,10,1,93,296\n16,5,5,41,271\n17,5,0,15,53\n18,55,13,19,913\n19,6,2,12,30\n20,42,26,19,913\n21,5,3,5,37\n22,13,0,11,125\n23,20,0,24,287\n24,7,6,13,72\n25,48,2,15,47\n26,11,1,14,72
27,15,5,32,170\n28,68,13,5,11,\n29,13,1,5,72\n30,8,3,66,323\n31,13,1,98,293\n32,14,1,0,155\n33,8,2,4,60"
,mode = "r"
,theme="eclipse"
),

p(br()),
actionButton("calculateStart",
	tags$b(HTML("Update data and results")),
	icon = icon("rotate-right")),

p(br()),

prettyRadioButtons(
inputId = "allsingle",
label = "Continuity correction type",
choiceNames = c("Correction for single study", "Correction for all studies"),
choiceValues = c("single", "all"),
selected = "single",
# status = "info",
fill = TRUE,
icon = icon("check")
),
helpText(HTML('
<i>Note:</i>
if there were 0 inputs in TN, FN, FP, or TN, continuity correction will be made.
<ol>
<li><b>Correction for single study:</b> TN, FN, FP, TN are added 0.5 only for the studies that have 0 inputs</li>
<li><b>Correction for all studies:</b> the whole data are added 0.5 for all studies if there were 0 inputs</li>
</ol>
')),

hr(),

h3(tags$b("Variance")),

selectInput("ci.method", label = "Select methods of variance", 
	choices = list(
	"Wald (default)" = "wald", 
	"Wilson" = "wilson", 
	"Agresti-Coull" = "agresti-coull", 
	"Jeffreys" = "jeffreys",
	"Modified Wilson" = "modified wilson", 
	"Modified Jeffreys" = "modified jeffreys", 
	"Clopper-Pearson" = "clopper-pearson", 
	"Arcsine transformation" = "arcsine", 
	"Logit transformation" = "logit",
	"Witting" = "witting"), 
	selected = "wald")
,
helpText(HTML('
<i>Note:</i> 
different methods cause some change in the variances and CIs in the summary 
')),

hr(),
h3(tags$b("Confidence Intervals (CIs)")),

sliderInput("ci.level", 
	label = "Significance level of CIs", 
	value = 0.95, 
	min = 0.50, max = 0.99, step = 0.01),
helpText(HTML("<i>Note:</i> this control CIs in the plots and tables")),





#       selectInput(
#     inputId = "letter",
#     label = "Label with popover help",
#     choices = c("a", "b", "c")
#   ) %>%
#   shinyInput_label_embed(
#     shiny_iconlink() %>%
#     bs_embed_popover(
#       title = '<div class="media"><img src="mochi.jpg" height="70" width="90"/></div>',content=HTML('<div class="media"><img src="mochi.jpg" height="70" width="90"/></div>')  #,img(src="mochi.jpg", height = 70, width = 90)'
#       , placement = "left"
#     )),
#      use_bs_tooltip(),
#    use_bs_popover(),
#    withMathJax(),img(src="mochi.jpg", height = 70, width = 90),
# p(HTML("<b>UU</b>"),span(shiny::icon("info-circle"), id = "info_uu"),numericInput('uu', NULL, 10000),
#                              tippy::tippy_this(elementId = "info_uu",tooltip = "Number of Unique Users of your experiment",placement = "right")),

# icon("keyboard"),
# icon("calendar"),
# icon = icon("calendar"),


# ,verbatimTextOutput("debug")                      
),
mainPanel(
h4(tags$b("Data Preview")),
tabsetPanel(

tabPanel(
	"Input Data", p(br()),
	DTOutput("RawData")
	),
	
tabPanel(
	"Data after continuity correction",p(br()),

	DTOutput("CorData")
	),

tabPanel(
	"Data after logit-transformation",p(br()),
	DTOutput("LogData"),
helpText(HTML('
<i>Note:</i> 
logit transformation is $\\mathrm{logit}(x)=\\log(\\dfrac{x}{1-x})$
<ul>
<li><b>Sens</b>: sensitivity$=\\dfrac{TP}{TP+FN}$; <b>Spec</b>: specificity$=\\dfrac{TN}{TN+FP}$</li>
<li><b>y1</b>: $\\mathrm{logit}(\\mathrm{Sens})$; <b>y2</b>: $\\mathrm{logit}(\\mathrm{Spec})$</li>
<li><b>v1</b>: variance of y1; <b>v2</b>: variance of y2</li>
</ul>
'))
	)

),


# DTOutput("CorData"),
hr(),

h4(tags$b("Outputs: Descriptive Statistics")),
tabsetPanel(

tabPanel("ROC scatter plot", p(br()),
tags$b("1. Configurations of the following plot"), p(br()),
	awesomeCheckbox( 
	   inputId = "studypp",
	   label = "Add ROC scatter point of studies", 
	   value = TRUE
	   ),

	awesomeCheckbox( 
	   inputId = "ROCellipse",
	   label = "Add CI region for each study", 
	   value = FALSE
	   ),
	 
	 awesomeCheckbox( 
	   inputId = "Crosshair",
	   label = "Add crosshair CI for each study", 
	   value = FALSE
	 ),

  splitLayout(
   textInput("ci.xlab", label = "Label for x-axis", value = "1-Specificity"),
   textInput("ci.ylab", label = "Label for y-axis", value = "Sensitivity"),
	), 
tags$b("2. Scatter plot of the Sens and Spec of each sttudy"), p(br()),
  plotOutput("plot_ci",  height ="600px", width = "600px")

),

tabPanel("Summary of Sens and Spec", p(br()),
	
tags$b("1. Summary of sensitivity (Sens) and specificity (Sepc)"), p(br()),
DTOutput("se_sp"), p(br()),	
helpText(HTML('
Note: 
<ul>
<li><b>Sens</b>: sensitivity$=\\dfrac{TP}{TP+FN}$</li>
<li><b>Sens.CI.lower</b>: lower bound of CI; <b>Sens.CI.upper</b>: upper bound of CI</li>
<li><b>Spec</b>: specificity$=\\dfrac{TN}{TN+FP}$</li>
<li><b>Spec.CI.lower</b>: lower bound of CI; <b>Spec.CI.upper</b>: upper bound of CI</li>
</ul>
')),
hr(),
	
tags$b("2. Test of equality"), p(br()),
DTOutput("se_sp_test"), hr(),

tags$b("3. Forest plots"), p(br()),
splitLayout(
  textInput("se.title", label = "Change title for the plot", value = "Sensitivity"),
  textInput("sp.title", label = "Change title for the plot", value = "Specificity")
), p(br()),

uiOutput("meta_sesp_plot")

),

tabPanel(
"Summary of DOR", p(br()),
tags$b("1. Summary of the diagnostic odds ratio (DOR)"), p(br()),
DTOutput("dor"), p(br()),

helpText(HTML('
Note: 
<ul>
<li><b>DOR</b>: diagnostic odds ratio</li>
<li><b>DOR.CI.lower</b>: lower bound of CI; <b>DOR.CI.upper</b>: upper bound of CI</li>
<li><b>lnDOR.se</b>: standard error of log-transformed DOR</li>
</ul>
')),hr(),

tags$b("2. Forest plots"), p(br()),
awesomeCheckbox(
inputId = "uni.log1",
label = "Show log-transformed results", 
value = TRUE
),

textInput("u1.title", label = "Change title for the plot", value = "Log diagnostic odds ratio"),
p(br()),

uiOutput("meta_dor_plot")

),

tabPanel(
"Summary of LRs", p(br()),
tags$b("1. Summary of the positive or negative likelihood ratios (LRs)"), p(br()),
DTOutput("uni.measure"), p(br()),

helpText(HTML('
Note: 
<ul>
<li><b>PosLR</b>: positive likelihood ratio</li>
<li><b>PosLR.CI.lower</b>: lower bound of CI; <b>PosLR.CI.upper</b>: upper bound of CI</li>
<li><b>lnPosLR.se</b>: standard error of log-transformed positive likelihood ratio</li>
<li><b>NegLR</b>: negative likelihood ratio</li>
<li><b>NegLR.CI.lower</b>: lower bound of CI; <b>NegLR.CI.upper</b>: upper bound of CI</li>
<li><b>lnNegLR.se</b>: standard error of log-transformed negative likelihood ratio</li>
</ul>
')),hr(),

tags$b("2. Forest plots"), p(br()),

awesomeCheckbox(
	inputId = "uni.log2",
	label = "Show log-transformed results", 
	value = TRUE
),

splitLayout(
	textInput("u2.title", label = "Change title for the plot", value = "Log negative LR"),
	textInput("u3.title", label = "Change title for the plot", value = "Log positive LR")
	), 
p(br()),

uiOutput("meta_uni_plot")

)

# tabPanel(
# 	"Studies distribution and CIs", p(br()),

# 	prettyCheckbox( 
# 	   inputId = "studypp",
# 	   label = "Only points of studies", 
# 	   value = TRUE,
# 	   icon = icon("check")
# 	   ),

# 	prettyCheckbox( 
# 	   inputId = "ROCellipse",
# 	   label = "Add CI region", 
# 	   value = FALSE,
# 	   icon = icon("check")
# 	   ),
	 
# 	 prettyCheckbox( 
# 	   inputId = "Crosshair",
# 	   label = "Add crosshair CI", 
# 	   value = FALSE,
# 	   icon = icon("check")
# 	 ),

# # prettyCheckbox( 
# # 	   inputId = "mslSROC",
# # 	   label = "Add Moses-Shapiro-Littenberg SROC curve", 
# # 	   value = FALSE,
# # 	   icon = icon("check")
# # 	   ),
	 
# # 	 prettyCheckbox( 
# # 	   inputId = "rsSROC",
# # 	   label = "Add Ruecker-Schumacher (2010) SROC curve", 
# # 	   value = TRUE,
# # 	   icon = icon("check")
# # 	 ), 
# 	 p(br()),


#   splitLayout(
#    textInput("ci.xlab", label = "Label for x-axis", value = "1-Specificity"),
#    textInput("ci.ylab", label = "Label for y-axis", value = "Sensitivity"),
# 	), 
#   p(br()),

#   plotOutput("plot_ci",  height ="600px", width = "600px")


# )

)
)
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