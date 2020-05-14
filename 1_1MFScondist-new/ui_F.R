# ****************************************************************************************************************************************************1.7.
# F
sidebarLayout(


	sidebarPanel(
	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),		#Select Src
	selectInput(
	    "InputSrc_f", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Upload data based" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("Step 2. Set parameters")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'MathDist'",
	    HTML("<b>1. Set Parameters</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters</b></h4>"),
		numericInput("df11", HTML("v1 > 0, Degree of Freedom 1"), value = 100, min = 0),
		numericInput("df21", HTML("v2 > 0, Degree of Freedom 2"), value = 100, min = 0),
		HTML("<li> Mean = v2 / (v2 - 2), for v2 > 2
			<li> Variance = [ 2 * v2^2 * ( v1 + v2 - 2 ) ] / [ v1 * ( v2 - 2 )^2 * ( v2 - 4 ) ] for v2 > 4"),
		hr(),

	 	p(tags$b("You can adjust x-axes range")),
		numericInput("f.xlim", "Range of x-axis, > 0", value = 5, min = 1)
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'SimuDist'",
        numericInput("f.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
        sliderInput("f.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_f == 'DataDist'",
	    tabsetPanel(
	       tabPanel("Manual Input",p(br()),
    p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Data be copied from CSV (one column) and pasted in the box")),     		

    tags$textarea(
        	id = "x.f", #p
        	rows = 10, "1.08\n1.54\n0.89\n0.83\n1.13\n0.89\n1.22\n1.04\n0.71\n0.84\n1.17\n0.88\n1.05\n0.91\n1.37\n0.87\n1\n1\n1\n1.01"
			),
      		p("Missing value is input as NA")
	     ), #tab1 end
			tabPanel.upload.num(file ="f.file", header="f.header", col="f.col", sep="f.sep")

	    ),
        sliderInput("bin.f","The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	  ),
	  #condiPa 3 end
	  hr(),
		h4(tags$b("Step 3. Show Probability")),
	 	numericInput("f.pr", HTML("Area Proportion Left to Red-line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		
		hr()
	), #sidePa end


mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_f == 'MathDist'",
		  h4("Mathematical-based Plot"),
		tags$b("F distribution plot"),

        plotOutput("f.plot", click = "plot_click7"),
        verbatimTextOutput("f.info"),
     hr(),
     plotly::plotlyOutput("f.plot.cdf") 
        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x0")),
        #tableOutput("f")
		),

		conditionalPanel(
		  condition = "input.InputSrc_f == 'SimuDist'",
		   h4("Simulation-based Plot"),

		tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("f.plot2"),#click = "plot_click8",

        #verbatimTextOutput("f.info2"),
        downloadButton("download7", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("f.sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_f == 'DataDist'",
		tags$b("Data preview"),
		DT::DTOutput("FF"),
	 h4("Distribution of Your Data"),
 		tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.f2"),
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.f1"),
        tags$b("CDF from upload data"),
        plotly::plotlyOutput("makeplot.f3"),        
        p(tags$b("Sample descriptive statistics")),
        tableOutput("f.sum2")

		)

	) #main pa end


)


