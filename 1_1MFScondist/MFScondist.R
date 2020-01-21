##'
##' MFScondist includes probability distribution of
##' (1) normal distribution
##' (2) exponential distribution
##' (3) gamma distribution
##' (4) beta distribution
##' (5) t distribution
##' (6) chi-square distribution
##' and (7) F distribution. 
##'
##' MFScondist also generates random numbers draw the distribution of user data
##'
##' @title MEPHAS: Continuous Probability Distribution (Probability)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##' @importFrom stats dchisq dnorm dt pbinom pnorm ppois qchisq qexp qf qgamma qnorm qt quantile rchisq rexp rf rgamma rnorm rt sd var qbeta rbeta
##' @importFrom utils head

##' @examples
##' # mephas::MFScondist()
##' ## or,
##' # library(mephas)
##' # MFScondist()

##' @export
MFScondist <- function(){

requireNamespace("shiny")

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Continuous Probability Distribution",

##########----------##########----------##########

##########----------##########----------##########
tabPanel("Normal",

headerPanel("Normal Distribution"),

HTML(
" 
<h4><b> What you can do on this page</b></h4>
<ul>
<li> Draw a Normal Distribution with N(&#956, &#963); &#956 is the location, and &#963 indicates the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line and Pr(x1 less than X greater than x2) in the blue area
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to N(&#956, &#963)

</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of N(0, 1), and wanted to know 1. at which point x0 when Pr(X < x0)= 0.025, and 2. what is the probability between means+/-1SD area  </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p1_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************1.1. Normal distribution
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Normal Distribution", p(br()),

		  HTML("<h4><b>Step 1. Set Parameters for N(&#956, &#963)</h4></b>"), 
		  numericInput("mu", HTML("Mean (&#956), the dashed line, indicates the location  "), value = 0),
		  numericInput("sigma", HTML("Standard Deviation (&#963), indicates the shape"), value = 1, min = 0),
		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
		  numericInput("n", HTML("Blue Area = Pr(Mean-n*SD < X < Mean+n*SD)"), value = 1, min = 0),
	 		numericInput("pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),

	 		hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("xlim", "Range of x-asis, symmetric to 0", value = 5, min = 1)
		  #numericInput("ylim", "Range of y-asis > 0", value = 0.5, min = 0.1, max = 1),


		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x", #p
        rows = 10,
				"-1.8\n0.8\n-0.3\n1\n-1.2\n-0.7\n-0.7\n-0.6\n1.3\n-0.8\n-1.2\n0.6\n2.2\n0.5\n0.4\n-0.3\n0.3\n-0.2\n-1.1\n0"
				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        p(tags$b("This only reads the 1st column of your data")),
        fileInput('file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col", "Yes", TRUE),

             # Input: Select separator ----
        radioButtons("sep", 
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
		h4(tags$b("Output Plots")),

		tabsetPanel(
			 tabPanel("Mathematical-based Plot", p(br()),
			 tags$b("Normal distribution plot"),
			 	#plotOutput("norm.plot", click = "plot_click", width = "600px", height = "400px"), #click = "plot_click", 
			 	plotOutput("norm.plot", click = "plot_click", width = "80%"), #click = "plot_click", 

			 	verbatimTextOutput("info"),

			 	p(tags$b("The position of Red-line and the Blue Ares")),
				tableOutput("xs")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("size", "Sample size of simulated numbers", value = 100, min = 1),
			 	tags$b("Histogram from random numbers"),
			 	plotOutput("norm.plot2", click = "plot_click2",  width = "80%"),	

			 	sliderInput("bin", "The width of bins in histogram", min = 0, max = 2, value = 0.2, step=0.01),
				verbatimTextOutput("info2"),

				downloadButton("download1", "Download Random Numbers"),

				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum")
				#verbatimTextOutput("data")
			 	),

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotOutput("makeplot.2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.1", width = "80%"),
      	sliderInput("bin1","The width of bins in histogram",min = 0,max = 2,value = 0.2, step=0.01),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("sum2")

			 	)

			)
	)
	),
hr()
),

##########----------##########----------##########
tabPanel("Exponential",

headerPanel("Exponential Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>
<ul>
<li> Draw an Exponential Distribution with E(Rate); Rate indicates the rate of change
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to E(Rate)
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of E(2), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"

),

hr(),

#source("p2_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************1.2. Exp distribution
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw an Exponential Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters for E(Rate)")), 
		  numericInput("r", HTML("Rate (> 0) indicates the rate of change"), value = 2, min = 0),
		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("e.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),

		  #numericInput("e.ylim", "Range of y-asis > 0", value = 2.5, min = 0.1, max = 3),
		  hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("e.xlim", "Range of x-asis > 0", value = 5, min = 1)


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

				plotOutput("e.plot", click = "plot_click9", width = "80%"),
			 	verbatimTextOutput("e.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("e")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("e.size", "Sample size of simulated numbers", value = 100, min = 1,step = 1),
			 	tags$b("Histogram from random numbers"),
				plotOutput("e.plot2", click = "plot_click10", width = "80%"),
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
				plotOutput("makeplot.e2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.e1", width = "80%"),
      	sliderInput("bin.e","The width of bins in histogram", min = 0,max = 2,value = 0.1, step=0.01),
				tableOutput("e.sum2")

			 	)

			)
	)
	),
hr()
),


##########----------##########----------##########
tabPanel("Gamma",

headerPanel("Gamma Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a Gamma Distribution with Gamma(&#945, &#952); &#945 controls the shape, 1/&#952 controls the change of rate
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to  Gamma(&#945, &#952)  
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Gamma(9,0.5), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p3_ui.R", local=TRUE)$value,
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
	),
hr()
),


##########----------##########----------##########
tabPanel("Beta",

headerPanel("Beta Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a Beta Distribution with Beta(&#945, &#946); &#945, &#946 controls the shape
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to Beta(&#945, &#946)  
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Beta(2, 2), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p4_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************1.4. beta

sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Beta Distribution", p(br()),
		  HTML("<h4><b>Step 1. Set Parameters for Beta(&#945, &#946)</h4></b>"), 
		  numericInput("b.shape", HTML("&#945 > 0, Shape parameter"), value = 2, min = 0),
		  numericInput("b.scale", HTML("&#946 > 0, Shape parameter"), value = 2, min = 0),

		  hr(),
		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("b.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		  hr(),
	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("b.xlim", "Range of x-asis, > 0", value = 1, min = 1)
		  #snumericInput("b.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),



		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.b", #p
        rows = 10,
"0.11\n0.57\n0.59\n0.52\n0.13\n0.45\n0.63\n0.68\n0.44\n0.55\n0.48\n0.54\n0.29\n0.41\n0.64\n0.75\n0.33\n0.24\n0.45\n0.18"				        ),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        fileInput('b.file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("b.header", "Show Data Header?", TRUE),

        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("b.col", "Yes", TRUE),

        radioButtons("b.sep", 
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
			 	tags$b("Beta distribution plot"),

				plotOutput("b.plot", click = "plot_click13", width = "80%"),
			 	verbatimTextOutput("b.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("b")
				),
			 tabPanel("Simulation-based Plot", p(br()),

			 	numericInput("b.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
			 	tags$b("Histogram from random numbers"),
				plotOutput("b.plot2", click = "plot_click14", width = "80%"),
			 	sliderInput("b.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.01, step=0.01),
				verbatimTextOutput("b.info2"),
				downloadButton("download4", "Download Random Numbers"),				
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

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotOutput("makeplot.b2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.b1", width = "80%"),
	      sliderInput("bin.b","The width of bins in histogram", min = 0,max = 2,value = 0.01, step=0.01),
				tableOutput("b.sum2")

			 	)

			)
	)
	),
hr()
),


##########----------##########----------##########
tabPanel("T",

headerPanel("Student's T Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a T Distribution with T(v); v is the degree of freedom related to your sample size and control the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to T(v)  </ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of T(4) and wanted to know at which point x0 when Pr(X < x0)= 0.025 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p5_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************1.5. T
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a T Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters for T(v)")), 
		  numericInput("t.df", HTML("v > 0, Degree of Freedom, related to the shape"), value = 4, min = 0),
		  
		  hr(),
		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("t.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.025, min = 0, max = 1, step = 0.05),
		  
		  hr(),	 		
		  p(tags$b("You can adjust x-axes range")), 
		  numericInput("t.xlim", "Range of x-asis", value = 5, min = 1)
		  #numericInput("t.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),



		),

	tabPanel("Distribution of Your Data", p(br()),

		h4(tags$b("1. Manual Input")),
		p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x.t", #p
        rows = 10,
"-0.52\n-0.36\n-1.15\n-1.46\n0.54\n-1.6\n0.1\n-0.48\n-0.69\n-1.66\n0.59\n0.11\n-0.01\n0.32\n-1.31\n1.25\n-0.19\n-0.66\n0.75\n-1.86"
),
      p("Missing value is input as NA"),

      hr(),

      h4(tags$b("Or, 2. Upload Data")),

      ##-------csv file-------##
        fileInput('t.file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("t.header", "Show Data Header?", TRUE),
        
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("t.col", "Yes", TRUE),

        radioButtons("t.sep", 
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
			 	tags$b("T distribution plot"),

				plotOutput("t.plot", click = "plot_click3", width ="80%"),
			 	verbatimTextOutput("t.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("t")

				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("t.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
			 	tags$b("Histogram from random numbers"),
				plotOutput("t.plot2", click = "plot_click4", width ="80%"),
			 	sliderInput("t.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.2, step=0.01),
				verbatimTextOutput("t.info2"),
				downloadButton("download5", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("t.sum")
				
			 	),

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotOutput("makeplot.t2", width = "80%"),   
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.t1", width = "80%"),
			sliderInput("bin.t","The width of bins in histogram", min = 0,max = 2,value = 0.2, step=0.01),
      				tableOutput("t.sum2")

			 	)

			)
	)
	),
hr()
),


##########----------##########----------##########
tabPanel("Chi",

headerPanel("Chi-Squared Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a Chi-Squared Distribution with Chi(v); v is the degree of freedom related to your sample size and control the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to Chi(v)</ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of Chi(4), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p6_ui.R", local=TRUE)$value,
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
				plotOutput("x.plot2", click = "plot_click6", width = "80%"),
			 	sliderInput("x.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.1, step=0.01),
				verbatimTextOutput("x.info2"),
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
				plotOutput("makeplot.x2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.x1", width = "80%"),
	      sliderInput("bin.x","The width of bins in histogram", min = 0,max = 2,value = 0.1, step=0.01),
	      tableOutput("x.sum2")

			 	)

			)
	)
	),
hr()
),

##########----------##########----------##########
tabPanel("F",

headerPanel("F Distribution"), 

HTML(
" 
<h4><b> What you can do on this page</b></h4>    
<ul>
<li> Draw a F Distribution with F(df1, df2) ; df1 and df2 are the degree of freedom related to your sample size and control the shape 
<li> Get the probability distribution of x0 that Pr(X less than x0) = left to the red-line 
<li> Get the probability distribution from simulation numbers in Simulation-based tab
<li> Download the random number in Simulation-based tab
<li> Get the mean, SD, and Pr(X less than x0) of simulated numbers
<li> Get the probability distribution of your data which can be roughly compared to F(df1, df2)  </ul>

<i><h4>Case Example</h4>
Suppose we wanted to see the shape of F(100, 10), and wanted to know at which point x0 when Pr(X < x0)= 0.05 </i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p7_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************1.7. F
sidebarLayout(

	sidebarPanel(	

	tabsetPanel(

		tabPanel(
			"Draw a Beta Distribution", p(br()),
		  h4(tags$b("Step 1. Set Parameters")), 
		  numericInput("df11", HTML("df1 > 0, Degree of Freedom 1"), value = 100, min = 0),
		  numericInput("df21", HTML("df2 > 0, Degree of Freedom 2"), value = 100, min = 0),

		  #numericInput("f.ylim", "Range of y-asis, > 0", value = 2.5, min = 0.1, max = 3),
		  hr(),

		  h4(tags$b("Step 2. Show Probability")),   
	 		numericInput("f.pr", HTML("Area Proportion Left to Red-line = Pr.(X < x0), x0 is the position of Red-line"), value = 0.05, min = 0, max = 1, step = 0.05),
		  hr(),

	 		p(tags$b("You can adjust x-axes range")), 
		  numericInput("f.xlim", "Range of x-asis, > 0", value = 5, min = 1)

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
			 	tags$b("F distribution plot"),

				plotOutput("f.plot", click = "plot_click7", width = "80%"),
			 	verbatimTextOutput("f.info"),

			 	p(tags$b("The position of Red-line, x0")),
				tableOutput("f")
				),
			 tabPanel("Simulation-based Plot", p(br()),
			 	numericInput("f.size", "Sample size of simulated numbers", value = 100, min = 1, step = 1),
			 	tags$b("Histogram from random numbers"),
				plotOutput("f.plot2", click = "plot_click8", width = "80%"),
			 	sliderInput("f.bin", "The width of bins in histogram", min = 0, max = 2, value = 0.1, step=0.01),
				verbatimTextOutput("f.info2"),
				downloadButton("download7", "Download Random Numbers"),
				p(tags$b("Sample descriptive statistics")),
				tableOutput("f.sum")
			 	),

			 tabPanel("Distribution of Your Data", p(br()),
			 	tags$b("Density from upload data"),
				plotOutput("makeplot.f2", width = "80%"),
			 	tags$b("Histogram from upload data"),
				plotOutput("makeplot.f1", width = "80%"),
      	sliderInput("bin.f","The width of bins in histogram", min = 0,max = 2,value = 0.1, step=0.01),
				tableOutput("f.sum2")

			 	)

			)
	)
	),
hr()
),


##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))


##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

#source("p1_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.1. Normal
output$norm.plot <- renderPlot({
  
  mynorm = function (x) {
  norm = dnorm(x, input$mu, input$sigma)
  norm[x<=(input$mu-input$n*input$sigma) |x>=(input$mu+input$n*input$sigma)] = NA
  return(norm)
  }

  ggplot(data = data.frame(x = c(-(input$xlim), input$xlim)), aes(x)) +
  stat_function(fun = dnorm, n = 101, args = list(mean = input$mu, sd = input$sigma)) + 
  scale_y_continuous(breaks = NULL) +
  stat_function(fun = mynorm, geom = "area", fill="cornflowerblue", alpha = 0.3) + 
  scale_x_continuous(breaks = c(-input$xlim, input$xlim))+
  ylab("Density") + 
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=input$mu), color="red", linetype="dashed", size=0.5) +
  geom_vline(aes(xintercept=qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)), color="red", size=0.5) })

output$info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click))})

