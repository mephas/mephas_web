#****************************************************************************************************************************************************5.np-1way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cnnp1", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1."))
    ),

    p(tags$b("Please follow the example to input your data")),
    p("Data point can be separated by , ; /Enter /Tab /Space"),
    p(tags$b("Data be copied from CSV (one column) and pasted in the box")), 
    
    p(tags$b("Sample Values")),
      tags$textarea(id = "xnp1",rows = 10,
"3.53\n3.55\n3.50\n5.40\n3.43\n3.22\n2.94\n3.85\n2.91\n3.94\n3.50\n3.38\n4.15\n4.26\n3.71\n1.77\n2.11\n1.92\n3.65\n2.35\n3.26\n3.73\n2.36\n3.75\n3.21\n2.78\n2.95\n4.52\n3.41\n3.56\n2.48\n3.16\n2.11\n3.89\n2.10\n2.87\n2.77\n4.59\n3.66\n3.55\n2.49\n3.48\n3.28\n3.04\n3.49\n2.13\n3.56\n2.88\n2.30\n4.38"
),
    p(tags$b("Factor group")),
      tags$textarea(id = "fnp1",rows = 10,

"NS\nLS\nLS\nPS\nLS\nHS\nMS\nNS\nPS\nNI\nMS\nLS\nNI\nNS\nMS\nPS\nMS\nLS\nPS\nHS\nMS\nMS\nHS\nLS\nHS\nMS\nHS\nNS\nLS\nNS\nHS\nMS\nHS\nNS\nLS\nNI\nMS\nPS\nLS\nPS\nNI\nLS\nLS\nHS\nLS\nHS\nLS\nMS\nHS\nNS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
tabPanel.upload(file ="filenp1", header="headernp1", col="colnp1", sep="sepnp1", quote = "quotenp1")

),
hr(),
uiOutput("value3"),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
      conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups"))
  )

),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
  DT::DTOutput("tablenp1"),
  p(tags$b("The categories in the Factor Group")),
  DT::DTOutput("level.tnp1")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("basnp1.t")#,
         #p(br()),
        #downloadButton("downloadnp1.1", "Download Results")
      ),

    tabPanel("Box-Plot",p(br()),

      plotly::plotlyOutput("mmeannp1")
      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")), p(br()),

  DT::DTOutput("kwtest"),p(br()),
      conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were significantly different among the 6 groups from Kruskal-Wallis rank sum test. "))
    ),

    hr(),
    HTML("<p><b>When P < 0.05,</b> if you want to find which pairwise factor groups are significantly different, please continue with <b>Multiple Comparison</b></p>")



  )
)
