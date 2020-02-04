#****************************************************************************************************************************************************1. binom
sidebarLayout(

	sidebarPanel(
	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),		#Select Src
	selectInput(
	    "InputSrc_b", "Select plot",
	    c("Mathematical formula based" = "MathDist",
	      "Simulation data based" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),



	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
	    HTML("<b> 1. Set Parameters</b>"),
		numericInput("m", "The number of trials / samples, n > 0", value = 10, min = 1 , max = 1000000000),
		numericInput("p", "The probability of success / event, p > 0", value = 0.2, min = 0, max = 1, step = 0.1)
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		p(tags$i("From the example, we know n=10 (10 white blood cells), p=0.2 (the probability of any cell being a lymphocyte)"))
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
		hr(),
		tags$b(" 2. Change Observed Data"),
		numericInput("k", "The observed number of success /event (Red-Dot)", value = 2, min =  0, max = 1000, step = 1)
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		p(tags$i("The observed number is 2 lymphocytes"))
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'SimuDist'",
		numericInput("size", "The sample size of random numbers", value = 100, min = 1, max = 1000000, step = 1),
		sliderInput("bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'DataDist'",
	    tabsetPanel(
	      tabPanel("Manual Input",p(br()),
			p("Data point can be separated by , ; /Enter /Tab /Space"),
    		tags$textarea(
        	id = "x", #p
        	rows = 10, "3\n5\n3\n4\n6\n3\n6\n6\n5\n2\n5\n4\n5\n5\n5\n2\n6\n8\n4\n2"
			),
      		p("Missing value is input as NA")
	     ), #tab1 end
			tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

# 	      tabPanel("Upload Data",p(br()),
#
# 	        ##-------csv file-------##
# 	        p(tags$b("This only reads the 1st column of your data, and will cover the input data")),
#         fileInput('file', "1. Choose CSV/TXT file",
#                   accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#
#         p(tags$b("2. Use 1st row as cloumn names?")),
#         checkboxInput("header", "Yes", TRUE),
#
#         p(tags$b("3. Use 1st column as row names? (No duplicates)")),
#         checkboxInput("col", "Yes", TRUE),
#
#              # Input: Select separator ----
#         radioButtons("sep",
#           "4. Which Separator for Data?",
#           choiceNames = list(
#             HTML("Comma (,): CSV often use this"),
#             HTML("One Tab (->|): TXT often use this"),
#             HTML("Semicolon (;)"),
#             HTML("One Space (_)")
#             ),
#           choiceValues = list(",", "\t", ";", " ")
#           ),
#
#         p("Correct Separator ensures data input successfully"),
#
#         a(tags$i("Find some example data here"), href = "https://github.com/mephas/datasets")
# 	      ) #tab2 end
	    ),
      sliderInput("bin1","The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end




mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist'",
		  h4("Mathematical-based Plot"),
		  p(tags$b("Binomial probability plot")),
		  p("The blue curve is the normal distribution with mean n*p and sd n*p*(1-p). It indicates the normal approximation of binomial distribution."),
		  plotly::plotlyOutput("b.plot"),
		  p(tags$b("Probability at the observed number of success /event (Red-Dot)")),
		  tableOutput("b.k")
		),
		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		  p(tags$i("Explanation: the probability of 2 lymphocytes was about 0.03"))
		),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'SimuDist'",
		  h4("Simulation-based Plot"),
		  p(tags$b("Histogram from random numbers")),
		  plotly::plotlyOutput("b.plot2"),
		  downloadButton("download1", "Download Random Numbers"),
		  p(tags$b("Sample descriptive statistics")),
		  tableOutput("sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_b == 'DataDist'",
		h4("Distribution of Your Data"),
 		p(tags$b("Histogram from upload data")),
		plotly::plotlyOutput("makeplot.1"),
		p("When the number of bins is 0, plot will use the default number of bins"),
		p(tags$b("Sample descriptive statistics")),
		tableOutput("sum2")

		)

	) #main pa end


)
