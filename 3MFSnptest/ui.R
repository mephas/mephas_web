##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
#source("p1_ui.R", local=TRUE,encoding = "UTF-8")
#source("p2_ui.R", local=TRUE,encoding = "UTF-8")
#source("p3_ui.R", local=TRUE,encoding = "UTF-8")

shinyUI(

tagList( 
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(

title = "Non-Parametric Test for Median",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Sign Test or Wilcoxon Signed-Rank Test"),

HTML(
    "
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the median of the population from which your data is drawn statistically significantly different from the specified median
      <li> To determine the distribution of you data is symmetric about the specified median
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain only 1 group of values (or 1 vector)
      <li> Your data are meaningful to measure the distance from the specified median
      <li> The values are independent observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
      <li> You have a specified median
    </ul> 

    <h4><b> 3. Two choices of tests </b></h4>

    <ul>
      <li> <b>Sign Test:</b> lack some the statistical power 
      <li> <b>Wilcoxon Signed-Rank Test:</b> alternative to one-sample t-test, when the data cannot be assumed to be normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

hr(),
##---------- 1.1 ----------

#source("p1.1_ui.R", local=TRUE)$value,
sidebarLayout(  

##########----------##########----------##########
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual Input", p(br()),
    
    p(tags$b("Please follow the example to input your data in the box")),

    p(tags$i("Example here is the Depression Rating Scale factor measurements of 9 patients from a certain group of patients. Scale > 1 indicates Depression.")),


    tags$textarea(id="a", 
      rows=10, 
      "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"
      ),
    
    p("Missing value is input as NA"),

    p(tags$b("You can change the name of your data (No space)")),

    tags$textarea(id="cn", rows= 1, "X")
    ),

    tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        fileInput('file', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep", 
          "Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a("Find some example data here",
          href = "https://github.com/mephas/datasets")

      )
    ),

  hr(),
  h4(tags$b("Step 2. Choose Parameter")),
  numericInput("med", HTML("Specify the median (m&#8320) that you want to compare with your data"), 1),
  p(tags$i("In this default settings, we want to know if the group of patients are suffering from depression (m > 1)."))

  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),  

      dataTableOutput("table")),

    tabPanel("Basic Descriptives", p(br()), 
        tableOutput("bas"), 
        
        HTML(
          "Notes:
          <ul>
            <li> If Skew.2SE > 1, then skewness is significantly different than zero
            <li> If Kurt.2SE > 1, then kurtosis is significantly different than zero
            <li> Normtest.W: the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p: p value the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p < 0.05, then data significantly different from normality
          </ul>"
          ),
        p(br()), 
      downloadButton("download1b", "Download Results")),

    tabPanel("Box-Plot", p(br()), 

        plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),

        verbatimTextOutput("info"), hr(),

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

      plotOutput("makeplot", width = "800px", height = "400px"),
      sliderInput("bin", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )
      )
    )
  )
),
hr(),

h4(tags$b("Step 3. Choose Methods and Hypotheses")),

##---------- 1.2 ----------
##---------- Sign Test ----------

##---------- 1.3 ----------
#source("p1.3_ui.R", local=TRUE)$value,
sidebarLayout(

##########----------##########----------##########
sidebarPanel(
h4(tags$b("Choice 1. Wilcoxon Signed-Rank Test")), hr(),

h4(tags$b("1. Hypotheses")),
p(tags$b("Null hypothesis")),

HTML("<p> m = m&#8320: the population median is equal to the specified median( m&#8320) </p>
  <p>Or, the distribution of the data set is symmetric about the specified median</p>"),

radioButtons("alt.wsr", 
  label = "Alternative hypothesis", 
  choiceNames = list(  
  HTML("m > m&#8320: the population median of is greater than the specified median"),
  HTML("m < m&#8320: the population median of is less than the specified median"),
  HTML("m &#8800 m&#8320: the population median of is significantly different from the specified median")
  ),
choiceValues = list("greater", "less", "two.sided")),

h4(tags$b("2. Whether to do Normal Approximation")),
radioButtons("nap.wsr", 
  label = "How large is your sample size", 
  choiceNames = list(
    HTML("Sample size is not large (<10), I want exact P Value. No need to do Normal Approximation"),
    HTML("Sample size is moderate large (>10), then do Normal Approximation")), 
  choiceValues = list(FALSE, TRUE)),
p("Note: Normal Approximation is to apply continuity correction for the p-value and confidence interval.")
),

  mainPanel(
    h4(tags$b("Output 2.1. Test Results")),p(br()), 
    h4('Results of Wilcoxon Signed-Rank Test'), p(br()), 
    tableOutput("ws.test"), p(br()), 

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population median IS significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population median IS NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we can conclude that the scales is significantly greater than 1 (P=0.006), which indicates the patients are suffering from depression.")),


    downloadButton("download1.2", "Download Results")
  )
##########----------##########----------##########
),




hr(),

#source("p1.2_ui.R", local=TRUE)$value,
sidebarLayout(

##########----------##########----------##########
sidebarPanel(

h4(tags$b("Choice 2. Sign Test")), hr(),

h4(tags$b("Hypotheses")),
p(tags$b("Null hypothesis")),

HTML("<p> m = m&#8320: the population median (m) is equal to the specified median ( m&#8320)</p>"),

radioButtons("alt.st", label = "Alternative hypothesis", 
  choiceNames = list(
  HTML("m > m&#8320: the population median is greater than the specified median"),
  HTML("m < m&#8320: the population median is less than the specified median"),
  HTML("m &#8800 m&#8320: the population median is significantly different from the specified median")
  
  ),
choiceValues = list("greater", "less", "two.sided")),
),

  mainPanel(
    h4(tags$b("Output 2.2. Test Results")),p(br()), 
    h4('Results of Sign Test'), p(br()), 
    tableOutput("sign.test"),p(br()), 
    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population median IS significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population median IS NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we can conclude that the scales is significantly greater than 1 (P=0.02), which indicates the patients are suffering from depression.")),

    downloadButton("download1.1", "Download Results")
    )  
##########----------##########----------##########
)


),

