###---------- F ---------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Beta Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("df11", HTML("df1 > 0, Degree of Freedom 1"), value = 100, min = 0, max = 1000000000),
		  numericInput("df21", HTML("df2 > 0, Degree of Freedom 2"), value = 100, min = 0, max = 1000000000),

		  #numericInput("f.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),
		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("f.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		  hr(),

	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("f.xlim", "Range of x-asis, > 0", value = 5, min = 1, max = 1000000000)

		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.f", #p
        rows = 10,
"1.08\n1.54\n0.89\n0.83\n1.13\n0.89\n1.22\n1.04\n0.71\n0.84\n1.17\n0.88\n1.05\n0.91\n1.37\n0.87\n1\n1\n1\n1.01"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      fileInput('f.file', "1. Choose CSV/TXT file",
                accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

      p(tags$b("2. Show 1st row as header?")),
      checkboxInput("f.header", "Show Data Header?", TRUE),

      p(tags$b("3. Use 1st column as row names? (No duplicates)")),
      checkboxInput("f.col", "Yes", TRUE),

      radioButtons("f.sep", "4. Which Separator for Data?",
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

				plotOutput("f.plot", click = "plot_click7", width = "65%"),
			 	verbatimTextOutput("f.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("f")
				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	numericInput("f.size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
				plotOutput("f.plot2", click = "plot_click8", width = "65%"),
			 	sliderInput("f.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.1, step=0.01),
				verbatimTextOutput("f.info2"),
				downloadButton("download7", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("f.sum")
			 	),

			 tabPanel("Distribution of Your Data", p(br()),

			plotOutput("makeplot.f1", width = "65%"),
			plotOutput("makeplot.f2", width = "65%"),

      sliderInput("bin.f","The width of bins in histogram", min = 0,max = 2,value = 0.1, step=0.01),
      				tableOutput("f.sum2")

			 	)

			)
	)
	)

