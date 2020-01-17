##'
##' MFSttest includes t test of 
##' (1) one sample,
##' (2) two independent samples,
##' and (3) two paired samples.
##'
##' @title MEPHAS: T Test (Hypothesis Testing)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom reshape melt
##' @importFrom stats t.test var.test
##' @importFrom utils read.csv

##' @examples
##' # mephas::MFSttest()
##' # or,
##' # library(mephas)
##' # MFSttest()

##' @export
MFSttest <- function(){

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Parametric T Test for Means",


##########----------##########----------##########
tabPanel( "One Sample",

headerPanel("One-Sample T-Test"), 

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if your data is statistically significantly different from the specified mean from T test results
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution 
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 1 group of values (or a numeric vector)
<li> The values are independent observations and approximately normally distributed
</ul> 

<i><h4>Case Example</h4>
Suppose we collected the age of 144 independent lymph node positive patients, and wanted to know whether the general age of lymph node positive patients was 50 years old
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#source("p1_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************1.t1
sidebarLayout(

sidebarPanel(


  h4(tags$b("Step 1. Data Preparation")), 

  p(tags$b("1. Give a name to your data (Required)")),

  tags$textarea(id = "cn", rows = 1, "Age"),p(br()),

  p(tags$b("2. Input data")),

  tabsetPanel(

    tabPanel("Manual Input", p(br()),

     p(tags$i("Here was the AGE of 144 independent lymph node positive patients")),
    
    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
    tags$textarea(
        id = "x", #p
        rows = 10,
        "50\n42\n50\n43\n47\n47\n38\n45\n31\n41\n48\n47\n38\n44\n36\n42\n42\n45\n49\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n48\n36\n43\n44\n47\n40\n41\n48\n41\n45\n45\n47\n37\n43\n43\n49\n45\n41\n50\n49\n43\n38\n42\n49\n44\n48\n50\n44\n49\n32\n43\n42\n50\n39\n42\n41\n49\n38\n43\n50\n49\n37\n37\n48\n48\n48\n49\n45\n44\n35\n49\n39\n46\n49\n37\n50\n35\n47\n43\n44\n41\n43\n45\n42\n39\n40\n37\n44\n39\n45\n46\n42\n49\n41\n26\n49\n36\n48\n29\n43\n45\n45\n47\n49\n41\n46\n41\n36\n38\n49\n49\n42\n46\n42\n51\n51\n52\n52\n52\n52\n52\n52\n53\n52\n51\n51\n51\n51\n51\n51\n47\n39\n51"
        ),

      p("Missing value is input as NA")
      ),

    tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        p(tags$b("This only reads the one column from your data file")),
        fileInput('file', "1. Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        p(tags$b("2. Show 1st row as column names?")),
        checkboxInput("header", "Yes", TRUE),
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

    ),

hr(),

  h4(tags$b("Step 2. Specify Parameter")),

  numericInput('mu', HTML("Mean (&#956&#8320) that you want to compare with your data"), 50), #p

  p(tags$i("The specified parameter is the general age 50")),

hr(),

  h4(tags$b("Step 3. Choose Hypothesis")),

  p(tags$b("Null hypothesis")),
  HTML("&#956 = &#956&#8320: the population mean (&#956) of your data is &#956&#8320"),

  radioButtons(
    "alt",
    label = "Alternative hypothesis",
    choiceNames = list(
      HTML("&#956 &#8800 &#956&#8320: the population mean of your data is not &#956&#8320"),
      HTML("&#956 < &#956&#8320: the population mean of your data is less than &#956&#8320"),
      HTML("&#956 > &#956&#8320: the population mean of your data is greater than &#956&#8320")
      ),
    choiceValues = list("two.sided", "less", "greater")),
    p(tags$i("We wanted to know whether the age was 50 or not, so we chose the first alternative hypothesis"))


    ),


mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table")
      #shiny::dataTableOutput("table")
      ),

    tabPanel("Basic Descriptives", p(br()),

        DT::DTOutput("bas")#,
      #p(br()),
       # downloadButton("download0", "Download Results")
       ),

    tabPanel("Box-Plot", p(br()),
      
        plotOutput("bp", width = "80%", click = "plot_click1"),
     
        verbatimTextOutput("info1"), 
          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            
          )
        
      ),

    tabPanel("Mean and SD Plot", p(br()),
plotOutput("meanp", width = "80%")),


    tabPanel("Distribution Plots", p(br()),
HTML(
"<b> Explanations </b>
<ul> 
<li> Normal Q&#8211;Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
<li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
<li> Density Plot: to estimate the probability density function of the data
</ul>"
),

      p(tags$b("Normal Q&#8211;Q plot")),
      plotOutput("makeplot1", width = "80%"),
      p(tags$b("Histogram")),
      plotOutput("makeplot1.2", width = "80%"),
      sliderInput("bin","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
      p(tags$b("Density plot")),
      plotOutput("makeplot1.3", width = "80%")
      
)
),

  hr(),
  h4(tags$b("Output 2. Test Results")),p(br()),
  DT::DTOutput("t.test"),


  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population of the data IS significantly different from the specified mean. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population of the data IS NOT significantly different from the specified mean. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("Because P <0.05 , we concluded that the age of lymph node positive population was significantly different from 50 years old. Thus the general age was not 50. If we reset the specified mean to 44, we could get P > 0.05"))
 )

),