output$xs = renderTable({
  a = qnorm(input$pr, mean = input$mu, sd = input$sigma, lower.tail = TRUE, log.p = FALSE)
  b = 100*pnorm(input$mu+input$n*input$sigma, input$mu, input$sigma)-pnorm(input$mu-input$n*input$sigma, input$mu, input$sigma)
  x <- t(data.frame(x.position = a, blue.area = b))
  rownames(x) <- c("Red-line Position (x0)", "Blue Area, Probability %")
  return(x)}, 
  digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

N = reactive({ 
  df = data.frame(x = rnorm(input$size, input$mu, input$sigma))
  return(df)})



output$norm.plot2 = renderPlot(
{df = N()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ geom_histogram(binwidth = input$bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-input$xlim, input$xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
})


output$sum = renderTable({
  x = N()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

output$info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click2))})

output$download1 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(N(), file)
    }
  )

NN <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.1 <- renderPlot({
  x = NN()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin1, position = "identity") + 
  xlab("") + 
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
  })

output$makeplot.2 <- renderPlot({
  x = NN()
  ggplot(x, aes(x = x[,1])) + 
  geom_density() + 
  xlab("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())+
  geom_vline(aes(xintercept=quantile(x[,1], probs = input$pr, na.rm = FALSE)), color="red", size=0.5)
  })

output$sum2 = renderTable({
  x = NN()[,1]
  x <- matrix(c(mean(x), sd(x), quantile(x, probs = input$pr)),3,1)
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
#source("p2_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.2. Exp distribution
output$e.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$e.xlim)), aes(x)) +
  stat_function(fun = "dexp", args = list(rate = input$r)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$e.ylim) +
  geom_vline(aes(xintercept=qexp(input$e.pr, rate = input$r)), colour = "red")
  })

