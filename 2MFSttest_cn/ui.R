if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("reshape")) {install.packages("reshape")}; library("reshape")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_cn.R")
source("../tab/panel_cn.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########
navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Parametric T Test for Means", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "均值的参数T检验",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel( "单样本",

headerPanel("单样本 T 检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定数据是否与 T 检验结果的指定均值在统计学上有显著差异</li>
<li> 了解有关数据的基本描述性统计信息</li>
<li> 了解数据的描述性统计图，如箱形图、均值-sd图、QQ图、分布直方图及密度分布图，以测定数据是否接近正态分布</li>
</ul>

<h4><b> 2. 关于你的数据 </b></h4>

<ul>
<li> 数据仅包含1组值（或一个数字向量）</li>
<li> 该组值是独立观察值，近似正态分布</li>
</ul>

<i><h4>示例</h4>
假设收集了50位仅患有淋巴结阳性患者的年龄，并想知道淋巴结阳性患者的一般年龄是否为50岁
</i>


<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>
"
)
),

hr(),

source("ui_1.R", local=TRUE)$value,

hr()


),


##########----------##########----------##########
tabPanel("独立双样本",

headerPanel("独立双样本 T 检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能   </b></h4>
<ul>
<li> 测定两组数据的均值是否分别与 T 检验结果的有显著差异</li>
<li> 了解有关数据的基本描述性统计信息</li>
<li> 了解数据的描述性统计图，如箱形图、均值-sd图、QQ图、分布直方图及密度分布图，以测定数据是否接近正态分布</li>

</ul>

<h4><b> 2. 关于你的数据 </b></h4>

<ul>
<li> 数据包含2个独立组/集（或2个数字向量）</li>
<li> 这2个独立组/集独立且等同近似正态分布</li>
</ul>

<i><h4>示例</h4>
假设收集了50位仅患有淋巴结阳性患者的年龄。其中雌激素受体 (ER) 阳性 25 例，ER 阴性 25 例。想知道ER阳性患者的年龄是否与ER阴性患者的年龄有显著性差异。或者，ER是否与年龄有关。
</i>

<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>

"
)
),

hr(),

source("ui_2.R", local=TRUE)$value,

hr()

),


##########----------##########----------##########
tabPanel("配对样本",

headerPanel("配对样本的配对 T 检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>配对情况下，比较2组的差异为零。因此，成为一个单样本检验问题。</b>

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 测定配对的2个样本的差值是否等于0</li>
<li> 了解有关数据的基本描述性统计信息</li>
<li> 了解数据的描述性统计图，如箱形图、均值-sd图、QQ图、分布直方图及密度分布图，以测定数据是否接近正态分布</li>

</ul>


<h4><b> 2. 关于你的数据 </b></h4>

<ul>
<li> 数据包含2个独立组/集（或2个数字向量）</li>
<li> 已匹配或配对的两个样本</li>
<li> 配对样本的差值近似正态分布</li>
</ul>

<h4><b> 3. 匹配或配对数据示例 </b></h4>
<ul>
<li>  一个人的前测和后测评分</li>
<li>  有两个样本已经匹配或配对时</li>
</ul>


<h4><i>示例</i></h4>
<i>假设，收集样本并想要知道某种药物是否对人们的睡眠时间有影响。我们找了10个人，收集了服药前后的睡眠时间数据。这是一个配对案例。我们想知道服药前后的睡眠时间是否会有显著差异；治疗前后的差异是否与0有显著性差异</i>


<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>

"
)
),

hr(),

source("ui_p.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tablang(),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))
)
)