##---------- Panel 2 ----------

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test or Mood's Median Test"),

HTML(
    "
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the medians of two population from which your 2 groups data drawn are statistically significantly different from each other
      <li> To determine if the distributions of 2 groups of data differ in locations
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain only 2 group of values (or 2 vectors) 
      <li> Your data are meaningful to measure the distance between 2 groups values
      <li> The values are independent observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
    </ul> 

    <h4><b> 3. Two choices of tests </b></h4>

    <ul>
      <li> <b>Wilcoxon Rank-Sum Test / Mann-Whitney U Test / Mann-Whitney-Wilcoxon Test / Wilcoxon-Mann-Whitney Test:</b> alternative to two-sample t-test, when the data cannot be assumed to be normally distributed
      <li> <b>Mood's Median Test:</b> a special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. 
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

hr(),

##---------- 2.1 ----------
#source("p2.1_ui.R", local=TRUE)$value,
sidebarLayout(  

##########----------##########----------##########

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual input", p(br()),

    p(tags$b("Please follow the example to input your data in the box")),

    p(tags$i("Example here is the Depression Rating Scale factor measurements of 19 patients from a two group of patients.")),

    tags$textarea(id="x1", 
    rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30\nNA"    
    ),  ## disable on chrome
    tags$textarea(id="x2", 
      rows=10, 
      "0.80\n0.83\n1.89\n1.04\n1.45\n1.38\n1.91\n1.64\n0.73\n1.46"
      ),
    
    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error"),

    p(tags$b("You can change the name of your data (No space)")),

    tags$textarea(id="cn2", rows=2, "Group1\nGroup2")),

    p(tags$i("In this default settings, we want to know if Depression Rating Scale from two group of patients are different.")),


  ##-------csv file-------##   
tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        fileInput('file2', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header2", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep2", 
          "Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a("Find some example data here",
          href = "https://github.com/mephas/datasets")
        )
        )
),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),

      dataTableOutput("table2")),

    tabPanel("Basic Descriptives", p(br()), 

        tableOutput("bas2"), 

      HTML(
          "Notes:
          <ul>
            <li> If Skew.2SE > 1, then skewness is significantly different than zero
            <li> If Kurt.2SE > 1, then kurtosis is significantly different than zero
            <li> Normtest.W: the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p: p value the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p < 0.05, then data significantly different from normality
          </ul>"
          ),

      p(br()), 
        downloadButton("download2b", "Download Results") ),

    tabPanel("Box-Plot", p(br()), 
        plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),

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

      plotOutput("makeplot2", width = "800px", height = "400px"),
      sliderInput("bin2", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
      HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>")
      )
    )) 
),
hr(),

h4(tags$b("Step 2. Choose Methods and Hypotheses")),
##---------- 2.2 ----------