output$e.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click9))})

output$e = renderTable({
  x <- data.frame(x.postion = qexp(input$e.pr, rate = input$r))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

E = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rexp(input$e.size, rate = input$r))
  return(df)})

output$download2 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(E(), file)
    }
  )

output$e.plot2 = renderPlot(
{df = E()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ylab("Frequency")+ 
geom_histogram(binwidth = input$e.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$e.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$e.pr, na.rm=TRUE)), color="red", size=0.5)})

output$e.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Click Position: ", "\n", xy_str(input$plot_click10))})

output$e.sum = renderTable({
  x = E()[,1]
  x <- t(data.frame(Mean = mean(x), SD = sd(x), Variance = quantile(x, probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

Y <- reactive({
  inFile <- input$e.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.e, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$e.col){
    csv <- read.csv(inFile$datapath, header = input$e.header, sep = input$e.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$e.header, sep = input$e.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })


output$makeplot.e1 <- renderPlot({
  x = Y()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.e, position = "identity") + 
  xlab("") + 
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
   })
output$makeplot.e2 <- renderPlot({
  x = Y()
  ggplot(x, aes(x = x[,1])) + 
  geom_density() + 
  ggtitle("") + 
  xlab("") + theme_minimal() + 
  theme(legend.title =element_blank())+
  geom_vline(aes(xintercept=quantile(x[,1], probs = input$e.pr, na.rm = TRUE)), color="red", size=0.5)
   })

output$e.sum2 = renderTable({
  x = Y()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$e.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")
#source("p3_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.3. gamma
output$g.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$g.xlim)), aes(x)) +
  stat_function(fun = "dgamma", args = list(shape = input$g.shape, scale=input$g.scale)) + 
  ylab("Density") +
  theme_minimal() + 
  ggtitle("")+
  scale_y_continuous(breaks = NULL) + #ylim(0, input$g.ylim) +
  geom_vline(aes(xintercept=qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale)), colour = "red")
  })

output$g.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click11))})

