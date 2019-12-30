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

##---------- Binomial 3 ---------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel("Draw a Binomial Distribution", p(br()),

		  h4(tags$b("Step 1. Set Parameters")), 
			numericInput("m", "The number of trials / samples, n > 0", value = 10, min = 1 , max = 1000000000),
		  numericInput("p", "The probability of success / event, p > 0", value = 0.2, min = 0, max = 1, step = 0.1),
		  p(tags$i("From the example, we know n=10 (10 white blood cells), p=0.2 (the probability of any cell being a lymphocyte)")),

		  hr(),

		  h4(tags$b("Step 2. Change Observed Data")), 
		  numericInput("k", "The observed number of success /event (Red-Dot)", value = 2, min =  0, max = 1000, step = 1),
		  p(tags$i("The observed number is 2 lymphocytes"))
		  ),

		tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x", #p
        rows = 10,
				"3\n5\n3\n4\n6\n3\n6\n6\n5\n2\n5\n4\n5\n5\n5\n2\n6\n8\n4\n2"
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
			 tabPanel("Model-based Plot", p(br()),
				plotly::plotlyOutput("b.plot", width = "600px", height = "400px"),
				p(tags$b("Probability at the observed number of success /event (Red-Dot)")),
				DT::DTOutput("b.k", width = "500px"),
				p(tags$i("Explanation: the probability of 2 lymphocytes was about 0.03"))
				),

			 tabPanel("Simulation-based Plot", p(br()),
			 	
			 	numericInput("size", "The sample size of random numbers", value = 100, min = 1, max = 1000000, step = 1),

			 	plotly::plotlyOutput("b.plot2", width = "600px", height = "400px"),	

			 	sliderInput("bin", "The width of bins in histogram", min = 0, max = 2, value = 1, step=0.1),

				p(tags$b("Sample descriptive statistics")),
				DT::DTOutput("sum", width = "500px"),
				p(tags$b("Random Number")),
				DT::DTOutput("simdata", width = "500px")
				#verbatimTextOutput("data")
			 	),    
			 			 tabPanel("Distribution of Your Data", p(br()),

			plotly::plotlyOutput("makeplot.1", width = "600px", height = "400px"),
			#plotOutput("makeplot.2", width = "500px", height = "300px"),
      sliderInput("bin1","The width of bins in histogram",min = 0,max = 2,value = 1, step=0.1),
				p(tags$b("Sample descriptive statistics")),
				DT::DTOutput("sum2", width = "500px")

			 	)
			 			 )


			)
	)
	


