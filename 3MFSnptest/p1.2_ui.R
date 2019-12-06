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

p(tags$b("Hypotheses")),
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
    h4(tags$b("Output 2.1. Test Results")),p(br()), 
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