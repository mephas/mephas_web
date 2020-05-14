#****************************************************************************************************************************************************1.3. gamma
sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),
	#Select Src
	selectInput(
	    "InputSrc_g", "Select plot",
      c("Mathematical formula based" = "MathDist",
        "Simulation data based" = "SimuDist",
        "Upload data based" = "DataDist")),
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

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'DataDist'",
	    tabsetPanel(

	      tabPanel("Manual Input",p(br()),
    p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Data be copied from CSV (one column) and pasted in the box")), 
    			
			tags$textarea(
        	id = "x.g", #p
       	 rows = 10, "4.1\n9.3\n11.7\n2\n2\n5.8\n1.6\n1.9\n4.7\n5.8\n3.1\n3.1\n3\n11\n1.2\n5.7\n10\n13.8\n3.8\n3.1"
				        ),
      		p("Missing value is input as NA")
	     	 ), #tab1 end
			tabPanel.upload.num(file ="g.file", header="g.header", col="g.col", sep="g.sep")
	    ),
      	sliderInput("bin.g","The number of bins in histogram", min = 0, max = 100, value = 0),
      	p("When the number of bins is 0, plot will use the default number of bins")
	  ),
	  #condiPa 3 end
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

		),

		conditionalPanel(
		condition = "input.InputSrc_g == 'DataDist'",
		tags$b("Data preview"),
		DT::DTOutput("Z"),
		h4("Distribution of Your Data"),
		tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.g2"),
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.g1"),
        tags$b("CDF from upload data"),
        plotly::plotlyOutput("makeplot.g3"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("g.sum2")
		)

	)
	)

