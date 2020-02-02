##'
##' MFSproptest includes test for binomial proportion of
##' (1) one single proportion,
##' (2) two proportions from independent groups,
##' (3) more than two groups,
##' and (4) trend in more than two groups.
##'
##' @title MEPHAS: Test for Binomial Proportion (Hypothesis Testing)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom reshape melt
##' @importFrom stats addmargins binom.test chisq.test fisher.test mcnemar.test prop.test reshape prop.trend.test
##'
##' @examples
##' # library(mephas)
##' # MFSproptest()
##' # or,
##' # mephas::MFSproptest()
##' # or,
##' # mephasOpen("proptest")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSproptest <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(
navbarPage(

title = "Test for Binomial Proportions",

##########----------##########----------##########

tabPanel("One Sample",

titlePanel("Chi-square Test and Exact Binomial Method for One Proportion"),


HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your data is significantly different from the specified rate/proportion
<li> To determine how compatible the sample rate/proportion with a population rate/proportion
<li> To determine the probability of success in a Bernoulli experiment
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group)
<li> You have a specified proportion (p<sub>0</sub>)
</ul>

<i><h4>Case Example</h4>
Suppose that in the general population, 20% women who had infertility. Suppose a treatment may affect infertility. 200 women who were trying to get pregnant accepted the treatment.
Among 40 women who got the treatment, 10 were still infertile. We wanted to know if there was a significant difference in the rate of infertility among treated women compared to 20% the general infertile rate.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
" ),

hr(),

#source("p1_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************1.prop1
  sidebarLayout(

    sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to your data")),
    tags$textarea(id = "ln", rows = 2, "Infertility\nfertility "), p(br()),

    p(tags$b("Please follow the example to input your data")),

      numericInput("x", "How many success / events, x", value = 10, min = 0, max = 100000, step = 1),
      numericInput("n", "How many trials / samples, n > x", value = 40, min = 1, max = 100000, step = 1),

    p(tags$i("In the example, the number of event was 10 and total sample size was 40.")),
    hr(),

    h4(tags$b("Step 2. Specify Parameter")),

      numericInput('p', HTML("The specified rate / proportion / probability (0 < p<sub>0</sub> < 1) that you want to compare"), value = 0.2, min = 0, max = 1, step = 0.1),
    p(tags$i("The infertility rate in general (20%) was what we wanted to compare.")),

      hr(),

    h4(tags$b("Step 3. Choose Hypothesis")),

    p(tags$b("Null hypothesis")),
    HTML("<p>p = p<sub>0</sub>: the probability/proportion is p<sub>0</sub></p>"),

    radioButtons("alt",
      label = "Alternative hypothesis",
      choiceNames = list(
        HTML("p &#8800 p<sub>0</sub>: the probability/proportion is not p<sub>0</sub>"),
        HTML("p < p<sub>0</sub>: the probability/proportion is less than p<sub>0</sub>"),
        HTML("p > p<sub>0</sub>: the probability/proportion is greater than p<sub>0</sub>")),
      choiceValues = list("two.sided", "less", "greater")
      ),

   p(tags$i("In this example, we wanted to test if there was a significant difference in the rate of infertility among treated women compared to 20% the general infertile rate, so we used the first alternative hypothesis"))

      ),

  mainPanel(

    h4(tags$b("Output 1. Proportion Plot")), p(br()),

    plotOutput("makeplot", width = "80%"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()),

    p(tags$b("1. Normal Theory Method with Yates' Continuity Correction, when np0(1-p0) >= 5")), p(br()),

    DT::DTOutput("b.test1"),

    p(tags$b("2. Exact Binomial Method, when np0(1-p0) < 5")),  p(br()),

    DT::DTOutput("b.test"),

     HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then the population proportion/rate IS significantly different from the specified median. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate IS NOT significantly different from the specified median. (Accept null hypothesis)
    </ul>"
  ),

  HTML("<i> From the default settings, we concluded that there was no significant difference in the rate of infertility among homozygous women compared to the general interfile rate (P = 0.55). In this case, np<sub>0</sub>(1-p<sub>0</sub>)=40*0.2*0.8 > 5, so <b>Normal Theory Method</b> was preferable. </i>")


    )
  ),
hr()

),

