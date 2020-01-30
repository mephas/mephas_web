#****************************************************************************************************************************************************1.3. gamma
sidebarLayout(

	sidebarPanel(

	#Select Src
	selectInput(
	    "InputSrc_g", "Select Input Data Source:",
	    c("Mathematical-based Distribution" = "MathDist",
	      "Simulation-based Plot" = "SimuDist",
	      "Data-based" = "DataDist")),
	hr(),
	#Select Src end	

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'MathDist'",
	    #h3("Draw a Gamma Distribution", p(br())),
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
	  #condiPa 1 end
	
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'SimuDist'",  
	    numericInput("g.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
	    sliderInput("g.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")
	    
	  ),
	  #condiPa 2 end
	  
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'DataDist'",  
	    
	    tabsetPanel(
	      tabPanel(
	        h4(tags$b("Manual Input")),
	        p("Data point can be separated by , ; /Enter /Tab /Space"),
			tags$textarea(
        	id = "x.g", #p
       	 rows = 10, "4.1\n9.3\n11.7\n2\n2\n5.8\n1.6\n1.9\n4.7\n5.8\n3.1\n3.1\n3\n11\n1.2\n5.7\n10\n13.8\n3.8\n3.1"
				        ),
      		p("Missing value is input as NA")
	     	 ), #tab1 end 
	      tabPanel(
	        h4(tags$b("Upload Data")),
	        
	        ##-------csv file-------##
	        p(tags$b("This only reads the 1st column of your data, and will cover the input data")),

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
	      ) #tab2 end 
	    ),
      	sliderInput("bin.g","The number of bins in histogram", min = 0, max = 100, value = 0),
      	p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),
		
		conditionalPanel(
		  condition = "input.InputSrc_g == 'MathDist'",
		  p(br()), h4("Mathematical-based Plot"), p(br()),
		  tags$b("Gamma distribution plot"),
		  plotOutput("g.plot", click = "plot_click11", width = "80%"),
         verbatimTextOutput("g.info"), 
		 p(tags$b("The position of Red-line, x0")),
         tableOutput("g")
		),
		
		conditionalPanel(
		  condition = "input.InputSrc_g == 'SimuDist'",
		  p(br()), h4("Simulation-based Plot"), p(br()),
		  
		tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("g.plot2",  width = "80%"),#click = "plot_click12",
        
        #verbatimTextOutput("g.info2"),
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
		
		conditionalPanel(
		condition = "input.InputSrc_g == 'DataDist'",
		p(br()), h4("Distribution of Your Data"), p(br()),
		tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.g2", width = "80%"),
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.g1", width = "80%"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("g.sum2")  
		)
		
	)
	)

