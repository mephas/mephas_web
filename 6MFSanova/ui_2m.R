#****************************************************************************************************************************************************2.1. 2-2way

sidebarLayout(

sidebarPanel(

h4(tags$b("Multiple Comparison")), 

hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two groups have significant different means"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the metastasis-free follow-up time was different with grade of the tumor (three ordered levels)"))
  ),
hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("methodm2", 
  "Which method do you want to use? See explanations right", 
  choiceNames = list(
    #HTML("Bonferroni"),
    #HTML("Bonferroni-Holm: often used"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    #HTML("False Discovery Rate-BH"),
    #HTML("False Discovery Rate-BY"),
    HTML("Scheffe "),
    HTML("Tukey Honest Significant Difference")
    #HTML("Dunnett")
    ),
  choiceValues = list("SF", "TH")
  ),
        p(br()),
      actionButton("M2", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
      HTML(
  "<b> Explanations </b>

    <li> <b>Scheffe</b> procedure controls for the search over any possible contrast</li>
    <li> <b>Tukey Honest Significant Difference</b> is preferred if there are unequal group sizes among the experimental and control groups</li>
  "
    )


),

mainPanel(

  h4(tags$b("Output 2. Test Results")), p(br()),

  p(tags$b("Pairwise P Value Table under Each Factor")),
  DT::DTOutput("multiple.t2"),p(br()),

        HTML(
  "<b> Explanations </b>
  <ul> 
    <li> In the matrix, P < 0.05 indicates the statistical significant in the pairs</li>
    <li> In the matrix, P >= 0.05 indicates no statistically significant differences in the pairs</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, all the pairs, normal vs LV, SV vs LV, SV vs normal, and male vs female had significant differences on SBP."))#,
    )


 # downloadButton("download.m222", "Download Results")
  )
)