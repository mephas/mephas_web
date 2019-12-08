##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

 sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$i("Example here is data of OC-users and myocardial infarction (MI) patients. Among 5000 OC-users, 13 developed MI; among 10000 non-OC-users, 7 developed MI.")),


  p(tags$b("Input 4 Values to Create Table, by Column")),
  tags$textarea(id="x1", rows=4, 
    "13\n7\n4987\n9993"),

  p(tags$b("You can change Row names")), 
  tags$textarea(id="rn1", rows=2, "OC-user\nNever-OC-user"),

  p(tags$b("You can change Column names")),
  tags$textarea(id="cn1", rows=2, "Developed-MI\nNo-MI"),

  p("Note: No Missing Value and n > x"),
  
  hr(),

   h4(tags$b("Step 2. Choose Parameter")),

   h4(tags$b("1. Hypothesis")),
   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) is significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column)"),

    h4(tags$b("2. Decide your Sample Size")),
    radioButtons("yt1", label = "Yates-correction", 
        choiceNames = list(
          HTML("Do: sample is large enough: n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("Not do: n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        ),

   p(tags$i("In this example, we want to determine if OC use is significantly associate with higher MI incidence."))
   
    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt1"),

        p(tags$b("Cell-Total %")),
        tableOutput("dt1.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt1.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt1.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot1", width = "800px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test1"),


     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that the probability to have cancer are significantly different in different age groups. (P < 0.001)"))

        )
      )
    