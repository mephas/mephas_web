##----------#----------#----------#----------
##
## 5MFSrctabtest UI
##
## Language: EN
## 
## DT: 2019-01-11
##
##----------#----------#----------#----------

#----------  Panel 2: 2,2 dependent ----------##
 sidebarLayout(
sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("Give names to case-control in the row")), 
  tags$textarea(id="rn2", rows=2, "OC-user\nNever-OC-user"),

  p(tags$b("Give names to samples in the column")), 
  tags$textarea(id="cn2", rows=2, "Developed-MI\nNo-MI"), p(br()),

  p(tags$i("Example here is data of OC-users and myocardial infarction (MI) patients. Among 5000 OC-users, 13 developed MI; among 10000 non-OC-users, 7 developed MI.")),
  
  p(tags$b("Input 4 Values by Column")),
  tags$textarea(id="x2", rows=4, 
    "13\n7\n4987\n9993"),

  p("Note: No Missing Value and n > x"),
  
  hr(),

   h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")), 
   p("Case-Control (Row) is significantly associate with Grouped Factors (Column)"),
    
   p(tags$b("Alternative hypothesis")), 
   p("Case-Control (Row) has no significant association with Grouped Factors (Column)"),
   p(tags$i("In this example, we want to determine if OC use is significantly associated with higher MI incidence.")),
      
  hr(),

    h4(tags$b("Step 2. Whether to do Yates-correction")),
    radioButtons("yt2", label = "Yates-correction on P Value", 
        choiceNames = list(
          HTML("Do: sample is large enough: n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("Not do: n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        )
   
    ),

    mainPanel(

    h4(tags$b("Output 1. Contingency Table")), p(br()), 

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("Data Table")),
        tableOutput("dt2"),

        p(tags$b("Cell-Total %")),
        tableOutput("dt2.3"),

        p(tags$b("Cell-Row %")),
        tableOutput("dt2.1"),

        p(tags$b("Cell-Column %")),
        tableOutput("dt2.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot2", width = "800px", height = "400px")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()), 

    tableOutput("c.test2"),

     HTML(
    "<b> Explanations </b> 
    <ul> 
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we conclude that using OC and MI development have significant association. (P = 0.01)"))

        )
      )
    