##########----------##########----------##########
tabPanel("Two Samples",

titlePanel("Chi-square Test for Two Independent Proportions"),

HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your 2 Groups data are significantly different </ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your 2 Groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from 2 Groups
<li> The 2 Groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose all women in the study had at least on birth. We investigated 3220 breast cancer women as case. Among them, 683 had at least one birth after 30 years old.
Also we investigated 10245 no breast cancer women as control. Among them, 1498 had at least one birth after 30 years old.
we wanted to know if the underlying probability of having first birth over 30 years old was different in breast cancer and non-breast cancer groups.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"),

hr(),

#source("p2_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2.prop2

sidebarLayout(

  sidebarPanel(
    h4(tags$b("Step 1. Data Preparation")),

    p(tags$b("Give names to the sample Groups")),
    tags$textarea(id = "cn.2", rows = 2,
        "Birth>30\nBirth<30"
      ),
    p(tags$b("Give names to the success / events")),
    tags$textarea(id = "rn.2", rows = 2,
        "Cancer (Case)\nNo-Cancer (Control)"
      ),
    p(br()),

    p(tags$b("Please follow the example to input your data")),

    p(tags$b("Group 1 (Case)")),
      numericInput("x1", "How many success / events (in case), x1", value =683, min = 0, max = 10000000, step = 1),
      numericInput("n1", "How many trials / samples, n1 > x1", value = 3220, min = 1, max = 10000000, step = 1),
    p(tags$i("Example in Group 1 were 3220 breast cancer women. Among them, 683 had at least one birth after 30 years old. ")),

    p(tags$b("Group 2 (Control)")),
      numericInput("x2", "How many success / events (in control), x2", value = 1498, min = 0, max = 10000000, step = 1),
      numericInput("n2", "How many trials / samples (Total), n2 > x2", value = 10245, min = 1, max = 10000000, step = 1),
    p(tags$i("Example in Group 2 were 10245 no breast cancer women. Among them, 1498 had at least one birth after 30 years old. ")),

      hr(),

    h4(tags$b("Step 2. Choose Hypothesis")),

     tags$b("Null hypothesis"),

      HTML("<p> p<sub>1</sub> = p<sub>2</sub>: the probability/proportion of cases are equal in Group 1 and Group 2. </p>"),

      radioButtons("alt1", label = "Alternative hypothesis",
        choiceNames = list(
          HTML("p<sub>1</sub> &#8800 p<sub>2</sub>: the probability/proportion of cases are not equal"),
          HTML("p<sub>1</sub> < p<sub>2</sub>: the probability/proportion of case in Group 1 is less than Group 2"),
          HTML("p<sub>1</sub> > p<sub>2</sub>: the probability/proportion of case in Group 1 is greater than Group 2")
          ),
        choiceValues = list("two.sided", "less", "greater")
        ),
    p(tags$i("In this example, we wanted to know if the underlying probability of having first birth over 30 years old was different in 2 groups.")),
    hr(),

    h4(tags$b("Step 3. Whether to do Yates-correction")),
    radioButtons("cr", label = "Yates-correction on P Value",
        choiceNames = list(
          HTML("Do: sample is large enough: n1*p*(1-p)>=5 and n2*p*(1-p)>=5, p=(x1+x2)/(n1+n2)"),
          HTML("Not do: n1*p*(1-p)<5 or n2*p*(1-p)<5, p=(x1+x2)/(n1+n2)")
          ),
        choiceValues = list(TRUE, FALSE)
        )

      ),

  mainPanel(

    h4(tags$b("Output 1. Data Preview")), p(br()),

    p(tags$b("Data Table")),
    DT::DTOutput("n.t2"),

    p(tags$b("Percentage Plot")),

    plotOutput("makeplot2", width = "80%"),
    plotOutput("makeplot2.1", width = "80%"),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()),

    DT::DTOutput("p.test"),

     HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then the population proportion/rate are significantly different in two groups. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different in two groups. (Accept null hypothesis)
    </ul>"
  ),

  HTML("<i> From the default settings, we conclude that women with breast cancer are significantly more likely to have their first child after 30 years old compared to women without breast cancer. (P<0.001) </i>")
          )

    ),
hr()


),

