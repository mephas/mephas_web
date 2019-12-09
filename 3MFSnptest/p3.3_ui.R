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
sidebarLayout(

##########----------##########----------##########

  sidebarPanel(

  h4(tags$b("Choice 1. Wilcoxon Signed-Rank Test")),
  hr(),

  h4(tags$b("1. Choose Hypothesis")),
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
  p(tags$i("From the default settings, we concluded no significant difference is found after the treatment. (P=0.46)")),

  downloadButton("download3.2", "Download Results")
    ) 

##########----------##########----------##########

  )
