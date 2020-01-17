##'
##' MFSnptest includes Non-parametric test of
##' (1) one sample,
##' (2) two independent samples,
##' and (3) two paried samples.
##'
##' @title MEPHAS: Non-parametric Test (Hypothesis Testing)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom reshape melt
##' @importFrom psych describe
##' @importFrom exactRankTests wilcox.exact
##' @importFrom stats wilcox.test
##'
##' @examples
##' # mephas::MFSnptest()
##' #
##' # library(mephas)
##' # MFSnptest()


##' @export
MFSnptest <- function(){

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Non-parametric Test for Medians",  
##########----------##########----------##########

tabPanel("One Sample",

headerPanel("Wilcoxon Signed-Rank Test for One Sample"),

HTML(
    "    
<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a certain group of patients. DRS Scale > 1 indicated Depression.
We wanted to know if the DRS of patients was significantly greater than 1. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    

    "
    ),

hr(),
#source("p1_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************1.np1

sidebarLayout(  

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give a name to your data (Required)")),

  tags$textarea(id="cn", rows= 1, "Scale"), p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual Input", p(br()),

    p(tags$i("Data here was the Depression Rating Scale factor measurements of 9 patients from a certain group of patients. ")),
    
    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(id="a", 
      rows=5, 
      "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
      ),
    
    p("Missing value is input as NA")

    ),

    tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        p(tags$b("This only reads the one column from your data file")),
        fileInput('file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as column names?")),
        checkboxInput("header", "Yes", TRUE),
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col", "Yes", TRUE),

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
    ),

  hr(),
  h4(tags$b("Step 2. Specify Parameter")),
  numericInput("med", HTML("Specify the median (m&#8320) that you want to compare with your data"), 1),
  p(tags$i("In this default settings, we wanted to know if the group of patients were suffering from depression (Scale > 1).")),
  hr(),

  h4(tags$b("Step 3. Choose Hypothesis")),
  p(tags$b("Null hypothesis")),

  HTML("<p> m = m&#8320: the population median is equal to the specified median( m&#8320) </p>
        <p>Or, the distribution of the data set is symmetric about the specified median</p>"),

  radioButtons("alt.wsr", 
    label = "Alternative hypothesis", selected = "greater",
    choiceNames = list(  
    HTML("m &#8800 m&#8320: the population median of is significantly different from the specified median"),
    HTML("m > m&#8320: the population median of is greater than the specified median"),
    HTML("m < m&#8320: the population median of is less than the specified median")
    ),
  choiceValues = list("two.sided", "greater", "less")),
  hr(),
    p(tags$i("In this default settings, we wanted to know if the group of patients were suffering from depression (Scale > 1).")),

  h4(tags$b("Step 4. Decide P Value method")),
  radioButtons("alt.md", 
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ), 
    choiceValues = list("a", "b", "c")),
    p(tags$i("In this example, we had only 9 people. So we chose exact P value"))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()), 
      DT::DTOutput("table")
      ),

    tabPanel("Basic Descriptives", p(br()), 

        DT::DTOutput("bas")
      ),

    tabPanel("Box-Plot", p(br()), 

        plotOutput("bp", width = "80%", click = "plot_click"),

        verbatimTextOutput("info"), hr(),

          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            
          )
      ),

    tabPanel("Histogram", p(br()), 
            HTML(
          "<b> Explanations </b>
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            ),
      p(tags$b("Histogram")),
      plotOutput("makeplot", width = "80%"),
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      p(tags$b("Density plot")),
      plotOutput("makeplot.1", width = "80%")

      )
    ),
hr(),
h4(tags$b("Output 2. Test Results")),
    p(tags$b('Results of Wilcoxon Signed-Rank Test')), p(br()), 
    DT::DTOutput("ws.test.t"),

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population median is significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population median is NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we concluded that the scales was significantly greater than 1 (P=0.006), which indicated the patients were suffering from depression."))#,
  )
),
hr()

),

##########----------##########----------##########

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann&#8211;Whitney U test) for Two Independent Samples"),

HTML(
    "
<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 19 patients from a certain group of patients. Among 19 people, 9 were women, and 10 were men.
We wanted to know if the DRS of patients was significantly different among different genders; or, whether age was related to DRS scores. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>


    "
    ),

hr(),
#source("p2_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2.np2

sidebarLayout(  

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your data (Required)")), 

  tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),
    p(tags$i("Example here was the Depression Rating Scale factor measurements of 19 patients from a two group of patients.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Group 1")),
    tags$textarea(id="x1", 
    rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"    
    ),  

    p(tags$b("Group 2")),## disable on chrome
    tags$textarea(id="x2", 
      rows=10, 
      "0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
      ),
    
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")
    ),


  ##-------csv file-------##   
tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        p(tags$b("This only reads 2 columns form your data file")),
        fileInput('file2', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
       p(tags$b("2. Show 1st row as header?")),        
      checkboxInput("header2", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names?")),
        checkboxInput("col2", "Yes", TRUE),
             # Input: Select separator ----
        radioButtons("sep2", 
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
        ),

  hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

    p(tags$b("Null hypothesis")),

    HTML("<p> m&#8321 = m&#8322: the medians of two group are equal </p>
          <p> Or, the distribution of values for each group are equal </p>"),

radioButtons("alt.wsr2", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of Group 2 is greater"),
    HTML("m&#8321 > m&#8322: the population median of Group 1 is greater")),
  choiceValues = list("two.sided", "less", "greater")),
    p(tags$i("In this default settings, we wanted to know if Depression Rating Scale from two group of patients were different.")),
    hr(),


  h4(tags$b("Step 3. Decide P Value method")),
  radioButtons("alt.md2", 
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ), 
    choiceValues = list("a", "b", "c")),
      p(tags$i("The sample sizes in each group were 9 and 10, so we used exact p value."))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table2")
      ),

    tabPanel("Basic Descriptives", p(br()), 

        DT::DTOutput("bas2")#, 

      #p(br()), 
      #  downloadButton("download2b", "Download Results") 
      ),

    tabPanel("Box-Plot", p(br()), 
        plotOutput("bp2", width = "80%", click = "plot_click2"),

        verbatimTextOutput("info2"), 
        hr(),
          HTML(
          "Notes:
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            )        
         ),

    tabPanel("Histogram", p(br()), 
      HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"),
      p(tags$b("Histogram")),
      plotOutput("makeplot2", width = "80%"),
      sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      p(tags$b("Density plot")),
      plotOutput("makeplot2.1", width = "80%")
      )
    ),
  hr(),

  h4(tags$b("Output 2. Test Results")),
  tags$b('Results of Wilcoxon Rank-Sum Test'), p(br()), 

  DT::DTOutput("mwu.test.t"), p(br()),

  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population medians of 2 groups are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, no significant differences between the medians of 2 groups. (Accept null hypothesis)
    </ul>"
  ),

    p(tags$i("From the default settings, we concluded that there was no significant differences in 2 groups Rating scale (P=0.44)."))#,


 # downloadButton("download2.1", "Download Results")

  ) 
),
hr()

),

##########----------##########----------##########
tabPanel("Paired Samples",    

headerPanel("Wilcoxon Signed-Rank Test for Two Paired Samples"),

HTML(
    "
<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a certain group of patients. We decided to give them some treatment, and after the treatment we tested the DRS again.
We wanted to know if the DRS of patients before and after were significantly; or, whether the differences were significantly different from 0, which could indicate if the treatment was effective.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
    ),

hr(),
#source("p3_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2.np2

sidebarLayout(  

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your data (Required)")), 

  tags$textarea(id="cn2", rows=2, "Group1\nGroup2"), p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),
    p(tags$i("Example here was the Depression Rating Scale factor measurements of 19 patients from a two group of patients.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Group 1")),
    tags$textarea(id="x1", 
    rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"    
    ),  

    p(tags$b("Group 2")),## disable on chrome
    tags$textarea(id="x2", 
      rows=10, 
      "0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
      ),
    
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")
    ),


  ##-------csv file-------##   
tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        p(tags$b("This only reads 2 columns form your data file")),
        fileInput('file2', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
       p(tags$b("2. Show 1st row as header?")),        
      checkboxInput("header2", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names?")),
        checkboxInput("col2", "Yes", TRUE),
             # Input: Select separator ----
        radioButtons("sep2", 
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
        ),

  hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

    p(tags$b("Null hypothesis")),

    HTML("<p> m&#8321 = m&#8322: the medians of two group are equal </p>
          <p> Or, the distribution of values for each group are equal </p>"),

radioButtons("alt.wsr2", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of Group 2 is greater"),
    HTML("m&#8321 > m&#8322: the population median of Group 1 is greater")),
  choiceValues = list("two.sided", "less", "greater")),
    p(tags$i("In this default settings, we wanted to know if Depression Rating Scale from two group of patients were different.")),
    hr(),


  h4(tags$b("Step 3. Decide P Value method")),
  radioButtons("alt.md2", 
    label = "What is the data like", selected = "c",
    choiceNames = list(
      HTML("Approximate normal distributed P value: sample size is large"),
      HTML("Asymptotic normal distributed P value: sample size is large"),
      HTML("Exact P value: sample size is small (< 50)")
      ), 
    choiceValues = list("a", "b", "c")),
      p(tags$i("The sample sizes in each group were 9 and 10, so we used exact p value."))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table2")
      ),

    tabPanel("Basic Descriptives", p(br()), 

        DT::DTOutput("bas2")#, 

      #p(br()), 
      #  downloadButton("download2b", "Download Results") 
      ),

    tabPanel("Box-Plot", p(br()), 
        plotOutput("bp2", width = "80%", click = "plot_click2"),

        verbatimTextOutput("info2"), 
        hr(),
          HTML(
          "Notes:
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            )        
         ),

    tabPanel("Histogram", p(br()), 
      HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"),
      p(tags$b("Histogram")),
      plotOutput("makeplot2", width = "80%"),
      sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      p(tags$b("Density plot")),
      plotOutput("makeplot2.1", width = "80%")
      )
    ),
  hr(),

  h4(tags$b("Output 2. Test Results")),
  tags$b('Results of Wilcoxon Rank-Sum Test'), p(br()), 

  DT::DTOutput("mwu.test.t"), p(br()),

  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population medians of 2 groups are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, no significant differences between the medians of 2 groups. (Accept null hypothesis)
    </ul>"
  ),

    p(tags$i("From the default settings, we concluded that there was no significant differences in 2 groups Rating scale (P=0.44)."))#,


 # downloadButton("download2.1", "Download Results")

  ) 
),
hr()

),