#source("p2.2_ui.R", local=TRUE)$value,
sidebarLayout(

##########----------##########----------##########

sidebarPanel(

h4(tags$b("Choice 1. Wilcoxon Rank-Sum Test, Mann-Whitney U Test, Mann-Whitney-Wilcoxon Test, Wilcoxon-Mann-Whitney Test")),
hr(),

h4(tags$b("Hypotheses")),
p(tags$b("Null hypothesis")),

HTML("<p> m&#8321 = m&#8322: the medians of two group are equal </p>
  <p> Or, the distribution of values for each group are equal </p>"),

radioButtons("alt.mwt", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of Group 2 is greater"),
    HTML("m&#8321 > m&#8322: the population median of Group 1 is greater")),
  choiceValues = list("two.sided", "less", "greater")),

p(tags$b("2. Whether to do Normal Approximation")),
radioButtons("nap.mwt", label = "How large is your sample size", 
  choiceNames = list(
    HTML("Sample size is not large (<10), I want exact P Value. No need to do Normal Approximation"),
    HTML("Sample size is moderate large (>10), then do Normal Approximation")), 
  choiceValues = list(FALSE, TRUE)),
p("Note: Normal Approximation is to apply continuity correction for the p-value and confidence interval.")
),

mainPanel(
  h4(tags$b("Output 2.1. Test Results")),p(br()), 
  h4('Results of Wilcoxon Rank-Sum Test'), p(br()), 

  tableOutput("mwu.test"), p(br()),

  HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population medians of 2 groups are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, no significant differences between the medians of 2 groups. (Accept null hypothesis)
    </ul>"
  ),

    p(tags$i("From the default settings, we can conclude that there is no significant differences in 2 groups Rating scale (P=0.44).")),


  downloadButton("download2.1", "Download Results")
  )

)

,
hr(),
##---------- 2.3 ----------
#source("p2.3_ui.R", local=TRUE)$value,
sidebarLayout(

sidebarPanel(
h4(tags$b("Choice 2. Mood's Median Test")),
hr(),
h4(tags$b("Hypotheses")),
p(tags$b("Null hypothesis")),

HTML("m&#8321 = m&#8322, the medians of values for each group are equal"),

radioButtons("alt.md", label = "Alternative hypothesis", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(
  h4(tags$b("Output 2.2. Test Results")),p(br()), 

  h4("Results of Mood's Median Test"), p(br()),

  tableOutput("mood.test"),p(br()),

    HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population medians of 2 groups are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, no significant differences between the medians of 2 groups. (Accept null hypothesis)
    </ul>"
  ),
  p(tags$i("From the default settings, we can conclude that there is no significant differences in 2 groups Rating scale (P=0.18).")),


  ) 

)

),

##---------- Panel 3 ----------

tabPanel("Paired Samples",    

headerPanel("Sign Test or Wilcoxon Signed-Rank Test"),

HTML(
    "
    <h4><b> 1. Goals </b></h4>
    <ul>
      <li> To determine if the difference of paired data is statistically significantly different from 0
    </ul>

    <h4><b> 2. About your data </b></h4>

    <ul>
      <li> Your data contain 2 group of values (or 2 vectors)
      <li> Your data are meaningful to measure the distance from the specified median
      <li> The values are paired or matched observations
      <li> No assumption on the distributional shape of your data
      <li> Your data may be not normally distributed
    </ul> 

    <h4><b> 3. Examples for Matched or Paired Data </b></h4>
      <ul>
       <li>  One person's pre-test and post-test scores 
       <li>  When there are two samples that have been matched or paired
      </ul>  

     <b>In paired case, we compare the differences of 2 groups to zero. Thus, it becomes a one-sample test problem.</b>

    <h4><b> 4. Two choices of tests </b></h4>

    <ul>
      <li> <b>Sign Test:</b> lack some the statistical power 
      <li> <b>Wilcoxon Signed-Rank Test:</b> alternative to one-sample t-test, when the data cannot be assumed to be normally distributed
    </ul> 

    <h4> If all applicable, please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    "
    ),

#source("p3.1_ui.R", local=TRUE)$value,
sidebarLayout(  

##########----------##########----------##########

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("Manual Input", p(br()),
    p(tags$b("Please follow the example to input your data in the box")),

    p(tags$i("Example here is the Depression Rating Scale factor measurements of 9 patients Before and After treatment. ")),

    tags$textarea(id="y1", 
      rows=10, 
    "1.83\n0.50\n1.62\n2.48\n1.68\n1.88\n1.55\n3.06\n1.30"    
    ),
    tags$textarea(id="y2", 
      rows=10, 
      "0.878\n0.647\n0.598\n2.050\n1.060\n1.290\n1.060\n3.140\n1.290"
      ),

    p("Missing value is input as NA"),

    p(tags$b("You can change the name of your data (No space)")),

    tags$textarea(id="cn3", rows=2, "Before\nAfter\nAfter-Before")),

  ##-------csv file-------##   
  tabPanel("Upload Data", p(br()),

        ##-------csv file-------##
        fileInput('file3', "Choose CSV/TXT file",
                  accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
        #helpText("The columns of X are not suggested greater than 500"),
        # Input: Checkbox if file has header ----
        checkboxInput("header3", "Show Data Header?", TRUE),

             # Input: Select separator ----
        radioButtons("sep3", 
          "Which Separator for Data?",
          choiceNames = list(
            HTML("Comma (,): CSV often use this"),
            HTML("One Tab (->|): TXT often use this"),
            HTML("Semicolon (;)"),
            HTML("One Space (_)")
            ),
          choiceValues = list(",", ";", " ", "\t")
          ),

        p("Correct Separator ensures data input successfully"),

        a("Find some example data here",
          href = "https://github.com/mephas/datasets")

      )
    )
  ),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

  tabsetPanel(

    tabPanel("Data Preview", p(br()),  

      dataTableOutput("table3")),

    tabPanel("Basic Descriptives", p(br()), 

      tags$b("Basic Descriptives of the Difference"),



        tableOutput("bas3"), 
        HTML(
          "Notes:
          <ul>
            <li> If Skew.2SE > 1, then skewness is significantly different than zero
            <li> If Kurt.2SE > 1, then kurtosis is significantly different than zero
            <li> Normtest.W: the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p: p value the statistic of a Shapiro-Wilk test of normality
            <li> Normtest.p < 0.05, then data significantly different from normality
          </ul>"
          ),

        p(br()),
  downloadButton("download3b", "Download Results")  ),

    tabPanel("Box-Plot of the Difference", p(br()),   

        plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),

        verbatimTextOutput("info3"), hr(),

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

      plotOutput("makeplot3", width = "800px", height = "400px"),
      sliderInput("bin3", "The width of bins in histogram", min = 0.01, max = 5, value = 0.2),
            HTML(
          "Notes:
          <ul> 
            <li> Histogram: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values
            <li> Density Plot: to estimate the probability density function of the data
          </ul>"
            )
      )
    ))  

)
,
hr(),
##---------- 3.1 ----------
h4(tags$b("Step 2. Choose Methods and Hypotheses")),

