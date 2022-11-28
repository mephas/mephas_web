sidebarLayout(

# tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

sidebarPanel(
	tags$head(tags$style("#reitsma {background: white; color: #5A5A5A};")),


h3(tags$b("Reitsma's model")),

# selectInput("alpha", label = "1. Transformation of Sens and Spec", 
# 	choices = list(
# 	"Logit" = 1, 
# 	"2-log" = 0, 
# 	"1.4" = 1.4, 
# 	"1.8" = 1.8), 
# 	selected = 1),

selectInput("res.method", label = "Choose optimization methods for estimating the parameters", 
	choices = list(
	"Restricted maximum likelihood (ReML)" = "reml", 
	"Maximum likelihood (ML)" = "ml", 
	"Method of moment (MM)" = "mm",
	"Variance components" = "vc"),
	# "Fixed-effects model" = "fixed"), 
	selected = "reml"),

helpText(HTML('
Note: the often used methods are "ReML" and "ML"
')),

hr(),

h3(tags$b("Summary ROC (SROC) Plot")), p(br()),

(tags$b("1. Configuration of SROC Plot based on the Reitsma's model")), p(br()),

awesomeCheckbox( 
   inputId = "studypp2",
   label = "Add study points", 
   value = TRUE
 ),

awesomeCheckbox( 
   inputId = "reitmaSROC",
   label = "Add the SROC curve", 
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
helpText(HTML("Note: see the equation of SROC in <b>Help and Download</b> panel")),
p(br()),


(tags$b("2. Other SROC plots")), p(br()),

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

 textInput("sroc.xlab", label = "Label for x-axis", value = "1-Specificity"),
 textInput("sroc.ylab", label = "Label for y-axis", value = "Sensitivity")


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
Note: see the details of the Reitsma's model in <b>Help and Download</b> panel
<ul>
<li><b>tsens.:</b> the estimated summarized sensitivity in the logit-scale, $\\mu_1$ in the Reitsma's model</li>
<li><b>tfpr.:</b> the estimated summarized 1-specificity (false positive rate) in the logit-scale, $-\\mu_2$ in the Reitsma's model</li>
<li><b>sensitivity:</b> the estimated summarized sensitivity, logit-scaled $\\mu_1$ in the Reitsma's model</li>
<li><b>false pos. rate::</b> the estimated summarized 1-specificity (false positive rate), logit-scaled $\\mu_2$ in the Reitsma's model</li>
</ul>
"))

)

)



)
)