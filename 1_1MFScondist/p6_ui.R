#****************************************************************************************************************************************************1.6. chi
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Chi-squared Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters for Chi(v)")), 
		  numericInput("x.df", HTML("v > 0, Degree of Freedom related the the shape"), value = 4, min = 0),

		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("x.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		  hr(),

	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("x.xlim", "Range of x-asis, > 0", value = 8, min = 1)

		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.x", #p
        rows = 10,
"11.92\n1.42\n5.56\n5.31\n1.28\n3.87\n1.31\n2.32\n3.75\n6.41\n3.04\n3.96\n1.09\n5.28\n7.88\n4.48\n1.22\n1.2\n9.06\n2.27"
),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

        fileInput('x.file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("x.header", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("x.col", "Yes", TRUE),

        radioButtons("x.sep", 
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
		h4(tags$b("Output. Plots")),

		tabsetPanel(
			 tabPanel("Mathematical-based Plot", p(br()),
			 	tags$b("Chi-square distribution plot"),

				plotOutput("x.plot", click = "plot_click5", width = "80%"),
			 	verbatimTextOutput("x.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("x")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("x.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
			 	tags$b("Histogram from random numbers"),
				plotly::plotlyOutput("x.plot2", width = "80%"),#click = "plot_click6", 
			 	sliderInput("x.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
			 	p("When the number of bins is 0, plot will use the default number of bins"),
				#verbatimTextOutput("x.info2"),
				downloadButton("download6", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("x.sum"),
				HTML(
    " 
    <b> Explanation </b>
   <ul>
    <li>  Mean = v
    <li>  SD = sqrt(2v)
   </ul>
    "
    )
			 	),

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotly::plotlyOutput("makeplot.x2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotly::plotlyOutput("makeplot.x1", width = "80%"),
	      sliderInput("bin.x","The number of bins in histogram", min = 0, max = 100, value = 0),
	      p("When the number of bins is 0, plot will use the default number of bins"),
	      p(tags$b("Sample descriptive statistics")),
	      tableOutput("x.sum2")

			 	)

			)
	)
	)