##########----------##########----------##########
tabPanel((a("Help",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/"))))

)
)

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

#source("p1_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.np1

names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


  A <- reactive({
    inFile <- input$file
  if (is.null(inFile)) {
    # input data
    x <- as.numeric(unlist(strsplit(input$a, "[,;\n\t]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    colnames(x) = names1()
    }
  else {
    if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- as.data.frame(csv[,1])
    colnames(x) <- names(csv)[1]
    #validate( need(sum(!is.na(csv))>1, "Please input enough valid numeric data") )
    if(input$header!=TRUE){
      names(x) <- names1()
      }
    }
  x <- as.data.frame(x)
  })

  #table 
output$table <- DT::renderDT(A(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

  A.des <- reactive({
    x <- A()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas <- DT::renderDT({  
    res <- A.des()
    },
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

   output$bp = renderPlot({
    x = A()
    ggplot(x, aes(x = 0, y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red", outlier.size = 2) + xlim(-1,1)+
    ylab("") + xlab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())}) 
  
  output$info <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("Click to get the value: ", round(e$y, 4))
    }
    paste0("Y-axis position", "\n", xy_str(input$plot_click))})

  output$makeplot <- renderPlot({  #shinysession 
    x <- A()
    ggplot(x, aes(x = x[,1])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin, position="identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank())
    })
  output$makeplot.1 <- renderPlot({  #shinysession 
    x <- A()
    ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title=element_blank())
    })
  

  ws.test<- reactive({
    x <- A()
    if (input$alt.md =="a"){
    res <- wilcox.test((x[,1]), mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md =="b") {
    res <- wilcox.test((x[,1]), 
      mu = input$med, 
      alternative = input$alt.wsr, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], mu = input$med, 
      alternative = input$alt.wsr, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$ws.test.t <- DT::renderDT({ws.test()},
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p2_server.R", local=TRUE)$value
#****************************************************************************************************************************************************2.np2

names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))[1:2]
  return(x)
  })

B <- reactive({
  inFile <- input$file2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$x2, "[,;\n\t]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    validate( need(sum(!is.na(Y))>1, "Please input enough valid numeric data") )
    validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )

    x <- data.frame(X = X, Y = Y)
    colnames(x) = names2()
    }
  else {
    if(!input$col2){
    csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header2, sep = input$sep2, row.names=1)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$header2==FALSE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table2 <-DT::renderDT({B()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

  B.des <- reactive({
    x <- B()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })
  output$bas2 <- DT::renderDT({  ## don't use renerPrint to do DT::renderDT
    res <- B.des()},
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

  output$bp2 = renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    ggplot(mx, aes(x = mx[,"variable"], y = mx[,"value"], fill=mx[,"variable"])) + geom_boxplot(alpha=.3, width = 0.2, outlier.color = "red", outlier.size = 2)+ 
    ylab("") + ggtitle("") + theme_minimal() + theme(legend.title=element_blank()) })

  output$info2 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("Click to get the value: ", round(e$y, 4))
    }
    paste0("Y-axis position", "\n", xy_str(input$plot_click2))})

  output$makeplot2 <- renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    ggplot(mx, aes(x=mx[,"value"], fill=mx[,"variable"])) + geom_histogram(binwidth=input$bin2, alpha=.5, position="identity") + xlab("")+ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    })
  output$makeplot2.1 <- renderPlot({
    x <- B()
    mx <- melt(B(), idvar = colnames(x))
    ggplot(mx, aes(x=mx[,"value"], colour=mx[,"variable"])) + geom_density()+ xlab("")+ ylab("") + ggtitle("") + theme_minimal()+ theme(legend.title=element_blank())
    })
#test
  mwu.test <- reactive({
    x <- B()
     if (input$alt.md2 =="a"){
    res <- wilcox.test(x[,1], x[,2], 
      alternative = input$alt.wsr2, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md2 =="b") {
    res <- wilcox.test(x[,1], x[,2], 
      alternative = input$alt.wsr2, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md2 =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], x[,2],  
      alternative = input$alt.wsr2, exact=TRUE, conf.int = TRUE)

  }
  
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$mwu.test.t<-DT::renderDT({
    mwu.test()},
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#source("p3_server.R", local=TRUE)$value
#****************************************************************************************************************************************************3.npp

names3 <- reactive({
  x <- unlist(strsplit(input$cn3, "[\n]"))
  return(x[1:3])
  })

  C <- reactive({
    inFile <- input$file3
    if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$y1, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$y2, "[,;\n\t]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    validate( need(sum(!is.na(Y))>1, "Please input enough valid numeric data") )
    validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )
    d <- round(X-Y,4)
    x <- data.frame(X =X, Y = Y, diff = d)
    colnames(x) = names3()
  }

    else {
      if(!input$col3){
    csv <- read.csv(inFile$datapath, header = input$header3, sep = input$sep3)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header3, sep = input$sep3, row.names=1)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    x$diff <- round(x[, 2] - x[, 1], 4)
    if(input$header3==FALSE){
      colnames(x) = names3()
      }
    }
    return(as.data.frame(x))
    })
  
  #table
output$table3 <-DT::renderDT(C() ,
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

  C.des <- reactive({
    x<- C()
    res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
    colnames(res) = names(x)
    rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
    return(res)
  })

  output$bas3 <- DT::renderDT({  ## don't use renerPrint to do DT::renderDT
    res <- C.des()}, 
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
  
  output$bp3 = renderPlot({
    x <- C()
    ggplot(x, aes(x = 0, y = x[,3])) + geom_boxplot(width = 0.2, outlier.color = "red") + xlim(-1,1)+
    ylab("") + ggtitle("") + theme_minimal()})

  output$info3 <- renderText({
    xy_str = function(e) {
      if(is.null(e)) return("NULL\n")
      paste0("Click to get the value: ", round(e$y, 4))
    }
    paste0("Y-axis position", "\n", xy_str(input$plot_click3))})

  output$makeplot3 <- renderPlot({
    x <- C()
    ggplot(x, aes(x=x[,3])) + geom_histogram(colour="black", fill = "grey", binwidth=input$bin3, alpha=.5, position="identity") + ylab("Frequncy") + xlab("") +  ggtitle("") + theme_minimal() + theme(legend.title=element_blank())
    })
  output$makeplot3.1 <- renderPlot({
    x <- C()
    ggplot(x, aes(x=x[,3])) + geom_density() + ggtitle("") + theme_minimal() + ylab("Density") + xlab("") + theme(legend.title=element_blank())
    })

psr.test <- reactive({
  x <- C()
  if (input$alt.md3 =="a"){
    res <- wilcox.test(x[,1], x[,2], paired = TRUE,
      alternative = input$alt.wsr3, exact=NULL, correct=TRUE, conf.int = TRUE)
  }
    if (input$alt.md3 =="b") {
    res <- wilcox.test(x[,1], x[,2], paired = TRUE,
      alternative = input$alt.wsr3, exact=NULL, correct=FALSE, conf.int = TRUE)
  }
  if (input$alt.md3 =="c")  {
    res <- exactRankTests::wilcox.exact(x[,1], x[,2],  paired = TRUE,
      alternative = input$alt.wsr3, exact=TRUE, conf.int = TRUE)

  }
    res.table <- t(data.frame(W = res$statistic,
                              P = res$p.value,
                              EM = res$estimate,
                              CI = paste0("(",round(res$conf.int[1], digits = 4),", ",round(res$conf.int[2], digits = 4), ")")))
    colnames(res.table) <- res$method
    rownames(res.table) <- c("W Statistic", "P Value","Estimated Median","95% Confidence Interval")

    return(res.table)
    })

  output$psr.test.t <- DT::renderDT({
    psr.test()}, 
  
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
