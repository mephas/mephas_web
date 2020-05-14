# ****************************************************************************************************************************************************1.1.
# Normal distribution
sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),
	#Select Src
	selectInput(
	    "InputSrc", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist")),
	hr(),
	#Select Src end
		h4(tags$b("Step 2. Set parameters")),

	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc == 'MathDist'",
	    #h3("Draw a Normal Distribution"), p(br()),

	    HTML("<b>Set Parameters for N(&#956, &#963)</b>"),
	    numericInput("mu", HTML("1. Mean(&#956), the dashed line, indicates the location  "), value = 0, min = -10000000, max = 10000000),
	    numericInput("sigma", HTML("2. Standard Deviation(&#963), indicates the shape"), value = 1, min = 0, max = 10000000),
	    hr(),
	   	numericInput("n", HTML("3. Blue Area = Pr(Mean-n*SD < X < Mean+n*SD)"), value = 1, min = 0, max = 10),
	    hr(),
	    numericInput("xlim", "4. Change range of x-axis, symmetric to 0", value = 5)
	    #numericInput("ylim", "Range of y-axis > 0", value = 0.5, min = 0.1, max = 1),
	  ),
	  #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc == 'SimuDist'",
	    numericInput("size", "Sample size of simulated numbers", value = 100, min = 1),
	    sliderInput("bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
	    p("When the number of bins is 0, plot will use the default number of bins")

	  ),
	  #condiPa 2 end

	  	hr(),
	    h4(tags$b("Step 3. Show Probability")),
	    numericInput("pr", HTML("Area Proportion Left to Red line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),

	    hr()
	), #sidePa end

	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc == 'MathDist'",
		  h4("Mathematical-based Plot"),
		  #tags$b("Normal distribution plot"),
		  #plotOutput("norm.plot", click = "plot_click", width = "600px", height = "400px"), #click = "plot_click",
		  plotOutput("norm.plot", click = "plot_click"), #click = "plot_click",

		  verbatimTextOutput("info"),
		  p(br()),
		  p(tags$b("The position of the red line and the blue ares")),
		  tableOutput("xs"),
		  hr(),
		  plotly::plotlyOutput("norm.plot.cdf")

		),

		conditionalPanel(
		  condition = "input.InputSrc == 'SimuDist'",
		  h4("Simulation-based Plot"),
		  tags$b("Histogram from random numbers"),
		  plotly::plotlyOutput("norm.plot2"),	# click = "plot_click2",

		  #verbatimTextOutput("info2"),
		  downloadButton("download1", "Download Random Numbers"),
		  p(tags$b("Sample descriptive statistics")),
		  tableOutput("sum")
		  #verbatimTextOutput("data")

		)

	)
	)

