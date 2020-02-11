#****************************************************************************************************************************************************3.1. 2-np-way

sidebarLayout(

sidebarPanel(

h4(tags$b("Multiple Comparison")), 

hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups"))
  ),
  hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("methodnp2", 
  "Which method do you want to use? See explanations below",
  choiceNames = list(
    HTML("Bonferroni's"),
    HTML("Sidak's"),
    HTML("Holm's"),
    HTML("Holm-Sidak"),
    HTML("Hochberg's "),
    HTML("Benjamini-Hochberg"),
    HTML("Benjamini-Yekutieli")
    ),
  choiceValues = list("bonferroni", "sidak", "holm", "hs", "hochberg", "bh", "by")
  ),
   p(br()),
      actionButton("M3", (tags$b("Show Results >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
      hr(),
  HTML(
  "<b> Explanations </b>

    <li> <b>Bonferroni</b> adjusted p-values = max(1, pm); m= k(k-1)/2 multiple pairwise comparisons</li>
    <li> <b>Sidak</b> adjusted p-values = max(1, 1 - (1 - p)^m)</li>
    <li> <b>Holm's</b>  adjusted p-values = max[1, p(m+1-i)]; i is ordering index</li>
    <li> <b>Holm-Sidak</b> adjusted p-values = max[1, 1 - (1 - p)^(m+1-i)]</li>
    <li> <b>Hochberg's</b> adjusted p-values = max[1, p*i]</li>
    <li> <b>Benjamini-Hochberg</b> adjusted p-values = max[1, pm/(m+1-i)]</li>
    <li> <b>Benjamini-Yekutieli</b> adjusted p-values = max[1, pmC/(m+1-i)]; C = 1 + 1/2 + ... + 1/m</li>

  "
    )
),

mainPanel(

  h4(tags$b("Output 2. Test Results")), p(br()),

  p(tags$b("Reject Null Hypothesis if p <= 0.025")),

  DT::DTOutput("dunntest.t"),p(br()),
      conditionalPanel(
    condition = "input.explain_on_off",
  
    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were not significantly different in LS-NI, LS-PS, and NI-PS groups. For other groups, P <0.025. "))#,
    )

  #downloadButton("downloadnp2.2", "Download Results")


  )
)