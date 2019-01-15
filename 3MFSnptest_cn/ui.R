##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: CN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
source("p1_ui.R", local=TRUE)
source("p2_ui.R", local=TRUE)
source("p3_ui.R", local=TRUE)

shinyUI(

tagList( 

navbarPage(

title = "非参数检验",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("符号检验，Wilcoxon符号秩检验"),

HTML(" 

<b> 注 </b>

  <ul>
  <li> X是随机采集的样本 
  <li> m是总体X的中位数，即X的分布的50百分位数 
  <li> m&#8320 是指定值. 
  </ul>


<b> 前提假设 </b>

  <ul>
  <li> 每个观察是独立的，来自同一总体
  <li> X是连续的（即间隔或比率）和序数
  </ul>


<p> 两者都可用于测试一组数字的中值是否显著大于或小于指定值 </p>

  "),
hr(),

##---------- 1.1 ----------
onesample,
hr(),

##---------- 1.2 ----------

h4("符号检验"),
p("符号检验对被检验的数据的分布性质基本不做出假设，但是其统计功效（statistical power）可能不如其他方法"),

signtest,
hr(),

##---------- 1.3 ----------

h4("Wilcoxon符号秩检验"),

HTML("

<p> 当数据不能被假定为正态分布时，可以使用这个方法来替代一个样本t检验，来确定样本的中值是否等于指定的值</p>

<b> 补充假设 </b>

<ul>
  <li> X的分布是对称的
  <li> X中没有相同的值 (No ties)
</ul>

  "),

wstest

),

##---------- Panel 2 ----------

tabPanel("两个独立样本",

headerPanel("Wilcoxon秩和检验（Mann-Whitney U检验），(Mood's)中数检验"),

HTML("

<p> To determine whether a randomly selected sample will be less than or greater than a second randomly selected sample. </p>

<b> 注 </b>
  <ul>
  <li> X是第一个随机选择的样本，而Y是第二个
  <li> m&#8321 是X的总体中位值, 即位于X的分布的百分之五十位的数
  <li> m&#8322 是Y的总体中位值, 即位于Y的分布的百分之五十位的数
  </ul>

<b> 前提假设 </b>  
  <ul>
  <li> 两组的观察结果相互独立，没有成对或重复的数据
  <li> m&#8321 是X的总体中位值, 即位于X的分布的百分之五十位的数
  <li> m&#8322 是Y的总体中位值, 即位于Y的分布的百分之五十位的数
  </ul>

  "),
hr(),

##---------- 2.1 ----------
twosample,
hr(),

##---------- 2.2 ----------
h4("(Wilcoxon)秩和检验, Mann-Whitney U检验, Mann-Whitney－Wilcoxon检验, Wilcoxon Mann-Whitney检验"),

HTML("

<p> 不需要假设正态分布，几乎与正态分布上的t检验一样有效 </p>

<b> 补充假设  </b>

<ul>
<li> 无离群值（确定两组在形状和分布上的分布是否相似）
<li> 如果存在离群值，该检验试用于检验分布的一致性（确定两组在形状和分布上的分布是否不同）
</ul>

<p> 离群值会影响数据的分布  </p>
  "),

wrtest,
hr(),

##---------- 2.3 ----------
h4("Mood's 中数检验"),

p("皮尔森卡方检验（Pearson's chi-squared test）的一个特例"),

mmtest

),

##---------- Panel 3 ----------

tabPanel("两个成对样本",    

headerPanel("符号检验，Wilcoxon符号秩检验"),

HTML("

<b> 前提假设 </b>

<ul>
  <li> （X，Y）的观测是成对的，来自同一总体
  <li> X和Y可以是连续的变量
  <li> D是独立的，来自同一总体
</ul>

<b> 注 </b>

<ul>
  <li> 成对观测值被指定为x和y.
  <li> D = X-Y, 成对（x，y）之间的差异
  <li> m 是D的总体中位数，或D的分布的百分之五十位的数
</ul>

<p> 给定每位受试者的一对观察值（如治疗前和治疗后的体重），这两个检测都可以用来确定其中一个（如治疗前）是否倾向于大于（或小于）另一个（如治疗后）</p>
"),

psample,

hr(),
##---------- 3.1 ----------

h4("符号检验"),
p("这种方法使用很少假设，并且具有非常普遍的适用性，但其统计效能可能不如其他方法"),

signtest.p,

hr(),
##---------- 3.2 ----------

h4("Wilcoxon符号秩检验"),

HTML("

  <p> 此方法是当总体不能被假定为正态分布时，配对的t检验的替代方案。此方法也可以用于检验是否从具有相同分布的总体中选择两个相关样本 </p>

  <b> 补充假设 </b>
  
  <ul>
    <li> D的分布是对称的.
    <li> D变量之中没有相同的值
  </ul>

  "),
  
wstest.p

),
##---------- other panels ----------

source("../0tabs/home_cn.R",local=TRUE)$value,
source("../0tabs/stop_cn.R",local=TRUE)$value

  
))
)

