sidebarLayout(


sidebarPanel(
tags$head(tags$style("#ml_lnDOR_bias {background: white};")),

h3(tags$b("Configuration of the funnel plot")),

selectInput("cont", label = "Add CI contour of the original studies", 
    choices = list(
    "No contour" = "no", 
    "90%, 95%, 99% CI" = "yes"), 
    selected = "yes"),

hr(),
h3(tags$b("Test on the asymmetry of the funnel plot")),
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

verbatimTextOutput("ml_lnDOR_bias")
),

tabPanel("Funnel plot of logit-Sens and logit-Spec", p(br()),

splitLayout(
    plotOutput("logit.Sens_plot",height ="500px", width = "500px"),
    plotOutput("logit.Spec_plot",height ="500px", width = "500px")
)

)



)

)
)
