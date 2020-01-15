###---------- 1.1 Exponential Distribution ----------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw an Exponential Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters for E(Rate)")), 
		  numericInput("r", HTML("Rate (> 0) indicates the rate of change"), value = 2, min = 0, max = 1000000000, step=1),
		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("e.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),

		  #numericInput("e.ylim", "Range of y-asis > 0", value = 2.5, min = 0.1, max = 3),
		  hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("e.xlim", "Range of x-asis > 0", value = 5, min = 1, max = 10000000)


		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.e", #p
        rows = 10,
"2.6\n0.5\n0.8\n2.3\n0.3\n2\n0.5\n4.4\n0.1\n1.1\n0.7\n0.2\n0.7\n0.6\n3.7\n0.3\n0.1\n1\n2.6\n1.3"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

        p(tags$b("This only reads the 1st column of your data")),
        fileInput('e.file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("e.header", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("e.col", "Yes", TRUE),

        radioButtons("e.sep", 
          "3. Which Separator for Data?",
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
		h4(tags$b("Output. Plots")),

		tabsetPanel(
			 tabPanel("Mathematical-based Plot", p(br()),
			 	tags$b("Exponential distribution plot"),

				plotOutput("e.plot", click = "plot_click9", width = "65%"),
			 	verbatimTextOutput("e.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("e")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("e.size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
			 	tags$b("Histogram from random numbers"),
				plotOutput("e.plot2", click = "plot_click10", width = "65%"),
			 	sliderInput("e.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.1, step=0.01),

				verbatimTextOutput("e.info2"),
				downloadButton("download2", "Download Random Numbers"),
		
				p(tags$b("Sample descriptive statistics")),
				tableOutput("e.sum"),
				HTML(
			    " 
			    <b> Explanation </b>
			   <ul>
			    <li>  Mean = 1/Rate
			    <li>  SD = 1/Rate
			   </ul>
			    "
			    )
			  ),
			 tabPanel("Distribution of Your Data", p(br()),	
			 	tags$b("Density from upload data"),
				plotOutput("makeplot.e2", width = "65%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.e1", width = "65%"),
      	sliderInput("bin.e","The width of bins in histogram", min = 0,max = 2,value = 0.1, step=0.01),
				tableOutput("e.sum2")

			 	)

			)
	)
	)

