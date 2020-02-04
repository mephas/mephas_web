#****************************************************************************************************************************************************km

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#str {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmt {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmt1 {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmlr {overflow-y:scroll; max-height: 350px; background: white};")),

h4(tags$b("Choose group variable to build the model")),

p("Prepare the data in the Data tab"),
hr(),          

p(tags$b("1. Check survival object, Surv(time, event), in the Data Tab")), 

uiOutput('g'),
tags$i("In the example of Diabetes data, we chose 'laser' as a categorical group variable. 
  That is to explore if the survival curves in two laser groups were different. "),

hr(),

h4(tags$b("Log-rank Test")),      

p(tags$b("Null hypothesis")),
p("Two groups have identical hazard functions"),

radioButtons("rho", "Choose Log-rank Test Method", selected=1,
  choiceNames = list(
    HTML("1. Log-rank test"),
    HTML("2. Peto & Peto modification of the Gehan-Wilcoxon test")
    ),
  choiceValues = list(1, 2)
  ),
p("See method explanations in Output 2. Log-rank Test tab."),
hr(),

h4(tags$b("Pairwise Log-rank Test")),      

p(tags$b("Null hypothesis")),
p("Two groups have identical hazard functions"),

radioButtons("rho2", "1. Choose Log-rank Test Method)", selected=1,
  choiceNames = list(
    HTML("1. Log-rank test"),
    HTML("2. Peto & Peto modification of the Gehan-Wilcoxon test")
    ),
  choiceValues = list(1, 2)
  ),
radioButtons("pm", 
  "2. Choose a method to adjust P value", selected="BH",
  choiceNames = list(
    HTML("Bonferroni"),
    HTML("Bonferroni-Holm: often used"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    HTML("False Discovery Rate-BH"),
    HTML("False Discovery Rate-BY")
    ),
  choiceValues = list("B", "BH", "FDR", "BY")
  ),
p("See method explanations in Output 2. Pairwise Log-rank Test tab.")

#tags$style(type='text/css', '#km {background-color: rgba(0,0,255,0.10); color: blue;}'),
#verbatimTextOutput("km", placeholder = TRUE),

),

mainPanel(

h4(tags$b("Output 1. Data Preview")),
 tabsetPanel(
   tabPanel("Variables information",p(br()),
 verbatimTextOutput("str")
 
 ),
tabPanel("First Part of Data", br(),
p("Check full data in Data tab"),
 DT::DTOutput("Xdata2")
 )

 ),
 hr(),
 
# #h4(tags$b("Output 2. Model Results")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. Estimate and Test Results")),
p(br()),
tabsetPanel(
tabPanel("Kaplan-Meier Survival Probability",  p(br()),
  p(tags$b("Kaplan-Meier survival probability by group")),
    verbatimTextOutput("kmt")
     ),
tabPanel("Kaplan-Meier Plot by Group",  p(br()),
    radioButtons("fun2", "Which plot do you want to see?", 
  choiceNames = list(
    HTML("1. Survival Probability"),
    HTML("2. Cumulative Events"),
    HTML("3. Cumulative Hazard")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
    plotOutput("km.p", width = "80%"),
     verbatimTextOutput("kmt1")
     ),
tabPanel("Log-Rank Test",  p(br()),
       HTML("
<b> Explanations </b>
<p>This implements the G-rho family of Harrington and Fleming (1982), with weights on each death of S(t)<sup>rho</sup>, where S is the Kaplan-Meier estimate of survival.</p>
<ul>
<li>rho = 0: log-rank or Mantel-Haenszel test</li>
<li>rho = 1: Peto & Peto modification of the Gehan-Wilcoxon test.</li>
<li> p < 0.05 indicates the curves are significantly different in the survival probabilities</li>
<li> p >= 0.05 indicates the curves are NOT significantly different in the survival probabilities</li>

</ul>"),

p(tags$b("Log-rank Test Result")),
    verbatimTextOutput("kmlr")

     ),

tabPanel("Pairwise Log-Rank Test",  p(br()),


     HTML(
  "<b> Explanations </b>
  <p>This implements the G-rho family of Harrington and Fleming (1982), with weights on each death of S(t)<sup>rho</sup>, where S is the Kaplan-Meier estimate of survival.</p>
  <ul> 
    <li><b>rho = 0:</b> log-rank or Mantel-Haenszel test</li>
    <li><b>rho = 1:</b> Peto & Peto modification of the Gehan-Wilcoxon test.</li>
    <li> <b>Bonferroni</b> correction is a generic but very conservative approach</li>
    <li> <b>Bonferroni-Holm</b> is less conservative and uniformly more powerful than Bonferroni</li>
    <li> <b>False Discovery Rate-BH</b> is more powerful than the others, developed by Benjamini and Hochberg</li>
    <li> <b>False Discovery Rate-BY</b> is more powerful than the others, developed by Benjamini and Yekutieli</li>
    <li> p < 0.05 indicates the curves are significantly different in the survival probabilities</li>
    <li> p >= 0.05 indicates the curves are NOT significantly different in the survival probabilities</li>
  </ul>"
    ),
     p(tags$b("Pairwise Log-rank Test P Value Table")),

    DT::DTOutput("PLR")
     )
)

)
)