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
###---------- 1.1 Exponential Distribution ----------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw an Exponential Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("r", HTML("Rate (> 0)"), value = 1, min = 0.0000000001, max = 1000000000),
		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("e.xlim", "Range of x-asis > 0", value = 5, min = 1, max = 10000000),
		  numericInput("e.ylim", "Range of y-asis > 0", value = 2.5, min = 0.1, max = 3),
		  hr(),

		  h4(tags$b("Step 3. Show Probability")),   
	 		numericInput("e.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x), x = Red-line"), value = 0.5, min = 0, max = 1, step = 0.05)

		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("See Plot at Data Distribution Plot")),
		p(tags$b("Manual Input")),
    tags$textarea(
        id = "x.e", #p
        rows = 10,
"2.6\n0.5\n0.8\n2.3\n0.3\n2\n0.5\n4.4\n0.1\n1.1\n0.7\n0.2\n0.7\n0.6\n3.7\n0.3\n0.1\n1\n2.6\n1.3"
				        ),
      p("Missing value is input as NA"),

      hr(),

      p(tags$b("Upload Data")),

      ##-------csv file-------##
        fileInput('e.file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("e.header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("e.sep", 
          "Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a("Find some example data here",
          href = "https://github.com/mephas/datasets")
        )
      
		)
	),

	mainPanel(
		h4(tags$b("Output. Plots")),

		tabsetPanel(
			 tabPanel("Mathematical-based Plot", p(br()),

				plotOutput("e.plot", click = "plot_click9", width = "1000px", height = "400px"),
			 	verbatimTextOutput("e.info"),

			 	p(tags$b("The position of Red-line and the Blue Ares")),
				tableOutput("e")
				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	sliderInput("e.bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.1),
			 	numericInput("e.size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
				plotOutput("e.plot2", click = "plot_click10", width = "1000px", height = "400px"),
				verbatimTextOutput("e.info2"),
				
				p(tags$b("Sample descriptive statistics")),
				tableOutput("e.sum"),
				HTML(
    " 
    <b> Explanation </b>
   <ul>
    <li>  Mean -> 1/Rate
    <li>  Variance -> 1/Rate^2
   </ul>
    "
    )
			 	),

			 tabPanel("Data Distribution Plot", p(br()),

			plotOutput("makeplot.e", width = "1000px", height = "400px"),
      sliderInput("bin.e","The width of bins in histogram", min = 0.01,max = 5,value = 0.2)
			 	)

			)
	)
	)

