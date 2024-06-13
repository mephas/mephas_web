#if (!require("Hmisc")) {install.packages("Hmisc")};library("Hmisc")
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)

#if (!require("DT")) {install.packages("DT")}; library("DT")
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")
Sys.setlocale(locale = "Chinese")

source("../tab/tab_cn.R", encoding="utf-8")
source("../tab/panel_cn.R", encoding="utf-8")
source("../tab/panel_plotinfo_cn.R", encoding="utf-8")
source("../tab/func.R", encoding="utf-8")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
#theme = shinythemes::shinytheme("cerulean"),
#title = a("Test for Binomial Proportions", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "二项式检验",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########

tabPanel("单样本",

headerPanel("一个比例的卡方检验和精确二项式方法（Exact Binomial Method）"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>

<ul>
<li> 测定数据的总体比率/比例（proportion/rate）是否与指定的比率/比例有显著差异 
<li> 测定抽样率/例与总体比率/比例的兼容性 
<li> 测定伯努利实验成功的概率
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据来自二项分布
<li> 知道整个样本和指定事件的数量
<li> 需要指定一个比例值 (p<sub>0</sub>)
</ul>

<i>
<h4>示例</h4>

假设在一般人群中有20%的不孕妇女，一种治疗可能会影响不孕。200名尝试怀孕的妇女接受了这种治疗。在40名接受治疗的妇女中，仍有10人不孕。想知道接受治疗妇女的不孕率与一般不孕率的20%相比是否有显著性差异。 
</i>

<h4>请参考以下步骤，输出分析结果。</h4>    
" 
)
),

hr(),

source("ui_1.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("双样本",

headerPanel("两个独立比例的卡方检验"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 测定2组数据背后的总体比率/比例是否有显著差异。</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 2组数据来自二项分布（成功比例）
<li> 知道2组整体样本和指定事件的数量（子组比例）
<li> 2个组是独立观察值。
</ul>

<i>
<h4>示例</h4>

假设研究中的所有女性至少生育过一次。
以3220例乳腺癌妇女为研究对象。
其中，30岁以后至少生育过一次的有683人。
同时调查了10245例无乳腺癌妇女作为对照。
其中，30岁以后至少生育过一次的有1498人。
假设想知道30岁以上生育第一胎的潜在概率在乳腺癌组和非乳腺癌组中是否不同。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>    
"
)
),
hr(),

source("ui_2.R", local=TRUE, encoding = "utf-8")$value,
hr()


),

##########----------##########----------##########
tabPanel("三个以上样本",

headerPanel("三个以上独立比例的卡方检验"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定多组数据背后的总体比率/比例是否有显著差异。
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 组数据来自二项分布（成功比例）
<li> 知道各组的整个样本和指定事件的数量（子组比例）
<li> 多组为独立观察值。
</ul>

<i>
<h4>示例</h4>

假设想研究第一次生育年龄与乳腺癌发展之间的关系，
因此调查了3220例乳腺癌患者和10254例非乳腺癌患者，
然后将妇女分为不同的年龄组。
假设想知道不同年龄组患癌症的概率是否不同；或者她们的年龄是否与乳腺癌有关。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>   
"
)
),
hr(),

source("ui_3.R", local=TRUE, encoding = "utf-8")$value,
hr()
),

##########----------##########----------##########
tabPanel("三个以上样本的趋势",

headerPanel("多个独立样本趋势的卡方检验"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 测定多组数据背后的总体比率/比例是否不同
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 组数据来自二项分布（成功比例）
<li> 知道各组的整个样本和指定事件的数量（子组比例）
<li> 多组为独立观察值
</ul>

<i>
<h4>示例</h4>

假设想研究第一次生育年龄与乳腺癌发展之间的关系。
因此，调查了3220例乳腺癌患者和10254例非乳腺癌患者，
然后将妇女分为不同的年龄组。
假设想知道癌症的发病率是否有年龄趋势。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>    
"
)
),
hr(),

source("ui_t.R", local=TRUE, encoding = "utf-8")$value,
hr()

),


##########----------##########----------##########

tablang("4MFSproptest"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))



))


