##'
##' MFSpca includes
##' (1) principal component analysis
##' and (2) factor analysis
##'
##' @title MEPHAS: Dimensional analysis 1 (Advanced Method)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom stats biplot cor prcomp screeplot
##'
##' @examples
##' # library(mephas)
##' # MFSpca()
##' # or,
##' # mephas::MFSpca()
##' # or,
##' # mephasOpen("pca")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSpca <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(


title = "Dimensional Analysis 1",

##########----------##########----------##########

tabPanel("Data",

headerPanel("Data Preparation"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To upload data file, preview data set, and check the correctness of data input
<li> To pre-process some variables (when necessary) for building the model
<li> To get the basic descriptive statistics and plots of the variables
</ul>

<h4><b> 2. About your data</b></h4>

<ul>
<li> Your data need to have more rows than columns
<li> Your data need to be all numeric
</ul>

<i><h4>Case Example 1: Chemical data</h4>

SUppose in one study, people measured the 9 chemical attributes of 7 types of drugs. However, not all the attributes are important.
We wanted to explore the important or principal components from the chemical attributes matrix.

</i>

<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results. After getting data ready, please find the model in the next tabs.</h4>
"
),
hr(),
#source("0data_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************

sidebarLayout(

sidebarPanel(

  tags$head(tags$style("#strnum {overflow-y:scroll; height: 200px; background: white};")),
  tags$head(tags$style("#strfac {overflow-y:scroll; height: 100px; background: white};")),
  tags$head(tags$style("#fsum {overflow-y:scroll; height: 100px; background: white};")),

selectInput("edata", h4(tags$b("Use example data (training set)")),
        choices =  c("Chemical"),
        selected = "Chemical"),
hr(),

h4(tags$b("Use my own data (training set)")),
p("We suggested putting the dependent variable (Y) in the left side of all independent variables (X) "),

h4(tags$b("Step 1. Upload Data File")),

fileInput('file', "1. Choose CSV/TXT file", accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),

p(tags$b("2. Show 1st row as column names?")),
checkboxInput("header", "Yes", TRUE),

p(tags$b("3. Use 1st column as row names? (No duplicates)")),
checkboxInput("col", "Yes", TRUE),

radioButtons("sep", "4. Which separator for data?",
  choiceNames = list(
    HTML("Comma (,): CSV often uses this"),
    HTML("One Tab (->|): TXT often uses this"),
    HTML("Semicolon (;)"),
    HTML("One Space (_)")
    ),
  choiceValues = list(",", "\t", ";", " ")
  ),

radioButtons("quote", "5. Which quote for characters?",
choices = c("None" = "",
           "Double Quote" = '"',
           "Single Quote" = "'"),
selected = '"'),

p("Correct separator and quote ensure the successful data input"),

a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets"),

h4(tags$b("(Optional) Change the types of some variable?")),
uiOutput("factor1"),
uiOutput("factor2")

),


mainPanel(
h4(tags$b("Output 1. Data Information")),
p(tags$b("Data Preview")),
p(br()),
DT::DTOutput("Xdata"),

p(tags$b("1. Numeric variable information list")),
verbatimTextOutput("strnum"),

p(tags$b("2. Categorical variable information list")),
verbatimTextOutput("strfac"),

hr(),
h4(tags$b("Output 2. Basic Descriptives")),

tabsetPanel(

tabPanel("Basic Descriptives", p(br()),

p(tags$b("1. For numeric variable")),

DT::DTOutput("sum"),

p(tags$b("2. For categorical variable")),
verbatimTextOutput("fsum"),

downloadButton("download2", "Download Results (Categorical variable)")

),

tabPanel("Linear fitting plot",p(br()),

HTML("<p><b>Linear fitting plot</b>: to roughly show the linear relation between any two numeric variable. Grey area is 95% confidence interval.</p>"),

uiOutput('tx'),
uiOutput('ty'),

plotOutput("p1", width = "80%")
),

tabPanel("Histogram", p(br()),

HTML("<p><b>Histogram</b>: to roughly assess the probability distribution of a given variable by depicting the frequencies of observations occurring in certain ranges of values.</p>"),
uiOutput('hx'),
p(tags$b("Histogram")),
plotOutput("p2", width = "80%"),
sliderInput("bin", "The number of bins in the histogram", min = 0, max = 100, value = 0),
p("When the number of bins is 0, plot will use the default number of bins "),
p(tags$b("Density plot")),
plotOutput("p21", width = "80%"))

)

)

),
hr()

),


