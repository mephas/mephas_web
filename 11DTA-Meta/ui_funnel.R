sidebarLayout(


sidebarPanel(
tags$head(tags$style("#ml_lnDOR_bias {background: white};")),

h3(tags$b("Configuration of the trim-and-fill plot")),

selectInput("cont", label = h5("Add CI contour of the original studies"), 
    choices = list(
    "No contour" = "no", 
    "90%, 95%, 99% CI" = "yes"), 
    selected = "yes"),

hr(),
h3(tags$b("Test on the asymmetry of the funnel plot")),
selectInput("method.bias", label = h5("Choose test methods"), 
    choices = list(
        "Deek's method" = "Deek",
    "Egger's method" = "Egger", 
    "Begger's method" = "Begg"
    ), 
    selected = "Deek"),
helpText(HTML("<i>Note:</i>
    Deek's method is recommended for detecting publication bias on lnDOR"))

),


mainPanel(

h3(tags$b("Trim-and-fill Plot")),

tabsetPanel(

tabPanel("Trim-and-fill plot on lnDOR", p(br()),

plotOutput("ml.lnDOR_funnel",height ="600px", width = "600px"), p(br()),
hr(),
tags$b("Test of Asymmetry"), p(br()),
verbatimTextOutput("ml_lnDOR_bias"),p(br()),
plotOutput("ml_lnDOR_bias_plot",height ="600px", width = "600px"),

),

tabPanel("Trim-and-fill plot on logit-Sens and logit-Spec", p(br()),

splitLayout(
    plotOutput("logit.Sens_plot",height ="500px", width = "500px"),
    plotOutput("logit.Spec_plot",height ="500px", width = "500px"),
),
helpText(HTML("<i>Note:</i>
    these 2 plots are presented to show the whether the publication bias could be detected on sensitivity or specificity only."))


)



)

)
)
