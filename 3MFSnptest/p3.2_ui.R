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
##---------- Sign Test ----------
sidebarLayout(

##########----------##########----------##########

sidebarPanel(
h4(tags$b("Choice 1. Sign Test")),
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
  h4(tags$b("Output 2.1. Test Results")),p(br()), 
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