#source("p3.3_ui.R", local=TRUE)$value,
sidebarLayout(

##########----------##########----------##########

  sidebarPanel(

  h4(tags$b("Choice 1. Wilcoxon Signed-Rank Test")),
  hr(),

  h4(tags$b("1. Hypotheses")),
  p(tags$b("Null hypothesis")),
  HTML("<p>  m = 0: the difference of medians between X and Y is not zero </p> 
        <p>  Or, the distribution of the differences in paired values is symmetric around zero</p> "),

  radioButtons("alt.pwsr", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is not symmetric around zero"),
      HTML("m < 0: the population median of Y is greater"),
      HTML("m > 0: the population median of X is greater")),
    choiceValues = list("two.sided", "less", "greater")),

h4(tags$b("2. Whether to do Normal Approximation")),
radioButtons("nap", 
  label = "How large is your sample size", 
  choiceNames = list(
    HTML("Sample size is not large (<10), I want exact P Value. No need to do Normal Approximation"),
    HTML("Sample size is moderate large (>10), then do Normal Approximation")), 
  choiceValues = list(FALSE, TRUE)),
p("Note: Normal Approximation is to apply continuity correction for the p-value and confidence interval.")
),

  mainPanel(
    h4(tags$b("Output 2.1. Test Results")),p(br()), 
    h4('Results of Wilcoxon Signed-Rank Test'), 
    tableOutput("psr.test"), 
      HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the Before and After are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the Before and After are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),
  p(tags$i("From the default settings, we can conclude no significant difference is found after the treatment. (P=0.46)")),

  downloadButton("download3.2", "Download Results")
    ) 

##########----------##########----------##########

  )
,
hr(),
##---------- 3.2 ----------
#source("p3.2_ui.R", local=TRUE)$value,
sidebarLayout(

##########----------##########----------##########

sidebarPanel(
h4(tags$b("Choice 2. Sign Test")),
hr(),

h4(tags$b("Hypotheses")),
p(tags$b("Null hypothesis")),
HTML("<p> m = 0: the difference median between 2 groups (Before and After) is equal to 0 </p>"),

  radioButtons("alt.ps", label = "Alternative hypothesis", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between 2 groups (Before and After) is not zero"),
      HTML("m < 0: the population median of Before is greater"),
      HTML("m > 0: the population median of After is greater")),
      choiceValues = list("two.sided", "less", "greater")) 
  ),

mainPanel(
  h4(tags$b("Output 2.2. Test Results")),p(br()), 
  h4('Results of Sign Test'), p(br()),
  tableOutput("psign.test"), p(br()),
      HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the Before and After are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the Before and After are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

  p(tags$i("From the default settings, we can conclude no significant difference is found after the treatment. (P=0.49)")),

  downloadButton("download3.1", "Download Results")
          )

##########----------##########----------##########

)


),
##########----------##########----------##########
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/help3.R",local=TRUE, encoding="UTF-8")$value

  
))
)

