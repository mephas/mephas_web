
##'
##' MFSanova includes
##' (1) one-way ANOVA,
##' (2) pairwise post-hoc test for one-way ANOVA,
##' (3) two-way ANOVA,
##' (4) pairwise post-hoc test for two-way ANOVA
##' (5) Kruskal-Wallis test
##' and (6) post-hoc test for Kruskal-Wallis test
##'
##'
##' @title MEPHAS: ANOVA (Hypothesis Testing)
##'
##' @return shiny interface
##'
##' @import shiny
##' @import ggplot2
##'
##' @importFrom psych describeBy
##' @importFrom graphics plot
##' @importFrom utils head read.csv write.csv
##' @importFrom stats TukeyHSD aov pairwise.t.test anova kruskal.test relevel
##'
##' @examples
##' # library(mephas)
##' # MFSanova()
##' # or,
##' # mephas::MFSanova()
##' # or,
##' # mephasOpen("anova")
##' # Use 'Stop and Quit' Button in the top to quit the interface

##' @export
MFSanova <- function(){

requireNamespace("shiny", quietly = TRUE)
requireNamespace("ggplot2", quietly = TRUE)
requireNamespace("DT", quietly = TRUE)
  #requireNamespace("ggplot2")

##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
ui <- tagList(

navbarPage(

title = "Analysis of Variance",

##########----------##########----------##########
tabPanel("One-way",

headerPanel("One-way ANOVA (Overall F Test) to Compare Means from Multiple Factor Groups"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among the factor groups
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups shown in two vectors
<li> One vector is the observed values; one vector is to mark your values in different factor groups
<li> The separate factor groups are independent and identically approximately normally distributed
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared
</ul>

<i><h4>Case Example</h4>
Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
NS,PS,LS,MS,and HS group had 200 people in each. NI group had 50 people. The study measured the forced mid-expiatory flow (FEF).
We wanted to the know the FEF differences among the 6 groups.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

#****************************************************************************************************************************************************1. one-way
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cn1", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(

    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "x1",rows = 10,
"4.21\n3.35\n3.72\n3.76\n3.67\n3.77\n2.69\n4.31\n2.87\n4.11\n3.47\n2.8\n4.14\n2.67\n5.31\n4.23\n4.52\n2.56\n4.26\n3.03\n4.85\n3.57\n1.38\n3.59\n3.56\n4.72\n3.82\n4.04\n4.2\n4.27\n3.84\n3.57\n3.05\n3.87\n2.09\n3.53\n3.19\n3.05\n4.38\n4.06\n3.12\n3.43\n3.25\n3.15\n5.05\n3.79\n2.92\n4.8\n3.67\n1.97\n3.71\n3.94\n4.75\n3.78\n2.76\n3.47\n5.15\n4.59\n3.36\n4.45\n4.43\n2.72\n4.6\n2.89\n4.33\n4.07\n4.29\n3.43\n3.1\n4.46\n3.38\n3.18\n6.47\n3.42\n5.15\n3.21\n4.2\n3.72\n2.56\n4\n5.27\n4.45\n4.04\n3.8\n2.98\n4.11\n3.17\n4.51\n4.02\n5.33\n3.04\n4.11\n3.35\n4.47\n4.69\n3.79\n3.05\n3.38\n4.75\n4.74\n2.44\n3.85\n4.38\n5.65\n3.75\n3.83\n3.9\n3.36\n2.34\n4.25\n3.85\n3.47\n2.5\n3.76\n4.1\n4.18\n5.03\n4.61\n2.95\n3.16\n4.15\n4.22\n3.24\n1.57\n2.92\n3.26\n3.01\n4.11\n3.06\n3.43\n3.15\n2.98\n4.58\n3.27\n3.81\n3.93\n4.14\n4.02\n4.01\n4.3\n3.52\n4.96\n3.92\n3.93\n3.56\n4.39\n3.51\n3.77\n3.67\n3.74\n4.83\n4.56\n5.1\n2.11\n3.89\n3.64\n4.02\n4.68\n3.88\n3.4\n2.99\n5.19\n3.09\n3.01\n2.83\n3.49\n3.79\n4.82\n4.17\n2.83\n3.09\n3.87\n4.98\n4.08\n4.8\n5.8\n2.99\n4.41\n2.96\n4.86\n3.6\n3.57\n4.08\n4.55\n5.58\n4.2\n4.17\n3.9\n3.85\n2.53\n2.57\n5.14\n3.94\n4.76\n3.97\n4.58\n4.79\n4.01\n1.88\n5.57\n2.83\n2.94\n2.16\n3.07\n3.54\n3.1\n2.25\n3.6\n3.71\n4.95\n3.46\n2.32\n2.9\n3.24\n3.79\n3.93\n2.61\n2.99\n3.93\n2.3\n3.97\n3.83\n2.64\n3.8\n4.38\n4.07\n0.96\n3.11\n4.73\n2.01\n2.82\n3.5\n3.28\n3.16\n3.12\n5.4\n1.15\n4.57\n5.31\n2.84\n3.62\n3.72\n1.67\n3.21\n3.09\n3.46\n5.12\n4.54\n4.57\n5\n2.96\n3.73\n4.21\n2.58\n3.28\n3.12\n2.36\n3.73\n3.85\n2.71\n3.63\n3.53\n2.55\n2.81\n4.01\n2.46\n3.65\n3.13\n4.32\n3.52\n2.61\n3.29\n3.63\n3.39\n2.02\n3.2\n2.61\n3.99\n4.34\n2.51\n3.7\n3.56\n3.1\n3.64\n4.35\n2.67\n3.45\n4.41\n2.53\n3.77\n3.49\n2.76\n2.1\n2.72\n4.49\n3.25\n2.56\n3.59\n1.74\n3.49\n3.32\n2.58\n3.31\n2.36\n3.83\n3.65\n3.74\n3.27\n3.68\n2.7\n4.52\n1.89\n3.55\n3.08\n3.99\n2.81\n3.41\n2.03\n1.77\n2.9\n1.79\n3.53\n3.77\n3.88\n3.28\n3.85\n4.13\n3.2\n3.86\n3.46\n4.06\n2.13\n3.29\n2.85\n3.46\n3.65\n3.81\n2.89\n3.32\n3.73\n3.62\n3.57\n2.71\n2.91\n1.92\n3.07\n2.95\n4.01\n2.22\n4.27\n3.12\n2.6\n4.41\n3.29\n2.89\n3.92\n3.04\n2.19\n4.73\n3.34\n3.34\n2.3\n2.47\n3.28\n2.75\n4.09\n4.13\n3.73\n4.52\n3.5\n4.27\n4.19\n4.59\n3.78\n2.4\n3.92\n4.23\n2.88\n4.21\n2.87\n3.85\n4.9\n3.24\n2.38\n1.29\n3.62\n3.4\n3.68\n3.47\n3.34\n3.25\n2.74\n4.46\n3.07\n3.96\n2.99\n2.75\n1.66\n3.72\n3.47\n3.45\n4.39\n3.75\n3.05\n2.85\n3.63\n4.25\n4.04\n3.09\n2.59\n2.96\n3.55\n3.59\n4.15\n2.87\n3.32\n4.14\n3.94\n2.87\n3.02\n2.29\n3.76\n3.35\n3.92\n4.04\n2.76\n3.98\n4.35\n1.45\n3.19\n3.53\n3.14\n3.58\n3.51\n2.75\n2.49\n2.21\n3.91\n5.21\n3.23\n2.83\n2.57\n4.27\n2.53\n4.37\n2.33\n2.63\n2.2\n2.85\n4.06\n3.83\n2.45\n3.5\n2.89\n3.38\n3.17\n4.33\n3.75\n3.64\n4.53\n2.95\n2.11\n4.51\n1.73\n3.47\n3.88\n2.09\n3.15\n4.11\n2.76\n2.88\n3.15\n2.97\n3.43\n3.8\n1.92\n2.64\n3.25\n1.72\n3.49\n2.94\n3.8\n2.58\n2.86\n1.35\n3.55\n2.31\n3.34\n2.48\n2.84\n3.62\n4.03\n2.62\n3.7\n2.29\n2.01\n3.48\n3.65\n3.47\n2.7\n3.31\n3.9\n2.93\n2.78\n2.52\n2.68\n3.49\n4.42\n2.66\n4.97\n3.6\n4.49\n3.41\n2.63\n3.39\n4.09\n3.02\n2.1\n3.42\n3.73\n2.68\n2.75\n3.34\n3.75\n3.67\n4.24\n1.72\n1.45\n2.27\n3.39\n3.93\n3.66\n1.57\n3.44\n3.14\n2.81\n2.99\n3.2\n3.77\n2.37\n4.93\n2.99\n3.54\n2.92\n4.66\n1.65\n2.01\n4.41\n2.44\n4.08\n2.1\n4.2\n2.89\n3.24\n3.33\n2.91\n3.67\n4.48\n2.45\n3.63\n3.51\n3.38\n4.03\n2.49\n3.6\n3.16\n2.35\n3.05\n3.2\n2.45\n3.29\n4.47\n3.56\n3.47\n3.32\n2.2\n2.52\n2.8\n2.62\n3.51\n2.98\n3.58\n3.38\n3.86\n2.33\n2.45\n4.22\n3.41\n2.12\n2.73\n3.25\n4.51\n5.21\n3.25\n3.36\n2.69\n4.68\n3.54\n2.58\n2\n3.63\n2.1\n2.33\n2.1\n2.91\n4.58\n2.81\n4.07\n2.9\n4.02\n2.41\n3.55\n3.85\n4.38\n3.35\n3.23\n3.63\n2.6\n3.63\n2.81\n3.78\n4.9\n3.78\n5.1\n2.87\n3.01\n2.52\n3.03\n2.18\n2.64\n3.18\n3.3\n2.91\n3.28\n2.6\n3.16\n3.44\n2.21\n4.08\n4.03\n2.76\n3.3\n4.38\n5.06\n1.66\n2.74\n3.58\n2.92\n3.24\n3.06\n1.77\n2.64\n2.27\n0.56\n2.57\n3.29\n4.03\n3.71\n3.33\n2.93\n3.58\n4.18\n3.85\n3.26\n4.27\n2.94\n1.82\n1.83\n2.23\n1.49\n3.61\n2.61\n2.94\n3.39\n0.89\n1.89\n1.97\n3.63\n3.23\n4.36\n1.23\n2.87\n2.46\n2.87\n2.49\n3.05\n2.57\n2.2\n2.7\n3.75\n3.46\n2.18\n1.48\n3.19\n1.77\n2.42\n1.66\n2.49\n2.52\n1.97\n3.63\n2.11\n3.14\n4.36\n4.38\n3.57\n2.82\n3.05\n2.77\n2.09\n2.3\n3.95\n3.16\n2.94\n4.27\n3.29\n2.48\n2.35\n2.88\n3.24\n1.94\n0.75\n2.8\n3.58\n2.71\n2.69\n2.54\n3.58\n2.71\n3.26\n3.74\n3.5\n2.76\n3.36\n3.23\n2.39\n3.1\n2.76\n3.05\n2.88\n3.14\n2.6\n2.78\n2.42\n2.91\n3.23\n2.63\n1.67\n3.17\n2.33\n3.13\n3.98\n3\n3.23\n3.89\n3.07\n2.45\n1.55\n2.45\n3.18\n4.2\n3.09\n2.97\n2.83\n3.85\n3.41\n2.47\n3.93\n2.9\n1.49\n4.13\n3.5\n1.84\n2.18\n2.35\n2.4\n3.39\n2.69\n3.07\n3.78\n2.14\n2.23\n4.48\n2.95\n3.67\n2.14\n2.39\n3.29\n2.57\n2.39\n2.86\n2.71\n2.85\n2.02\n2.16\n3.97\n2.75\n3.97\n3.77\n1.58\n3.51\n2.59\n2.72\n1.91\n3.49\n3.73\n4.47\n4.12\n1.68\n2.72\n2.3\n2.84\n3.4\n1.53\n2.91\n4.51\n1.66\n3.17\n3.13\n1.91\n2.82\n3.3\n2.49\n2.59\n3.63\n2.41\n3.19\n2.64\n2.7\n2.2\n3.31\n1.54\n3.72\n2.3\n2.35\n2.75\n3.44\n2.87\n3.58\n3.05\n2.75\n4.5\n2.78\n3.1\n3.31\n2.03\n1.78\n1.45\n2.19\n3.14\n4.03\n2.86\n2.38\n1.02\n1.25\n4.52\n3.43\n3.47\n3.1\n2.87\n2.78\n1.37\n2.06\n1.68\n2.93\n2.8\n2.48\n2.67\n3.11\n2.76\n1.43\n3.08\n1.85\n1.89\n2.79\n2.43\n2.95\n1.84\n2.8\n2.57\n1.76\n1.92\n0.73\n2.21\n3.24\n1.54\n2.89\n2.1\n3.37\n2.8\n2.66\n0.99\n1.36\n1.92\n2.63\n3.56\n1.82\n3.74\n2.85\n1.54\n3.65\n2.29\n3\n3.22\n2.46\n3.49\n3.56\n4.81\n1.91\n3.94\n2.75\n1.63\n2.55\n2.96\n2.43\n4.3\n3.06\n3.39\n3.47\n1.49\n3.35\n3.69\n3.71\n2.82\n1.83\n1.05\n1.67\n2.13\n3.85\n4.45\n1.53\n2.49\n2.33\n1.86\n2.89\n1.77\n2.75\n3.22\n1.82\n3.13\n2.49\n3.36\n2.35\n2.31\n0.88\n2.63\n3.45\n2.15\n2.95\n3.06\n2.86\n1.69\n3.02\n3.79\n1.3\n2.33\n2.48\n1.63\n3.17\n4.32\n2.2\n1.22\n2.01\n0.85\n2.36\n2.85\n3.8\n1.12\n2.63\n2.51\n2.64\n1.62\n3.5\n2.1\n2.6\n2.6\n3\n1.22\n2.85\n1.6\n0.34\n1.97\n4.56\n2.76\n2.24\n2.83\n2.29\n2.92\n2.03\n2.05\n3.02\n1.65\n2.08\n2.69\n2.51\n2.55\n3.25\n2.42\n2.88\n3.67\n2.22\n2.19\n2.86\n2.25\n0.88\n1.54\n3.17\n3.21\n2.58\n3.21\n2.88\n2.51\n0.04\n2.11\n2.2\n3.88\n3.48\n2.15\n2.3\n3.23\n1.16\n2.04\n1.87\n3.04\n2.84\n2.87\n2.35\n2.68\n3.31\n2.09\n2.48\n3.06\n3.77\n1.94\n4.55\n2.97\n2.11\n4.1\n2.89\n3.22\n2.14\n2.24\n2.98\n2.13\n1.65\n1.67\n0.15\n3.27\n1.59\n2.46"
),
    p(tags$b("Factor group")),
      tags$textarea(id = "f11",rows = 10,

"NS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),

tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads 2 columns from your data")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors" )),
    fileInput('file1', "1. Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("header1", "Show Data Header?", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("col1", "Yes", TRUE),

    radioButtons("sep1",
      "4. Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups"))

),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
        DT::DTOutput("table1"),
        p(tags$b("The categories in the Factor Group")),
        DT::DTOutput("level.t1")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("bas1.t")
      ),
    tabPanel("Box Plot",p(br()),

      plotOutput("mbp1", width = "80%"),
    HTML(
    "<b> Explanations </b>
    <ul>
      <li> The band inside the box is the median
      <li> The box measures the difference between 75th and 25th percentiles
      <li> Outliers will be in red, if existing
    </ul>"

    )
      ),
    tabPanel("Marginal Means Plot",p(br()),

      plotOutput("mmean1", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Table")), p(br()),

  DT::DTOutput("anova1"),p(br()),
  HTML(
  "<b> Explanations </b>
  <ul>
    <li> DF<sub>Factor</sub> = [number of factor group categories] -1
    <li> DF<sub>Residuals</sub> = [number of sample values] - [number of factor group categories]
    <li> MS = SS/DF
    <li> F = MS<sub>Factor</sub> / MS<sub>Residuals</sub>
    <li> P Value < 0.05, then the population means are significantly different among factor groups. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences in the factor groups. (Accept null hypothesis)
  </ul>"
    ),
    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were significantly different among the 6 groups. ")),
    hr(),
    HTML("<p><b>When P < 0.05,</b> if you want to find which pairwise factor groups are significantly different, please go to next page for <b>Multiple Comparison</b></p>")



  )
),

hr()
),

