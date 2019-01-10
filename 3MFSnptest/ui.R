##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
source("p1_ui.R", local=TRUE)

shinyUI(

tagList( 

navbarPage(

title = "Non-parametric Test",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Sign Test, Wilcoxon Signed-Rank Test"),

HTML(" 

<p> Both can be used to test whether the median of a collection of numbers is significantly greater than or less than a specified value. </p>

<b> Assumptions </b>

  <ul>
  <li>Each observation is independent and comes from the same population
  <li>X could be continuous (i.e., interval or ratio) and ordinal
  </ul>

<b> Notations </b>

  <ul>
  <li> X is the randomly collected sample 
  <li> m is the population median of X, meaning the 50 percentile of the underlying distribution of the X 
  <li> m&#8320 is the specified value 
  </ul>

  "),
hr(),

L1,
hr(),
L2,
hr(),
L3


),

##---------- Panel 2 ----------

tabPanel("Two Independent Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann-Whitney U Test), Mood's Median Test"),

p("To determine whether a randomly selected sample will be less than or greater than a second randomly selected sample."),

tags$b("Assumptions"),
tags$ul(
  tags$li("All the observations from both groups are independent of each other, no paired or repeated data"),
  tags$li("X and Y could be continuous (i.e., interval or ratio) and ordinal (i.e., at least, of any two observations, which is the greater)"),
  tags$li("X and Y are similar in distribution's shape")),

tags$b("Notations"),
HTML("<ul>
      <li> X is the first randomly selected sample, while Y is the second</li>
      <li> m&#8321 is the population median of X, or the 50 percentile of the underlying distribution of X </li>  
      <li> m&#8322 is the population median of Y, or the 50 percentile of the underlying distribution of Y </li> 
      </ul>" ),

##---------- 2.1 ----------

sidebarLayout(
sidebarPanel(
##-------explanation-------##
h4(tags$b("Wilcoxon Rank-Sum Test")),
h4(tags$b("Mann-Whitney U Test")),
p(tags$b("Mann-Whitney-Wilcoxon Test")),
p(tags$b("Wilcoxon-Mann-Whitney Test")),

helpText("Not require the assumption of normal distributions; nearly as efficient as the t-test on normal distributions."),

tags$b("Supplementary Assumptions"),
tags$ul(
  tags$li("No outliers"),
  tags$li("If outliers exist, the test is used for testing distributions")),
helpText("Outliers will affect the spread of data"),

p(tags$b("No outliers"), "To determine if the distributions of the two groups are similar in shape and spread"),
p(tags$b("Outliers exist"), "To determine if the distributions of the two groups are different in shape and spread"),

helpText("Hypotheses"),
tags$b("Null hypothesis"),
HTML("<p> m&#8321 = m&#8322: the medians of each group are equal; the distribution of values for each group are equal </p>"),

radioButtons("alt.mwt", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal; there is systematic difference in the distribution of values for the groups"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater")),

helpText("Correction"),
radioButtons("nap.mwt", label = "Normal Approximation", 
  choices = list("Sample size is not large" = FALSE,
                 "Sample size is moderate large" = TRUE, 
                 "Small sample size" = TRUE), selected = FALSE)),

mainPanel(
  h3(tags$b("Results")), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff' denotes the estimated differences of medians
      <li> When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction' </li>  
      </ul>" ))
  )),

##---------- 2.2 ----------

sidebarLayout(
sidebarPanel(

h4(tags$b("Mood's Median Test")),
helpText("A special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. "),

helpText("Hypotheses"),
tags$b("Null hypothesis"),
HTML("m&#8321 = m&#8322, the medians of values for each group are equal"),

radioButtons("alt.md", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(h3(tags$b("Results")), tableOutput("mood.test") 
  ) ),

# data input
sidebarLayout(  
sidebarPanel(

helpText("Two ways to import your data"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manually input values", p(br()),
    helpText("Missing value is input NA"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("Change the names of two samples (optinal)"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("Upload .csv file", p(br()),
    fileInput('file2', 'Choose .csv File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', 'Header', TRUE), #p
    radioButtons('sep2', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("Data Display"), dataTableOutput("table2"),

hr(),
h4("Figure Configuration"), sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('Boxplot')), splitLayout(
    plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),
    wellPanel(verbatimTextOutput("info2"), hr(),
      helpText(HTML("Notes:
                    <ul> 
                    <li> Points are simulated and located randomly in the same horizontal line. </li>
                    <li> Outliers will be highlighted in red, if existing. </li>
                    <li> The red outlier may not cover the simulated point. </li>
                    <li> The red outlier only indicates the value in horizontal line.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('Histogram')), plotOutput("makeplot2", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('Descriptive statistics')), 
  splitLayout(tableOutput("bas2"), tableOutput("des2"), tableOutput("nor2")))  )),

##---------- Panel 3 ----------

tabPanel("Two Paired Samples",    

headerPanel("Sign Test & Wilcoxon Signed-Rank Test"),

p("Given pairs of observations (such as weight pre- and post-treatment) for each subject, both test determine if one of the pair (such as pre-treatment) tends to be greater than (or less than) the other pair (such as post-treatment)."),

tags$b("Assumptions"),
tags$ul(
  tags$li("The observations of (X, Y) are paired and come from the same population"),
  tags$li("X's and Y's could be continuous (i.e., interval or ratio) and ordinal"),
  tags$li("D's are independent and come from the same population")),

tags$b("Notations"),
tags$ul(
  tags$li("The paired observations are designated X and Y"),
  tags$li("D = X-Y, the differences between paired (X, Y)"),
  tags$li("m is the population median of D, or the 50 percentile of the underlying distribution of the D.")),

##---------- 3.1 ----------

sidebarLayout(

sidebarPanel(

  h4(tags$b("Sign Test")),
  helpText("It makes very few assumptions, and has very general applicability but may lack the statistical power of the alternative tests."),
  
  helpText("Hypotheses"),
  tags$b("Null hypothesis"),
  p("m = 0: the difference of medians between X and Y is zero; X and Y are equally effective"),

  radioButtons("alt.ps", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; X and Y are not equally effective"),
      HTML("m < 0: the population median of X is greater; X is more effective"),
      HTML("m > 0: the population median of Y is greater; Y is more effective")),
      choiceValues = list("two.sided", "less", "greater")) ),

mainPanel(h3(tags$b('Results')), tableOutput("psign.test"), 
          helpText("Notes: 'Estimated.d' denotes the estimated differences of medians")
          )),

##---------- 3.2 ----------

sidebarLayout(
  sidebarPanel(

  h4(tags$b("Wilcoxon Signed-Rank Test")),
  helpText("An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution."),
  
  tags$b("Supplementary Assumptions"),
  tags$ul(
    tags$li("The distribution of D's is symmetric."),
    tags$li("No ties in D's")),

  helpText("Ties means the same values"),

  helpText("Hypotheses"),
  tags$b("Null hypothesis"),
  p("m = 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is symmetric around zero."),

  radioButtons("alt.pwsr", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is not symmetric around zero"),
      HTML("m < 0: the population median of Y is greater"),
      HTML("m > 0: the population median of X is greater")),
    choiceValues = list("two.sided", "less", "greater")),

  helpText("Correction"),
  radioButtons("nap", label = "Normal Approximation", 
    choices = list("Sample size is not large" = FALSE,
                   "Sample size is moderate large" = TRUE,
                   "Small sample size" = TRUE), selected = FALSE),
  helpText("Normal approximation is applicable when n > 10.")),

  mainPanel(h3(tags$b('Results')), tableOutput("psr.test"), 
    helpText("When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction'")
    ) ),


sidebarLayout(  
sidebarPanel(

helpText("Two ways to import your data"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manually input values", p(br()),
    helpText("Missing value is input NA"),
    tags$textarea(id="y1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="y2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("Change the names of two samples (optional)"), tags$textarea(id="cn3", rows=2, "X\nY\n(X-Y)")),

  ##-------csv file-------##   
  tabPanel("Upload .csv file", p(br()),
    fileInput('file3', 'Choose .csv File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', 'Header', TRUE), #p
    radioButtons('sep3', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("Data Display"), dataTableOutput("table3"),

hr(),
h4("Figure Configuration"), sliderInput("bin3", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('Boxplot')), splitLayout(
    plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),
    wellPanel(verbatimTextOutput("info3"), hr(),
      helpText(HTML("Notes:
                    <ul> 
                    <li> Outliers will be highlighted in red, if existing. </li>
                    <li> The red outlier may not cover the simulated point. </li>
                    <li> The red outlier only indicates the value in horizontal line.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('Histogram')), plotOutput("makeplot3", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('Descriptive statistics')), 
  splitLayout(tableOutput("bas3"), tableOutput("des3"), tableOutput("nor3"))))

)
,
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value

  
))
)

