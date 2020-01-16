##' See https://alain003.phs.osaka-u.ac.jp/mephas_web/4MFSproptest/
##'
##' MFSproptest includes test for binomial proportion of
##' (1) one single proportion,
##' (2) two proportions for independent groups,
##' and (3) two proportions for matched-pair data.
##'
##' Help file: https://alain003.phs.osaka-u.ac.jp/mephas/help4.html
##'
##' @title MEPHAS: Test for Binomial Proportion (Hypothesis Testing)
##'
##' @return The web-based GUI and interactive interfaces
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom gridExtra grid.arrange
##' @importFrom reshape melt
##' @importFrom pastecs stat.desc
##' @importFrom stats addmargins binom.test chisq.test fisher.test mcnemar.test prop.test
##'
##' @examples
##' # mephas::MFSproptest()
##' ## or,
##' # library(mephas)
##' # MFSproptest()

##' @export
MFSproptest <- function(){

##Yi
##20190504

##########----------##########----------##########

ui <- tagList(

##########----------##########----------##########

navbarPage(

title = "Test for Binomial Proportions",

##---------- 1. Panel 1 ----------
tabPanel("One Single Proportion",

titlePanel("Exact Binomial Test"),

#tags$b("Introduction"),

#p("To test the probability of events (success) in a series of Bernoulli experiments. "),
HTML("

      <b> Notations </b>

      <ul>
      <li> x is the number of events</li>
      <li> n is the number of trials</li>
      <li> p is the underlying probability of event</li>
      <li> p&#8320 is the specific probability </li>
      </ul>

    <b>Assumptions </b>

      <ul>
      <li> The observations come from binomial distribution </li>
      <li> The normal approximation to the binomial distribution is valid</li>
      </ul>
      " ),

    p(br()),

  sidebarLayout(

    sidebarPanel(

    h4("Hypotheses"),
    tags$b("Null hypothesis"),
    HTML("<p>p = p&#8320: the probability of events is p&#8320 </p>"),

    radioButtons("alt",
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("p &#8800 p&#8320: the probability of events is not p&#8320"),
        HTML("p < p&#8320: the probability of events is less than p&#8320"),
        HTML("p > p&#8320: the probability of events is greater than p&#8320")),
      choiceValues = list("two.sided", "less", "greater")),

    hr(),

    h4("Data Preparation"),
      numericInput("x", "How many events, x", value = 5, min = 0, max = 10000, step = 1),
      numericInput("n", "How many trials, n", value = 10, min = 1, max = 50000, step = 1),
      numericInput('p', HTML("The specific probability, p&#8320"), value = 0.5, min = 0, max = 1, step = 0.1)
    ),

  mainPanel(
    h4("Results"),
    p(br()),
    tableOutput("b.test"),
  #tags$b("Interpretation"), wellPanel(p("When p-value is less than 0.05, it indicates that the underlying probability is far away from the specified value.")),
    hr(),
    h4('Pie Plot of Proportions'),
    plotOutput("makeplot", width = "400px", height = "400px")
    )
  )
),

##----------  Panel 2 ----------
tabPanel("Two Proportions for Independent Groups",

    titlePanel("Chi-square Test, Fisher's Exact Test"),

HTML("

<b> Assumptions </b>
<ul>
  <li> The expected value in each cell is greater than 5
  <li> When the expected value in each cell < 5, one should do correction or Fisher's exact test
</ul>

  "),


    sidebarLayout(

      sidebarPanel(
        h4("Data Preparation"),
        helpText("2 x 2 Table"),
        tags$b("Input groups' names"),
        splitLayout(
          verticalLayout(
            tags$b("Group names"),
            tags$textarea(id="cn", label = "Group names", rows=4, cols = 20, "Group1\nGroup2")
            ),

          verticalLayout(
            tags$b("Status"),
            tags$textarea(id="rn", label = "Status", rows=4, cols = 20, "Case\nControl")
            )
          ),
        p(br()),

        tags$b("Input data"),

          splitLayout(
            verticalLayout(
              tags$b("The first column"),
              tags$textarea(id="x1", rows=4, "10\n20")
              ),
            verticalLayout(
              tags$b("The second column"),
              tags$textarea(id="x2", rows=4, "30\n35")
              )
            ),
          helpText("Note: ")

        ),

  mainPanel(

    h4("Data description"),

      tabsetPanel(
        tabPanel("Display of Table", p(br()),
          tableOutput("t")
          ),

        tabPanel("Expected values", p(br()),
          tableOutput("e.t")
          ),

        tabPanel("Percentages for columns", p(br()),
          tableOutput("p.t")
          ),
        tabPanel("Pie Plot of Proportions", p(br()),
          plotOutput("makeplot2", width = "800px", height = "400px")
          ) )
        )
      ),


  h4("Chi-square Test"),

    sidebarLayout(
      sidebarPanel(

      h4("Hypotheses"),
      tags$b("Null hypothesis"),
      HTML("<p> p&#8321 = p&#8322: the probabilities of cases are equal in both group. </p>"),

      radioButtons("alt1", label = "Alternative hypothesis",
        choiceNames = list(
          HTML("p&#8321 &#8800 p&#8322: the probabilities of cases are not equal"),
          HTML("p&#8321 < p&#8322: the probability of case in the first group is less than the second group"),
          HTML("p&#8321 > p&#8322: the probability of case in the first group is greater than the second group")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),

      radioButtons("cr", label = "Yates-correction",
        choiceNames = list(
          HTML("No: no cell has an expected value less than 5"),
          HTML("Yes: at least one cell has an expected value less than 5")
          ),
        choiceValues = list(FALSE, TRUE)
        )
      ),

      mainPanel(
        h4("Results"), tableOutput("p.test")
        #tags$b("Interpretation"), p("Chi-square.test")
        )
      ),


      h4("Fisher's Exact Test"),
    sidebarLayout(

      sidebarPanel(


      tags$b("Assumptions"),
      HTML("
        <ul>
        <li> The normal approximation to the binomial distribution is not valid</li>
        <li> The expected value in each cell is less than 5</li>
        </ul>" )
      ),

      mainPanel(
        h4("Results"),
        tableOutput("f.test")
      #tags$b("Interpretation"), p("Fisher's exact test")
        )
    )
    ),

##---------- 3. Chi-square test for 2 paired-independent sample ----------
    tabPanel("Two Proportions for Matched-Pair Data",

    titlePanel("McNemar's Test"),

#tags$b("Introduction"),
#p("To test the difference between the sample proportions"),

    p(br()),

    sidebarLayout(
      sidebarPanel(

      h4("Hypotheses"),
      tags$b("Null hypothesis"),
      HTML("<p> The probabilities of being classified into cells [i,j] and [j,i] are the same</p>"),
      tags$b("Alternative hypothesis"),
      HTML("<p> The probabilities of being classified into cells [i,j] and [j,i] are not same</p>"),
      hr(),

      h4("Data Preparation"),
      helpText("2 x 2 Table"),

      tags$b("Input groups' names"),
      splitLayout(
        verticalLayout(
          tags$b("Results of Treatment A"),
          tags$textarea(id="ra", rows=4, cols = 20, "Result1.A\nResult2.A")
          ),

        verticalLayout(
          tags$b("Results of Treatment B"),
          tags$textarea(id="cb", rows=4, cols = 20, "Result1.B\nResult2.B")
          )
        ),
      p(br()),
      tags$b("Input Data"),

        splitLayout(
          verticalLayout(
            tags$b("Column 1"),
            tags$textarea(id="xn1", rows=4, "510\n15")
            ),
          verticalLayout(
            tags$b("Column 2"),
            tags$textarea(id="xn2", rows=4, "16\n90")
            )
          )

      ),

      mainPanel(
        h4("Display of Table"),
        tableOutput("n.t"),
        helpText(
          HTML(
            "<p> When the number of discordant pairs < 20, one should refer to results with correction </p>
            <ul>
            <li> Discordant pair is a matched pair in which the outcome differ for the members of the pair. </li>
            </ul>"
            )
          ),
        h4("Results"),
        tableOutput("n.test")
  #tags$b("Interpretation"), p("bbb")
        )
      )
    )

##########----------##########----------##########

,tabPanel((a("Help",
            #target = "_blank",
            style = "margin-top:-30px; color:DodgerBlue",
            href = paste0("https://alain003.phs.osaka-u.ac.jp/mephas/","help4.html"))))
))

##########----------##########----------##########
##########----------##########----------##########

server <- function(input, output) {

##########----------##########----------##########

##----------1. Chi-square test for single sample ----------
output$b.test = renderTable({

  res = binom.test(x = input$x, n= input$n, p = input$p, alternative = input$alt)

  res.table = t(data.frame(
    Num.success = res$statistic,
    Num.trial = res$parameter,
    Estimated.prob.success = res$estimate,
    p.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
    ))

  colnames(res.table) = res$method
  return(res.table)
  },
  rownames = TRUE)

output$makeplot <- renderPlot({  #shinysession
  x = data.frame(
    group = c("Success", "Failure"),
    value = c(input$x, input$n-input$x)
    )
  ggplot(x, aes(x="", y=x[,"value"], fill=x[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

##---------- 2. Chi-square test for 2 by C table ----------
P = reactive({ # prepare dataset

  X <- as.numeric(unlist(strsplit(input$x1, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x2, "[\n, \t, ]")))
  #P <- round(X/Z, 4)
  x <- cbind(X,Y)
  rownames(x) = unlist(strsplit(input$rn, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cn, "[\n, \t, ]"))
  return(x)
  })

output$t = renderTable({
  addmargins(P(), margin = seq_along(dim(P())), FUN = sum, quiet = TRUE)
  },
  width = "50" ,rownames = TRUE)

output$p.t = renderTable({
  prop.table(P(), 2)
  },
  width = "50" ,rownames = TRUE, digits = 4)


output$makeplot2 <- renderPlot({  #shinysession
  x = as.data.frame(P())
  p1 = ggplot(x, aes(x="", y= x[,1], fill = rownames(x)))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  p2 = ggplot(x, aes(x="", y= x[,2], fill = rownames(x)))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  grid.arrange(p1, p2, ncol=2)
  })

output$p.test = renderTable({
  x = P()
  res = prop.test(x = x[,1], n= x[,1]+x[,2], alternative = input$alt1, correct = input$cr)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = paste0("prop.1 = ",round(res$estimate[1],4),", ","prop.2 = ",round(res$estimate[2],4)),
    P.value = round(res$p.value,6)))

  colnames(res.table) = c(res$method)
  return(res.table)},
  rownames = TRUE)

output$e.t = renderTable({
  x = P()
  res = chisq.test(x)
  res$expected}, rownames = TRUE)

  output$f.test = renderTable({
  x = P()
  res = fisher.test(x= x, alternative = input$alt1)
  res.table = t(data.frame(Estimated.odds = res$estimate,
                           P.value = round(res$p.value, 6)))
  colnames(res.table) = c(res$method)
  return(res.table)},
  rownames = TRUE)

##---------- 3. Mcnemar test for 2 matched data ----------

N = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$xn1, "[\n, \t, ]")))
  Y <- as.numeric(unlist(strsplit(input$xn2, "[\n, \t, ]")))
  #P <- round(X/Z, 4)
  x <- cbind(X,Y)
  rownames(x) = unlist(strsplit(input$ra, "[\n, \t, ]"))
  colnames(x) = unlist(strsplit(input$cb, "[\n, \t, ]"))
  return(x)
  })

output$n.t = renderTable({
  addmargins(N(), margin = seq_along(dim(N())), FUN = sum, quiet = TRUE)},
  width = "50" ,rownames = TRUE)

output$n.test = renderTable({
  x = N()
  res1 = mcnemar.test(x = x, correct = FALSE)
  res.table1 = t(data.frame(
    X.statistic = res1$statistic,
    Degree.of.freedom = res1$parameter,
    P.value = round(res1$p.value, 6)))
  res2 = mcnemar.test(x = x, correct = TRUE)

  res.table2 = t(data.frame(
    X.statistic = res2$statistic,
    Degree.of.freedom = res2$parameter,
    P.value = round(res2$p.value, 6)))

  res.table = cbind(res.table1, res.table2)
  colnames(res.table) = c(res1$method, res2$method)
  return(res.table)},
  rownames = TRUE)


##########----------##########----------##########

}

app <- shinyApp(ui = ui, server = server)
runApp(app, quiet=TRUE)

}

