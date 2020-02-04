#****************************************************************************************************************************************************1.4. beta

sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. Select the data source")),
	p("Mathematical-based, simulated-data-based, or user data-based"),
	#Select Src
	selectInput(
	    "InputSrc_b", "Select plot",
      c("Mathematical formula based" = "MathDist",
        "Simulation data based" = "SimuDist",
        "Data-based" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("Step 2. Set parameters")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
	    HTML("<b>1. Set Parameters for Beta(&#945, &#946)</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for Beta(&#945, &#946)</h4></b>"),
		numericInput("b.shape", HTML("&#945 > 0, Shape parameter"), value = 2, min = 0),
		  numericInput("b.scale", HTML("&#946 > 0, Shape parameter"), value = 2, min = 0),

		  hr(),
		  HTML("<b>2. Show Probability</b>"),
		  #h4(tags$b("Step 2. Show Probability")),
	 		numericInput("b.pr", HTML("Area Proportion Left to Red-line = Pr(X < x<sub>0</sub>), x<sub>0</sub> is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		  hr(),
	 		p(tags$b("You can adjust x-axes range")),
		  numericInput("b.xlim", "Range of x-axis, > 0", value = 1, min = 1)
		  #snumericInput("b.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'SimuDist'",
	    numericInput("b.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
	    sliderInput("b.bin", "The number of bins in histogram", min = 0, max = 100, value = 0),
		p("When the number of bins is 0, plot will use the default number of bins")

	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'DataDist'",

	    tabsetPanel(
	       tabPanel("Manual Input",p(br()),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    	tags$textarea(
        id = "x.b", #p
        rows = 10,
"0.11\n0.57\n0.59\n0.52\n0.13\n0.45\n0.63\n0.68\n0.44\n0.55\n0.48\n0.54\n0.29\n0.41\n0.64\n0.75\n0.33\n0.24\n0.45\n0.18"				        ),
      	p("Missing value is input as NA")
	     	 ), #tab1 end

tabPanel.upload.num(file ="b.file", header="b.header", col="b.col", sep="b.sep")
# 	        tabPanel("Upload Data",p(br()),
#
# 	        ##-------csv file-------##
# 	        p(tags$b("This only reads the 1st column of your data, and will cover the input data")),
#
#         	fileInput('b.file', "1. Choose CSV/TXT file",
#                   accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
#
#         p(tags$b("2. Show 1st row as header?")),
#         checkboxInput("b.header", "Show Data Header?", TRUE),
#
#         p(tags$b("3. Use 1st column as row names? (No duplicates)")),
#         checkboxInput("b.col", "Yes", TRUE),
#
#         radioButtons("b.sep",
#           "3. Which Separator for Data?",
#           choiceNames = list(
#             HTML("Comma (,): CSV often use this"),
#             HTML("One Tab (->|): TXT often use this"),
#             HTML("Semicolon (;)"),
#             HTML("One Space (_)")
#             ),
#           choiceValues = list(",", "\t", ";", " ")
#           ),
#
#         p("Correct Separator ensures data input successfully"),
#
#         a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
# 	      ) #tab2 end
	    ),
		sliderInput("bin.b","The number of bins in histogram", min = 0, max = 100, value = 0),
        p("When the number of bins is 0, plot will use the default number of bins")
	  )
	  #condiPa 3 end

	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist'",
		  h4("Mathematical-based Plot"),
		tags$b("Beta distribution plot"),
        plotOutput("b.plot", click = "plot_click13"),
        verbatimTextOutput("b.info"),
        p(tags$b("The position of Red-line, x<sub>0</sub>")),
        tableOutput("b")
		),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'SimuDist'",
		   h4("Simulation-based Plot"),

		tags$b("Histogram from random numbers"),
        plotly::plotlyOutput("b.plot2"),# click = "plot_click14",

        #verbatimTextOutput("b.info2"),
        downloadButton("download4", "Download Random Numbers"),
        p(tags$b("Sample descriptive statistics")),
        tableOutput("b.sum"),
        HTML(
    "
    <b> Explanation </b>
   <ul>
    <li>  Mean = &#945/(&#945+&#946) </li>
    <li>  SD = sqrt(&#945*&#946/(&#945+&#946)^2(&#945+&#946+1)) </li>
   </ul>
    "
    )

		),

		conditionalPanel(
		condition = "input.InputSrc_b == 'DataDist'",

		tags$b("Data preview"),
		DT::DTOutput("ZZ"),
		h4("Distribution of Your Data"),
        tags$b("Density from upload data"),
        plotly::plotlyOutput("makeplot.b2"),
        tags$b("Histogram from upload data"),
        plotly::plotlyOutput("makeplot.b1"),

        p(tags$b("Sample descriptive statistics")),
        tableOutput("b.sum2")



		)

	) #main pa end


	)

