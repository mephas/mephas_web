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
sidebarLayout(

sidebarPanel(
h4(tags$b("Choice 2. Mood's Median Test")),hr(),
h4(tags$b("1. Choose Hypothesis")),

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
  p(tags$i("From the default settings, we can conclude that there is no significant differences in 2 groups Rating scale (P=0.18)."))


  ) 

)
