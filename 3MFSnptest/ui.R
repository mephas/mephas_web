##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
#source("p1_ui.R", local=TRUE,encoding = "UTF-8")
#source("p2_ui.R", local=TRUE,encoding = "UTF-8")
#source("p3_ui.R", local=TRUE,encoding = "UTF-8")

shinyUI(

tagList( 
source("../0tabs/font.R",local=TRUE, encoding="UTF-8")$value,

##########----------##########----------##########

navbarPage(

title = "Wilcoxon Test for Median",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Wilcoxon Signed-Rank Test for One Sample"),

HTML(
    "    
<p>This is an alternative to one-sample t-test, when the data cannot be assumed to be normally distributed.
This method is based on the ranks of observations rather than on their true values</p>

<h4><b> 1. What can you do on this page  </b></h4>
<ul>
<li> To determine if the median / location of the population from which your data is drawn statistically significantly different from the specified median
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data  
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 1 group of values (or 1 numeric vector)
<li> Your data are meaningful to measure the distance from the specified median
<li> The values are independent observations
<li> No assumption on the distributional shape of your data, which means your data may be not normally distributed
</ul> 

<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a certain group of patients. DRS Scale > 1 indicated Depression.
We wanted to know if the DRS of patients was significantly greater than 1. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>
    

    "
    ),

hr(),
##---------- 1.1 ----------

source("p1_ui.R", local=TRUE)$value,

hr()



),

##---------- Panel 2 ----------

tabPanel("Two Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann–Whitney U test) for Two Independent Samples"),

HTML(
    "
<p>This is an alternative to two-sample t-test, when the data cannot be assumed to be normally distributed</p>

<h4><b> 1. What can you do on this page  </b></h4>
<ul>
<li> To determine if the medians of two population from which your 2 groups data drawn are statistically significantly different from each other
<li> To determine if the distributions of 2 groups of data differ in locations
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data  
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain only 2 group of values (or 2 numeric vectors) 
<li> Your data are meaningful to measure the distance between 2 groups values
<li> The values are independent observations
<li> No assumption on the distributional shape of your data
<li> Your data may be not normally distributed
</ul> 

<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 19 patients from a certain group of patients. Among 19 people, 9 were women, and 10 were men.
We wanted to know if the DRS of patients was significantly different among different genders; or, whether age was related to DRS scores. 
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>


    "
    ),

hr(),

##---------- 2.1 ----------
source("p2_ui.R", local=TRUE)$value,

hr()

),

##---------- Panel 3 ----------

tabPanel("Paired Samples",    

headerPanel("Wilcoxon Signed-Rank Test for Two Paired Samples"),

HTML(
    "
<b>In paired case, we compare the differences of 2 groups to zero. Thus, it becomes a one-sample test problem.</b>
<p>This is an alternative to paired-sample t-test, when the data cannot be assumed to be normally distributed</p>

<h4><b> 1. What can you do on this page  </b></h4>
<ul>
<li> To determine if the difference of paired data is statistically significantly different from 0
<li> To know the basic descriptive statistics about your data
<li> To know the descriptive statistics plot such as box-plot, distribution histogram, and density distribution plot about your data  
</ul>

<h4><b> 2. About your data </b></h4>

<ul>
<li> Your data contain 2 group of values (or 2 numeric vectors)
<li> Your data are meaningful to measure the distance from the specified median
<li> The values are paired or matched observations
<li> No assumption on the distributional shape of your data
<li> Your data may be not normally distributed
</ul> 

<h4><b> 3. Examples for Matched or Paired Data </b></h4>
<ul>
<li>  One person's pre-test and post-test scores 
<li>  When there are two samples that have been matched or paired
</ul>  


<i><h4>Case Example</h4>
Suppose we collected the Depression Rating Scale (DRS) measurements of 9 patients from a certain group of patients. We decided to give them some treatment, and after the treatment we tested the DRS again.
We wanted to know if the DRS of patients before and after were significantly; or, whether the differences were significantly different from 0, which could indicate if the treatment was effective.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results.</h4>    
"
    ),

hr(),
##---------- 3.1 ----------

source("p3_ui.R", local=TRUE)$value,

hr()

),
##########----------##########----------##########
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/help3.R",local=TRUE, encoding="UTF-8")$value

  
))
)

