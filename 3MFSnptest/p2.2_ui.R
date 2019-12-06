##----------#----------#----------#----------
##
## 3MFSnptest UI
##
##    >Panel 2
##
## Language: EN
## 
## DT: 2019-01-10
##
##----------#----------#----------#----------
##---------- Wilcoxon Rank-Sum Test ----------
sidebarLayout(

##########----------##########----------##########

sidebarPanel(

h4(tags$b("1. Hypotheses")),
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

