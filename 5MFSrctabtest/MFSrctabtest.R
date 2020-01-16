##' See https://alain003.phs.osaka-u.ac.jp/mephas_web/5MFSrctabtest/
##'
##' MFSrctabtest includes test for contingency table of
##' (1) chi-squre test for R-C table,
##' (2) trend test for 2-k table,
##' and (3) kappa test for k-k table.
##'
##' Help file: https://alain003.phs.osaka-u.ac.jp/mephas/help5.html
##'
##' @title MEPHAS: Test for Contigency Table (Hypothesis Testing)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom psych cohen.kappa
##' @importFrom stats prop.trend.test reshape
##'
##' @examples
##' # mephas::MFSrctabtest()
##' ## or,
##' # library(mephas)
##' # MFSrctabtest()
##' # not run

##' @export
MFSrctabtest <- function(){

##Yi
##20190504

##########----------##########----------##########

ui <- tagList(

##########----------##########----------##########

navbarPage(

  title = "Contingency Table of Counts",

##---------- Panel 1 ----------
tabPanel("Chi-square Test (R x C Table)",

titlePanel("Chi-square Test"),

HTML("
<b> Notes </b>

<ul>

<li> R x C contingency table is a table with R rows (R categories) and C columns (C categories)
<li> To determine whether there is significant relationship between two discrete variables, where one variable has R categories and the other has C categories

</ul>

<b> Assumptions </b>

<ul>

<li> No more than 1/5 of the cells have expected values < 5
<li> No cell has an expected value < 1

</ul>

  "),

p(br()),
sidebarLayout(

sidebarPanel(

  h4("Configurations"),
  numericInput("r", "How many rows, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Row names"),
  tags$textarea(id="rn", rows=4, cols = 30, "R1\nR2"),
  helpText("Row names must be corresponding to number of rows")),
  numericInput("c", "How many columns, C", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Column names"),
  tags$textarea(id="cn", rows=4, cols = 30, "C1\nC2"),
  helpText("Column names must be corresponding to number of columns")),
  hr(),

  h4("Input Data"),
  helpText("Input your values by column, i.e., the second column follows the first column"),
  tags$textarea(id="x", rows=10, "10\n20\n30\n35")
    ),

mainPanel(

h4("Results of the Chi-Square Test"),
tableOutput("c.test"),
hr(),

h4("Contingency Table Description"),
tabsetPanel(

tabPanel("Contingency table", p(br()),
  dataTableOutput("ct")
  ),

tabPanel("Percentages", p(br()),
  h4("Percentages for rows"), tableOutput("prt"),
  h4("Percentages for columns"), tableOutput("pct"),
  h4("Percentages for total"), tableOutput("pt")
  ),

tabPanel("Expected value in each cell",p(br()),
  tableOutput("c.e")
  ),

tabPanel("Barplot of frequency (counts)",p(br()),
  plotOutput("makeplot", width = "800px", height = "400px")
  )
  )
  )
)
),


##---------- Panel 2 ----------

tabPanel("Test for Trend (2 x K Table)",

titlePanel("Test for Trend"),


p("To determine whether an increasing or decreasing trend in proportions"),

p(br()),
sidebarLayout(

sidebarPanel(

h4("Data Preparation"),

  tabsetPanel(
  ##-------input data-------##
  tabPanel("Manual input", p(br()),
    helpText("Missing value is input as NA"),
    tags$textarea(id="suc", rows=10, "320\n1206\n1011\n463\n220"),
    tags$textarea(id="fail", rows=10, "1422\n4432\n2893\n1092\n406")),
    helpText("Case data are input left, while control data are input right"),

  ##-------csv file-------##
  tabPanel("Upload .csv", p(br()),
    fileInput('file2', 'Choose .csv File', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE),
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')))),

  mainPanel(

h4("Results of the Test for Trend, Case out of Total"),
tableOutput("tr.test"),
hr(),

  h4("Contingency Table Description"),
  tabsetPanel(
    tabPanel("Contingency Table",p(br()),
      dataTableOutput("ct.tr"),
      helpText("Note: Percentage = Case/Total")
      ),

    tabPanel("Barplot of Case Percentage",p(br()),
    plotOutput("makeplot.tr", width = "800px", height = "400px")
      )
    )
  )
  )
),

##---------- Panel 3 ----------

tabPanel("Kappa Statistic (K x K Table)",

titlePanel("Kappa Statistic"),

p("To qualify the degree of association. This is particularly true in reliability studies, where the researcher want to qualify the reproducibility of the same variable measured more than once."),

sidebarLayout(
sidebarPanel(

h4("Configurations"),
  numericInput("r.k", "How many raters in both survey, R", value = 2, min = 2, max = 9, step = 1, width = "50%"),
  verticalLayout(
  tags$b("Rater names"),
  tags$textarea(id="rater", rows=4, cols = 30, "Yes\nNo")),

h4("Input Data"),
  tabPanel("Manually input values",
  tags$textarea(id="k", rows=10, "136\n69\n92\n240")),
  helpText("Input the counts by column, for example, the second column follows the first column")

  ),

mainPanel(

  h4("Results of the Kappa Statistic, k"), tableOutput("k.test"),
  tags$b("Notes"),
  HTML("
  <ul>
  <li> k > 0.75 denotes excellent reproducibility </li>
  <li> 0.4 < k < 0.75 denotes good  reproducibility</li>
  <li> 0 < k < 0.4 denotes marginal reproducibility </li>
  </ul>" ),

  hr(),
  h4("Contingency table"), dataTableOutput("kt"),
  HTML("
    <b> Notes</b>
    <ul>
    <li> Row is the rater of measurement-A, while column is measurement-B
    <li> The last row is the sum of above rows
    </ul>
    ")
  )

))

##########----------##########----------##########

,tabPanel((a("Help",
            #target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","help5.html"))))

))

##########----------##########----------##########
##########----------##########----------##########

server <- function(input, output) {

##########----------##########----------##########
##---------- 1. Chi-square test for R by C table ----------
T = reactive({ # prepare dataset
  x = as.numeric(unlist(strsplit(input$x, "[\n, \t, ]")))
  T = matrix(x, input$r, input$c)
  rownames(T) = unlist(strsplit(input$rn, "[\n, \t, ]"))
  colnames(T) = unlist(strsplit(input$cn, "[\n, \t, ]"))
  return(T)})

output$ct = renderDataTable({addmargins(T(), margin = seq_along(dim(T())), FUN = sum, quiet = TRUE)})

output$c.test = renderTable({
    x = T()
    res = chisq.test(x, correct = FALSE)
    res.table = t(data.frame(X_statistic = res$statistic,
                              Degree_of_freedom = res$parameter,
                              P_value = res$p.value))
    res1 = chisq.test(x, correct = TRUE)
    res1.table = t(data.frame(X_statistic = res1$statistic,
                              Degree_of_freedom = res1$parameter,
                              P_value = res1$p.value))
    res2.table = cbind(res.table, res1.table)
    colnames(res2.table) <- c(res$method, res1$method)
    return(res2.table)}, rownames = TRUE)

output$c.e = renderTable({
  x = T()
  res = chisq.test(x, correct = FALSE)
  exp = res$expected
  return(exp)
}, rownames = TRUE, digits = 4)

output$prt = renderTable({prop.table(T(), 1)}, width = "50" ,rownames = TRUE, digits = 4)

output$pct = renderTable({prop.table(T(), 2)}, width = "50" ,rownames = TRUE, digits = 4)

output$pt = renderTable({prop.table(T())}, width = "50" ,rownames = TRUE, digits = 4)

output$makeplot <- renderPlot({  #shinysession
    x <- as.data.frame(T())
    mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
    plot1 = ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
    plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
    grid.arrange(plot1, plot2, ncol=2)})

##---------- 2. Chi-square test for 2 by C table ----------
TR = reactive({ # prepare dataset
  inFile <- input$file2
    if (is.null(inFile)) {
      X <- as.numeric(unlist(strsplit(input$suc, "[\n, \t, ]")))
      Y <- as.numeric(unlist(strsplit(input$fail, "[\n, \t, ]")))
      Z <- X+Y
      P <- round(X/Z, 4)
      x <- data.frame(Case = X, Control = Y, Total = Z, Percentage = P)
      #names(x) = unlist(strsplit(input$cn2, "[\n, \t, ]"))
      return(x)}
    else {
      csv <- as.data.frame(read.csv(inFile$datapath, header=TRUE, sep=input$sep))
      return(csv)}
    })

#output$ct.tr = renderDataTable({addmargins(TR(), margin = seq_along(dim(TR())), FUN = sum, quiet = TRUE)},  width = "50" ,rownames = TRUE)
output$ct.tr = renderDataTable({TR()})

#output$pct.tr = renderTable({prop.table(TR(), 2)}, width = "50" ,rownames = TRUE, digits = 4)

output$tr.test = renderTable({
  x = TR()
  res = prop.trend.test(x$Case, x$Total)
  res.table = t(data.frame(X_statistic = res$statistic,
                            Degree_of_freedom = res$parameter,
                            P_value = res$p.value))
  colnames(res.table) <- c(res$method)
    return(res.table)}, rownames = TRUE)

output$makeplot.tr <- renderPlot({  #shinysession
    x <- TR()
    ggplot(x, aes(x = rownames(x), y = x[,"Percentage"]))+geom_bar(stat = "identity", width = 0.5, position = position_dodge()) + ylab("Proportion") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
})

##---------- 3. Kappa test for K by K table ----------

K = reactive({ # prepare dataset
  x = as.numeric(unlist(strsplit(input$k, "[\n, \t, ]")))
  T = matrix(x, input$r.k, input$r.k)
  rownames(T) = unlist(strsplit(input$rater, "[\n, \t, ]"))
  colnames(T) = unlist(strsplit(input$rater, "[\n, \t, ]"))
  return(T)})

output$kt = renderDataTable({addmargins(K(), margin = seq_along(dim(K())), FUN = sum, quiet = TRUE)})

output$k.test = renderTable({

  x = K()
  k = cohen.kappa(x)
  res.table = data.frame(k.estimate = c(round(k$kappa, digits = 4), round(k$weighted.kappa, digits = 4)),
               CI.0.95 = c(paste0("(",round(k$confid[1], digits = 4),", ",round(k$confid[5], digits = 4), ")"),
                          paste0("(",round(k$confid[2], digits = 4),", ",round(k$confid[6], digits = 4), ")")),
               row.names = c("Kappa", "Weighted.kappa"))
  return(res.table)}, rownames = TRUE)

##########----------##########----------##########

}

##########----------##########----------##########
##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)
runApp(app, quiet = TRUE)

}

