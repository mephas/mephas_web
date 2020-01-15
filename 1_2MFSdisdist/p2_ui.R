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
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel("Draw a Binomial Distribution", p(br()),

		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("lad", "Rate, = mean = variance", value = 2.3, min = 0, max = 10000000000, step = 1),
		  numericInput("k2", "The duration of occurrences > 0", value = 12, min = 0 , max = 1000000000),
		  p(tags$i("From the example, the rate is 2.3 and the duration of the rate is 12 months")),

		  hr(),

		  h4(tags$b("Step 2. Change Observed Data")), 
		  numericInput("x0", "The observed duration of occurrences (Red-Dot)", value = 5, min = 0 , max = 1000000000),
		  p(tags$i("The observed is <= 5, and we wanted to know the cumulated probability after 5 months, which means 1 - cumulated probability of 0-5 months"))
		  ),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.p", #p
        rows = 10,
				"1\n3\n4\n3\n3\n3\n5\n3\n2\n1\n1\n3\n2\n4\n1\n2\n5\n4\n2\n3"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        p(tags$b("This only reads the 1st column of your data")),
        fileInput('file.p', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header.p", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col.p", "Yes", TRUE),

             # Input: Select separator ----
        radioButtons("sep.p", 
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
		tabPanel("Model-based Plot", p(br()),
			p(tags$b("Poisson probability plot")),
		plotOutput("p.plot", width = "80%"),
		p(tags$b("Probability at the observed number of occurrences (Red-Dot)")),
		tableOutput("p.k"),
		p(tags$i("Explanation: the probability distribution until 5 month was 0.97. Thus, the probability distribution after 6 months was about 0.03"))
    ),
    tabPanel("Simulation-based Plot", p(br()),
			 	
			 	numericInput("size.p", "The sample size of random numbers", value = 100, min = 1, max = 1000000, step = 1),
			 	p(tags$b("Histogram from random numbers")),
			 	plotOutput("p.plot2", width = "80%"),	

			 	sliderInput("bin.p", "The width of bins in histogram", min = 0, max = 2, value = 1, step=0.1),
			 	downloadButton("download2", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum.p")
			 	),    
		tabPanel("Distribution of Your Data", p(br()),
			p(tags$b("Histogram from upload data")),
			plotOutput("makeplot.2", width = "80%"),
			#plotOutput("makeplot.2", width = "500px", height = "300px"),
      sliderInput("bin1.p","The width of bins in histogram",min = 0,max = 2,value = 1, step=0.1),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum2.p")

			 	)
			 			 )
	)
)
	