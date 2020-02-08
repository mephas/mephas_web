#****************************************************************************************************************************************************2. poisson
sidebarLayout(

	sidebarPanel(
	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),		#Select Src
	selectInput(
	    "InputSrc_p", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),
	#Select Src end
		h4(tags$b("Step 2. Set parameters")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist'",
	    HTML("<b> 1. Set Parameters</b>"),
		numericInput("lad", "Rate, = mean = variance", value = 2.3, min = 0, max = 10000000000, step = 1),
      numericInput("k2", "The duration of occurrences > 0", value = 12, min = 0 , max = 1000000000)
      ),
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
	    p(tags$i("From the example, the rate is 2.3 and the duration of the rate is 12 months"))
	  ),
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist'",
      hr(),

      tags$b(" 2. Change Observed Data"),
      numericInput("x0", "The observed duration of occurrences (Red-Dot)", value = 5, min = 0 , max = 1000000000)
      ),
      conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
      p(tags$i("The observed is <= 5, and we wanted to know the cumulated probability after 5 months, which means 1 - cumulated probability of 0-5 months"))
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'SimuDist'",
		numericInput("size.p", "The sample size of random numbers", value = 100, min = 1, max = 1000000, step = 1),
		sliderInput("bin.p", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'DataDist'",
	    tabsetPanel(
	      tabPanel("Manual Input",p(br()),
    p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Data be copied from CSV (one column) and pasted in the box")), 
    		
    	tags$textarea(
        id = "x.p", #p
        rows = 10,
        "1\n3\n4\n3\n3\n3\n5\n3\n2\n1\n1\n3\n2\n4\n1\n2\n5\n4\n2\n3"
         ),
      p("Missing value is input as NA")
	     ), #tab1 end
		tabPanel.upload.num(file ="file.p", header="header.p", col="col.p", sep="sep.p")

	    ),
      sliderInput("bin1.p","The number of bins in histogram", min = 0, max = 100, value = 0),
       p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_p == 'MathDist'",
		  h4("Mathematical-based Plot"),
		  p("The blue curve is the normal distribution with mean=rate and sd=rate. It indicates the normal approximation of binomial distribution."),
 		p(tags$b("Poisson probability plot")),
    	plotly::plotlyOutput("p.plot"),
    	p(tags$b("Probability at the observed number of occurrences (Red-Dot)")),
    	tableOutput("p.k")
    	),
    	conditionalPanel(
		  condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
    	p(tags$i("Explanation: the probability distribution until 5 month was 0.97. Thus, the probability distribution after 6 months was about 0.03"))
		),

		conditionalPanel(
		  condition = "input.InputSrc_p == 'SimuDist'",
 		p(tags$b("Histogram from random numbers")),
        plotly::plotlyOutput("p.plot2"),

        downloadButton("download2", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("sum.p")

		),

		conditionalPanel(
		condition = "input.InputSrc_p == 'DataDist'",
		h4("Distribution of Your Data"),
 		p(tags$b("Histogram from upload data")),
        plotly::plotlyOutput("makeplot.2"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("sum2.p")


		)

	) #main pa end


)
