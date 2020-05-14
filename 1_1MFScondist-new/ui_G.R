#****************************************************************************************************************************************************1.3. gamma
sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),
	#Select Src
	selectInput(
	    "InputSrc_g", "Select plot",
      c("Mathematical formula based" = "MathDist",
        "Simulation data based" = "SimuDist")),
	hr(),
	#Select Src end
	h4(tags$b("Step 2. Set parameters")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'MathDist'",
	    #h3("Draw a Gamma Distribution", p(br())),
	    HTML("<b>1. Set Parameters for Gamma(k, &#952)</b>"),
	    numericInput("g.shape", HTML("k > 0, Shape parameter"), value = 9, min = 0),
		numericInput("g.scale", HTML("&#952 > 0, Scale parameter"), value = 0.5, min = 0),
hr(),
numericInput("g.mean", HTML("Or. Calculate k and &#952 from Mean and SD (Mean = SD), input mean"), value = 0.5, min = 0),
numericInput("g.sd", HTML("Input SD"), value = 0.5, min = 0),

verbatimTextOutput("g.rate"),
HTML("<li> Mean = k&#952
			<li> Variance = k&#952<sup>2</sup>"),
		hr(),

		numericInput("g.xlim", "Change the range of x-axis, > 0", value = 20, min = 1)
	  ),
	  #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'SimuDist'",
	    numericInput("g.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
	    sliderInput("g.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")

	  ),
	  #condiPa 2 end
	  hr(),
		h4(tags$b(" Step 3. Show Probability")),
	 	numericInput("g.pr", HTML("Area Proportion Left to Red-line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
 		hr()
	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_g == 'MathDist'",
		  h4("Mathematical-based Plot"),
		  tags$b("Gamma distribution plot"),
		  plotOutput("g.plot", click = "plot_click11"),
         verbatimTextOutput("g.info"),
         #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
		 #p(tags$b("The position of Red-line, x<sub>0</sub>")),
         #tableOutput("g")
     hr(),
     plotly::plotlyOutput("g.plot.cdf")   
		),

		conditionalPanel(
		  condition = "input.InputSrc_g == 'SimuDist'",
		 h4("Simulation-based Plot"),

		tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("g.plot2"),#click = "plot_click12",

        #verbatimTextOutput("g.info2"),
        downloadButton("download3", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("g.sum")

		)

	)
	)

