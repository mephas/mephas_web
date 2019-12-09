##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------
#----------  Panel 1: 2,2 independent ----------##

sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("Give names to Columns (No space)")),
  tags$textarea(id="cn1", rows=2, "Developed-MI\nNo-MI"),

    p(tags$b("Give names to Rows (No space)")), 
  tags$textarea(id="rn1", rows=2, "OC-user\nNever-OC-user"), p(br()),

  p(tags$b("Input 4 Values by Column-order")),
  tags$textarea(id="x1", rows=4, 
    "13\n7\n4987\n9993"),

  p("Note: No Missing Value"),

  p(tags$i("Example here was data of OC-users and myocardial infarction (MI) patients.")),
  p(tags$i("Among 5000 OC-users, 13 developed MI; among 10000 non-OC-users, 7 developed MI.")),

  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) has no significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) is significant association with Grouped Factors (Column)"),

  p(tags$i("In this example, we wanted to determine if OC use was significantly associated with higher MI incidence.")),

hr(),

    h4(tags$b("Step 2. Check the Rule of Five")),
    radioButtons("yt1", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: no value in the Expected Table (Right) <5 "),
          HTML("Not do: some value in the Expected Table (Right) <5")
          ),
        choiceValues = list(TRUE, FALSE)
        )
    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table Preview", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt1"),

        p(tags$b("Expected Table")),
        tableOutput("dt1.0")
        ),

    tabPanel("Percentage Table", p(br()),

        p(tags$b("Cell-Total %")),
        tableOutput("dt1.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt1.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt1.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot1", width = "1000px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test1"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we concluded that using OC and MI development had significant association. (P = 0.01) Because the minimum expected value was 6.67, Yates-correction on P Value was done." ))

        )
      )
    