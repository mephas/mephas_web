##----------#----------#----------#----------
##
## 1MFSdistribution UI
##
## Language: EN
## 
## DT: 2019-01-08
## Update: 2019-12-05
##
##----------#----------#----------#----------

###---------- 1.1 Normal Distribution ----------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Normal Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("mu", HTML("Mean (&#956), the dashed line, the location  "), value = 0, min = -10000000, max = 10000000),
		  numericInput("sigma", HTML("Standard Deviation (&#963), the shape"), value = 1, min = 0, max = 10000000),
		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("xlim", "Range of x-asis, symmetric to 0", value = 5, min = 1, max = 10000000),
		  #numericInput("ylim", "Range of y-asis > 0", value = 0.5, min = 0.1, max = 1),
		  hr(),

		  h4(tags$b("Step 3. Show Probability")),   
		  numericInput("n", HTML("Blue Area = Pr(Mean - n * SD < X < Mean + n * SD)"), value = 1, min = 0, max = 10),
	 		numericInput("pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 = Red-line"), value = 0.025, min = 0, max = 1, step = 0.05)

		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("See Plot at Data Distribution Plot")),
		p(tags$b("1. Manual Input")),
    tags$textarea(
        id = "x", #p
        rows = 10,
				"-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
				        ),
      p("Missing value is input as NA"),

      hr(),

      p(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        p(tags$b("This only reads the 1st column of your data")),
        fileInput('file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep", 
          "3. Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
        )
      
		)
	),

	mainPanel(
		h4(tags$b("Output. Plots")),

		tabsetPanel(
			 tabPanel("Mathematical-based Plot", p(br()),

			 	plotOutput("norm.plot", click = "plot_click", width = "800px", height = "400px"),
			 	verbatimTextOutput("info"),

			 	p(tags$b("The position of Red-line and the Blue Ares")),
				tableOutput("xs")
				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.1),
			 	numericInput("size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
			 	plotOutput("norm.plot2", click = "plot_click2", width = "800px", height = "400px"),	
				verbatimTextOutput("info2"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum")
				#verbatimTextOutput("data")
			 	),

			 tabPanel("Data Distribution Plot", p(br()),

			plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin1","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum2")

			 	)

			)
	)
	)
