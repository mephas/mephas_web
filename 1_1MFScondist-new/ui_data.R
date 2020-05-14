# ****************************************************************************************************************************************************1.1. User data distribution
sidebarLayout(

sidebarPanel(

h4(tags$b("Step 1. Data Preparation")),

tabsetPanel(
tabPanel("Manual Input",p(br()),
	p("Data point can be separated by , ; /Enter /Tab /Space"),
	p(tags$b("Data be copied from CSV (one column) and pasted in the box")), 	        
	tags$textarea(
	id = "x", #p
	rows = 10,
	"-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
	),
	p("Missing value is input as NA")
),

tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

),
sliderInput("bin1","The number of bins in histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins"),

hr(),
h4(tags$b("Step 2. Show Probability")),
numericInput("pr.data", HTML("Area Proportion Left to Red line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),

hr()
),

	mainPanel(
		h4(tags$b("Outputs")),p(br()),
		  h4("Data preview"),
			DT::DTOutput("NN"),
		  
		  h4("Distribution of Your Data"),
		  tags$b("Density plot"),
		  plotly::plotlyOutput("makeplot.2"),

		  tags$b("Histogram"),
		  plotly::plotlyOutput("makeplot.1"),

		  tags$b("Cumulative density plot"),
		  plotly::plotlyOutput("makeplot.3"),

		  p(tags$b("Sample descriptive statistics")),
		  tableOutput("sum2")

		)

)

