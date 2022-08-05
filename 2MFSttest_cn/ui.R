if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!require("reshape")) {install.packages("reshape")}; library("reshape")
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")
if (!require("dplyr")) {install.packages("dplyr")}; library("dplyr")


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
theme = shinythemes::shinytheme("cerulean"),
#title = a("Parametric T Test for Means", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "T检验",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel( "单样本",

headerPanel("单样本的T检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. 功能  </b></h4>

<ul>
<li> 检验一个正态分布的总体的均值是否在满足零假设的值之内												
<li> 有关数据的基本描述性统计信息																	
<li> 数据的描述性统计图，如箱形图、均值-标准差图、QQ图、分布直方图及密度分布图，以测定数据是否接近正态分布	
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul> 
<li> 已知一个总体均数
<li> 样本数据包含1组连续型观测值，可得到一个样本均数及该样本标准差	
<li> 样本来自正态或近似正态总体									
</ul>

<i>
<h4>示例</h4>

假设收集了50位患有淋巴结阳性患者的年龄，并想知道淋巴结阳性患者的一般年龄是否为50岁。
</i>


<h4>请参考以下步骤，输出分析结果。</h4>
"
)
),

hr(),

source("ui_1.R", local=TRUE, encoding="utf-8")$value,

hr()


),


##########----------##########----------##########
tabPanel("双样本",

headerPanel("独立双样本的T检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能   </b></h4>

<ul>
<li> 两个正态分布的总体的均值是否相等，或之差是否为某实数 												
<li> 了解有关数据的基本描述性统计信息																
<li> 了解数据的描述性统计图，如箱形图、均值-标准差图、QQ图、分布直方图及密度分布图，以测定数据是否接近正态分布	

</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据包含2个独立组，每组是连续观测值 		
<li> 这2个独立组的数据独立同分布，近似正态分布	
</ul>

<i>
<h4>示例</h4>

假设收集了50位仅患有淋巴结阳性患者的年龄。
其中雌激素受体 (ER) 阳性 25 例，ER 阴性 25 例。
想知道ER阳性患者的年龄是否与ER阴性患者的年龄有显著性差异；或者，ER是否与年龄有关。
</i>

<h4>请参考以下步骤，输出分析结果。</h4>

"
)
),

hr(),

source("ui_2.R", local=TRUE, encoding="utf-8")$value,

hr()

),


##########----------##########----------##########
tabPanel("配对样本",

headerPanel("配对样本的T检验"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>配对情况下，比较2组的差异为零。因此，成为一个单样本检验问题。</b>

<h4><b> 1. 功能  </b></h4>

<ul>
<li> 检定自同一总体抽出的成对样本间差异是否为零 
<li> 了解有关数据的基本描述性统计信息 
<li> 了解数据的描述性统计图，如箱形图、均值-标准差图、QQ图、分布直方图及密度分布图，以测定数据是否接近正态分布

</ul>


<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据包含2个已匹配或配对的两个样本	
<li> 配对样本的差值近似正态分布 		
</ul>

<h4><b> 3. 匹配或配对数据示例 </b></h4>

<ul>
<li>  一个人的前测和后测评分		
<li>  有两个样本已经匹配或配对时	
</ul>

<i>
<h4>示例</h4>

假设想要知道某种药物是否对人们的睡眠时间有影响。我们找了10个人作为样本，收集了服药前后的睡眠时间数据。
这是一个配对案例。
如果想知道服药前后的睡眠时间是否会有显著差异；或者治疗前后的差是否与0有显著性差异，可用这个方法。
</i>


<h4>请参考以下步骤，输出分析结果。</h4>

"
)
),

hr(),

source("ui_p.R", local=TRUE, encoding="utf-8")$value,
hr()

),

##########----------##########----------##########
tablang("2MFSttest"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))
)
)
