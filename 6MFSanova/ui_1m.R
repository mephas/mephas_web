#****************************************************************************************************************************************************1.1. 2-1way

sidebarLayout(

sidebarPanel(

h4(tags$b("Multiple Comparison")), 

hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("In one pair of factors, the means from each pair are equal"),
  p(tags$b("Alternative hypothesis")),
  p("In one pair of factors, the means from each pair are significantly different"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the FEF values were different in which pairs of the 6 smoking groups"))
  ),
hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("method", 
  "Which method do you want to use? See explanations right", selected="BH",
  choiceNames = list(
    HTML("Bonferroni"),
    HTML("Bonferroni-Holm: often used"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    HTML("False Discovery Rate-BH"),
    HTML("False Discovery Rate-BY"),
    HTML("Scheffe "),
    HTML("Tukey Honest Significant Difference"),
    HTML("Dunnett")
    ),
  choiceValues = list("B", "BH", "FDR", "BY", "SF", "TH", "DT")
  ),
  uiOutput("dt.ref"),
      p(br()),
      actionButton("M1", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
hr(),
      HTML(
  "<b> Explanations </b>
  
    <li> <b>Bonferroni</b> correction is a generic but very conservative approach</li>
    <li> <b>Bonferroni-Holm</b> is less conservative and uniformly more powerful than Bonferroni</li>
    <li> <b>False Discovery Rate-BH</b> is more powerful than the others, developed by Benjamini and Hochberg</li>
    <li> <b>False Discovery Rate-BY</b> is more powerful than the others, developed by Benjamini and Yekutieli</li>
    <li> <b>Scheffe</b> procedure controls for the search over any possible contrast</li>
    <li> <b>Tukey Honest Significant Difference</b> is preferred if there are unequal group sizes among the experimental and control groups</li>
    <li> <b>Dunnett</b> is useful for compare all treatment groups with a control group</li>
  "
    )

),

mainPanel(

  h4(tags$b("Output 3. Multiple Comparison Results")), p(br()),

  #numericInput("control", HTML("* For Dunnett Methods, you can change the control factor from the factor groups above"), 
  #  value = 1, min = 1, max = 20, step=1),

  p(tags$b("Pairwise P Value Table")),
  DT::DTOutput("multiple.t"),p(br()),

      HTML(
  "<b> Explanations </b>
  <ul> 
    <li> In the matrix, P < 0.05 indicates the statistical significant in the pairs</li>
    <li> In the matrix, P >= 0.05 indicates no statistically significant differences in the pairs</li>
  </ul>"
    ),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, we used Bonferroni-Holm method to explore the possible pairs with P < 0.05. 
      HS was significant different from the other groups; 
      LS was significantly different from MS and NS;
      MS was significantly different from NI and PS;
      NI was significantly different from NS."))#,
    )

  #downloadButton("download.m1", "Download Results")
  )
)