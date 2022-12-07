sidebarLayout(

# tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

sidebarPanel(
tags$style("#reitsma {background: white; color: #5A5A5A};"),
tags$style("#glmm {background: white; color: #5A5A5A};"),

h3(("Reitsma's model")),

# selectInput("alpha", label = "1. Transformation of Sens and Spec", 
# 	choices = list(
# 	"Logit" = 1, 
# 	"2-log" = 0, 
# 	"1.4" = 1.4, 
# 	"1.8" = 1.8), 
# 	selected = 1),

selectInput("res.method", label = h5("Choose optimization methods for estimating the parameters"), 
	choices = list(
	"Restricted maximum likelihood (ReML)" = "reml", 
	"Maximum likelihood (ML)" = "ml", 
	"Method of moment (MM)" = "mm",
	"Variance components" = "vc"),
	# "Fixed-effects model" = "fixed"), 
	selected = "ml"),

helpText(HTML('
<i>Note:</i>
the often used methods are "ReML" and "ML"
')),

hr(),

h3(("Summary ROC (SROC) Plot")), 

h5("1. Configuration of SROC plot"), 


prettyCheckbox( 
   inputId = "studypp2",
   label = "Add ROC points of studies", 
   value = TRUE,
   shape = "square",
   fill = TRUE,
   icon = icon("check"),
   status = "primary"
 ),

h5("2. SROC curve by two models"), 
helpText(HTML("<i>Note:</i>
   see the equation of SROC in <b>Help and Download</b> panel")),

# tags$b("Reitsma's model"), 

prettySwitch( 
   inputId = "reitmaSROC",
   label = "Add the Reitsma's SROC curve", 
   value = FALSE,
   fill = TRUE,
   status = "primary"
 ),

# materialSwitch(
#    inputId = "reitmaSROC",
#    label = ("Add the Reitsma's SROC curve"),
#    status = "primary",
#    value = TRUE,
#    right = TRUE,
#    inline = TRUE
# ),

conditionalPanel(condition="input.reitmaSROC",
   prettyCheckbox( 
   inputId = "res.pt",
   label = "Add estimated summary point", 
   value = TRUE,
   shape = "square",
   fill = TRUE,
   icon = icon("check"),
   status = "primary"
 ),
   prettyCheckbox( 
   inputId = "res.ci",
   label = "Add CI region of the summary point", 
   value = FALSE,
   shape = "square",
   fill = TRUE,
   icon = icon("check"),
   status = "primary"
 )
# awesomeCheckbox( 
#    inputId = "res.pt",
#    label = "Add estimated summary point", 
#    value = TRUE
#  ),

# awesomeCheckbox( 
#    inputId = "res.ci",
#    label = "Add CI region of the summary point", 
#    value = FALSE
#  )
),

# h5("GLM model"), 

prettySwitch( 
   inputId = "glmmSROC",
   label = "Add the GLMM SROC curve", 
   value = FALSE,
   fill = TRUE,
   status = "primary"
 ),

# materialSwitch(
#    inputId = "glmmSROC",
#    label = ("Add the GLM model's SROC curve"),
#    status = "primary",
#    value = FALSE,
#    right = TRUE,
#    inline = TRUE
# ),
conditionalPanel(condition="input.glmmSROC",

# awesomeCheckbox( 
#    inputId = "glmm.pt",
#    label = "Add the GLMM SROC curve", 
#    value = FALSE
#  )
prettyCheckbox( 
   inputId = "glmm.pt",
   label = "Add the GLMM SROC curve", 
   value = FALSE,
   shape = "square",
   fill = TRUE,
   icon = icon("check"),
   status = "primary"
 )
),



prettySwitch( 
   inputId = "othersroc",
   label = "Add other SROC curve", 
   value = FALSE,
   fill = TRUE,
   status = "primary"
 ),
conditionalPanel(condition="input.othersroc",

   prettyCheckbox( 
   inputId = "mslSROC",
   label = "Add Moses-Shapiro-Littenberg SROC curve", 
   value = FALSE,
   shape = "square",
   fill = TRUE,
   icon = icon("check"),
   status = "primary"
 ),
   prettyCheckbox( 
   inputId = "rsSROC",
   label = "Add Ruecker-Schumacher (2010) SROC curve", 
   value = FALSE,
   shape = "square",
   fill = TRUE,
   icon = icon("check"),
   status = "primary"
 )
# awesomeCheckbox( 
#    inputId = "mslSROC",
#    label = "Add Moses-Shapiro-Littenberg SROC curve", 
#    value = FALSE
#    ),
 
#  awesomeCheckbox( 
#    inputId = "rsSROC",
#    label = "Add Ruecker-Schumacher (2010) SROC curve", 
#    value = FALSE
#  )
 ), 
# hr(),

# h5("3. Other configurations"), 
	selectInput("sroc.xlab", label = h5("3. Label for x-axis"), choices = c("1-Specificity","FPR"), selected = "1-Specificity"),
	selectInput("sroc.ylab", label = h5("4. Label for y-axis"), choices = c("Sensitivity","TPR"), selected = "Sensitivity")

),

mainPanel(

h4(("Meta-analysis")), 

tabsetPanel(

tabPanel("SROC Plot", p(br()),

	h5(("Summary ROC (SROC) Plot")), 

	 plotOutput("plot_sroc",  height ="600px", width = "600px")

	# verbatimTextOutput("reitsma")
	),


tabPanel("Reitsma's Model", p(br()),

	h5(("Estimates from the model")), 
   DTOutput("reitsma.dt"),
	verbatimTextOutput("reitsma"),

   helpText(HTML("
<i>Note:</i>
<p><b>Fixed-effects coefficients</b>: the estimates in the between-study level</p>
<ul>
<li><b>tsens.:</b> the estimated summarized sensitivity in the logit-scale, $\\mu_1$ in the Reitsma's model</li>
<li><b>tfpr.:</b> the estimated summarized 1-specificity (false positive rate) in the logit-scale, $-\\mu_2$ in the Reitsma's model</li>
<li><b>sensitivity:</b> the estimated summarized sensitivity, logit-scaled $\\mu_1$ in the Reitsma's model</li>
<li><b>false pos. rate::</b> the estimated summarized 1-specificity (false positive rate), logit-scaled $\\mu_2$ in the Reitsma's model</li>
</ul>
<p>See the details of the Reitsma's model in <b>Help and Download</b> panel
</p>
"))
   

),

tabPanel("GLM Model", p(br()),

   h5(("Estimates from the model")), 
   DTOutput("glmm.dt"),
   verbatimTextOutput("glmm"),
   helpText(HTML("
<i>Note:</i>
see the details of the GLM model in <b>Help and Download</b> panel
<p><b>Random effects</b>: the estimates in the within-study level</p>
</ul>
<p><b>Fixed effects</b>: the estimates in the between-study level</p>
<ul>
<li><b>sens.:</b> the estimated summarized sensitivity in the logit-scale</li>
<li><b>spec:</b> the estimated summarized specificity in the logit-scale</li>
</ul>
<p>See the details of the GLM model in <b>Help and Download</b> panel
"))

)

)



)
)