output$g = renderTable({
  x <- data.frame(x.postion = qgamma(input$g.pr, shape = input$g.shape, scale=input$g.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

G = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rgamma(input$g.size, shape = input$g.shape, scale=input$g.scale))
  return(df)})

output$download3 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(G(), file)
    }
  )

output$g.plot2 = renderPlot(
{df = G()
ggplot(df, aes(x = x)) + 
ylab("Frequency")+ 
theme_minimal() + 
ggtitle("")+
geom_histogram(binwidth = input$g.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$g.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$g.pr, na.rm = FALSE)), color="red", size=0.5)})

output$g.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Click Position: ", "\n", xy_str(input$plot_click12))})

output$g.sum = renderTable({
  x = G()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = var(x[,1])))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

Z <- reactive({
  inFile <- input$g.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.g, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$col){
    csv <- read.csv(inFile$datapath, header = input$g.header, sep = input$g.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$g.header, sep = input$g.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.g1 <- renderPlot({
  x = Z()
  ggplot(x, aes(x = x[,1])) + 
  geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.g, position = "identity") + 
  xlab("") + 
  ggtitle("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())
 
  })

output$makeplot.g2 <- renderPlot({
  x = Z()
  ggplot(x, aes(x = x[,1])) + 
  geom_density() + 
  ggtitle("") + 
  xlab("") + 
  theme_minimal() + 
  theme(legend.title =element_blank())+ 
  geom_vline(aes(xintercept=quantile(x[,1], probs = input$g.pr, na.rm = FALSE)), color="red", size=0.5)
 
  })

output$g.sum2 = renderTable({
  x = Z()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance =quantile(x[,1], probs = input$g.pr)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

#source("p4_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.4. beta
output$b.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$b.xlim)), aes(x)) +
  stat_function(fun = "dbeta", args = list(shape1 = input$b.shape, shape2=input$b.scale)) + 
  ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$b.ylim) +
  geom_vline(aes(xintercept=qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale)), colour = "red")})

