sidebarLayout(

# tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

sidebarPanel(
tags$style("#reitsma {background: white; color: #5A5A5A};"),
tags$style("#glmm {background: white; color: #5A5A5A};"),

h3(tags$b("Reitsma's model")),

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

h3(tags$b("Summary ROC (SROC) Plot")), 

tags$h5("1. Configuration of SROC plot"), 


awesomeCheckbox( 
   inputId = "studypp2",
   label = "Add ROC points of studies", 
   value = TRUE
 ),

p(br()),
tags$b("Reitsma's model"), 

awesomeCheckbox( 
   inputId = "reitmaSROC",
   label = "Add the Reitsma's SROC curve", 
   value = TRUE
 ),

awesomeCheckbox( 
   inputId = "res.pt",
   label = "Add estimated summary point", 
   value = TRUE
 ),

awesomeCheckbox( 
   inputId = "res.ci",
   label = "Add CI region of the summary point", 
   value = TRUE
 ),

tags$b("GLM model"), 


awesomeCheckbox( 
   inputId = "glmmSROC",
   label = "Add the GLMM SROC curve", 
   value = FALSE
 ),

awesomeCheckbox( 
   inputId = "glmm.pt",
   label = "Add the GLMM SROC curve", 
   value = FALSE
 ),

helpText(HTML("<i>Note:</i>
   see the equation of SROC in <b>Help and Download</b> panel")),
p(br()),


tags$h5("2. Other SROC plots"), 

awesomeCheckbox( 
   inputId = "mslSROC",
   label = "Add Moses-Shapiro-Littenberg SROC curve", 
   value = FALSE
   ),
 
 awesomeCheckbox( 
   inputId = "rsSROC",
   label = "Add Ruecker-Schumacher (2010) SROC curve", 
   value = FALSE
 ), 
 p(br()),

tags$h5("3. Other configurations"), 
	pickerInput("sroc.xlab", label = "Label for x-axis", choices = c("1-Specificity","FPR")),
	pickerInput("sroc.ylab", label = "Label for y-axis", choices = c("Sensitivity","TPR"))

),

mainPanel(

h4(tags$b("Output: Reitsma's model")), p(br()),

tabsetPanel(

tabPanel("SROC Plot", p(br()),

	(tags$b("Summary ROC (SROC) Plot")), p(br()),

	 plotOutput("plot_sroc",  height ="600px", width = "600px")

	# verbatimTextOutput("reitsma")
	),


tabPanel("Reitsma's Model", p(br()),

	(tags$b("Estimates from the model")), p(br()),

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
")),

   (tags$b("Estimates table")),
   DTOutput("reitsma.dt")

),

tabPanel("GLM Model", p(br()),

   (tags$b("Estimates from the model")), p(br()),

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
")),

   (tags$b("Estimates table")),
   DTOutput("glmm.dt")




)

)



)
)