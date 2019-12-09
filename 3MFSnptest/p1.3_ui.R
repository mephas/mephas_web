##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 1
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

##---------- Wilcoxon Signed-Rank Test ----------

sidebarLayout(

##########----------##########----------##########
sidebarPanel(
h4(tags$b("Choice 1. Wilcoxon Signed-Rank Test")), hr(),

h4(tags$b("1. Choose Hypothesis")),
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

  p(tags$i("From the default settings, we concluded that the scales was significantly greater than 1 (P=0.006), which indicated the patients were suffering from depression.")),


    downloadButton("download1.2", "Download Results")
  )
##########----------##########----------##########
)