output$b.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click13))})

output$b = renderTable({
  x <- data.frame(x.postion = qbeta(input$b.pr, shape1 = input$b.shape, shape2=input$b.scale))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

B = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rbeta(input$b.size, shape1 = input$b.shape, shape2=input$b.scale))
  return(df)})

output$download4 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(B(), file)
    }
  )

output$b.plot2 = renderPlot(
{df = B()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$b.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$b.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$b.pr, na.rm = FALSE)), color="red", size=0.5)
})

output$b.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Click Position: ", "\n", xy_str(input$plot_click12))})

output$b.sum = renderTable({
  x = B()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), va=quantile(x[,1], probs = input$b.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation","Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

ZZ <- reactive({
  inFile <- input$b.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.b, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$b.col){
    csv <- read.csv(inFile$datapath, header = input$b.header, sep = input$b.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$b.header, sep = input$b.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.b1 <- renderPlot({
  x = as.data.frame(ZZ())
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.b, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
   })

output$makeplot.b2 <- renderPlot({
  x = as.data.frame(ZZ())
  ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank()) + geom_vline(aes(xintercept=quantile(x[,1], probs = input$b.pr, na.rm = FALSE)), color="red", size=0.5)
   })

output$b.sum2 = renderTable({
  x = ZZ()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance =quantile(x[,1], probs = input$b.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

#source("p5_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.5. T
output$t.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-input$t.xlim, input$t.xlim)), aes(x)) + 
  stat_function(fun = dt, n = 100, args = list(df = input$t.df)) + 
  stat_function(fun = dnorm, args = list(mean = 0, sd = 1), color = "cornflowerblue") +
  ylab("Density") + 
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("")+
  geom_vline(aes(xintercept=qt(input$t.pr, df = input$t.df)), colour = "red")})

output$t.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click3))})

