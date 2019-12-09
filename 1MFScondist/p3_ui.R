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

###---------- Gamma ---------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Gamma Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("g.shape", HTML("&#945 > 0, Shape parameter"), value = 9, min = 0.0000000001, max = 1000000000),
		  numericInput("g.scale", HTML("&#952 > 0, Scale parameter"), value = 0.5, min = 0.0000000001, max = 1000000000),

		  hr(),

		  h4(tags$b("Step 2. Adjust Axes Range")), 
		  numericInput("g.xlim", "Range of x-asis, > 0", value = 20, min = 1, max = 10000000),
		  numericInput("g.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),
		  hr(),

		  h4(tags$b("Step 3. Show Probability")),   
	 		numericInput("g.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x), x = Red-line"), value = 0.5, min = 0, max = 1, step = 0.05)

		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("See Plot at Data Distribution Plot")),
		p(tags$b("Manual Input")),
    tags$textarea(
        id = "x.g", #p
        rows = 10,
"4.1\n9.3\n11.7\n2\n2\n5.8\n1.6\n1.9\n4.7\n5.8\n3.1\n3.1\n3\n11\n1.2\n5.7\n10\n13.8\n3.8\n3.1"
				        ),
      p("Missing value is input as NA"),

      hr(),

      p(tags$b("Upload Data")),

      ##-------csv file-------##
        fileInput('g.file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("g.header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("g.sep", 
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

				plotOutput("g.plot", click = "plot_click11", width = "1000px", height = "400px"),
			 	verbatimTextOutput("g.info"),

			 	p(tags$b("The position of Red-line and the Blue Ares")),
				tableOutput("g")
				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	sliderInput("g.bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.1),
			 	numericInput("g.size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
				plotOutput("g.plot2", click = "plot_click12", width = "1000px", height = "400px"),
				verbatimTextOutput("g.info2"),
				
				p(tags$b("Sample descriptive statistics")),
				tableOutput("g.sum"),
				HTML(
    " 
    <b> Explanation </b>
   <ul>
    <li>  Rate -> &#946=1/&#952
    <li>  Mean -> &#945*&#952
   </ul>
    "
    )
			 	),

			 tabPanel("Data Distribution Plot", p(br()),

			plotOutput("makeplot.g", width = "1000px", height = "400px"),
      sliderInput("bin.g","The width of bins in histogram", min = 0.01,max = 5,value = 0.2)
			 	)

			)
	)
	)