##########----------##########----------##########
tabPanel("PCA",

headerPanel("Principal Component Analysis"),

HTML(
"
<b>Principal components analysis (PCA)</b> is a data reduction technique that transforms a larger number of correlated variables into a much smaller set of uncorrelated variables called principal components.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> From <parallel analysis> to estimate the number of components
<li> To get correlation matrix and plot
<li> To get the principal components and loadings result tables and
<li> To get the principal components and loadings distribution plots
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> More samples size than the number of independent variables, that is, he number of rows is greater than the number of columns
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
#source("pca_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************pca

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),

h4("Example data is upload in Data tab"),

h4(tags$b("Step 1. Choose parameters to build the model")),

uiOutput('x'),

numericInput("nc", "2. How many components (a)", 4, min = 1, max = NA),
p(tags$i("According to the suggested results from parallel analysis, we chose to generate 4 components from the data")),

hr(),

h4(tags$b("When components >=2, choose components to show component and loading 2D Plot")),
numericInput("c1", "1. Component at x-axis", 1, min = 1, max = NA),
numericInput("c2", "2. Component at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
p(tags$i("The default is to show the first 2 PC for all the 2D plot"))
),

mainPanel(

h4(tags$b("Output 1. Data Explores")),

tabsetPanel(
tabPanel("Browse", p(br()),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("table.x")
),
tabPanel("Parallel Analysis", p(br()),
plotOutput("pc.plot", width = "80%"),
verbatimTextOutput("pcncomp")
),
tabPanel("Correlation Matrix", p(br()),
plotOutput("cor.plot", width = "80%"),p(br()),
DT::DTOutput("cor")
)
  ),

hr(),
actionButton("pca1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(

tabPanel("Components", p(br()),
  HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the components relations from two components, you can use the score plot to assess the data structure and detect clusters, outliers, and trends
<li> Groupings of data on the plot may indicate two or more separate distributions in the data
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
</ul>

<i> Click the button to show and update the result.
<ul>
<li> In the plot of PC1 and PC2 (without group circle), we could find some outliers in the up. After soring PC2 in the table, we could see 107 and 108 are two of the outliers.
<li> In the plot of PC1 and PC2 (add group circle in Euclid distance), we could find chem2 is separated from chem3 and 5, and from others.

</ul></i>
  "),
checkboxInput("frame", tags$b("Add group circle in the component plot"), FALSE),
uiOutput('g'),
radioButtons("type", "The type of ellipse",
 choices = c("T: assumes a multivariate t-distribution" = 't',
             "Normal: assumes a multivariate normal-distribution" = "norm",
             "Euclid: the euclidean distance from the center" = "euclid"),
 selected = 'euclid',
 width="500px"),
plotOutput("pca.ind", width = "80%"),

DT::DTOutput("comp")
  ),

tabPanel("Loading", p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)
<li> Red indicates negative and blue indicates positive effects
<li> Use the cumulative proportion of variance (in the variance table) to determine the amount of variance that the factors explain.
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained.
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the factors.
</ul>
  "),
  plotOutput("pca.ind2", width = "80%"),
  p(tags$b("Loadings")),
  DT::DTOutput("load"),
  p(tags$b("Variance table")),
  DT::DTOutput("var")
  ),
tabPanel("Component and Loading 2D Plot" ,p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot (biplots) overlays the components and the loadings (choose PC in the left panel)
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
<li> Loadings identify which variables have the largest effect on each component.
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.
</ul>
<i> Click the button to show and update the result.
<ul>
<li> In the plot of PC1 and PC2, we could find chem1,7 have comparatively strong negative effect to PC1, and chem 4 has comparatively strong positive effect on PC1. For PC2, chem 8 has strong positive effect and chem3 has strong negative effect.
The results are corresponding to the loading plot
</ul></i>

  "),
plotOutput("pca.bp")

)
)

)

),
hr()

), #penal tab end