##########----------##########----------##########

tabPanel("Pairwise1",

headerPanel("Multiple Comparison Post-Hoc Correction for Specific Groups after One-way ANOVA"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among pairs, given that one-way ANOVA finds significant differences among factor groups.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups/sets are independent and identically approximately normally distributed
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared
</ul>

<i><h4>Case Example</h4>
Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
NS,PS,LS,MS,and HS group had 200 people in each. NI group had 50 people. The study measured the forced mid-expiatory flow (FEF).
We wanted to the know in which pairs of the 6 groups, FEF were significantly different
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
# source("p3_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************1.1. p-one-way
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cnm", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "xm",rows = 10,
"4.21\n3.35\n3.72\n3.76\n3.67\n3.77\n2.69\n4.31\n2.87\n4.11\n3.47\n2.8\n4.14\n2.67\n5.31\n4.23\n4.52\n2.56\n4.26\n3.03\n4.85\n3.57\n1.38\n3.59\n3.56\n4.72\n3.82\n4.04\n4.2\n4.27\n3.84\n3.57\n3.05\n3.87\n2.09\n3.53\n3.19\n3.05\n4.38\n4.06\n3.12\n3.43\n3.25\n3.15\n5.05\n3.79\n2.92\n4.8\n3.67\n1.97\n3.71\n3.94\n4.75\n3.78\n2.76\n3.47\n5.15\n4.59\n3.36\n4.45\n4.43\n2.72\n4.6\n2.89\n4.33\n4.07\n4.29\n3.43\n3.1\n4.46\n3.38\n3.18\n6.47\n3.42\n5.15\n3.21\n4.2\n3.72\n2.56\n4\n5.27\n4.45\n4.04\n3.8\n2.98\n4.11\n3.17\n4.51\n4.02\n5.33\n3.04\n4.11\n3.35\n4.47\n4.69\n3.79\n3.05\n3.38\n4.75\n4.74\n2.44\n3.85\n4.38\n5.65\n3.75\n3.83\n3.9\n3.36\n2.34\n4.25\n3.85\n3.47\n2.5\n3.76\n4.1\n4.18\n5.03\n4.61\n2.95\n3.16\n4.15\n4.22\n3.24\n1.57\n2.92\n3.26\n3.01\n4.11\n3.06\n3.43\n3.15\n2.98\n4.58\n3.27\n3.81\n3.93\n4.14\n4.02\n4.01\n4.3\n3.52\n4.96\n3.92\n3.93\n3.56\n4.39\n3.51\n3.77\n3.67\n3.74\n4.83\n4.56\n5.1\n2.11\n3.89\n3.64\n4.02\n4.68\n3.88\n3.4\n2.99\n5.19\n3.09\n3.01\n2.83\n3.49\n3.79\n4.82\n4.17\n2.83\n3.09\n3.87\n4.98\n4.08\n4.8\n5.8\n2.99\n4.41\n2.96\n4.86\n3.6\n3.57\n4.08\n4.55\n5.58\n4.2\n4.17\n3.9\n3.85\n2.53\n2.57\n5.14\n3.94\n4.76\n3.97\n4.58\n4.79\n4.01\n1.88\n5.57\n2.83\n2.94\n2.16\n3.07\n3.54\n3.1\n2.25\n3.6\n3.71\n4.95\n3.46\n2.32\n2.9\n3.24\n3.79\n3.93\n2.61\n2.99\n3.93\n2.3\n3.97\n3.83\n2.64\n3.8\n4.38\n4.07\n0.96\n3.11\n4.73\n2.01\n2.82\n3.5\n3.28\n3.16\n3.12\n5.4\n1.15\n4.57\n5.31\n2.84\n3.62\n3.72\n1.67\n3.21\n3.09\n3.46\n5.12\n4.54\n4.57\n5\n2.96\n3.73\n4.21\n2.58\n3.28\n3.12\n2.36\n3.73\n3.85\n2.71\n3.63\n3.53\n2.55\n2.81\n4.01\n2.46\n3.65\n3.13\n4.32\n3.52\n2.61\n3.29\n3.63\n3.39\n2.02\n3.2\n2.61\n3.99\n4.34\n2.51\n3.7\n3.56\n3.1\n3.64\n4.35\n2.67\n3.45\n4.41\n2.53\n3.77\n3.49\n2.76\n2.1\n2.72\n4.49\n3.25\n2.56\n3.59\n1.74\n3.49\n3.32\n2.58\n3.31\n2.36\n3.83\n3.65\n3.74\n3.27\n3.68\n2.7\n4.52\n1.89\n3.55\n3.08\n3.99\n2.81\n3.41\n2.03\n1.77\n2.9\n1.79\n3.53\n3.77\n3.88\n3.28\n3.85\n4.13\n3.2\n3.86\n3.46\n4.06\n2.13\n3.29\n2.85\n3.46\n3.65\n3.81\n2.89\n3.32\n3.73\n3.62\n3.57\n2.71\n2.91\n1.92\n3.07\n2.95\n4.01\n2.22\n4.27\n3.12\n2.6\n4.41\n3.29\n2.89\n3.92\n3.04\n2.19\n4.73\n3.34\n3.34\n2.3\n2.47\n3.28\n2.75\n4.09\n4.13\n3.73\n4.52\n3.5\n4.27\n4.19\n4.59\n3.78\n2.4\n3.92\n4.23\n2.88\n4.21\n2.87\n3.85\n4.9\n3.24\n2.38\n1.29\n3.62\n3.4\n3.68\n3.47\n3.34\n3.25\n2.74\n4.46\n3.07\n3.96\n2.99\n2.75\n1.66\n3.72\n3.47\n3.45\n4.39\n3.75\n3.05\n2.85\n3.63\n4.25\n4.04\n3.09\n2.59\n2.96\n3.55\n3.59\n4.15\n2.87\n3.32\n4.14\n3.94\n2.87\n3.02\n2.29\n3.76\n3.35\n3.92\n4.04\n2.76\n3.98\n4.35\n1.45\n3.19\n3.53\n3.14\n3.58\n3.51\n2.75\n2.49\n2.21\n3.91\n5.21\n3.23\n2.83\n2.57\n4.27\n2.53\n4.37\n2.33\n2.63\n2.2\n2.85\n4.06\n3.83\n2.45\n3.5\n2.89\n3.38\n3.17\n4.33\n3.75\n3.64\n4.53\n2.95\n2.11\n4.51\n1.73\n3.47\n3.88\n2.09\n3.15\n4.11\n2.76\n2.88\n3.15\n2.97\n3.43\n3.8\n1.92\n2.64\n3.25\n1.72\n3.49\n2.94\n3.8\n2.58\n2.86\n1.35\n3.55\n2.31\n3.34\n2.48\n2.84\n3.62\n4.03\n2.62\n3.7\n2.29\n2.01\n3.48\n3.65\n3.47\n2.7\n3.31\n3.9\n2.93\n2.78\n2.52\n2.68\n3.49\n4.42\n2.66\n4.97\n3.6\n4.49\n3.41\n2.63\n3.39\n4.09\n3.02\n2.1\n3.42\n3.73\n2.68\n2.75\n3.34\n3.75\n3.67\n4.24\n1.72\n1.45\n2.27\n3.39\n3.93\n3.66\n1.57\n3.44\n3.14\n2.81\n2.99\n3.2\n3.77\n2.37\n4.93\n2.99\n3.54\n2.92\n4.66\n1.65\n2.01\n4.41\n2.44\n4.08\n2.1\n4.2\n2.89\n3.24\n3.33\n2.91\n3.67\n4.48\n2.45\n3.63\n3.51\n3.38\n4.03\n2.49\n3.6\n3.16\n2.35\n3.05\n3.2\n2.45\n3.29\n4.47\n3.56\n3.47\n3.32\n2.2\n2.52\n2.8\n2.62\n3.51\n2.98\n3.58\n3.38\n3.86\n2.33\n2.45\n4.22\n3.41\n2.12\n2.73\n3.25\n4.51\n5.21\n3.25\n3.36\n2.69\n4.68\n3.54\n2.58\n2\n3.63\n2.1\n2.33\n2.1\n2.91\n4.58\n2.81\n4.07\n2.9\n4.02\n2.41\n3.55\n3.85\n4.38\n3.35\n3.23\n3.63\n2.6\n3.63\n2.81\n3.78\n4.9\n3.78\n5.1\n2.87\n3.01\n2.52\n3.03\n2.18\n2.64\n3.18\n3.3\n2.91\n3.28\n2.6\n3.16\n3.44\n2.21\n4.08\n4.03\n2.76\n3.3\n4.38\n5.06\n1.66\n2.74\n3.58\n2.92\n3.24\n3.06\n1.77\n2.64\n2.27\n0.56\n2.57\n3.29\n4.03\n3.71\n3.33\n2.93\n3.58\n4.18\n3.85\n3.26\n4.27\n2.94\n1.82\n1.83\n2.23\n1.49\n3.61\n2.61\n2.94\n3.39\n0.89\n1.89\n1.97\n3.63\n3.23\n4.36\n1.23\n2.87\n2.46\n2.87\n2.49\n3.05\n2.57\n2.2\n2.7\n3.75\n3.46\n2.18\n1.48\n3.19\n1.77\n2.42\n1.66\n2.49\n2.52\n1.97\n3.63\n2.11\n3.14\n4.36\n4.38\n3.57\n2.82\n3.05\n2.77\n2.09\n2.3\n3.95\n3.16\n2.94\n4.27\n3.29\n2.48\n2.35\n2.88\n3.24\n1.94\n0.75\n2.8\n3.58\n2.71\n2.69\n2.54\n3.58\n2.71\n3.26\n3.74\n3.5\n2.76\n3.36\n3.23\n2.39\n3.1\n2.76\n3.05\n2.88\n3.14\n2.6\n2.78\n2.42\n2.91\n3.23\n2.63\n1.67\n3.17\n2.33\n3.13\n3.98\n3\n3.23\n3.89\n3.07\n2.45\n1.55\n2.45\n3.18\n4.2\n3.09\n2.97\n2.83\n3.85\n3.41\n2.47\n3.93\n2.9\n1.49\n4.13\n3.5\n1.84\n2.18\n2.35\n2.4\n3.39\n2.69\n3.07\n3.78\n2.14\n2.23\n4.48\n2.95\n3.67\n2.14\n2.39\n3.29\n2.57\n2.39\n2.86\n2.71\n2.85\n2.02\n2.16\n3.97\n2.75\n3.97\n3.77\n1.58\n3.51\n2.59\n2.72\n1.91\n3.49\n3.73\n4.47\n4.12\n1.68\n2.72\n2.3\n2.84\n3.4\n1.53\n2.91\n4.51\n1.66\n3.17\n3.13\n1.91\n2.82\n3.3\n2.49\n2.59\n3.63\n2.41\n3.19\n2.64\n2.7\n2.2\n3.31\n1.54\n3.72\n2.3\n2.35\n2.75\n3.44\n2.87\n3.58\n3.05\n2.75\n4.5\n2.78\n3.1\n3.31\n2.03\n1.78\n1.45\n2.19\n3.14\n4.03\n2.86\n2.38\n1.02\n1.25\n4.52\n3.43\n3.47\n3.1\n2.87\n2.78\n1.37\n2.06\n1.68\n2.93\n2.8\n2.48\n2.67\n3.11\n2.76\n1.43\n3.08\n1.85\n1.89\n2.79\n2.43\n2.95\n1.84\n2.8\n2.57\n1.76\n1.92\n0.73\n2.21\n3.24\n1.54\n2.89\n2.1\n3.37\n2.8\n2.66\n0.99\n1.36\n1.92\n2.63\n3.56\n1.82\n3.74\n2.85\n1.54\n3.65\n2.29\n3\n3.22\n2.46\n3.49\n3.56\n4.81\n1.91\n3.94\n2.75\n1.63\n2.55\n2.96\n2.43\n4.3\n3.06\n3.39\n3.47\n1.49\n3.35\n3.69\n3.71\n2.82\n1.83\n1.05\n1.67\n2.13\n3.85\n4.45\n1.53\n2.49\n2.33\n1.86\n2.89\n1.77\n2.75\n3.22\n1.82\n3.13\n2.49\n3.36\n2.35\n2.31\n0.88\n2.63\n3.45\n2.15\n2.95\n3.06\n2.86\n1.69\n3.02\n3.79\n1.3\n2.33\n2.48\n1.63\n3.17\n4.32\n2.2\n1.22\n2.01\n0.85\n2.36\n2.85\n3.8\n1.12\n2.63\n2.51\n2.64\n1.62\n3.5\n2.1\n2.6\n2.6\n3\n1.22\n2.85\n1.6\n0.34\n1.97\n4.56\n2.76\n2.24\n2.83\n2.29\n2.92\n2.03\n2.05\n3.02\n1.65\n2.08\n2.69\n2.51\n2.55\n3.25\n2.42\n2.88\n3.67\n2.22\n2.19\n2.86\n2.25\n0.88\n1.54\n3.17\n3.21\n2.58\n3.21\n2.88\n2.51\n0.04\n2.11\n2.2\n3.88\n3.48\n2.15\n2.3\n3.23\n1.16\n2.04\n1.87\n3.04\n2.84\n2.87\n2.35\n2.68\n3.31\n2.09\n2.48\n3.06\n3.77\n1.94\n4.55\n2.97\n2.11\n4.1\n2.89\n3.22\n2.14\n2.24\n2.98\n2.13\n1.65\n1.67\n0.15\n3.27\n1.59\n2.46"
),
    p(tags$b("Factor Group")),
      tags$textarea(id = "fm",rows = 10,
"NS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads the first 2-column of your data")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors" )),
    fileInput('filem', "Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("headerm", "Show Data Header?", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("colm", "Yes", TRUE),

    radioButtons("sepm",
      "Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),

hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("In one pair of factors, the means from each pair are equal"),
  p(tags$b("Alternative hypothesis")),
  p("In one pair of factors, the means from each pair are significantly different"),
  p(tags$i("In this example, we wanted to know if the FEF values were different in which pairs of the 6 smoking groups")),
hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("method",
  "Which method do you want to use? See explanations right", selected="BH",
  choiceNames = list(
    HTML("Bonferroni"),
    HTML("Bonferroni-Holm: often used"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    HTML("False Discovery Rate-BH"),
    HTML("False Discovery Rate-BY"),
    HTML("Scheffe "),
    HTML("Tukey Honest Significant Difference"),
    HTML("Dunnett")
    ),
  choiceValues = list("B", "BH", "FDR", "BY", "SF", "TH", "DT")
  )


),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
        DT::DTOutput("tablem"),
  p(tags$b("The categories in the factor group")),
  DT::DTOutput("level.t")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("basm.t")
      ),
    tabPanel("Box Plot",p(br()),

    plotOutput("mbp1m", width = "80%"),
    HTML(
    "<b> Explanations </b>
    <ul>
      <li> The band inside the box is the median
      <li> The box measures the difference between 75th and 25th percentiles
      <li> Outliers will be in red, if existing
    </ul>"

    )
      ),

    tabPanel("Marginal Means Plot",p(br()),

      plotOutput("mmeanm", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")), p(br()),

    HTML(
  "<b> Explanations </b>
  <ul>
    <li> <b>Bonferroni</b> correction is a generic but very conservative approach
    <li> <b>Bonferroni-Holm</b> is less conservative and uniformly more powerful than Bonferroni
    <li> <b>False Discovery Rate-BH</b> is more powerful than the others, developed by Benjamini and Hochberg
    <li> <b>False Discovery Rate-BY</b> is more powerful than the others, developed by Benjamini and Yekutieli
    <li> <b>Scheffe</b> procedure controls for the search over any possible contrast
    <li> <b>Tukey Honest Significant Difference</b> is preferred if there are unequal group sizes among the experimental and control groups
    <li> <b>Dunnett</b> is useful for compare all treatment groups with a control group
  </ul>"
    ),
  numericInput("control", HTML("* For Dunnett Methods, you can change the control factor from the factor groups above"),
    value = 1, min = 1, max = 20, step=1),


  p(tags$b("Pairwise P Value Table")),
  DT::DTOutput("multiple.t"),p(br()),

      HTML(
  "<b> Explanations </b>
  <ul>
    <li> In the matrix, P < 0.05 indicates the statistical significant in the pairs
    <li> In the matrix, P >= 0.05 indicates no statistically significant differences in the pairs
  </ul>"
    ),

    p(tags$i("In this example, we used Bonferroni-Holm method to explore the possible pairs with P < 0.05.
      HS was significant different from the other groups;
      LS was significantly different from MS and NS;
      MS was significantly different from NI and PS;
      NI was significantly different from NS."))  )
),
hr()
),

##########----------##########----------##########
tabPanel("Two-way",

headerPanel("Two-way ANOVA to Compare Means from Multiple Groups"),

HTML(
"
<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among the Factor1 after controlling for Factor2
<li> To determine if the means differ significantly among the Factor2 after controlling for Factor1
<li> To determine if the Factor1 and Factor2 have interaction to effect the outcomes
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups/sets are independent and identically approximately normally distributed
<li> Each mean of the factor group follows a normal distribution with the same variance and can be compared
</ul>

<i><h4>Case Example</h4>
Suppose we were interested in the effects of sex and 3 dietary groups on SPB.
The 3 dietary groups included 100 strict vegetarians (SV), 60 lactovegentarians (LV), and 100 normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the effect of dietary group and sex on the SPB and whether the two factors were related with each other.
 </h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),

hr(),

# source("p2_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2. two-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and 2 Factors Group variables ")),

  tags$textarea(id = "cn", rows = 3, "SBP\nDiet\nSex"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the full metastasis-free follow-up time (months) of 100 lymph node positive patients under 3 grades of the tumor and 2 levels of ER.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "x",rows = 10,
 "110.29\n110.79\n110.29\n110.87\n109.71\n109.85\n109.55\n110.37\n109.77\n109.97\n108.99\n110.05\n110.78\n109.41\n110.26\n110.16\n109.43\n110.05\n110.36\n110.02\n109.12\n110.2\n110.72\n109.99\n109.24\n110.16\n109.73\n110.71\n110.69\n111.05\n109.42\n110.13\n110.8\n109.74\n110.05\n109.23\n110.84\n110.03\n109.61\n109.75\n109.33\n110.02\n109.46\n110.75\n110.14\n109.24\n109.13\n109.43\n111.03\n109.65\n110.73\n109.83\n109.01\n110.36\n109.67\n109.57\n109.47\n110.78\n108.87\n109.04\n110.73\n110.2\n110.71\n110.34\n110.63\n108.63\n110.42\n109.06\n109.99\n109.67\n102.89\n103.99\n102.36\n101.88\n102.39\n101.41\n103.11\n102.2\n102.02\n101.49\n102.73\n103.05\n102.96\n104.27\n103.59\n101.46\n103.77\n102.8\n102.56\n102.51\n103.07\n102.19\n102.48\n102.75\n102.34\n103.16\n103.46\n102.14\n102.88\n102.52\n115.53\n115.32\n115.22\n115.56\n115.68\n115.3\n115.05\n115.79\n115.27\n115.35\n115.81\n115.66\n116.16\n115.49\n115.45\n115.99\n114.47\n116.69\n114.98\n116.38\n115.33\n116.58\n115.67\n115.34\n115.75\n115.67\n115.93\n115.27\n116.17\n115.71\n105.3\n105.57\n105.59\n105.72\n104.02\n105.95\n106.26\n103.9\n104.92\n104.06\n105.77\n104.92\n105.27\n104.78\n105.31\n105.36\n105.54\n105.2\n104.17\n105.37\n105.07\n104.67\n105.67\n104.84\n105.46\n105.9\n104.69\n106.1\n105.31\n104.83\n127.11\n127.14\n128.31\n129.25\n129.51\n129.17\n128.97\n127.75\n128.46\n130.18\n128.21\n128.44\n127.83\n128.07\n128.27\n128.41\n127.45\n128.46\n128.76\n128.63\n127.88\n128.69\n125.62\n128.92\n127.57\n128.78\n128.85\n128.41\n129.07\n127.59\n127.07\n128.78\n129.92\n127.46\n128.19\n127.37\n127.43\n129.07\n127.36\n126.17\n128.38\n128.3\n128.74\n127.94\n128.07\n129.86\n127.32\n127.14\n128.68\n128.35\n129.62\n126.94\n128.41\n129.63\n128.63\n119.75\n120.21\n120\n119.42\n121.13\n119.41\n120.13\n119.66\n120.2\n119.82\n119.57\n119.49\n119.23\n119.56\n119.34\n120.13\n119.48\n120.62\n119.93\n121.9\n119.66\n121.26\n119.8\n118.92\n120.36\n120.67\n119.16\n119.94\n118.35\n118.99\n118.76\n119.74\n119.52\n120.68\n119.23\n119.93\n120.66\n120.34\n119.88\n120.4\n120.79\n119.63\n118.95\n120.1\n119.42"
),
    p(tags$b("Factor 1")),
      tags$textarea(id = "f1",rows = 10,
"SV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM"
),
      p(tags$b("Factor 2")),
      tags$textarea(id = "f2",rows = 10,
"Male\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale"
),

    p("Missing value is input as NA to ensure 3 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads the first 3-column of your data")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors / group variables" )),
    fileInput('file', "1. Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("header", "Show Data Header?", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("col", "Yes", TRUE),

    radioButtons("sep",
      "4. Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("1. The population means under the first factor are equal."),
  p("2. The population means under the second factor are equal"),
  p("3. There is no interaction between the two factors"),
  p(tags$b("Alternative hypothesis")),
  p("1. The first factor effects."),
  p("2. The second factor effects"),
  p("3. There is interaction between the two factors"),

  p(tags$i("In this example, we wanted to know if the metastasis-free follow-up time was different with grade of the tumor under the controlling for ER"))
),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
  DT::DTOutput("table"),
  p(tags$b("The categories in the Factor 1")),
  DT::DTOutput("level.t21"),
  p(tags$b("The categories in the Factor 2")),
  DT::DTOutput("level.t22")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("bas.t")
      ),

      tabPanel("Means plot",p(br()),
      checkboxInput('tickm', 'Tick to change the factor group', FALSE), #p
      plotOutput("meanp.am", width = "80%")
    ),

      tabPanel("Marginal means plot",p(br()),
      checkboxInput('tick2m', 'Tick to change the factor group', FALSE), #p
      plotOutput("mmean.am", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. ANOVA Table")), p(br()),

  checkboxInput('inter', 'Interaction', TRUE),
  DT::DTOutput("anova"),p(br()),
  HTML(
  "<b> Explanations </b>
  <ul>
    <li> DF<sub>Factor</sub> = [number of factor group categories] -1
    <li> DF<sub>Interaction</sub> = DF<sub>Factor1</sub> x DF<sub>Factor2</sub>
    <li> DF<sub>Residuals</sub> = [number of sample values] - [number of factor1 group categories] x [number of factor2 group categories]
    <li> MS = SS/DF
    <li> F = MS<sub>Factor</sub> / MS<sub>Residuals</sub>
    <li> P Value < 0.05, then the population means are significantly different among factor groups. (Accept alternative hypothesis)
    <li> P Value >= 0.05, then there is NO significant differences in the factor groups. (Accept null hypothesis)
  </ul>"
    ),

  p(tags$i("In this example, dietary types and sex both have effects on the SBP (P<0.001), and dietary types also significantly related with sex (P<0.001). "))#,
  )
),
hr()
),
#
##########----------##########----------##########
tabPanel("Pairwise2",

headerPanel("Multiple Comparison Post-Hoc Correction for Specific Groups after Two-way ANOVA"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among which pairs, given that two-way ANOVA finds significant differences among groups.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups are independent and identically approximately normally distributed
<li> Each mean of the factor groups follows a normal distribution with the same variance and can be compared
</ul>

<i><h4>Case Example</h4>
Suppose we were interested in the effects of sex and 3 dietary groups on SPB.
The 3 dietary groups included 100 strict vegetarians (SV), 60 lactovegentarians (LV), and 100 normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the pairwise effect of dietary group and sex on the SPB. For example, which two of dietary group had significant difference, and whether male and female had significant difference.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
# source("p4_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************2.1. p-two-way
sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and 2 Factors Group variables ")),

  tags$textarea(id = "cnm2", rows = 2, "SBP\nDiet\nSex"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the full metastasis-free follow-up time (months) of 100 lymph node positive patients with Grade of the tumor (three ordered levels).")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),
    p(tags$b("Sample Values")),
      tags$textarea(id = "xm2",rows = 10,
 "110.29\n110.79\n110.29\n110.87\n109.71\n109.85\n109.55\n110.37\n109.77\n109.97\n108.99\n110.05\n110.78\n109.41\n110.26\n110.16\n109.43\n110.05\n110.36\n110.02\n109.12\n110.2\n110.72\n109.99\n109.24\n110.16\n109.73\n110.71\n110.69\n111.05\n109.42\n110.13\n110.8\n109.74\n110.05\n109.23\n110.84\n110.03\n109.61\n109.75\n109.33\n110.02\n109.46\n110.75\n110.14\n109.24\n109.13\n109.43\n111.03\n109.65\n110.73\n109.83\n109.01\n110.36\n109.67\n109.57\n109.47\n110.78\n108.87\n109.04\n110.73\n110.2\n110.71\n110.34\n110.63\n108.63\n110.42\n109.06\n109.99\n109.67\n102.89\n103.99\n102.36\n101.88\n102.39\n101.41\n103.11\n102.2\n102.02\n101.49\n102.73\n103.05\n102.96\n104.27\n103.59\n101.46\n103.77\n102.8\n102.56\n102.51\n103.07\n102.19\n102.48\n102.75\n102.34\n103.16\n103.46\n102.14\n102.88\n102.52\n115.53\n115.32\n115.22\n115.56\n115.68\n115.3\n115.05\n115.79\n115.27\n115.35\n115.81\n115.66\n116.16\n115.49\n115.45\n115.99\n114.47\n116.69\n114.98\n116.38\n115.33\n116.58\n115.67\n115.34\n115.75\n115.67\n115.93\n115.27\n116.17\n115.71\n105.3\n105.57\n105.59\n105.72\n104.02\n105.95\n106.26\n103.9\n104.92\n104.06\n105.77\n104.92\n105.27\n104.78\n105.31\n105.36\n105.54\n105.2\n104.17\n105.37\n105.07\n104.67\n105.67\n104.84\n105.46\n105.9\n104.69\n106.1\n105.31\n104.83\n127.11\n127.14\n128.31\n129.25\n129.51\n129.17\n128.97\n127.75\n128.46\n130.18\n128.21\n128.44\n127.83\n128.07\n128.27\n128.41\n127.45\n128.46\n128.76\n128.63\n127.88\n128.69\n125.62\n128.92\n127.57\n128.78\n128.85\n128.41\n129.07\n127.59\n127.07\n128.78\n129.92\n127.46\n128.19\n127.37\n127.43\n129.07\n127.36\n126.17\n128.38\n128.3\n128.74\n127.94\n128.07\n129.86\n127.32\n127.14\n128.68\n128.35\n129.62\n126.94\n128.41\n129.63\n128.63\n119.75\n120.21\n120\n119.42\n121.13\n119.41\n120.13\n119.66\n120.2\n119.82\n119.57\n119.49\n119.23\n119.56\n119.34\n120.13\n119.48\n120.62\n119.93\n121.9\n119.66\n121.26\n119.8\n118.92\n120.36\n120.67\n119.16\n119.94\n118.35\n118.99\n118.76\n119.74\n119.52\n120.68\n119.23\n119.93\n120.66\n120.34\n119.88\n120.4\n120.79\n119.63\n118.95\n120.1\n119.42"
),
    p(tags$b("Factor 1")),
      tags$textarea(id = "fm1",rows = 10,
"SV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nSV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nLV\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM\nNORM"
),
      p(tags$b("Factor 2")),
      tags$textarea(id = "fm2",rows = 10,
"Male\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nMale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale\nFemale"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads the first 2-column of your data")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors" )),
    fileInput('filem2', "1. Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("headerm2", "Show Data Header?", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("colm2", "Yes", TRUE),

    radioButtons("sepm2",
      "Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),

hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two groups have significant different means"),
  p(tags$i("In this example, we wanted to know if the metastasis-free follow-up time was different with grade of the tumor (three ordered levels)")),
hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("methodm2",
  "Which method do you want to use? See explanations right",
  choiceNames = list(
    #HTML("Bonferroni"),
    #HTML("Bonferroni-Holm: often used"),
    #HTML("Bonferroni-Hochberg"),
    #HTML("Bonferroni-Hommel"),
    #HTML("False Discovery Rate-BH"),
    #HTML("False Discovery Rate-BY"),
    HTML("Scheffe "),
    HTML("Tukey Honest Significant Difference")
    #HTML("Dunnett")
    ),
  choiceValues = list("SF", "TH")
  )


),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
        DT::DTOutput("tablem2"),
          p(tags$b("The categories in the Factor 1")),
  DT::DTOutput("level.t21m"),
  p(tags$b("The categories in the Factor 2")),
  DT::DTOutput("level.t22m")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("basm.t2")
      ),

    tabPanel("Marginal Means Plot",p(br()),

      plotOutput("mmeanm2", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")), p(br()),

    HTML(
  "<b> Explanations </b>
  <ul>
    <li> <b>Scheffe</b> procedure controls for the search over any possible contrast
    <li> <b>Tukey Honest Significant Difference</b> is preferred if there are unequal group sizes among the experimental and control groups
  </ul>"
    ),

  p(tags$b("Pairwise P Value Table under Each Factor")),
  DT::DTOutput("multiple.t2"),p(br()),

        HTML(
  "<b> Explanations </b>
  <ul>
    <li> In the matrix, P < 0.05 indicates the statistical significant in the pairs
    <li> In the matrix, P >= 0.05 indicates no statistically significant differences in the pairs
  </ul>"
    ),

    p(tags$i("In this example, all the pairs, normal vs LV, SV vs LV, SV vs normal, and male vs female had significant differences on SBP."))#,
  )
),
hr()
),

##########----------##########----------##########
tabPanel("One-way (Non-parametric)",

headerPanel("Kruskal-Wallis Non-parametric Test to Compare Multiple Samples"),

HTML(
"
<b>This method compares ranks of the observed data, rather than mean and SD. An alternative to one-way ANOVA without assumption on the data distribution</b>

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among the factor groups
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups shown in two vectors
<li> One vector is the observed values; one vector is to mark your values in different factor groups
<li> The separate factor groups are independent and identically without distribution assumption
</ul>

<i><h4>Case Example</h4>
Suppose we want to find whether passive smoking had a measurable effect on the incidence of cancer. In a study, we studied 6 group of smokers: nonsmokers (NS), passive smokers (PS), non-inhaling smokers (NI), light smokers (LS), moderate smokers (MS), and heavy smokers (HS).
NS,PS,LS,MS,and HS group had 200 people in each. NI group had 50 people. The study measured the forced mid-expiatory flow (FEF).
We wanted to the know the FEF differences among the 6 groups.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
# source("p5_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************3. np-one-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cnnp1", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),

    p(tags$b("Sample Values")),
      tags$textarea(id = "xnp1",rows = 10,
"4.21\n3.35\n3.72\n3.76\n3.67\n3.77\n2.69\n4.31\n2.87\n4.11\n3.47\n2.8\n4.14\n2.67\n5.31\n4.23\n4.52\n2.56\n4.26\n3.03\n4.85\n3.57\n1.38\n3.59\n3.56\n4.72\n3.82\n4.04\n4.2\n4.27\n3.84\n3.57\n3.05\n3.87\n2.09\n3.53\n3.19\n3.05\n4.38\n4.06\n3.12\n3.43\n3.25\n3.15\n5.05\n3.79\n2.92\n4.8\n3.67\n1.97\n3.71\n3.94\n4.75\n3.78\n2.76\n3.47\n5.15\n4.59\n3.36\n4.45\n4.43\n2.72\n4.6\n2.89\n4.33\n4.07\n4.29\n3.43\n3.1\n4.46\n3.38\n3.18\n6.47\n3.42\n5.15\n3.21\n4.2\n3.72\n2.56\n4\n5.27\n4.45\n4.04\n3.8\n2.98\n4.11\n3.17\n4.51\n4.02\n5.33\n3.04\n4.11\n3.35\n4.47\n4.69\n3.79\n3.05\n3.38\n4.75\n4.74\n2.44\n3.85\n4.38\n5.65\n3.75\n3.83\n3.9\n3.36\n2.34\n4.25\n3.85\n3.47\n2.5\n3.76\n4.1\n4.18\n5.03\n4.61\n2.95\n3.16\n4.15\n4.22\n3.24\n1.57\n2.92\n3.26\n3.01\n4.11\n3.06\n3.43\n3.15\n2.98\n4.58\n3.27\n3.81\n3.93\n4.14\n4.02\n4.01\n4.3\n3.52\n4.96\n3.92\n3.93\n3.56\n4.39\n3.51\n3.77\n3.67\n3.74\n4.83\n4.56\n5.1\n2.11\n3.89\n3.64\n4.02\n4.68\n3.88\n3.4\n2.99\n5.19\n3.09\n3.01\n2.83\n3.49\n3.79\n4.82\n4.17\n2.83\n3.09\n3.87\n4.98\n4.08\n4.8\n5.8\n2.99\n4.41\n2.96\n4.86\n3.6\n3.57\n4.08\n4.55\n5.58\n4.2\n4.17\n3.9\n3.85\n2.53\n2.57\n5.14\n3.94\n4.76\n3.97\n4.58\n4.79\n4.01\n1.88\n5.57\n2.83\n2.94\n2.16\n3.07\n3.54\n3.1\n2.25\n3.6\n3.71\n4.95\n3.46\n2.32\n2.9\n3.24\n3.79\n3.93\n2.61\n2.99\n3.93\n2.3\n3.97\n3.83\n2.64\n3.8\n4.38\n4.07\n0.96\n3.11\n4.73\n2.01\n2.82\n3.5\n3.28\n3.16\n3.12\n5.4\n1.15\n4.57\n5.31\n2.84\n3.62\n3.72\n1.67\n3.21\n3.09\n3.46\n5.12\n4.54\n4.57\n5\n2.96\n3.73\n4.21\n2.58\n3.28\n3.12\n2.36\n3.73\n3.85\n2.71\n3.63\n3.53\n2.55\n2.81\n4.01\n2.46\n3.65\n3.13\n4.32\n3.52\n2.61\n3.29\n3.63\n3.39\n2.02\n3.2\n2.61\n3.99\n4.34\n2.51\n3.7\n3.56\n3.1\n3.64\n4.35\n2.67\n3.45\n4.41\n2.53\n3.77\n3.49\n2.76\n2.1\n2.72\n4.49\n3.25\n2.56\n3.59\n1.74\n3.49\n3.32\n2.58\n3.31\n2.36\n3.83\n3.65\n3.74\n3.27\n3.68\n2.7\n4.52\n1.89\n3.55\n3.08\n3.99\n2.81\n3.41\n2.03\n1.77\n2.9\n1.79\n3.53\n3.77\n3.88\n3.28\n3.85\n4.13\n3.2\n3.86\n3.46\n4.06\n2.13\n3.29\n2.85\n3.46\n3.65\n3.81\n2.89\n3.32\n3.73\n3.62\n3.57\n2.71\n2.91\n1.92\n3.07\n2.95\n4.01\n2.22\n4.27\n3.12\n2.6\n4.41\n3.29\n2.89\n3.92\n3.04\n2.19\n4.73\n3.34\n3.34\n2.3\n2.47\n3.28\n2.75\n4.09\n4.13\n3.73\n4.52\n3.5\n4.27\n4.19\n4.59\n3.78\n2.4\n3.92\n4.23\n2.88\n4.21\n2.87\n3.85\n4.9\n3.24\n2.38\n1.29\n3.62\n3.4\n3.68\n3.47\n3.34\n3.25\n2.74\n4.46\n3.07\n3.96\n2.99\n2.75\n1.66\n3.72\n3.47\n3.45\n4.39\n3.75\n3.05\n2.85\n3.63\n4.25\n4.04\n3.09\n2.59\n2.96\n3.55\n3.59\n4.15\n2.87\n3.32\n4.14\n3.94\n2.87\n3.02\n2.29\n3.76\n3.35\n3.92\n4.04\n2.76\n3.98\n4.35\n1.45\n3.19\n3.53\n3.14\n3.58\n3.51\n2.75\n2.49\n2.21\n3.91\n5.21\n3.23\n2.83\n2.57\n4.27\n2.53\n4.37\n2.33\n2.63\n2.2\n2.85\n4.06\n3.83\n2.45\n3.5\n2.89\n3.38\n3.17\n4.33\n3.75\n3.64\n4.53\n2.95\n2.11\n4.51\n1.73\n3.47\n3.88\n2.09\n3.15\n4.11\n2.76\n2.88\n3.15\n2.97\n3.43\n3.8\n1.92\n2.64\n3.25\n1.72\n3.49\n2.94\n3.8\n2.58\n2.86\n1.35\n3.55\n2.31\n3.34\n2.48\n2.84\n3.62\n4.03\n2.62\n3.7\n2.29\n2.01\n3.48\n3.65\n3.47\n2.7\n3.31\n3.9\n2.93\n2.78\n2.52\n2.68\n3.49\n4.42\n2.66\n4.97\n3.6\n4.49\n3.41\n2.63\n3.39\n4.09\n3.02\n2.1\n3.42\n3.73\n2.68\n2.75\n3.34\n3.75\n3.67\n4.24\n1.72\n1.45\n2.27\n3.39\n3.93\n3.66\n1.57\n3.44\n3.14\n2.81\n2.99\n3.2\n3.77\n2.37\n4.93\n2.99\n3.54\n2.92\n4.66\n1.65\n2.01\n4.41\n2.44\n4.08\n2.1\n4.2\n2.89\n3.24\n3.33\n2.91\n3.67\n4.48\n2.45\n3.63\n3.51\n3.38\n4.03\n2.49\n3.6\n3.16\n2.35\n3.05\n3.2\n2.45\n3.29\n4.47\n3.56\n3.47\n3.32\n2.2\n2.52\n2.8\n2.62\n3.51\n2.98\n3.58\n3.38\n3.86\n2.33\n2.45\n4.22\n3.41\n2.12\n2.73\n3.25\n4.51\n5.21\n3.25\n3.36\n2.69\n4.68\n3.54\n2.58\n2\n3.63\n2.1\n2.33\n2.1\n2.91\n4.58\n2.81\n4.07\n2.9\n4.02\n2.41\n3.55\n3.85\n4.38\n3.35\n3.23\n3.63\n2.6\n3.63\n2.81\n3.78\n4.9\n3.78\n5.1\n2.87\n3.01\n2.52\n3.03\n2.18\n2.64\n3.18\n3.3\n2.91\n3.28\n2.6\n3.16\n3.44\n2.21\n4.08\n4.03\n2.76\n3.3\n4.38\n5.06\n1.66\n2.74\n3.58\n2.92\n3.24\n3.06\n1.77\n2.64\n2.27\n0.56\n2.57\n3.29\n4.03\n3.71\n3.33\n2.93\n3.58\n4.18\n3.85\n3.26\n4.27\n2.94\n1.82\n1.83\n2.23\n1.49\n3.61\n2.61\n2.94\n3.39\n0.89\n1.89\n1.97\n3.63\n3.23\n4.36\n1.23\n2.87\n2.46\n2.87\n2.49\n3.05\n2.57\n2.2\n2.7\n3.75\n3.46\n2.18\n1.48\n3.19\n1.77\n2.42\n1.66\n2.49\n2.52\n1.97\n3.63\n2.11\n3.14\n4.36\n4.38\n3.57\n2.82\n3.05\n2.77\n2.09\n2.3\n3.95\n3.16\n2.94\n4.27\n3.29\n2.48\n2.35\n2.88\n3.24\n1.94\n0.75\n2.8\n3.58\n2.71\n2.69\n2.54\n3.58\n2.71\n3.26\n3.74\n3.5\n2.76\n3.36\n3.23\n2.39\n3.1\n2.76\n3.05\n2.88\n3.14\n2.6\n2.78\n2.42\n2.91\n3.23\n2.63\n1.67\n3.17\n2.33\n3.13\n3.98\n3\n3.23\n3.89\n3.07\n2.45\n1.55\n2.45\n3.18\n4.2\n3.09\n2.97\n2.83\n3.85\n3.41\n2.47\n3.93\n2.9\n1.49\n4.13\n3.5\n1.84\n2.18\n2.35\n2.4\n3.39\n2.69\n3.07\n3.78\n2.14\n2.23\n4.48\n2.95\n3.67\n2.14\n2.39\n3.29\n2.57\n2.39\n2.86\n2.71\n2.85\n2.02\n2.16\n3.97\n2.75\n3.97\n3.77\n1.58\n3.51\n2.59\n2.72\n1.91\n3.49\n3.73\n4.47\n4.12\n1.68\n2.72\n2.3\n2.84\n3.4\n1.53\n2.91\n4.51\n1.66\n3.17\n3.13\n1.91\n2.82\n3.3\n2.49\n2.59\n3.63\n2.41\n3.19\n2.64\n2.7\n2.2\n3.31\n1.54\n3.72\n2.3\n2.35\n2.75\n3.44\n2.87\n3.58\n3.05\n2.75\n4.5\n2.78\n3.1\n3.31\n2.03\n1.78\n1.45\n2.19\n3.14\n4.03\n2.86\n2.38\n1.02\n1.25\n4.52\n3.43\n3.47\n3.1\n2.87\n2.78\n1.37\n2.06\n1.68\n2.93\n2.8\n2.48\n2.67\n3.11\n2.76\n1.43\n3.08\n1.85\n1.89\n2.79\n2.43\n2.95\n1.84\n2.8\n2.57\n1.76\n1.92\n0.73\n2.21\n3.24\n1.54\n2.89\n2.1\n3.37\n2.8\n2.66\n0.99\n1.36\n1.92\n2.63\n3.56\n1.82\n3.74\n2.85\n1.54\n3.65\n2.29\n3\n3.22\n2.46\n3.49\n3.56\n4.81\n1.91\n3.94\n2.75\n1.63\n2.55\n2.96\n2.43\n4.3\n3.06\n3.39\n3.47\n1.49\n3.35\n3.69\n3.71\n2.82\n1.83\n1.05\n1.67\n2.13\n3.85\n4.45\n1.53\n2.49\n2.33\n1.86\n2.89\n1.77\n2.75\n3.22\n1.82\n3.13\n2.49\n3.36\n2.35\n2.31\n0.88\n2.63\n3.45\n2.15\n2.95\n3.06\n2.86\n1.69\n3.02\n3.79\n1.3\n2.33\n2.48\n1.63\n3.17\n4.32\n2.2\n1.22\n2.01\n0.85\n2.36\n2.85\n3.8\n1.12\n2.63\n2.51\n2.64\n1.62\n3.5\n2.1\n2.6\n2.6\n3\n1.22\n2.85\n1.6\n0.34\n1.97\n4.56\n2.76\n2.24\n2.83\n2.29\n2.92\n2.03\n2.05\n3.02\n1.65\n2.08\n2.69\n2.51\n2.55\n3.25\n2.42\n2.88\n3.67\n2.22\n2.19\n2.86\n2.25\n0.88\n1.54\n3.17\n3.21\n2.58\n3.21\n2.88\n2.51\n0.04\n2.11\n2.2\n3.88\n3.48\n2.15\n2.3\n3.23\n1.16\n2.04\n1.87\n3.04\n2.84\n2.87\n2.35\n2.68\n3.31\n2.09\n2.48\n3.06\n3.77\n1.94\n4.55\n2.97\n2.11\n4.1\n2.89\n3.22\n2.14\n2.24\n2.98\n2.13\n1.65\n1.67\n0.15\n3.27\n1.59\n2.46"
),
    p(tags$b("Factor group")),
      tags$textarea(id = "fnp1",rows = 10,

"NS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads 2 columns from your data file")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors" )),
    fileInput('filenp1', "Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("headernp1", "Show Data Header?", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("colnp1", "Yes", TRUE),

    radioButtons("sepnp1",
      "Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups"))

),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
  DT::DTOutput("tablenp1"),
  p(tags$b("The categories in the Factor Group")),
  DT::DTOutput("level.tnp1")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("basnp1.t")
      ),

    tabPanel("Box-Plot",p(br()),

      plotOutput("mmeannp1", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")), p(br()),

  DT::DTOutput("kwtest"),p(br()),

    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were significantly different among the 6 groups from Kruskal-Wallis rank sum test. ")),

    hr(),
    HTML("<p><b>When P < 0.05,</b> if you want to find which pairwise factor groups are significantly different, please go to next page for <b>Multiple Comparison</b></p>")



  )
),
hr()
),

##########----------##########----------##########
tabPanel("Pairwise3",

headerPanel("Multiple Comparison Post-Hoc Correction for Specific Groups after Kruskal-Wallis Non-parametric Test"),

HTML(
"

<h4><b> 1. What you can do on this page  </b></h4>
<ul>
<li> To determine if the means differ significantly among pairs, given that one-way ANOVA finds significant differences among groups.
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain several separate factor groups (or 2 vectors)
<li> The separate factor groups are independent and identically approximately normally distributed
<li> Each mean of the factor groups follows a normal distribution with the same variance and can be compared
</ul>

<i><h4>Case Example</h4>
Suppose we were interested in the effects of sex and 3 dietary groups on SPB.
The 3 dietary groups included 100 strict vegetarians (SV), 60 lactovegentarians (LV), and 100 normal (NOR) people, and we tested the SBP.
The effects of sex and and dietary group might be related (interact) with each other.
We wanted to know the pairwise effect of dietary group and sex on the SPB. For example, which two of dietary group had significant difference, and whether male and female had significant difference.
</h4></i>


<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
"
),
hr(),
# source("p6_ui.R", local=TRUE)$value
#****************************************************************************************************************************************************3.1. p-np-one-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")),

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cnnp2", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),

    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1.")),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),
    p(tags$b("Sample Values")),
      tags$textarea(id = "xnp2",rows = 10,
"4.21\n3.35\n3.72\n3.76\n3.67\n3.77\n2.69\n4.31\n2.87\n4.11\n3.47\n2.8\n4.14\n2.67\n5.31\n4.23\n4.52\n2.56\n4.26\n3.03\n4.85\n3.57\n1.38\n3.59\n3.56\n4.72\n3.82\n4.04\n4.2\n4.27\n3.84\n3.57\n3.05\n3.87\n2.09\n3.53\n3.19\n3.05\n4.38\n4.06\n3.12\n3.43\n3.25\n3.15\n5.05\n3.79\n2.92\n4.8\n3.67\n1.97\n3.71\n3.94\n4.75\n3.78\n2.76\n3.47\n5.15\n4.59\n3.36\n4.45\n4.43\n2.72\n4.6\n2.89\n4.33\n4.07\n4.29\n3.43\n3.1\n4.46\n3.38\n3.18\n6.47\n3.42\n5.15\n3.21\n4.2\n3.72\n2.56\n4\n5.27\n4.45\n4.04\n3.8\n2.98\n4.11\n3.17\n4.51\n4.02\n5.33\n3.04\n4.11\n3.35\n4.47\n4.69\n3.79\n3.05\n3.38\n4.75\n4.74\n2.44\n3.85\n4.38\n5.65\n3.75\n3.83\n3.9\n3.36\n2.34\n4.25\n3.85\n3.47\n2.5\n3.76\n4.1\n4.18\n5.03\n4.61\n2.95\n3.16\n4.15\n4.22\n3.24\n1.57\n2.92\n3.26\n3.01\n4.11\n3.06\n3.43\n3.15\n2.98\n4.58\n3.27\n3.81\n3.93\n4.14\n4.02\n4.01\n4.3\n3.52\n4.96\n3.92\n3.93\n3.56\n4.39\n3.51\n3.77\n3.67\n3.74\n4.83\n4.56\n5.1\n2.11\n3.89\n3.64\n4.02\n4.68\n3.88\n3.4\n2.99\n5.19\n3.09\n3.01\n2.83\n3.49\n3.79\n4.82\n4.17\n2.83\n3.09\n3.87\n4.98\n4.08\n4.8\n5.8\n2.99\n4.41\n2.96\n4.86\n3.6\n3.57\n4.08\n4.55\n5.58\n4.2\n4.17\n3.9\n3.85\n2.53\n2.57\n5.14\n3.94\n4.76\n3.97\n4.58\n4.79\n4.01\n1.88\n5.57\n2.83\n2.94\n2.16\n3.07\n3.54\n3.1\n2.25\n3.6\n3.71\n4.95\n3.46\n2.32\n2.9\n3.24\n3.79\n3.93\n2.61\n2.99\n3.93\n2.3\n3.97\n3.83\n2.64\n3.8\n4.38\n4.07\n0.96\n3.11\n4.73\n2.01\n2.82\n3.5\n3.28\n3.16\n3.12\n5.4\n1.15\n4.57\n5.31\n2.84\n3.62\n3.72\n1.67\n3.21\n3.09\n3.46\n5.12\n4.54\n4.57\n5\n2.96\n3.73\n4.21\n2.58\n3.28\n3.12\n2.36\n3.73\n3.85\n2.71\n3.63\n3.53\n2.55\n2.81\n4.01\n2.46\n3.65\n3.13\n4.32\n3.52\n2.61\n3.29\n3.63\n3.39\n2.02\n3.2\n2.61\n3.99\n4.34\n2.51\n3.7\n3.56\n3.1\n3.64\n4.35\n2.67\n3.45\n4.41\n2.53\n3.77\n3.49\n2.76\n2.1\n2.72\n4.49\n3.25\n2.56\n3.59\n1.74\n3.49\n3.32\n2.58\n3.31\n2.36\n3.83\n3.65\n3.74\n3.27\n3.68\n2.7\n4.52\n1.89\n3.55\n3.08\n3.99\n2.81\n3.41\n2.03\n1.77\n2.9\n1.79\n3.53\n3.77\n3.88\n3.28\n3.85\n4.13\n3.2\n3.86\n3.46\n4.06\n2.13\n3.29\n2.85\n3.46\n3.65\n3.81\n2.89\n3.32\n3.73\n3.62\n3.57\n2.71\n2.91\n1.92\n3.07\n2.95\n4.01\n2.22\n4.27\n3.12\n2.6\n4.41\n3.29\n2.89\n3.92\n3.04\n2.19\n4.73\n3.34\n3.34\n2.3\n2.47\n3.28\n2.75\n4.09\n4.13\n3.73\n4.52\n3.5\n4.27\n4.19\n4.59\n3.78\n2.4\n3.92\n4.23\n2.88\n4.21\n2.87\n3.85\n4.9\n3.24\n2.38\n1.29\n3.62\n3.4\n3.68\n3.47\n3.34\n3.25\n2.74\n4.46\n3.07\n3.96\n2.99\n2.75\n1.66\n3.72\n3.47\n3.45\n4.39\n3.75\n3.05\n2.85\n3.63\n4.25\n4.04\n3.09\n2.59\n2.96\n3.55\n3.59\n4.15\n2.87\n3.32\n4.14\n3.94\n2.87\n3.02\n2.29\n3.76\n3.35\n3.92\n4.04\n2.76\n3.98\n4.35\n1.45\n3.19\n3.53\n3.14\n3.58\n3.51\n2.75\n2.49\n2.21\n3.91\n5.21\n3.23\n2.83\n2.57\n4.27\n2.53\n4.37\n2.33\n2.63\n2.2\n2.85\n4.06\n3.83\n2.45\n3.5\n2.89\n3.38\n3.17\n4.33\n3.75\n3.64\n4.53\n2.95\n2.11\n4.51\n1.73\n3.47\n3.88\n2.09\n3.15\n4.11\n2.76\n2.88\n3.15\n2.97\n3.43\n3.8\n1.92\n2.64\n3.25\n1.72\n3.49\n2.94\n3.8\n2.58\n2.86\n1.35\n3.55\n2.31\n3.34\n2.48\n2.84\n3.62\n4.03\n2.62\n3.7\n2.29\n2.01\n3.48\n3.65\n3.47\n2.7\n3.31\n3.9\n2.93\n2.78\n2.52\n2.68\n3.49\n4.42\n2.66\n4.97\n3.6\n4.49\n3.41\n2.63\n3.39\n4.09\n3.02\n2.1\n3.42\n3.73\n2.68\n2.75\n3.34\n3.75\n3.67\n4.24\n1.72\n1.45\n2.27\n3.39\n3.93\n3.66\n1.57\n3.44\n3.14\n2.81\n2.99\n3.2\n3.77\n2.37\n4.93\n2.99\n3.54\n2.92\n4.66\n1.65\n2.01\n4.41\n2.44\n4.08\n2.1\n4.2\n2.89\n3.24\n3.33\n2.91\n3.67\n4.48\n2.45\n3.63\n3.51\n3.38\n4.03\n2.49\n3.6\n3.16\n2.35\n3.05\n3.2\n2.45\n3.29\n4.47\n3.56\n3.47\n3.32\n2.2\n2.52\n2.8\n2.62\n3.51\n2.98\n3.58\n3.38\n3.86\n2.33\n2.45\n4.22\n3.41\n2.12\n2.73\n3.25\n4.51\n5.21\n3.25\n3.36\n2.69\n4.68\n3.54\n2.58\n2\n3.63\n2.1\n2.33\n2.1\n2.91\n4.58\n2.81\n4.07\n2.9\n4.02\n2.41\n3.55\n3.85\n4.38\n3.35\n3.23\n3.63\n2.6\n3.63\n2.81\n3.78\n4.9\n3.78\n5.1\n2.87\n3.01\n2.52\n3.03\n2.18\n2.64\n3.18\n3.3\n2.91\n3.28\n2.6\n3.16\n3.44\n2.21\n4.08\n4.03\n2.76\n3.3\n4.38\n5.06\n1.66\n2.74\n3.58\n2.92\n3.24\n3.06\n1.77\n2.64\n2.27\n0.56\n2.57\n3.29\n4.03\n3.71\n3.33\n2.93\n3.58\n4.18\n3.85\n3.26\n4.27\n2.94\n1.82\n1.83\n2.23\n1.49\n3.61\n2.61\n2.94\n3.39\n0.89\n1.89\n1.97\n3.63\n3.23\n4.36\n1.23\n2.87\n2.46\n2.87\n2.49\n3.05\n2.57\n2.2\n2.7\n3.75\n3.46\n2.18\n1.48\n3.19\n1.77\n2.42\n1.66\n2.49\n2.52\n1.97\n3.63\n2.11\n3.14\n4.36\n4.38\n3.57\n2.82\n3.05\n2.77\n2.09\n2.3\n3.95\n3.16\n2.94\n4.27\n3.29\n2.48\n2.35\n2.88\n3.24\n1.94\n0.75\n2.8\n3.58\n2.71\n2.69\n2.54\n3.58\n2.71\n3.26\n3.74\n3.5\n2.76\n3.36\n3.23\n2.39\n3.1\n2.76\n3.05\n2.88\n3.14\n2.6\n2.78\n2.42\n2.91\n3.23\n2.63\n1.67\n3.17\n2.33\n3.13\n3.98\n3\n3.23\n3.89\n3.07\n2.45\n1.55\n2.45\n3.18\n4.2\n3.09\n2.97\n2.83\n3.85\n3.41\n2.47\n3.93\n2.9\n1.49\n4.13\n3.5\n1.84\n2.18\n2.35\n2.4\n3.39\n2.69\n3.07\n3.78\n2.14\n2.23\n4.48\n2.95\n3.67\n2.14\n2.39\n3.29\n2.57\n2.39\n2.86\n2.71\n2.85\n2.02\n2.16\n3.97\n2.75\n3.97\n3.77\n1.58\n3.51\n2.59\n2.72\n1.91\n3.49\n3.73\n4.47\n4.12\n1.68\n2.72\n2.3\n2.84\n3.4\n1.53\n2.91\n4.51\n1.66\n3.17\n3.13\n1.91\n2.82\n3.3\n2.49\n2.59\n3.63\n2.41\n3.19\n2.64\n2.7\n2.2\n3.31\n1.54\n3.72\n2.3\n2.35\n2.75\n3.44\n2.87\n3.58\n3.05\n2.75\n4.5\n2.78\n3.1\n3.31\n2.03\n1.78\n1.45\n2.19\n3.14\n4.03\n2.86\n2.38\n1.02\n1.25\n4.52\n3.43\n3.47\n3.1\n2.87\n2.78\n1.37\n2.06\n1.68\n2.93\n2.8\n2.48\n2.67\n3.11\n2.76\n1.43\n3.08\n1.85\n1.89\n2.79\n2.43\n2.95\n1.84\n2.8\n2.57\n1.76\n1.92\n0.73\n2.21\n3.24\n1.54\n2.89\n2.1\n3.37\n2.8\n2.66\n0.99\n1.36\n1.92\n2.63\n3.56\n1.82\n3.74\n2.85\n1.54\n3.65\n2.29\n3\n3.22\n2.46\n3.49\n3.56\n4.81\n1.91\n3.94\n2.75\n1.63\n2.55\n2.96\n2.43\n4.3\n3.06\n3.39\n3.47\n1.49\n3.35\n3.69\n3.71\n2.82\n1.83\n1.05\n1.67\n2.13\n3.85\n4.45\n1.53\n2.49\n2.33\n1.86\n2.89\n1.77\n2.75\n3.22\n1.82\n3.13\n2.49\n3.36\n2.35\n2.31\n0.88\n2.63\n3.45\n2.15\n2.95\n3.06\n2.86\n1.69\n3.02\n3.79\n1.3\n2.33\n2.48\n1.63\n3.17\n4.32\n2.2\n1.22\n2.01\n0.85\n2.36\n2.85\n3.8\n1.12\n2.63\n2.51\n2.64\n1.62\n3.5\n2.1\n2.6\n2.6\n3\n1.22\n2.85\n1.6\n0.34\n1.97\n4.56\n2.76\n2.24\n2.83\n2.29\n2.92\n2.03\n2.05\n3.02\n1.65\n2.08\n2.69\n2.51\n2.55\n3.25\n2.42\n2.88\n3.67\n2.22\n2.19\n2.86\n2.25\n0.88\n1.54\n3.17\n3.21\n2.58\n3.21\n2.88\n2.51\n0.04\n2.11\n2.2\n3.88\n3.48\n2.15\n2.3\n3.23\n1.16\n2.04\n1.87\n3.04\n2.84\n2.87\n2.35\n2.68\n3.31\n2.09\n2.48\n3.06\n3.77\n1.94\n4.55\n2.97\n2.11\n4.1\n2.89\n3.22\n2.14\n2.24\n2.98\n2.13\n1.65\n1.67\n0.15\n3.27\n1.59\n2.46"
),
    p(tags$b("Factor group")),
      tags$textarea(id = "fnp2",rows = 10,

"NS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads 2 columns from your data file")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors" )),
    fileInput('filenp2', "1. Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Show 1st row as header?")),
    checkboxInput("headernp2", "Show Data Header?", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("colnp2", "Yes", TRUE),

    radioButtons("sepnp2",
      "Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups")),
  hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("methodnp2",
  "Which method do you want to use? See explanations right",
  choiceNames = list(
    HTML("Bonferroni's"),
    HTML("Sidak's"),
    HTML("Holm's"),
    HTML("Holm-&#352;idak"),
    HTML("Hochberg's "),
    HTML("Benjamini-Hochberg"),
    HTML("Benjamini-Yekutieli")
    ),
  choiceValues = list("bonferroni", "sidak", "holm", "hs", "hochberg", "bh", "by")
  )


),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
    DT::DTOutput("tablenp2"),
  p(tags$b("1. The categories in the Factor Group")),
  DT::DTOutput("level.tnp2")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("basnp2.t")
      ),

    tabPanel("Box-Plot",p(br()),

      plotOutput("mmeannp2", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")), p(br()),

      HTML(
  "<b> Explanations </b>
  <ul>
    <li> <b>Bonferroni</b> adjusted p-values = max(1, pm); m= k(k-1)/2 multiple pairwise comparisons
    <li> <b>Sidak</b> adjusted p-values = max(1, 1 - (1 - p)^m)
    <li> <b>Holm's</b>  adjusted p-values = max[1, p(m+1-i)]; i is ordering index
    <li> <b>Holm-Sidak</b> adjusted p-values = max[1, 1 - (1 - p)^(m+1-i)]
    <li> <b>Hochberg's</b> adjusted p-values = max[1, p*i]
    <li> <b>Benjamini-Hochberg</b> adjusted p-values = max[1, pm/(m+1-i)]
    <li> <b>Benjamini-Yekutieli</b> adjusted p-values = max[1, pmC/(m+1-i)]; C = 1 + 1/2 + ... + 1/m
  </ul>

  <b> * Reject Null Hypothesis if p <= 0.025 </b>
  "
    ),

  DT::DTOutput("dunntest.t"),p(br()),

    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were not significantly different in LS-NI, LS-PS, and NI-PS groups. For other groups, P <0.025. "))#,

  #downloadButton("downloadnp2.2", "Download Results")


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


##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########

server <- function(input, output) {
#****************************************************************************************************************************************************1. one-way
names1 <- reactive({
  x <- unlist(strsplit(input$cn1, "[\n]"))
  return(x[1:2])
  })

level1 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f11, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names1()[2]
  return(x)
  })
output$level.t1 <- DT::renderDT({level1()}, options = list(dom = 't'))

Y1 <- reactive({
  inFile <- input$file1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x1, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )

    F1 <-as.factor(unlist(strsplit(input$f11, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, F1 = F1)
    validate( need(sum(!is.na(x))>1, "Please input enough valid numeric data") )

    colnames(x) = names1()
    }
  else {
if(!input$col1){
    csv <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header1, sep = input$sep1, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$header1==FALSE){
      colnames(x) = names1()
      }
    }
    return(as.data.frame(x))
})


output$table1 <- DT::renderDT(Y1(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

bas1 <- reactive({
  x <- Y1()
  res <- (describeBy(x[,1], x[,2], mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$bas1.t <- DT::renderDT({
  bas1()},
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$mbp1 = renderPlot({
  x = Y1()
  plot_boxm(x)
  })

output$mmean1 = renderPlot({
  x = Y1()
  plot_msdm(x, names(x)[1], names(x)[2])
  #b = Rmisc::summarySE(x,names(x)[1], names(x)[2])

  #ggplot(b, aes(x=b[,1], y=b[,3], fill=b[,1])) +
  #  geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
  #  geom_errorbar(aes(ymin=b[,3]-b[,5], ymax=b[,3]+b[,5]),
  #                width=.2,                    # Width of the error bars
  #                position=position_dodge(.9))+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

anova10 <- reactive({
  x <- Y1()
    res <- aov(x[,1]~x[,2])
    res.table <- anova(res)
    rownames(res.table)[1] <-colnames(x)[2]
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  return(res.table)
  })

output$anova1 <- DT::renderDT({
  anova10()},
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#source("p2_server.R", local=TRUE)$value
#****************************************************************************************************************************************************1.1. p-one-way

names2 <- reactive({
  x <- unlist(strsplit(input$cn, "[\n]"))
  return(x[1:3])
  })

level21 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f1, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[2]
  return(x)
  })
output$level.t21 <- DT::renderDT({level21()}, options = list(dom = 't'))

level22 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$f2, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[3]
  return(x)
  })
output$level.t22 <- DT::renderDT({level22()}, options = list(dom = 't'))


Y <- reactive({
  inFile <- input$file
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$x, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <- as.factor(unlist(strsplit(input$f1, "[,;\n\t ]")))
    F2 <- as.factor(unlist(strsplit(input$f2, "[,;\n\t ]")))
    validate( need(length(X)==length(F1)&length(X)==length(F2), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, F1 = F1, F2 = F2)
    colnames(x) = names2()
    }
  else {
if(!input$col){
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$header, sep = input$sep, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:3]
    if(input$header==FALSE){
      colnames(x) = names2()
      }
    }
    return(as.data.frame(x))
})

output$table <- DT::renderDT({Y()},
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

bas <- reactive({
  x <- Y()
  x$grp <- paste0(x[,2]," : ",x[,3])
  res <- (psych::describeBy(x[,1], x$grp, mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(as.factor(x$grp))
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$bas.t <- DT::renderDT({
  bas()},
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))
output$meanp.a = renderPlot({
  x = Y()
  #b = Rmisc::summarySE(x,colnames(x)[1], c(colnames(x)[2], colnames(x)[3]))

  if (input$tick == "TRUE"){
    plot_line2(x, names(x)[1], names(x)[2], names(x)[3])
  #ggplot(b, aes(x=b[,1], y=b[,4], colour=b[,2], group=b[,2])) +
  #    geom_line() + xlab("") +ylab("")+
  #    geom_point(shape=21, size=3, fill="white") +
  #    theme_minimal() + theme(legend.title = element_blank())
    }

  else {
    plot_line2(x, names(x)[1], names(x)[3], names(x)[2])
  #ggplot(b, aes(x=b[,2], y=b[,4], colour=b[,1], group=b[,1])) +
  #    geom_line() + xlab("") +ylab("")+
  #    geom_point(shape=21, size=3, fill="white") +
  #    theme_minimal() + theme(legend.title = element_blank())
  }

  })

output$mmean.a = renderPlot({
  x = Y()
  #b = Rmisc::summarySE(x,colnames(x)[1], c(colnames(x)[2], colnames(x)[3]))

  if (input$tick2 == "TRUE"){
    plot_msdm(x, names(x)[1], names(x)[2])
  #ggplot(b, aes(x=b[,1], y=b[,4], fill=b[,2])) +
  #  geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
  #  geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
  #                width=.2,                    # Width of the error bars
  #                position=position_dodge(.9))+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
    }

  else {
    plot_msdm(x, names(x)[1], names(x)[3])
  #ggplot(b, aes(x=b[,2], y=b[,4], fill=b[,1])) +
  #  geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
   #     geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
   #               width=.2,                    # Width of the error bars
   #               position=position_dodge(.9))+
   # scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  }

  })

anova0 <- reactive({
  x <- Y()

  if (input$inter == "TRUE"){
    res <- aov(x[,1]~x[,2]*x[,3])
    res.table <- anova(res)
    rownames(res.table)[1:3] <- c(names(x)[2],names(x)[3], paste0(names(x)[2]," : ",names(x)[3]))
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")
  }

  else {
    res <- aov(x[,1]~x[,2]+x[,3])
    res.table <- anova(res)
    rownames(res.table)[1:2] <- names(x)[2:3]
    colnames(res.table) <- c("Degree of Freedom (DF)", "Sum of Squares (SS)", "Mean Squares (MS)", "F Statistic", "P Value")

  }

  return(res.table)
  })
output$anova <- DT::renderDT({
  anova0()
  },
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p3_server.R", local=TRUE)$value
#****************************************************************************************************************************************************2. two-way

namesm <- reactive({
  x <- unlist(strsplit(input$cnm, "[\n]"))
  return(x[1:2])
  })

level <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fm, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- namesm()[2]

  return(x)
  })

output$level.t <- DT::renderDT({level()}, options = list(dom = 't'))

Ym <- reactive({
  inFile <- input$filem
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xm, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )

    F1 <-as.factor(unlist(strsplit(input$fm, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, F1 = F1)
    colnames(x) = namesm()
    }
  else {
  if(!input$colm){
    csv <- read.csv(inFile$datapath, header = input$headerm, sep = input$sepm, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headerm, sep = input$sepm, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$headerm==FALSE){
      colnames(x) = namesm()
      }
    }
    return(as.data.frame(x))
})

output$tablem <- DT::renderDT(Ym(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basm <- reactive({
  x <- Ym()
  res <- (describeBy(x[,1], x[,2], mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basm.t <- DT::renderDT({
  basm()},
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$mbp1m = renderPlot({
  x = Ym()
  plot_boxm(x)
  })

output$mmeanm = renderPlot({
  x = Ym()
  plot_msdm(x, names(x)[1], names(x)[2])
  #b = Rmisc::summarySE(x,names(x)[1], names(x)[2])

  #ggplot(b, aes(x=b[,1], y=b[,3], fill=b[,1])) +
  #  geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
  ##  geom_errorbar(aes(ymin=b[,3]-b[,5], ymax=b[,3]+b[,5]),
  #                width=.2,                    # Width of the error bars
  #                position=position_dodge(.9))+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })


multiple <- reactive({
  x <- Ym()
  if (input$method == "B"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]],
    p.adjust.method = "bonf")$p.value
  }
  if (input$method == "BH"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]],
    p.adjust.method = "holm")$p.value
  }
    if (input$method == "FDR"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]],
    p.adjust.method = "BH")$p.value
  }
    if (input$method == "BY"){
    res <- pairwise.t.test(x[,names(x)[1]], x[,names(x)[2]],
    p.adjust.method = "BY")$p.value
  }
    if (input$method == "SF"){
    res <- DescTools::ScheffeTest(aov(x[,names(x)[1]]~x[,names(x)[2]]))[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )
  }
    if (input$method == "TH"){
    res <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]))[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  }
    if (input$method == "DT"){
    x2 <- relevel(x[,names(x)[2]], ref=level()[input$control])
    res <- DescTools::DunnettTest(x[,names(x)[1]],x2)[[1]]
    colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  }
  res <- as.data.frame(res)
  return(res)
})

output$multiple.t <- DT::renderDT({multiple()},
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))


#source("p4_server.R", local=TRUE)$value
#****************************************************************************************************************************************************2.1. p-two-way

##Pairwise2
namesm2 <- reactive({
  x <- unlist(strsplit(input$cnm2, "[\n]"))
  return(x[1:2])
  })

level21m <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fm1, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[2]
  return(x)
  })
output$level.t21m <- DT::renderDT({level21m()}, options = list(dom = 't'))

level22m <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fm2, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names2()[3]
  return(x)
  })
output$level.t22m <- DT::renderDT({level22m()}, options = list(dom = 't'))

Ym2 <- reactive({
  inFile <- input$filem2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xm2, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <- as.factor(unlist(strsplit(input$fm1, "[,;\n\t ]")))
    F2 <- as.factor(unlist(strsplit(input$fm2, "[,;\n\t ]")))
    validate( need(length(X)==length(F1)&length(X)==length(F2), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, F1 = F1, F2 = F2)
    colnames(x) = names2()
    }
  else {
if(!input$colm2){
    csv <- read.csv(inFile$datapath, header = input$headerm2, sep = input$sepm2, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headerm2, sep = input$sepm2, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:3]
    if(input$headerm2==FALSE){
      colnames(x) = namesm2()
      }
    }
    return(as.data.frame(x))
})

output$tablem2 <- DT::renderDT(Ym2(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basm2 <- reactive({
  x <- Ym2()
  x$grp <- paste0(x[,2]," : ",x[,3])
  res <- (psych::describeBy(x[,1], x$grp, mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(as.factor(x$grp))
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basm.t2 <- DT::renderDT({
  basm2()},
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#output$mmeanm2 = renderPlot({
#  x = Ym2()
#  b = Rmisc::summarySE(x,colnames(x)[1], c(colnames(x)[2], colnames(x)[3]))#

#  if (input$tick2 == "TRUE"){
#  ggplot(b, aes(x=b[,1], y=b[,4], fill=b[,2])) +
#    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
#    geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
#                  width=.2,                    # Width of the error bars
#                  position=position_dodge(.9))+
#    scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
#    }

#  else {
#  ggplot(b, aes(x=b[,2], y=b[,4], fill=b[,1])) +
#    geom_bar(stat="identity", position = "dodge")+ xlab("") +ylab("")+
#        geom_errorbar(aes(ymin=b[,4]-b[,6], ymax=b[,4]+b[,6]),
#                  width=.2,                    # Width of the error bars
 #                 position=position_dodge(.9))+
 #   scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
 # }#

  #})
output$meanp.am = renderPlot({
  x = Ym2()

  if (input$tickm == "TRUE"){
  plot_line2(x, names(x)[1], names(x)[2], names(x)[3])
    }

  else {
  plot_line2(x, names(x)[1], names(x)[3], names(x)[2])
  }
  })

output$mmean.am = renderPlot({
  x = Ym2()
  if (input$tick2m == "TRUE"){
  plot_msdm(x, names(x)[1], names(x)[2])
    }

  else {
  plot_msdm(x, names(x)[1], names(x)[3])
  }
  })


multiple2 <- reactive({
  x <- Ym2()
    if (input$methodm2 == "SF"){
    res1 <- DescTools::ScheffeTest(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[1]]
    colnames(res1) <-NULL
    res2 <- DescTools::ScheffeTest(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[2]]
    colnames(res2) <-NULL
    res <- rbind(res1,res2)
  }
    if (input$methodm2 == "TH"){
    res1 <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[1]]
    colnames(res1) <-NULL
    res2 <- TukeyHSD(aov(x[,names(x)[1]]~x[,names(x)[2]]+x[,names(x)[3]]))[[2]]
    colnames(res2) <-NULL
    res <- rbind.data.frame(res1,res2)
  }
  res <- as.data.frame(res)
  colnames(res) <-c("Difference", "95%CI lower band","95%CI higher band", "P Value" )

  return(res)
})

output$multiple.t2 <- DT::renderDT({multiple2()},
  #class="row-border",
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#source("p5_server.R", local=TRUE)$value
#****************************************************************************************************************************************************3. np-one-way

namesnp1 <- reactive({
  x <- unlist(strsplit(input$cnnp1, "[\n]"))
  return(x[1:2])
  })

levelnp1 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fnp1, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names1()[2]
  return(x)
  })
output$level.tnp1 <- DT::renderDT({levelnp1()}, options = list(dom = 't'))

Ynp1 <- reactive({
  inFile <- input$filenp1
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xnp1, "[,;\n\t ]")))
    validate( need(sum(!is.na(X))>1, "Please input enough valid numeric data") )
    F1 <-as.factor(unlist(strsplit(input$fnp1, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )
    x <- data.frame(X = X, F1 = F1)
    colnames(x) = names1()
    }
  else {
if(!input$colnp1){
    csv <- read.csv(inFile$datapath, header = input$headernp1, sep = input$sepnp1, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headernp1, sep = input$sepnp1, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$headernp1==FALSE){
      colnames(x) = namesnp1()
      }
    }
    return(as.data.frame(x))
})

output$tablenp1 <- DT::renderDT(Ynp1(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basnp1 <- reactive({
  x <- Ynp1()
  res <- (psych::describeBy(x[,1], x[,2], mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basnp1.t <- DT::renderDT({
  basnp1()},
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$mmeannp1 = renderPlot({
  x = Ynp1()
  plot_boxm(x)
  #ggplot(x, aes(y=x[,1], x=x[,2], fill=x[,2])) + geom_boxplot()+ xlab("") +ylab("")+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

output$kwtest <- DT::renderDT({
  x <- Ynp1()
  res <- kruskal.test(x[,1]~x[,2])
  res.table <- t(data.frame(W = res[["statistic"]][["Kruskal-Wallis chi-squared"]],
                            P = res[["p.value"]],
                            df= res[["parameter"]][["df"]]))
  colnames(res.table) <- res$method
  rownames(res.table) <- c("Kruskal-Wallis chi-squared", "P Value","Degree of Freedom")
  return(res.table)
    },
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

#source("p6_server.R", local=TRUE)$value
#****************************************************************************************************************************************************3.1. p-np-one-way

namesnp2 <- reactive({
  x <- unlist(strsplit(input$cnnp2, "[\n]"))
  return(x[1:2])
  })

levelnp2 <- reactive({
  F1 <-as.factor(unlist(strsplit(input$fnp2, "[,;\n\t ]")))
  x <- matrix(levels(F1), nrow=1)
  colnames(x) <- c(1:length(x))
  rownames(x) <- names1()[2]
  return(x)
  })
output$level.tnp2 <- DT::renderDT({levelnp2()}, options = list(dom = 't'))

Ynp2 <- reactive({
  inFile <- input$filenp2
  if (is.null(inFile)) {
    X <- as.numeric(unlist(strsplit(input$xnp2, "[,;\n\t ]")))
    F1 <-as.factor(unlist(strsplit(input$fnp2, "[,;\n\t ]")))
    validate( need(length(X)==length(F1), "Please make sure two groups have equal length") )

    x <- data.frame(X = X, F1 = F1)
    colnames(x) = namesnp2()
    }
  else {
if(!input$colnp2){
    csv <- read.csv(inFile$datapath, header = input$headernp2, sep = input$sepnp2, stringsAsFactors=TRUE)
    }
    else{
    csv <- read.csv(inFile$datapath, header = input$headernp2, sep = input$sepnp2, row.names=1, stringsAsFactors=TRUE)
    }
    validate( need(ncol(csv)>0, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )
    validate( need(nrow(csv)>1, "Please check your data (nrow>2, ncol=1), valid row names, column names, and spectators") )

    x <- csv[,1:2]
    if(input$headernp2==FALSE){
      colnames(x) = namesnp2()
      }
    }
    return(as.data.frame(x))
})

output$tablenp2 <- DT::renderDT(Ynp2(),
    extensions = list(
      'Buttons'=NULL,
      'Scroller'=NULL),
    options = list(
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel'),
      deferRender = TRUE,
      scrollY = 300,
      scroller = TRUE))

basnp2 <- reactive({
  x <- Ynp2()
  res <- (psych::describeBy(x[,1], x[,2], mat=TRUE))[,-c(1,2,3,8,9)]
  rownames(res) <- levels(x[,2])
  colnames(res) <- c("Total Number of Valid Values","Mean", "SD", "Median", "Minimum","Maximum", "Range","Skew", "Kurtosis","SE")
  return(res)
  })

output$basnp2.t <- DT::renderDT({
  basnp2()},
    extensions = 'Buttons',
    options = list(
    dom = 'Bfrtip',
    buttons = c('copy', 'csv', 'excel'),
    scrollX = TRUE))

output$mmeannp2 = renderPlot({
  x = Ynp2()
  plot_boxm(x)
  #ggplot(x, aes(y=x[,1], x=x[,2], fill=x[,2])) + geom_boxplot()+ xlab("") +ylab("")+
  #  scale_fill_brewer(palette="Paired")+theme_minimal()+theme(legend.title=element_blank())
  })

dunntest <- reactive({
  x <- Ynp2()
  res <- dunn.test::dunn.test(x[,1], x[,2], method=input$methodnp2)
  res.table <- data.frame(Z=res$Z, P=res$P, Q=res$P.adjusted, row.names = res$comparisons)
  colnames(res.table) <- c("Kruskal-Wallis chi-squared", "P Value","Adjusted P value")
  return(res.table)
  })

output$dunntest.t <- DT::renderDT({dunntest()
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
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########
##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########----------##########


app <- shinyApp(ui = ui, server = server)
runApp(app, quiet = TRUE)
}