output$t = renderTable({
  x <-data.frame(x.position = qt(input$t.pr, df = input$t.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


T = reactive({ # prepare dataset
 #set.seed(1)
  df = data.frame(x = rt(input$t.size, input$t.df))
  return(df)})

output$download5 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(T(), file)
    }
  )

output$table2 = renderDataTable({head(T(), n = 100L)},  options = list(pageLength = 10))

output$t.plot2 = renderPlot(
{df = T()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$t.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-input$t.xlim, input$t.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)
})

output$t.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click4))})

output$t.sum = renderTable({
  x = T()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


TT <- reactive({
  inFile <- input$t.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.t, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$t.col){
    csv <- read.csv(inFile$datapath, header = input$t.header, sep = input$t.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$t.header, sep = input$t.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })


output$makeplot.t1 <- renderPlot({
  x = as.data.frame(TT())
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.t, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
   })
output$makeplot.t2 <- renderPlot({
  x = as.data.frame(TT())
  ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank()) + geom_vline(aes(xintercept=quantile(x[,1], probs = input$t.pr, na.rm = FALSE)), color="red", size=0.5)
   })

output$t.sum2 = renderTable({
  x = TT()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$t.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

#source("p6_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.6. chi
output$x.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$x.xlim)), aes(x)) +
  stat_function(fun = dchisq, n = 100, args = list(df = input$x.df)) + 
  ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$x.ylim) +
  geom_vline(aes(xintercept=qchisq(input$x.pr, df = input$x.df)), colour = "red")})

output$x.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click5))})

output$xn = renderTable({
  x <- data.frame(x.postion = qchisq(input$x.pr, df = input$x.df))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

X = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rchisq(input$x.size, input$x.df))
  return(df)})

output$download6 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(X(), file)
    }
  )