##########----------##########----------##########
tabPanel(">2 Samples",

titlePanel("Chi-square Test for More than Two Independent Proportions"),

HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your multiple Groups data are significantly different </ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your Groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
<li> The multiple Groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to study the relationship between age at first birth and development of breast cancer. Thus, we investigated 3220 breast cancer cases and 10254 no breast cancer cases.
Then, we categorize women into different age groups.
We wanted to know if the probability to have cancer were different among different age groups; or, if there age related to breast cancer.

</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"),
hr(),

#source("p3_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2.prop2
    sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),
     p(tags$b("You can change Groups names")),
        tags$textarea(id = "gn",
          rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

      p(tags$b("You can change success / events names")),
        tags$textarea(id = "ln3",
          rows = 2,
        "Cancer\nNo-Cancer"
      ),
        p(br()),

          p("Data point can be separated by , ; /Enter /Tab"),
        p(tags$b("How many success / events in every Group, x")),
        tags$textarea(id = "xx", rows = 5,
        "320\n1206\n1011\n463\n220"
        ),

        p(tags$b("How many trials / samples in every Group, n > x")),
        tags$textarea(id = "nn", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

    p("Note: No Missing Value"),

    p(tags$i("In this example, we had 5 age groups of people as shown in n, and we record the number of people who had cancer in x.")),

        hr(),

    h4(tags$b("Hypothesis")),

     p(tags$b("Null hypothesis")),

      p("The probability/proportion are equal over the Groups"),

      p(tags$b("Alternative hypothesis")),
       p("The probability/proportions are not equal"),

    p(tags$i("In this example,  we wanted to know if the probability to have cancer were different among different age groups."))


    ),

      mainPanel(

      h4(tags$b("Output 1. Data Preview")), p(br()),

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("Data Table")),
        DT::DTOutput("n.t")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot3", width = "80%")
      )
    ),

      hr(),

      h4(tags$b("Output 2. Test Results")), p(br()),

      DT::DTOutput("n.test"),


     HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then the population proportion/rate are significantly different. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then the population proportion/rate are NOT significantly different. (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we concluded that the probability to have cancer were significantly different in different age groups. (P < 0.001)"))

        )
      ),
hr()
),

