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

###---------- T ---------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a T Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("t.df", HTML("v > 0, Degree of Freedom"), value = 4, min = 0, max = 1000000000),
		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("t.xlim", "Range of x-asis", value = 5, min = 1, max = 1000000000),
		  #numericInput("t.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),
		  hr(),

		  h4(tags$b("Step 3. Show Probability")),   
	 		numericInput("t.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x), x = Red-line"), value = 0.025, min = 0, max = 1, step = 0.05)

		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("See Plot at Data Distribution Plot")),
		p(tags$b("Manual Input")),
    tags$textarea(
        id = "x.t", #p
        rows = 10,
"-0.52\n-0.36\n-1.15\n-1.46\n0.54\n-1.6\n0.1\n-0.48\n-0.69\n-1.66\n0.59\n0.11\n-0.01\n0.32\n-1.31\n1.25\n-0.19\n-0.66\n0.75\n-1.86"
),
      p("Missing value is input as NA"),

      hr(),

      p(tags$b("Upload Data")),

      ##-------csv file-------##
        fileInput('t.file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("t.header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("t.sep", 
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

				plotOutput("t.plot", click = "plot_click3", width = "800px", height = "400px"),
			 	verbatimTextOutput("t.info"),

			 	p(tags$b("The position of Red-line and the Blue Ares")),
				tableOutput("t")

				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	sliderInput("t.bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
			 	numericInput("t.size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
				plotOutput("t.plot2", click = "plot_click4", width = "800px", height = "400px"),
				verbatimTextOutput("t.info2"),
				
				p(tags$b("Sample descriptive statistics")),
				tableOutput("t.sum")
				
			 	),

			 tabPanel("Data Distribution Plot", p(br()),

			plotOutput("makeplot.t", width = "800px", height = "400px"),
      sliderInput("bin.t","The width of bins in histogram", min = 0.01,max = 5,value = 0.2),
      				tableOutput("t.sum2")

			 	)

			)
	)
	)