output$x.plot2 = renderPlot(
{df = X()
ggplot(df, aes(x = x)) + 
theme_minimal() + 
ggtitle("")+
ylab("Frequency")+ 
geom_histogram(binwidth = input$x.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$x.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)})

output$x.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click6))})

output$x.sum = renderTable({
  x = X()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

XX <- reactive({
  inFile <- input$x.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.x, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$x.col){
    csv <- read.csv(inFile$datapath, header = input$x.header, sep = input$x.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$x.header, sep = input$x.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.x1 <- renderPlot({
  x = as.data.frame(XX())
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.x, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
   })
output$makeplot.x2 <- renderPlot({
  x = as.data.frame(XX())
ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+ geom_vline(aes(xintercept=quantile(x[,1], probs = input$x.pr, na.rm = FALSE)), color="red", size=0.5)
   })

output$x.sum2 = renderTable({
  x = XX()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$x.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")

#source("p7_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.7. F
output$f.plot <- renderPlot({
  ggplot(data = data.frame(x = c(-0.1, input$f.xlim)), aes(x)) +
  stat_function(fun = "df", n= 100, args = list(df1 = input$df11, df2 = input$df21)) + ylab("Density") +
  scale_y_continuous(breaks = NULL) + 
  theme_minimal() + 
  ggtitle("") + #ylim(0, input$f.ylim) +
  geom_vline(aes(xintercept=qf(input$f.pr, df1 = input$df11, df2 = input$df21)), colour = "red")})

output$f.info = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }
    paste0("Click Position: ", "\n", xy_str(input$plot_click7))})

output$f = renderTable({
  x <- data.frame(x.postion = qf(input$f.pr, df1 = input$df11, df2 = input$df21))
  rownames(x) <- c("Red-line Position (x)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


F = reactive({ # prepare dataset
  #set.seed(1)
  df = data.frame(x = rf(input$f.size, input$df11, input$df21))
  return(df)})

output$download7 <- downloadHandler(
    filename = function() {
      "rand.csv"
    },
    content = function(file) {
      write.csv(F(), file)
    }
  )

output$table4 = renderDataTable({head(F(), n = 100L)},  options = list(pageLength = 10))

output$f.plot2 = renderPlot(
{df = F()
ggplot(df, aes(x = x)) + 
ggtitle("") + 
theme_minimal() + 
ylab("Frequency")+ 
geom_histogram(binwidth = input$f.bin, colour = "white", fill = "cornflowerblue", size = 0.1) + 
xlim(-0.1, input$f.xlim) + 
geom_vline(aes(xintercept=quantile(x, probs = input$f.pr, na.rm = FALSE)), color="red", size=0.5)})

output$f.info2 = renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0(" x = ", round(e$x, 6), "\n", " y = ", round(e$y, 6))
    }

    paste0("Click Position: ", "\n", xy_str(input$plot_click8))})

output$f.sum = renderTable({
  x = F()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$f.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


FF <- reactive({
  inFile <- input$f.file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x.f, "[\n,\t; ]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    }
  else {
    if(input$f.col){
    csv <- read.csv(inFile$datapath, header = input$f.header, sep = input$f.sep, row.names=1)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$f.header, sep = input$f.sep)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    x <- as.data.frame(csv[,1])
    }
    colnames(x) = c("X")
    return(as.data.frame(x))
  })

output$makeplot.f1 <- renderPlot({
  x = as.data.frame(FF())
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin.f, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
   })
output$makeplot.f2 <- renderPlot({
  x = as.data.frame(FF())
 ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank())+ geom_vline(aes(xintercept=quantile(x[,1], probs = input$f.pr, na.rm = FALSE)), color="red", size=0.5)
   })

output$f.sum2 = renderTable({
  x = FF()
  x <- t(data.frame(Mean = mean(x[,1]), SD = sd(x[,1]), Variance = quantile(x[,1], probs = input$f.pr, na.rm = FALSE)))
  rownames(x) <- c("Mean", "Standard Deviation", "Red-line Position (x0)")
  return(x)
  }, digits = 6, colnames=FALSE, rownames=TRUE, width = "80%")


observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}

