#****************************************************************************************************************************************************1.1. Normal distribution
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Normal Distribution", p(br()),

		  HTML("<h4><b>Step 1. Set Parameters for N(&#956, &#963)</h4></b>"), 
		  numericInput("mu", HTML("Mean (&#956), the dashed line, indicates the location  "), value = 0),
		  numericInput("sigma", HTML("Standard Deviation (&#963), indicates the shape"), value = 1, min = 0),
		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
		  numericInput("n", HTML("Blue Area = Pr(Mean-n*SD < X < Mean+n*SD)"), value = 1, min = 0),
	 		numericInput("pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),

	 		hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("xlim", "Range of x-asis, symmetric to 0", value = 5, min = 1)
		  #numericInput("ylim", "Range of y-asis > 0", value = 0.5, min = 0.1, max = 1),


		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x", #p
        rows = 10,
				"-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        p(tags$b("This only reads the 1st column of your data")),
        fileInput('file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col", "Yes", TRUE),

             # Input: Select separator ----
        radioButtons("sep", 
          "4. Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", "\t", ";", " ")
          ),

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
        )
      
		)
	),

	mainPanel(
		h4(tags$b("Output Plots")),

		tabsetPanel(
			 tabPanel("Mathematical-based Plot", p(br()),
			 tags$b("Normal distribution plot"),
			 	#plotOutput("norm.plot", click = "plot_click", width = "600px", height = "400px"), #click = "plot_click", 
			 	plotOutput("norm.plot", click = "plot_click", width = "80%"), #click = "plot_click", 

			 	verbatimTextOutput("info"),

			 	p(tags$b("The position of Red-line and the Blue Ares")),
				tableOutput("xs")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("size", "Sample size of simulated numbers", value = 100, min = 1),
			 	tags$b("Histogram from random numbers"),
			 	plotly::plotlyOutput("norm.plot2",  width = "80%"),	# click = "plot_click2",

			 	sliderInput("bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
			 	p("When the number of bins is 0, plot will use the default number of bins"),
				#verbatimTextOutput("info2"),

				downloadButton("download1", "Download Random Numbers"),

				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum")
				#verbatimTextOutput("data")
			 	),

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotly::plotlyOutput("makeplot.2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotly::plotlyOutput("makeplot.1", width = "80%"),
      	sliderInput("bin1","The number of bins in histogram", min = 0, max = 100, value = 0),
      	p("When the number of bins is 0, plot will use the default number of bins"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum2")

			 	)

			)
	)
	)
