##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
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

title = "ノンパラメトリック検定",  

##---------- Panel 1 ----------
tabPanel("一群に対する検定",

headerPanel("符号検定, ウィルコクソンの符号順位検定"),

HTML(" 

<b> 注 </b>

  <ul>
  <li> Xはサンプルから無作為に抽出された
  <li> mはXの平均, 50パーセントタイルはXの分布にもとずいたものである
  <li> m&#8320 は特定の
  </ul>


<b> 前提として </b>

  <ul>
  <li> それぞれの検定は独立しており一つの母集団から抽出されたものである
  <li> 数値は連続しているものとする
  </ul>


<p> ここでは、データの数値の中央値が指定された値よりも大幅に大きいか小さいかをテストできます </p>
  "),
hr(),

##---------- 1.1 ----------
onesample,
hr(),

##---------- 1.2 ----------

h4("符号検定"),
p("符号検定は、テスト中の分布の性質についてはほとんど仮定していませんが、代替テストの統計力が不足している可能性があります"),

signtest,
hr(),

##---------- 1.3 ----------

h4("ウィルコクソンの符号順位検定"),

HTML("

<p> データが正規分布していると仮定できない場合の1標本t検定の代替案。 これは、サンプルの中央値が指定された値と等しいかどうかを判断するために使用されます</p>

<b> 補足仮定 </b>

<ul>
  <li> Xの分布は対称である
  <li> No ties (same values) in X
</ul>

  "),

wstest

),

##---------- Panel 2 ----------

tabPanel("Two Independent Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann-Whitney U Test), Mood's Median Test"),

HTML("

<p> To determine whether a randomly selected sample will be less than or greater than a second randomly selected sample. </p>

<b> 注 </b>
  <ul>
  <li> X is the first randomly selected sample, while Y is the second</li>
  <li> m&#8321 is the population median of X, or the 50 percentile of the underlying distribution of X </li>  
  <li> m&#8322 is the population median of Y, or the 50 percentile of the underlying distribution of Y </li> 
  </ul>

<b> 前提として </b>  
  <ul>
  <li> All the observations from both groups are independent of each other, no paired or repeated data </li>
  <li> X and Y could be continuous (i.e., interval or ratio) and ordinal (i.e., at least, of any two observations, which is the greater) </li>  
  <li> X and Y are similar in distribution's shape </li> 
  </ul>

  "),
hr(),

##---------- 2.1 ----------
twosample,
hr(),

##---------- 2.2 ----------
h4("Wilcoxon Rank-Sum Test, Mann-Whitney U Test, Mann-Whitney-Wilcoxon Test, Wilcoxon-Mann-Whitney Test"),

HTML("

<p> Not require the assumption of normal distributions; nearly as efficient as the t-test on normal distributions. </p>

<b> 補足仮定  </b>

<ul>
<li> No outliers (to determine if the distributions of the two groups are similar in shape and spread)
<li> If outliers exist, the test is used for testing distributions (to determine if the distributions of the two groups are different in shape and spread)
</ul>

<p> Outliers will affect the spread of data  </p>
  "),

wrtest,
hr(),

##---------- 2.3 ----------
h4("Mood's Median Test"),

p("A special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. "),

mmtest

),

##---------- Panel 3 ----------

tabPanel("関連する二群に対する検定",    

headerPanel("符号検定 と ウィルコクソンの符号順位検定"),

HTML("

<b> 注 </b>

<ul>
  <li> The paired observations are designated X and Y ,
  <li> D = X-Y, the differences between paired (X, Y) 
  <li> m is the population median of D, or the 50 percentile of the underlying distribution of the D. 
</ul>

<b> 前提として </b>

<ul>
  <li>（X、Y）の観測値は対になっており、同じ母集団からのものです
  <li> X's and Y's could be continuous (i.e., interval or ratio) and ordinal 
  <li> D's are independent and come from the same population 
</ul>



<p> Given pairs of observations (such as weight pre- and post-treatment) for each subject, both test determine if one of the pair (such as pre-treatment) tends to be greater than (or less than) the other pair (such as post-treatment).</p>

"),

psample,

hr(),
##---------- 3.1 ----------

h4("符号テスト"),
p("符号検定は、テスト中の分布の性質についてはほとんど仮定していませんが、代替テストの統計力が不足している可能性があります"),

signtest.p,

hr(),
##---------- 3.2 ----------

h4("ウィルコクソンの符号順位検定"),

HTML("

  <p> 母集団が正規分布していると仮定できない場合の、マッチドペアの対応のあるt検定の代替方法。 また、2つの従属サンプルが同じ分布を持つ集団から選択されたかどうかを判断するためにも使用できます </p>

  <b> 補足仮定 </b>
  
  <ul>
    <li> The distribution of D's is symmetric
    <li> No ties in D's
  </ul>

  "),
  
helpText("Ties means the same values"),

wstest.p

),
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value

  
))
)

