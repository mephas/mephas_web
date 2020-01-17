#****************************************************************************************************************************************************1.3. gamma
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Gamma Distribution", p(br()),
		  HTML("<h4><b>Step 1. Set Parameters for Gamma(&#945, &#952)</h4></b>"), 
		  numericInput("g.shape", HTML("&#945 > 0, Shape parameter"), value = 9, min = 0),
		  numericInput("g.scale", HTML("&#952 > 0, Scale parameter"), value = 0.5, min = 0),

		  hr(),
		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("g.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
 			
 			hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("g.xlim", "Range of x-asis, > 0", value = 20, min = 1)
		  #numericInput("g.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),
		 


		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.g", #p
        rows = 10,
"4.1\n9.3\n11.7\n2\n2\n5.8\n1.6\n1.9\n4.7\n5.8\n3.1\n3.1\n3\n11\n1.2\n5.7\n10\n13.8\n3.8\n3.1"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        fileInput('g.file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("g.header", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("g.col", "Yes", TRUE),

        radioButtons("g.sep", 
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
			 	tags$b("Gamma distribution plot"),

				plotOutput("g.plot", click = "plot_click11", width = "80%"),
			 	verbatimTextOutput("g.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("g")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("g.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
			 	tags$b("Histogram from random numbers"),
				plotOutput("g.plot2", click = "plot_click12", width = "80%"),
			 	sliderInput("g.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.3, step=0.01),

				verbatimTextOutput("g.info2"),
				downloadButton("download3", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("g.sum"),
				HTML(
    " 
    <b> Explanation </b>
   <ul>
    <li>  Rate = &#946=1/&#952
    <li>  Mean = &#945*&#952
   </ul>
    "
    )
			 	),

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotOutput("makeplot.g2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.g1", width = "80%"),
      	sliderInput("bin.g","The width of bins in histogram", min = 0,max = 2,value = 0.3, step=0.01),
				tableOutput("g.sum2")
			 	)

			)
	)
	)

