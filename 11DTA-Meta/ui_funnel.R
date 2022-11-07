sidebarLayout(


sidebarPanel(
tags$head(tags$style("#strnum {overflow-y:scroll; max-height: 200px; background: white};")),
tags$head(tags$style("#strfac {overflow-y:scroll; max-height: 100px; background: white};")),

h3(tags$b("Settings of plot")),
p(br()),

selectInput("cont", label = "Add CI contour of the original studies", 
    choices = list(
    "No contour" = "no", 
    "90%, 95%, 99% CI" = "yes"), 
    selected = "yes"),

hr(),
h3(tags$b("Test methods for detecting publication bias")),
p(br()),

selectInput("method.bias", label = "Choose test methods", 
    choices = list(
    "Egger's method" = "Egger", 
    "Begger's method" = "Begg",
    "Deek's method" = "Deek"), 
    selected = "yes")

),


mainPanel(

h3(tags$b("Trim-and-fill funnel Plot")),

tabsetPanel(


tabPanel("Funnel plot of lnDOR", p(br()),

plotOutput("ml.lnDOR_funnel",height ="600px", width = "600px"), p(br()),

tags$b("Test of Asymmetry"), p(br()),

verbatimTextOutput("ml.lnDOR.bias")
),

tabPanel("Funnel plot of logit-Sens and logit-Spec", p(br()),

splitLayout(
    plotOutput("logit.Sens_plot",height ="600px", width = "600px"),
    plotOutput("logit.Spec_plot",height ="600px", width = "600px")
)

)



)

)
)
