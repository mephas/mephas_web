sidebarLayout(

sidebarPanel(

h3(tags$b("Settings of Bivariate Random Effects Model")),

selectInput("alpha", label = "1. Transformation of Sens and Spec", 
	choices = list(
	"Logit" = 1, 
	"2-log" = 0, 
	"1.4" = 1.4, 
	"1.8" = 1.8), 
	selected = 1),

selectInput("res.method", label = "2. Optimization methods", 
	choices = list(
	"Restricted maximum likelihood" = "reml", 
	"Maximum likelihood" = "ml", 
	"Method of moment" = "mm",
	"Variance components" = "vc",
	"Fixed-effects model" = "fixed"), 
	selected = "reml"),

hr(),

h3(tags$b("Settings of Summary ROC Plot")), p(br()),

h4(tags$b("SROC from Bivariate Random Effects Model (BREM)")), p(br()),

	awesomeCheckbox( 
	   inputId = "studypp2",
	   label = "Add study points", 
	   value = TRUE
	 ),

	awesomeCheckbox( 
	   inputId = "reitmaSROC",
	   label = "Add the SROC curve of BREM", 
	   value = TRUE
	 ),

	awesomeCheckbox( 
	   inputId = "res.pt",
	   label = "Add Summary points in the BREM's SROC curve", 
	   value = TRUE
	 ),

	awesomeCheckbox( 
	   inputId = "res.ci",
	   label = "Add CI in the BREM's SROC curve", 
	   value = TRUE
	 ),

	p(br()),

	h4(tags$b("Other SROC plots")), p(br()),

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

h4(tags$b("Output")), p(br()),

tabsetPanel(

tabPanel(
	"SROC Analysis", p(br()),

	h4(tags$b("Summary ROC Plot")), p(br()),

	 plotOutput("plot_sroc",  height ="600px", width = "600px")

	# verbatimTextOutput("reitsma")
	),

tabPanel(
	"Random Effects Model", p(br()),

	h4(tags$b("Detailed estimates from the model")), p(br()),

	verbatimTextOutput("reitsma")
	)

)



)
)