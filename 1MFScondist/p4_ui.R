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

###---------- Beta ---------

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Beta Distribution", p(br()),
		  HTML("<h4><b>Step 1. Set Parameters for Beta(&#945, &#946)</h4></b>"), 
		  numericInput("b.shape", HTML("&#945 > 0, Shape parameter"), value = 2, min = 0, max = 1000000000),
		  numericInput("b.scale", HTML("&#946 > 0, Shape parameter"), value = 2, min = 0, max = 1000000000),

		  hr(),
		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("b.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		  hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("b.xlim", "Range of x-asis, > 0", value = 1, min = 1, max = 1000000000)
		  #snumericInput("b.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),



		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("See Plot at Data Distribution Plot")),
		p(tags$b("1. Manual Input")),
    tags$textarea(
        id = "x.b", #p
        rows = 10,
"0.11\n0.57\n0.59\n0.52\n0.13\n0.45\n0.63\n0.68\n0.44\n0.55\n0.48\n0.54\n0.29\n0.41\n0.64\n0.75\n0.33\n0.24\n0.45\n0.18"				        ),
      p("Missing value is input as NA"),

      hr(),

      p(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        fileInput('b.file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("b.header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("b.sep", 
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

				plotOutput("b.plot", click = "plot_click13", width = "800px", height = "400px"),
			 	verbatimTextOutput("b.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("b")
				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	numericInput("b.size", "Sample size of simulated numbers", value = 100, min = 1, max = 1000000, step = 1),
				plotOutput("b.plot2", click = "plot_click14", width = "800px", height = "400px"),
			 	sliderInput("b.bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.01),
				verbatimTextOutput("b.info2"),
				
				p(tags$b("Sample descriptive statistics")),
				tableOutput("b.sum"),
				HTML(
    " 
    <b> Explanation </b>
   <ul>
    <li>  Mean = &#945/(&#945+&#946)
    <li>  SD = sqrt(&#945*&#946/(&#945+&#946)^2(&#945+&#946+1))
   </ul>
    "
    )
			 	),

			 tabPanel("Data Distribution Plot", p(br()),

			plotOutput("makeplot.b", width = "800px", height = "400px"),
      sliderInput("bin.b","The width of bins in histogram", min = 0.01,max = 5,value = 0.2),
      				tableOutput("b.sum2")

			 	)

			)
	)
	)