##########----------##########----------##########
tabPanel("EFA",

headerPanel("Exploratory Factor Analysis"),

HTML(
"
<b>Exploratory Factor analysis (EFA)</b> is a statistical method used to describe variability among observed, correlated variables in terms of a potentially lower number of unobserved variables called factors.

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> From <parallel analysis> to estimate the number of components
<li> To get correlation matrix and plot
<li> To get the factors and loadings result tables and
<li> To get the factors and loadings distribution plots
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> All the data for analysis are numeric
<li> More samples size than the number of independent variables, that is, he number of rows is greater than the number of columns
</ul>

<h4> Please follow the <b>Steps</b> to build the model, and click <b>Outputs</b> to get analytical results.</h4>
"),
hr(),
#source("fa_ui.R", local=TRUE, encoding="UTF-8")$value
#****************************************************************************************************************************************************fa

sidebarLayout(

sidebarPanel(

#tags$head(tags$style("#x_fa {height: 150px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#fa {overflow-y:scroll; height: 300px; background: white};")),

h4("Example data is upload in Data tab"),

h4(tags$b("Step 1. Choose parameters to build the model")),

uiOutput('x.fa'),

numericInput("ncfa", "2. How many factors (a)", 4, min = 1, max = NA),
p(tags$i("According to the suggested results from parallel analysis, we chose to generate 4 factors from the data")),

hr(),
h4(tags$b("Choose factors to show factor and loading 2D plot")),
numericInput("c1.fa", "1. Factor at x-axis", 1, min = 1, max = NA),
numericInput("c2.fa", "2. Factor at y-axis", 2, min = 1, max = NA),
p("x and y must be different"),
p(tags$i("The default is to show the first 2 factors for all the 2D plot"))
),

mainPanel(

h4(tags$b("Output 1. Data Explores")),

tabsetPanel(

tabPanel("Browse", p(br()),
p("This only shows the first several lines, please check full data in the 1st tab"),
DT::DTOutput("table.x.fa")
),
tabPanel("Parallel Analysis", p(br()),
plotOutput("fa.plot", width = "80%"),
verbatimTextOutput("fancomp")
),
tabPanel("Correlation Matrix", p(br()),
plotOutput("cor.fa.plot", width = "80%"),p(br()),
DT::DTOutput("cor.fa")
)
  ),
hr(),
actionButton("pca1.fa", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
 p(br()),

tabsetPanel(
tabPanel("Factors Result",p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot graphs the factor relations to the variables
<li> Results in the window shows the statistical test for the sufficiency of factors.
</ul>

  "),
  plotOutput("pca.ind.fa", width = "80%"),
  verbatimTextOutput("fa")),

tabPanel("Factors", p(br()),

  DT::DTOutput("comp.fa")
  ),

tabPanel("Loading", p(br()),
        HTML("
<b>Explanations</b>
<ul>
<li> This plot show the contributions from the variables to the PCs (choose PC in the left panel)
<li> Red indicates negative and blue indicates positive effects
<li> Use the proportion of variance (in the variance table) to determine the amount of variance that the factors explain.
<li> For descriptive purposes, you may need only 80% (0.8) of the variance explained.
<li> If you want to perform other analyses on the data, you may want to have at least 90% of the variance explained by the factors.
</ul>

  "),
    plotOutput("pca.ind.fa2", width = "80%"),
    p(tags$b("Loadings")),
  DT::DTOutput("load.fa"),
  p(tags$b("Variance table")),
  DT::DTOutput("var.fa")  ),

tabPanel("Factors and Loading 2D Plot" ,p(br()),
    HTML("
<b>Explanations</b>
<ul>
<li> This plot (biplots) overlays the components and the loadings (choose PC in the left panel)
<li> If the data follow a normal distribution and no outliers are present, the points are randomly distributed around zero
<li> Loadings identify which variables have the largest effect on each component
<li> Loadings can range from -1 to 1. Loadings close to -1 or 1 indicate that the variable strongly influences the component. Loadings close to 0 indicate that the variable has a weak influence on the component.
</ul>


  "),
plotOutput("fa.bp", width = "80%")

)

)

)
),
hr()
),

##########----------##########----------##########
tabPanel((a("Help Pages Online",
            target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://mephas.github.io/helppage/")))),
tabPanel(
  tags$button(
    id = 'close',
    type = "button",
    class = "btn action-button",
    style = "margin-top:-8px; color:Tomato; background-color: #F8F8F8  ",
    onclick = "setTimeout(function(){window.close();},500);",  # close browser
    "Stop and Quit"))

))

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {

#source("0data_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************

#load("pca.RData")


data <- reactive({
                switch(input$edata,
               "Chemical" = chem)
               #"Independent variable matrix (Gene sample2)" = genesample2)
        })

DF0 <- reactive({
  # req(input$file)
  inFile <- input$file
  if (is.null(inFile)){
    x<-data()
    }
  else{
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, quote=input$quote, row.names=1)
    }
    validate( need(ncol(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>1, ncol>1), valid row names, column names, and spectators") )

  x <- as.data.frame(csv)
}
return(as.data.frame(x))
})

type.num0 <- reactive({
colnames(DF0()[unlist(lapply(DF0(), is.numeric))])
})

output$factor1 = renderUI({
selectInput(
  'factor1',
  HTML('1. Convert real-valued numeric variable into categorical variable'),
  selected = NULL,
  choices = type.num0(),
  multiple = TRUE
)
})

DF1 <- reactive({
df <-DF0()
df[input$factor1] <- as.data.frame(lapply(df[input$factor1], factor))
return(df)
  })

type.fac1 <- reactive({
colnames(DF1()[unlist(lapply(DF1(), is.factor))])
})

output$factor2 = renderUI({
selectInput(
  'factor2',
  HTML('2. Convert categorical variable into real-valued numeric variable'),
  selected = NULL,
  #choices = names(DF()),
  choices = type.fac1(),
  multiple = TRUE
)
})

X <- reactive({
  df <-DF1()
df[input$factor2] <- as.data.frame(lapply(df[input$factor2], as.numeric))
return(df)
  })

type.fac2 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

 output$Xdata <- DT::renderDT({
  if (ncol(X())>1000 || nrow(X())>1000) {X()[,1:1000]}
  else { X()}
  },
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))


type.num3 <- reactive({
colnames(X()[unlist(lapply(X(), is.numeric))])
})

type.fac3 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$strnum <- renderPrint({str(X()[,type.num3()])})
output$strfac <- renderPrint({Filter(Negate(is.null), lapply(X(),levels))})

sum <- reactive({
  x <- X()[,type.num3()]
  res <- as.data.frame(psych::describe(x))[,-c(1,6,7)]
  rownames(res) = names(x)
  colnames(res) <- c("Total Number of Valid Values", "Mean" ,"SD", "Median", "Minimum", "Maximum", "Range","Skew","Kurtosis","SE")
  return(res)
  })

output$sum <- DT::renderDT({sum()},
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

fsum = reactive({
  x <- X()[,type.fac3()]
  summary(x)
  })

output$fsum = renderPrint({fsum()})

 output$download2 <- downloadHandler(
     filename = function() {
       "lr.des2.txt"
     },
     content = function(file) {
       write.table(fsum(), file, row.names = TRUE)
     }
   )

# First Exploration of Variables

output$tx = renderUI({
   selectInput(
     'tx',
     tags$b('1. Choose a numeric variable for the x-axis'),
     selected=type.num3()[2],
     choices = type.num3())
   })

 output$ty = renderUI({
   selectInput(
     'ty',
     tags$b('2. Choose a numeric variable for the y-axis'),
     selected = type.num3()[1],
     choices = type.num3())

 })

 output$p1 = renderPlot({
    plot_scat(X(), input$tx, input$ty)
 #  ggplot(X(), aes(x = X()[, input$tx], y = X()[, input$ty])) + geom_point(shape = 1) +
 #    geom_smooth(method = "lm") + xlab(input$tx) + ylab(input$ty) + theme_minimal()
   })

## histogram
output$hx = renderUI({

  selectInput(
    'hx',
     tags$b('Choose a numeric variable'),
     selected = type.num3()[1],
     choices = type.num3())
})

output$p2 = renderPlot({
  plot_hist1(X(), input$hx, input$bin)
 #  ggplot(X(), aes(x = X()[, input$hx])) +
 #    geom_histogram(binwidth = input$bin, colour = "black",fill = "grey") +
 #    #geom_density()+
 #    xlab("") + theme_minimal() + theme(legend.title = element_blank())
   })

output$p21 = renderPlot({
  plot_density1(X(), input$hx)
 #  ggplot(X(), aes(x = X()[, input$hx])) +
 #    #geom_histogram(binwidth = input$bin, colour = "black",fill = "white") +
 #    geom_density() +
 #    xlab("") + theme_minimal() + theme(legend.title = element_blank())
   })



#source("pca_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************pca

output$x = renderUI({
selectInput(
'x',
tags$b('1. Choose independent variable matrix (X)'),
selected = type.num3(),
choices = type.num3(),
multiple = TRUE
)
})

DF4 <- reactive({
  X()[,input$x]
  })

output$table.x <- DT::renderDT(
    head(X()), options = list(scrollX = TRUE,dom = 't'))

output$cor <- DT::renderDT({as.data.frame(cor(DF4()))},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$cor.plot   <- renderPlot({
  plot_corr(DF4())
#c <- as.data.frame(cor(DF4()))
#c$group <- rownames(c)
#corrs.m <- reshape::melt(c, id="group",
#                            measure=rownames(c))

#ggplot(corrs.m, aes(corrs.m$group, corrs.m$variable, fill=abs(corrs.m$value))) +
#  geom_tile() + #rectangles for each correlation
#  #add actual correlation value in the rectangle
#  geom_text(aes(label = round(corrs.m$value, 2)), size=2.5) +
#  theme_bw(base_size=10) + #black and white theme with set font size
  #rotate x-axis labels so they don't overlap,
  #get rid of unnecessary axis titles
  #adjust plot margins
#  theme(axis.text.x = element_text(angle = 90),
#        axis.title.x=element_blank(),
#        axis.title.y=element_blank(),
#        plot_margin = unit(c(3, 1, 0, 0), "mm")) +
  #set correlation fill gradient
#  scale_fill_gradient(low="white", high="red") +
#  guides(fill=F) #omit unnecessary gradient legend
})

#output$nc <- renderText({input$nc})
# model
pca <- eventReactive(input$pca1,{
  X <- DF4()
  a <- input$nc
validate(need(input$nc>=2, "Components must be >= 1."))
  prcomp(X, rank.=a, scale.=TRUE)
  })


output$var  <- DT::renderDT({
  validate(need(input$nc>=2, "Components must be >= 2."))
  res <- summary(pca())
  res.tab<- as.data.frame(res$importance)[,1:input$nc]
  return(res.tab)
  },
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$comp <- DT::renderDT({
  as.data.frame(pca()$x)},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$load <- DT::renderDT({pca()$rotation},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


type.fac4 <- reactive({
colnames(X()[unlist(lapply(X(), is.factor))])
})

output$g = renderUI({
selectInput(
'g',
tags$b('4. Choose one group variable, categorical (if add group circle)'),
selected = type.fac4()[1],
choices = type.fac4()
)
})

output$pca.ind  <- renderPlot({
validate(need(input$nc>=2, "Components are not enough to create the plot."))
df <- as.data.frame(pca()$x)
  if (input$frame == FALSE)
  {
  df$group <- rep(1, nrow(df))
  plot_score(df, input$c1, input$c2)
  #ggplot(df,aes(x = df[,input$c1], y = df[,input$c2], color=df$group))+
  #geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  #theme_minimal()+
  #xlab(paste0("PC", input$c1))+ylab(paste0("PC", input$c2))
  }
  else
  {
  df$group <- X()[,input$g]
  plot_scorec(df, input$c1, input$c2, input$type)
  #ggplot(df, aes(x = df[,input$c1], y = df[,input$c2], color=df$group))+
  #geom_point() + geom_hline(yintercept=0, lty=2) +geom_vline(xintercept=0, lty=2)+
  #stat_ellipse(type = input$type)+ theme_minimal()+
  #xlab(paste0("PC", input$c1))+ylab(paste0("PC", input$c2))
  }
  })

output$pca.ind2  <- renderPlot({
load <- as.data.frame(pca()$rotation)
plot_load(loads=load, a=input$nc)
  #validate(need(input$nc>=2, "Components are not enough to create the plot."))
#ll <- as.data.frame(pca()$rotation)
#ll$group <- rownames(ll)
#loadings.m <- reshape::melt(ll, id="group",
#                   measure=colnames(ll)[1:input$nc])

#ggplot(loadings.m, aes(loadings.m$group, abs(loadings.m$value), fill=loadings.m$value)) +
#  facet_wrap(~ loadings.m$variable, nrow=1) + #place the factors in separate facets
#  geom_bar(stat="identity") + #make the bars
#  coord_flip() + #flip the axes so the test names can be horizontal
  #define the fill color gradient: blue=positive, red=negative
#  scale_fill_gradient2(name = "Loading",
#                       high = "blue", mid = "white", low = "red",
#                       midpoint=0, guide=F) +
#  ylab("Loading Strength") + #improve y-axis label
#  theme_bw(base_size=10)

  })

output$pc.plot   <- renderPlot({
psych::fa.parallel((DF4()),fa="pc",fm="ml")
})

output$pcncomp   <- renderPrint({
x <- psych::fa.parallel((DF4()),fa="pc",fm="ml")
cat(paste0("Parallel analysis suggests that the number of components: ", x$ncomp))
})

output$pca.bp   <- renderPlot({
validate(need(input$nc>=2, "Components are not enough to create the plot."))
score <- as.data.frame(pca()$x)
load <- as.data.frame(pca()$rotation)
plot_biplot(score, load, input$c1, input$c2)
#biplot(pca(), choice=c(input$c1,input$c2))
})

# Plot of the explained variance
output$pca.plot <- renderPlot({ screeplot(pca(), npcs= input$nc, type="lines", main="") })


#source("fa_server.R", local=TRUE, encoding="UTF-8")
#****************************************************************************************************************************************************fa

output$x.fa = renderUI({
selectInput(
'x.fa',
tags$b('1. Choose independent variable matrix (X)'),
selected = type.num3(),
choices = type.num3(),
multiple = TRUE
)
})

DF4.fa <- reactive({
  X()[,input$x.fa]
  })


output$table.x.fa <- DT::renderDT(
    head(X()), options = list(scrollX = TRUE,dom = 't'))

fa <- eventReactive(input$pca1.fa,{
  X <- DF4.fa()
  a <- input$ncfa
  validate(need(input$ncfa>=1, "Components must be >= 1."))
  psych::fa(X, nfactors=a, rotate="varimax", fm="ml")
  #factanal(DF4.fa(), factors = input$ncfa, scores= "regression")
  })


output$fa  <- renderPrint({
  summary(fa())
  })

output$fa.plot   <- renderPlot({
psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
})

output$fancomp   <- renderPrint({
x <- psych::fa.parallel((DF4.fa()),fa="fa",fm="ml")
cat(paste0("Parallel analysis suggests that the number of factors: ", x$nfact))
})


output$comp.fa <- DT::renderDT({as.data.frame(fa()$scores)},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$load.fa <- DT::renderDT({
  validate(need(input$ncfa>=2, "Components must be >= 2."))
  as.data.frame(fa()$loadings[,1:input$ncfa])},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$var.fa <- DT::renderDT({as.data.frame(fa()$Vaccounted)},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$pca.ind.fa  <- renderPlot({
    validate(need(input$ncfa>=1, "Components are not enough to create the plot."))
psych::fa.diagram(fa(), cut = 0)
  })

output$pca.ind.fa2  <- renderPlot({
    validate(need(input$ncfa>=2, "Components are not enough to create the plot."))
    load <- as.data.frame(fa()$loadings[,1:input$ncfa])
    plot_load(loads=load, a=input$ncfa)
#ll <- as.data.frame(fa()$loadings[,1:input$ncfa])
#ll$group <- rownames(ll)
#loadings.m <- reshape::melt(ll, id="group",
#                   measure=colnames(ll)[1:input$ncfa])

#ggplot(loadings.m, aes(loadings.m$group, abs(loadings.m$value), fill=loadings.m$value)) +
#  facet_wrap(~ loadings.m$variable, nrow=1) + #place the factors in separate facets
#  geom_bar(stat="identity") + #make the bars
#  coord_flip() + #flip the axes so the test names can be horizontal
#  #define the fill color gradient: blue=positive, red=negative
#  scale_fill_gradient2(name = "Loading",
#                       high = "blue", mid = "white", low = "red",
#                       midpoint=0, guide=F) +
#  ylab("Loading Strength") + #improve y-axis label
#  theme_bw(base_size=10)

  })

output$cor.fa <- DT::renderDT({as.data.frame(cor(DF4.fa()))},
  extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$cor.fa.plot   <- renderPlot({
  plot_corr(DF4.fa())
#c <- as.data.frame(cor(DF4.fa()))
#c$group <- rownames(c)
#corrs.m <- reshape::melt(c, id="group",
#                            measure=rownames(c))

#ggplot(corrs.m, aes(corrs.m$group, corrs.m$variable, fill=abs(corrs.m$value))) +
#  geom_tile() + #rectangles for each correlation
#  #add actual correlation value in the rectangle
#  geom_text(aes(label = round(corrs.m$value, 2)), size=2.5) +
#  theme_bw(base_size=10) + #black and white theme with set font size
  #rotate x-axis labels so they don't overlap,
  #get rid of unnecessary axis titles
  #adjust plot margins
#  theme(axis.text.x = element_text(angle = 90),
#        axis.title.x=element_blank(),
#        axis.title.y=element_blank(),
#        plot_margin = unit(c(3, 1, 0, 0), "mm")) +
  #set correlation fill gradient
#  scale_fill_gradient(low="white", high="red") +
#  guides(fill=F) #omit unnecessary gradient legend

})

output$fa.bp   <- renderPlot({
  validate(need(input$ncfa>=2, "Components are not enough to create the plot."))
  score <- as.data.frame(fa()$scores)
load <- as.data.frame(fa()$loadings[,1:input$ncfa])
plot_biplot(score, load, input$c1.fa, input$c2.fa)
#biplot(fa(),labels=rownames(DF4.fa()), choose=c(input$c1.fa,input$c2.fa), main="")

})

observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