##########----------##########----------##########
tabPanel("Trend in >2 Samples ",

titlePanel("Chi-square Test for Trend in Multiple Independent Samples"),

HTML("
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the population rate/proportion behind your multiple Groups data vary with score
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your Groups data come from binomial distribution (the proportion of success)
<li> You know the whole sample and the number of specified events (the proportion of sub-group) from each Groups
<li> The multiple Groups are independent observations
</ul>

<i><h4>Case Example</h4>
Suppose we wanted to study the relationship between age at first birth and development of breast cancer. Thus, we investigated 3220 breast cancer cases and 10254 no breast cancer cases.
Then, we categorize women into different age groups.
In this example, we wanted to know if the rate to have cancer had tendency from small to large ages.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"),

hr(),

#source("p4_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************4.prop.t

 sidebarLayout(
      sidebarPanel(

    h4(tags$b("Step 1. Data Preparation")),
      p("Data point can be separated by , ; /Enter /Tab"),

      p(tags$b("Give names to trials / samples ")),
        tags$textarea(id = "cn4",rows = 5,
        "~20\n20-24\n25-29\n30-34\n34~"
      ),

    p(tags$b("Give names to success / event")),
        tags$textarea(id = "rn4",rows = 2,
        "Cancer\nNo-Cancer"
      ),
        p(br()),
    p(tags$b("Please follow the example to input your data")),

        p(tags$b("How many success / event in every Group, x")),
        tags$textarea(id = "x4", rows = 5,
        "320\n1206\n1011\n463\n220"
        ),

        p(tags$b("How many trials / samples totally in every Group, n > x")),
        tags$textarea(id = "x44", rows = 5,
        "1742\n5638\n3904\n1555\n626"
        ),

    p("Note: No Missing Value"),

    p(tags$i("In this example, we had 5 age groups of people as shown in n, and we recorded the number of people who had cancer in x.")),

        hr(),

   h4(tags$b("Step 2. What is the order that you want to test for your samples")),

    p(tags$b("Order of the columns (same length with your sample)")),
    tags$textarea(id = "xs", rows = 5,
        "1\n2\n3\n4\n5"
    ),
    p(tags$i("In this case, age groups were in increasing order")),

    hr(),

    h4(tags$b("Hypothesis")),

   p(tags$b("Null hypothesis")),
   p("There is no variation in for the sample proportion"),

   p(tags$b("Alternative hypothesis")),
   p("The proportion / rate / probabilities vary with score")

    ),

    mainPanel(

    h4(tags$b("Output 1. Data Preview")), p(br()),

    tabsetPanel(

    tabPanel("Table", p(br()),

        p(tags$b("Data Table")),
        DT::DTOutput("dt4"),

        p(tags$b("Cell-Column %")),
        DT::DTOutput("dt4.2")
        ),

    tabPanel("Percentage Plot", p(br()),

      plotOutput("makeplot4", width = "80%")
      )
    ),

    hr(),

    h4(tags$b("Output 2. Test Results")), p(br()),

    DT::DTOutput("c.test4"),

     HTML(
    "<b> Explanations </b>
    <ul>
    <li> P Value < 0.05, then Case-Control (Row) is significantly associated with Grouped Factors (Column) (Accept alternative hypothesis)
    <li> P Value >= 0.05, then Case-Control (Row) are not associated with Grouped Factors (Column). (Accept null hypothesis)
    </ul>"
  ),

     p(tags$i("In this default setting, we concluded that the proportion of cancer varied among different ages. (P = 0.01)"))

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

#source("p1_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.prop1

output$b.test = DT::renderDT({
validate(need(input$n>=input$x, "Please check your data whether x <= n"))
  res = binom.test(x = input$x, n= input$n, p = input$p, alternative = input$alt)

   res.table = t(data.frame(
    Num.success = res$statistic,
    Num.trial = res$parameter,
    Estimated.prob.success = res$estimate,
    p.value = round(res$p.value,6),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
    ))

  colnames(res.table) = res$method
  rownames(res.table) =c("Number of Success/Events", "Number of Total Trials/Samples", "Estimated Probability/Proportion", "P Value", "95% Confidence Interval")
  return(res.table)
  },

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$b.test1 = DT::renderDT({
validate(need(input$n>=input$x, "Please check your data whether x <= n"))
  res = prop.test(x = input$x, n= input$n, p = input$p, alternative = input$alt, correct = TRUE)

    res.table = t(data.frame(
    X.squared = res$statistic,
    Estimated.prob.success = res$estimate,
    p.value = (res$p.value),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],4),",",round(res$conf.int[2],4), ")")
    ))

  colnames(res.table) = res$method
  rownames(res.table) =c("X-squared Statistic", "Estimated Probability/Proportion", "P Value", "95% Confidence Interval")
  return(res.table)
  },

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot <- renderPlot({  #shinysession
  x = data.frame(
    group = c(unlist(strsplit(input$ln, "[\n]"))),
    value = c(input$x, input$n-input$x)
    )
  plot_pie(x)
  #ggplot(x, aes(x="", y=x[,"value"], fill=x[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })
#source("p2_server.R", local=TRUE)$value
#****************************************************************************************************************************************************2.prop2

T = reactive({ # prepare dataset
  validate(need(input$n1>=input$x1, "Please check your data whether x1 <= n1"))
  validate(need(input$n2>=input$x2, "Please check your data whether x2 <= n2"))

 x <- matrix(c(input$x1,input$n1-input$x1,input$x2,input$n2-input$x2),2,2, byrow=TRUE)
  rownames(x) = unlist(strsplit(input$rn.2, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn.2, "[\n]"))
  return(x)
  })

output$n.t2 = DT::renderDT({
  addmargins(T(),
    margin = seq_along(dim(N())),
    FUN = list(Total=sum), quiet = TRUE)},

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$makeplot2 <- renderPlot({  #shinysession
  validate(need(input$n1>=input$x1, "Please check your data whether x <= n"))
  #validate(need(input$n2>=input$x2, "Please check your data whether x <= n"))
    x1 = data.frame(
    group = c(unlist(strsplit(input$cn.2, "[\n]"))),
    value = c(input$x1, input$n1-input$x1)
    )
    plot_pie(x1)
  #ggplot(x1, aes(x="", y=x1[,"value"], fill=x1[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab(rownames(T())[1])+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  #p2 = ggplot(x2, aes(x="", y=x2[,"value"], fill=x2[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab(rownames(T())[2])+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())

  })
output$makeplot2.1 <- renderPlot({  #shinysession
  #validate(need(input$n1>=input$x1, "Please check your data whether x <= n"))
  validate(need(input$n2>=input$x2, "Please check your data whether x <= n"))
    x2 = data.frame(
    group = c(unlist(strsplit(input$cn.2, "[\n]"))),
    value = c(input$x2, input$n2-input$x2)
    )
    plot_pie(x2)
  #p1 = ggplot(x1, aes(x="", y=x1[,"value"], fill=x1[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab(rownames(T())[1])+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  #ggplot(x2, aes(x="", y=x2[,"value"], fill=x2[,"group"]))+ geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + xlab(rownames(T())[2])+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())

  })

output$p.test = DT::renderDT({
  validate(need(input$n1>=input$x1, "Please check your data whether x <= n"))
  validate(need(input$n2>=input$x2, "Please check your data whether x <= n"))
  x <- c(input$x1, input$x2)
  n <- c(input$n1, input$n2)
  res = prop.test(x = x, n= n, alternative = input$alt1, correct = input$cr)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = paste0("prop.1 = ",round(res$estimate[1],6),", ","prop.2 = ",round(res$estimate[2],6)),
    P.value = (res$p.value),
    Confidence.Interval.95 = paste0("(", round(res$conf.int[1],6),",",round(res$conf.int[2],6), ")")
))

  colnames(res.table) = c(res$method)
    rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportion", "P Value", "95% Confidence Interval")

  return(res.table)},

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))



#source("p3_server.R", local=TRUE)$value
#****************************************************************************************************************************************************2.prop2

N = reactive({ # prepare dataset


  X <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  Y <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  validate(need(length(Y)==length(X), "Please check whether your data groups have equal length "))

  #P <- round(X/Z, 4)
  x <- rbind(X,(Y-X))
  validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))
  rownames(x) = unlist(strsplit(input$ln3, "[\n]"))
  colnames(x) = unlist(strsplit(input$gn, "[\n]"))
  return(x)
  })

output$n.t = DT::renderDT({
  addmargins(N(),
    margin = seq_along(dim(N())),
    FUN = list(Total=sum), quiet = TRUE)},

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$makeplot3 <- renderPlot({  #shinysession

  x<-as.data.frame(N())
  plot_bar1(x)
  #X <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  #Y <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  #validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))

  #xm <- rbind(X,Y)
  #rownames(xm) = unlist(strsplit(input$ln3, "[\n]"))
  #colnames(xm) = unlist(strsplit(input$gn, "[\n]"))
  #x <- melt(xm)
  ##ggplot(x, aes(fill=x[,1], y=x[,"value"], x=x[,2])) + geom_bar(position="fill", stat="identity")+
  #xlab("")+ ylab("") + scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

output$n.test = DT::renderDT({
  x <- as.numeric(unlist(strsplit(input$xx, "[\n,;\t ]")))
  n <- as.numeric(unlist(strsplit(input$nn, "[\n,;\t ]")))
  validate(need((sum((n-x)<0))==0, "Please check your data whether x <= n"))

  res = prop.test(x, n)
  res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    Estimated.prop = toString(round(res$estimate,6)),
    P.value = (res$p.value)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("X-squared Statistic", "Degree of Freedom","Estimated Probability/Proportions", "P Value")

  return(res.table)},

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p4_server.R", local=TRUE)$value
#****************************************************************************************************************************************************4.prop.t

T4 = reactive({ # prepare dataset
  X <- as.numeric(unlist(strsplit(input$x4, "[\n,;\t ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n,;\t ]")))
  validate(need(length(Y)==length(X), "Please check whether your data groups have equal length "))

  x <- rbind(X,Y-X)
  validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))
  x <- as.matrix(x)
  rownames(x) = unlist(strsplit(input$rn4, "[\n]"))
  colnames(x) = unlist(strsplit(input$cn4, "[\n]"))
  return(x)
  })

output$dt4 = DT::renderDT({
  addmargins(T4(),
    margin = seq_along(dim(T4())),
    FUN = list(Total=sum), quiet = TRUE)},

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$dt4.2 = DT::renderDT({prop.table(T4(), 2)},

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


output$makeplot4 <- renderPlot({  #shinysession
  x <- as.data.frame(T4())
  plot_bar(x)
  #x <- as.data.frame(T4())
  #mx <- reshape(x, varying = list(names(x)), times = names(x), ids = row.names(x), direction = "long")
  #ggplot(mx, aes(x = mx[,"time"], y = mx[,2], fill = mx[,"id"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
  #plot2 = ggplot(mx, aes(x = mx[,"id"], y = mx[,2], fill = mx[,"time"]))+geom_bar(stat = "identity", position = position_dodge()) + ylab("Counts") + xlab("") + labs(fill = "") + theme_minimal() + scale_fill_brewer(palette = "Paired")
# grid.arrange(plot1, plot2, ncol=2)
 })

output$c.test4 = DT::renderDT({
  X <- as.numeric(unlist(strsplit(input$x4, "[\n;\t, ]")))
  Y <- as.numeric(unlist(strsplit(input$x44, "[\n;\t, ]")))
  validate(need((sum((Y-X)<0))==0, "Please check your data whether x <= n"))

  score <- as.numeric(unlist(strsplit(input$xs, "[\n;\t, ]")))

    res = prop.trend.test(X,Y,score)
    res.table = t(data.frame(
    Statistic = res$statistic,
    Degree.of.freedom = res$parameter,
    P.value = (res$p.value)
    ))
  colnames(res.table) = c(res$method)
  rownames(res.table) =c("Chi-Squared Statistic", "Degree of Freedom", "P Value")
  return(res.table)
    },

    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


observe({
      if (input$close > 0) stopApp()                             # stop shiny
    })

}

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

app <- shinyApp(ui = ui, server = server)

runApp(app, quiet = TRUE)

}