hr()


),


##########----------##########----------##########
tabPanel("Two Samples",

headerPanel("Independent Two-Sample T-Test"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means of two sets of your data are significantly different from each other from T test results
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution 

</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 separate groups/sets (or 2 numeric vectors)
<li> The 2 separate groups/sets are independent and identically approximately normally distributed
</ul> 

<i><h4>Case Example</h4>
Suppose we collected the age of 144 independent lymph node positive patients. Among them, 27 had Estrogen receptor (ER) positive, 114 had ER negative. 
We wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative in general. Or, whether ER is related to age.
</h4></i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
),

hr(),

#source("p2_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************2.t2
sidebarLayout(

sidebarPanel(
  
  h4(tags$b("Step 1. Data Preparation")),
    
  p(tags$b("1. Give names to your groups (Required)")),

  tags$textarea(id = "cn2", rows = 2, "Age.positive\nAge.negative"), p(br()),

    p(tags$b("2. Input data")),

    tabsetPanel(
      ##-------input data-------##
      tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the AGE of 27 lymph node positive patients with Estrogen receptor (ER) positive (Group.1-Age.positive); and 117 patients with ER negative (Group.2-Age.negative)")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),

        p(tags$b("Group 1")),
        tags$textarea(id = "x1",rows = 10,
"47\n45\n31\n38\n44\n49\n48\n44\n47\n45\n37\n43\n49\n32\n41\n38\n37\n44\n45\n46\n26\n49\n48\n45\n46\n52\n51\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA\nNA"        
),
        p(tags$b("Group 2")),
        tags$textarea(id = "x2",rows = 10,
"50\n42\n50\n43\n47\n38\n41\n48\n47\n36\n42\n42\n45\n44\n32\n46\n50\n38\n43\n40\n42\n46\n41\n46\n48\n36\n43\n40\n41\n48\n41\n45\n47\n43\n43\n49\n45\n41\n50\n49\n38\n42\n44\n48\n50\n44\n49\n43\n42\n50\n39\n42\n49\n43\n50\n49\n37\n48\n48\n48\n49\n45\n44\n35\n49\n39\n46\n49\n37\n50\n35\n47\n43\n41\n43\n42\n39\n40\n37\n44\n39\n45\n42\n49\n41\n36\n29\n43\n45\n47\n49\n41\n41\n36\n38\n49\n49\n42\n46\n42\n51\n51\n52\n52\n52\n52\n52\n53\n52\n51\n51\n51\n51\n51\n47\n39\n51"
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

  h4(tags$b("Choose Hypothesis")),

  h4(tags$b("Step 2. Equivalence of Variance")),
  p("Before doing T test, we need to check the equivalence of variance and then decide which T test to use"),
  p(tags$b("Null hypothesis")),
  HTML("<p> v1 = v2: Group 1 and Group 2 have equal population variances </p>"),
    
    radioButtons("alt.t22", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("v1 &#8800 v2: the population variances of Group 1 and Group 2 are not equal"),
        HTML("v1 < v2: the population variances of Group 1 is less than Group 2"),
        HTML("v1 > v2: the population variances of Group 1 is greater than Group 2")
        ),
      choiceValues = list("two.sided", "less", "greater")),
    hr(),

  h4(tags$b("Step 3. T Test")),

  p(tags$b("Null hypothesis")),
  HTML("<p> &#956&#8321 = &#956&#8322: Group 1 and Group 2 have equal population mean </p>"),
    
    radioButtons("alt.t2", #p
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("&#956&#8321 &#8800 &#956&#8322: the population means of Group 1 and Group 2 are not equal"),
        HTML("&#956&#8321 < &#956&#8322: the population means of Group 1 is less than Group 2"),
        HTML("&#956&#8321 > &#956&#8322: the population means of Group 1 is greater than Group 2")
        ),
      choiceValues = list("two.sided", "less", "greater")),

      p(tags$i("In this default settings, we wanted to know if the ages of patients with ER positive was significantly different from patients with ER negative"))


    ),

  mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table2")),

    tabPanel("Basic Descriptives", p(br()),
          
          DT::DTOutput("bas2")
      ),

      tabPanel("Box-Plot",p(br()),     
        
      plotOutput("bp2",width = "80%",click = "plot_click2"),
           
        verbatimTextOutput("info2"), 
        hr(),
        
          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            )        
         ),

      tabPanel("Mean and SD Plot", p(br()), 

        plotOutput("meanp2", width = "80%")),

    tabPanel("Distribution Plots", p(br()),
HTML(
"<b> Explanations </b>
<ul> 
<li> Normal Q&#8211;Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
<li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
<li> Density Plot: to estimate the probability density function of the data
</ul>"
),
        p(tags$b("Normal Q-Q plot")),
        plotOutput("makeplot2", width = "80%"),
        plotOutput("makeplot2.2", width = "80%"),
        p(tags$b("Histogram")),
        plotOutput("makeplot2.3", width = "80%"),
        sliderInput("bin2","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
        p(tags$b("Density plot")),
        plotOutput("makeplot2.4", width = "80%")

         )

      ),

    hr(),
    h4(tags$b("Output 2. Test Result 1")),

    tags$b("Check the equivalence of 2 variances"),

    DT::DTOutput("var.test"),

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P value < 0.05, then refer to the <b>Welch Two-Sample t-test</b>
    <li> P Value >= 0.05, then refer to <b>Two-Sample t-test</b>
    </ul>"
  ),


    p(tags$i("In this example, P value of F test was about 0.11 (>0.05), we should refer to the results from 'Two-Sample t-test'")),

    hr(),
    h4(tags$b("Output 3. Test Result 2")),

    tags$b("Decide the T Test"),

    DT::DTOutput("t.test2"),
    p(br()), 

      HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population means of the Group 1 IS significantly different from Group 2. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences between Group 1 and Group 2. (Accept null hypothesis) 
    </ul>"
  ),

    p(tags$i("In this example, we concluded that the age of lymph node positive population with ER positive was not significantly different from ER negative (P=0.24, from 'Two-Sample t-test')"))
    
    )
  ),
hr()

),


##########----------##########----------##########
tabPanel("Paired Samples",

headerPanel("Dependent T-Test for Paired Samples"),

HTML("    
<b>In paired case, we compare the differences of 2 groups to zero. Thus, it becomes a one-sample test problem.</b>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the difference of the paired 2 samples are equal to 0
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, mean-sd plot, QQ-plot, distribution histogram, and density distribution plot about your data to determine if your data is close to normal distribution 

</ul>


<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 separate groups/sets (or 2 numeric vectors)
<li> Two samples that have been matched or paired 
<li> The differences of paired samples are approximately normally distributed                           
</ul>    

<h4><b> 3. Examples for Matched or Paired Data </b></h4>
<ul>
<li>  One person's pre-test and post-test scores 
<li>  When there are two samples that have been matched or paired
</ul>  


<i><h4>Case Example</h4>
Suppose we collected the wanted to know whether a certain drug had effect on people's sleeping hour. We got 10 people and collected the sleeping hour data before and after taking the drug. 
This was a paired case. We wanted to know whether the sleeping hours before and after the drug would be significantly different; or, whether the difference before and after were significantly different from 0</i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>

"
),

hr(),

#source("p3_ui.R", local=TRUE)$value,
#****************************************************************************************************************************************************3.tp

sidebarLayout(

sidebarPanel(
        
  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your groups (Required)")),
    
    tags$textarea(id = "cn.p", rows = 3, "Before\nAfter\nAfter-Before"), p(br()),

    p(tags$b("2. Input data")),

  tabsetPanel(
          ##-------input data-------##
    tabPanel("Manual Input", p(br()),
        p(tags$i("Example here was the HOUR of sleep effected by a certain drug. Sleeping hours before and after taking the drug were recorded")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab /Space"),
          p(tags$b("Before")),
            tags$textarea(id = "x1.p",rows = 10,
              "0.6\n3\n4.7\n5.5\n6.2\n3.2\n2.5\n2.8\n1.1\n2.9"
              ),
           p(tags$b("After")),
            tags$textarea(id = "x2.p",rows = 10,
              "1.3\n1.4\n4.5\n4.3\n6.1\n6.6\n6.2\n3.6\n1.1\n4.9"
              ),
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

),

          ##-------csv file-------##
    tabPanel("Upload Data", p(br()),
    p(tags$b("This only reads the 2 columns from your data file")),
    fileInput('file.p', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

        p(tags$b("2. Show 1st row as header?")),
        checkboxInput("header.p", "Show Data Header?", TRUE),
        p(tags$b("3. Use 1st column as row names? (No duplicates)")),
        checkboxInput("col.p", "Yes", TRUE),
             # Input: Select separator ----
        radioButtons("sep.p", 
          "Which Separator for Data?",
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

        tags$b("Null hypothesis"),
        HTML("<p> &#916 = 0: Group 1 (Before) and Group 2 (After) have equal effect </p>"),
        
        radioButtons(
          "alt.pt",
          label = "Alternative hypothesis",
          choiceNames = list(
            HTML("&#916 &#8800 0: Group 1 (Before) and Group 2 (After) have unequal effect"),
            HTML("&#916 < 0: Group 2 (After) is worse than Group 1 (Before)"),
            HTML("&#916 > 0: Group 2 (After) is better than Group 1 (Before)")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),
       p(tags$i("In this default settings, we wanted to know if the drug has effect. 
        Or, if sleep HOUR changed after they take the drug. "))

        ),

      mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

        tabsetPanel(

    tabPanel("Data Preview", p(br()),

      DT::DTOutput("table.p")),

    tabPanel("Basic Descriptives", p(br()),

      tags$b("Basic Descriptives of the Difference"),
            
              DT::DTOutput("bas.p")
            ),

      tabPanel("Boxplot of the difference", p(br()), 
        
       plotOutput("bp.p",width = "80%",click = "plot_click3"),
          
       verbatimTextOutput("info3"), hr(),
            
          HTML(
          "<b> Explanations </b>
          <ul>
            <li> The band inside the box is the median
            <li> The box measures the difference between 75th and 25th percentiles
            <li> Outliers will be in red, if existing
          </ul>"
            )        
         ),

          tabPanel("Mean and SD Plot", p(br()), 

            plotOutput("meanp.p", width = "80%")),

    tabPanel("Distribution Plots", p(br()),

            HTML(
          "<b> Explanations </b>
          <ul> 
            <li> Normal Q&#8211;Q Plot: to compare randomly generated, independent standard normal data on the vertical axis to a standard normal population on the horizontal axis. The linearity of the points suggests that the data are normally distributed.
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the difference
          </ul>"
            ),
            p(tags$b("Normal Q-Q plot")),
            plotOutput("makeplot.p", width = "80%"),
            p(tags$b("Histogram")),
            plotOutput("makeplot.p2", width = "80%"),
            sliderInput("bin.p","The width of bins in histogram",min = 0.01,max = 5,value = 0.2),
            p(tags$b("Density plot")),
            plotOutput("makeplot.p3", width = "80%")
            
            )
          ),

          hr(),
    h4(tags$b("Output 2. Test Results")),p(br()), 
          DT::DTOutput("t.test.p"),p(br()), 

            HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Group 1 (Before) and Group 2 (After) have significantly unequal effect. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant difference between 2 groups. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we concluded that the drug has no significant effect on the sleep hour. (P=0.2)"))
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
#****************************************************************************************************************************************************1.t1
names1 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1])
  })


X <- reactive({

  inFile <- input$file
  if (is.null(inFile)) {
    x <- as.numeric(unlist(strsplit(input$x, "[,;\n\t]")))
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )
    x <- as.data.frame(x)
    colnames(x) <- names1()

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
  return(x)
  })

output$table <- DT::renderDT({X()}, 
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc <- reactive({
  x <- X()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas <- DT::renderDT({basic_desc()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$download0 <- downloadHandler(
#    filename = function() {
#      "basic_desc.csv"
#    },
#    content = function(file) {
#      write.csv(basic_desc(), file, row.names = TRUE)
#    }
#  )

# box plot
output$bp = renderPlot({
  x = X()
  ggplot(x, aes(x = 0, y = x[,1])) + geom_boxplot(width = 0.2, outlier.colour = "red") + xlim(-1,1) + ylab("") + xlab(names(x)) + ggtitle("") + theme_minimal()
  })

output$info1 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("Click to get value: ", round(e$y, 4))
  }
  paste0("Y-axis position", "\n", xy_str(input$plot_click1))
})

output$meanp = renderPlot({
  x = X()
  des = data.frame(psych::describe(x))
  rownames(des) = names(x)
  ggplot(des, aes(x = rownames(des), y = mean)) + 
  geom_bar(position = position_dodge(),stat = "identity",width = 0.2, alpha = .3) +
  geom_errorbar(width = .1,position = position_dodge(.9),aes(ymin = mean - des$sd, ymax = mean + des$sd),data = des) + 
  xlab("") + ylab(expression(Mean %+-% SD)) + 
  theme_minimal() + theme(legend.title = element_blank())
  })

output$makeplot1 <- renderPlot({
  x = X()
  ggplot(x, aes(sample = x[,1])) + stat_qq() + ggtitle("") + xlab("") + theme_minimal()  ## add line, 
  })
output$makeplot1.2 <- renderPlot({
  x = X()
  ggplot(x, aes(x = x[,1])) + geom_histogram(colour = "black", fill = "grey", binwidth = input$bin, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank()) 
  })
output$makeplot1.3 <- renderPlot({
  x = X()
  ggplot(x, aes(x = x[,1])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title =element_blank())
  })

t.test0 <- reactive({
  x <- X()
  res <-t.test(
    x[,1],
    mu = input$mu,
    alternative = input$alt)
  res.table <- t(
    data.frame(
      T = round(res$statistic, digits=6),
      P = res$p.value,
      E.M = round(res$estimate, digits=6),
      CI = paste0("(",round(res$conf.int[1], digits = 6),", ",round(res$conf.int[2], digits = 6),")"),
      DF = res$parameter
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("T Statistic", "P Value","Estimated Mean","95% Confidence Interval","Degree of Freedom")

  return(res.table)
  })

output$t.test <- DT::renderDT({t.test0()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#source("p2_server.R", local=TRUE)$value
#****************************************************************************************************************************************************2.t2

names2 <- reactive({
  x <- unlist(strsplit(input$cn2, "[\n]"))[1:2]
  return(x)
  })

Y <- reactive({
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

output$table2 <-DT::renderDT(Y(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc2 <- reactive({
  x <- Y()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas2 <- DT::renderDT({
basic_desc2()
},
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$bp2 = renderPlot({
  x = Y()
  mx = melt(x, idvar = names(x))
  ggplot(mx, aes(x = mx[,"variable"], y = mx[,"value"], fill = mx[,"variable"])) + 
  geom_boxplot(width = 0.4,outlier.colour = "red",alpha = .3) + 
  ylab(" ") + xlab(" ") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
  })

output$meanp2 = renderPlot({
  x = Y()
  des = data.frame(psych::describe(x))
  rownames(des) = names(x)
  ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
    xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(), stat = "identity", width = 0.2, alpha = .3) + 
    geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - des$sd, ymax = mean + des$sd), data = des) + 
    theme_minimal() + theme(legend.title = element_blank())
  })


output$makeplot2 <- renderPlot({
  x <- Y()
  mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  # normal qq plot
  ggplot(x, aes(sample = x[, 1])) + stat_qq(color = "brown1") + ggtitle(paste0("Normal Q-Q Plot of ", colnames(x[1]))) + theme_minimal()
  })
output$makeplot2.2 <- renderPlot({
  x <- Y()
  mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  # normal qq plot
  ggplot(x, aes(sample = x[, 2])) + stat_qq(color = "forestgreen") + ggtitle(paste0("Normal Q-Q Plot of ", colnames(x[2]))) + theme_minimal()

  })
output$makeplot2.3 <- renderPlot({
  x <- Y()
  mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  ggplot(mx, aes(x = mx[,"value"], colour = mx[,"variable"], fill = mx[,"variable"])) + 
    geom_histogram(binwidth = input$bin2, alpha = .3, position = "identity") + 
    ggtitle("Histogram") + xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })
output$makeplot2.4 <- renderPlot({
  x <- Y()
  mx <- melt(x, idvar = names(x))  ###bug: using as id variables
  ggplot(mx, aes(x = mx[,"value"], colour = mx[,"variable"])) + geom_density() + 
    ggtitle("Density Plot") + xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })


output$info2 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("Click to get value: ", round(e$y, 4))
    }
  paste0("Y-axis position", "\n", xy_str(input$plot_click2))
  })

  # test result

var.test0 <- reactive({
  x <- Y()
  res <- var.test(as.vector(x[, 1]), as.vector(x[, 2]),alternative=input$alt.t22)
  res.table <- t(
    data.frame(
      F = res$statistic,
      P = res$p.value,
      CI = paste0("(", round(res$conf.int[1], digits = 6), ", ", round(res$conf.int[2], digits = 6),")"),
      EVR = res$estimate
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("F Statistic", "P Value", "95% Confidence Interval", "Estimated Ratio of Variances (Var1/Var2)")
  return(res.table)
  })

output$var.test <- DT::renderDT({
  var.test0() }, 

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

t.test20 <- reactive({
  x <- Y()
  res <- t.test(
    as.vector(x[, 1]),
    as.vector(x[, 2]),
    alternative = input$alt.t2,
    var.equal = TRUE
    )

res.table <- t(
  data.frame(
    T = res$statistic,
    P = res$p.value,
    EMX = res$estimate[1],
    EMY = res$estimate[2],
    EMD = res$estimate[1] - res$estimate[2],
    CI = paste0("(",round(res$conf.int[1], digits = 6),", ", round(res$conf.int[2], digits = 6), ")" ),
    DF = res$parameter
    )
  )
  res1 <- t.test(
    as.vector(x[, 1]),
    as.vector(x[, 2]),
    alternative = input$alt.t2,
    var.equal = FALSE
    )
  res1.table <- t(
    data.frame(
      T = res1$statistic,
      P = res1$p.value,
      EMX = res1$estimate[1],
      EMY = res1$estimate[2],
      EMD = res1$estimate[1] - res1$estimate[2],
      CI = paste0("(",round(res1$conf.int[1], digits = 6),", ",round(res1$conf.int[2], digits = 6),")"),
      DF = res1$parameter
      )
    )

  res2.table <- cbind(res.table, res1.table)
  colnames(res2.table) <- c(res$method, res1$method)
  rownames(res2.table) <- c("T Statistic", "P Value","Estimated Mean of Group 1","Estimated Mean of Group 2", "Estimated Mean Difference of 2 Groups" ,"95% Confidence Interval","Degree of Freedom")
  return(res2.table)
  })

output$t.test2 <- DT::renderDT({
  t.test20()},  

    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p3_server.R", local=TRUE)$value
#****************************************************************************************************************************************************3.tp

names.p <- reactive({
  x <- unlist(strsplit(input$cn.p, "[\n]"))
  return(x[1:3])
  })

Z <- reactive({
  # prepare dataset
  inFile <- input$file.p
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1.p, "[,;\n\t]")))
    Y <- as.numeric(unlist(strsplit(input$x2.p, "[,;\n\t]")))
    
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    validate( need(sum(!is.na(Y))>1, "Please input enough valid numeric data") )
    validate( need(length(X)==length(Y), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, Y = Y)
    x$diff <- round(x[, 2] - x[, 1], 4)
    colnames(x) = names.p()
    }
  else {
    if(!input$col.p){
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header.p, sep = input$sep.p, row.names=1)  
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    x$diff <- round(x[, 2] - x[, 1], 4)
    if(input$header.p==FALSE){
      colnames(x) = names.p()
      }
    }
    return(as.data.frame(x))
})
 

output$table.p <-DT::renderDT({Z()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basic_desc3 <- reactive({
  x <- Z()
  res <- as.data.frame(t(psych::describe(x))[-c(1,6,7), ])
  colnames(res) = names(x)
  rownames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$bas.p <- DT::renderDT({
  basic_desc3()
  }, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



#output$download5 <- downloadHandler(
#    filename = function() {
#      "basic_desc.csv"
#    },
#    content = function(file) {
#      write.csv(basic_desc3(), file, row.names = TRUE)
#    }
#  )

output$bp.p = renderPlot({
  x = Z()
  ggplot(x, aes(x = 0, y = x[, 3])) + geom_boxplot(width = 0.2, outlier.colour = "red") + xlim(-1,1) +
  ylab("") + xlab("") + ggtitle("") + theme_minimal()
  })

output$meanp.p = renderPlot({
  x = Z()[,3]
  des = data.frame(psych::describe(x))
  rownames(des) = names(x)
  ggplot(des, aes(x = rownames(des), y = mean, fill = rownames(des))) + 
    xlab("") + ylab(expression(Mean %+-% SD)) + geom_bar(position = position_dodge(), stat = "identity", width = 0.2, alpha = .3) + 
    geom_errorbar(width = .1, position = position_dodge(.9), aes(ymin = mean - des$sd, ymax = mean + des$sd), data = des) + 
    theme_minimal() + theme(legend.title = element_blank())
  
  })

output$info3 <- renderText({
  xy_str = function(e) {
    if (is.null(e))
    return("NULL\n")
    paste0("Click to get value: ", round(e$y, 4))
  }
  paste0("Y-axis position ", "\n", xy_str(input$plot_click3))
  })

output$makeplot.p <- renderPlot({
  x <- Z()
  ggplot(x, aes(sample = x[, 3])) + stat_qq() + ggtitle("Normal Q-Q Plot of the Mean Differences") + xlab("") + theme_minimal()  ## add line,
  })
output$makeplot.p2 <- renderPlot({
  x <- Z()
  ggplot(x, aes(x = x[, 3])) + geom_histogram(colour = "black",fill = "grey", binwidth = input$bin.p, position = "identity") + xlab("") + ggtitle("") + theme_minimal() + theme(legend.title =element_blank())
  })
output$makeplot.p3 <- renderPlot({
  x <- Z()
  ggplot(x, aes(x = x[, 3])) + geom_density() + ggtitle("") + xlab("") + theme_minimal() + theme(legend.title = element_blank())
  })

t.test.p0 <- reactive({
  x <- Z()
  res <-t.test(
    x[, 1],
    x[, 2],
    data = x,
    paired = TRUE,
    alternative = input$alt.pt
  )

  res.table <- t(
    data.frame(
      T = res$statistic,
      P = res$p.value,
      EMD = res$estimate,
      CI = paste0("(",round(res$conf.int[1], digits = 6),", ",round(res$conf.int[2], digits = 6),")"),
      DF = res$parameter
      )
    )
  colnames(res.table) <- res$method
  rownames(res.table) <- c("T Statistic", "P Value", "Estimated Mean Difference of 2 Groups" ,"95% Confidence Interval","Degree of Freedom")
  return(res.table)

  })
output$t.test.p <- DT::renderDT({
  t.test.p0()}, 
    extensions = 'Buttons', 
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })
}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}