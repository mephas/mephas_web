 
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!require("psych")) {install.packages("psych")}; library("psych")
if (!require("DescTools")) {install.packages("DescTools")}; library("DescTools")
if (!require("dunn.test")) {install.packages("dunn.test")}; library("dunn.test")
if (!require("DT")) {install.packages("DT")}; library("DT")
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

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
#title = a("Test for Contingency Table", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "方差分析",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel("单因素差分析和多重比较",

headerPanel("比较多组样本的单因素方差分析（One-Way ANOVA）和多重比较"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能  </b></h4>

<ul>
<li> 测定各因子群之间的均值是否有显著差异
<li> 假设单向方差分析发现各因子群间存在显著差异，测定配对的均值是否存在显著差异
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据包含以2个向量显示的若干单独因子群
<li> 一个向量是观测值；一个向量是在不同的因子群中标记的值
<li> 各因子群是独立的且近似正态分布
<li> 因子群的各个均值遵循具有相同方差的正态分布，并且可以比较
</ul>

<i>
<h4>示例</h4>

假设想发现被动吸烟对癌症的发病率是否有影响。
在一项研究中，研究了6组吸烟者：非吸烟者 (NS)、被动吸烟者 (PS)、非吸入吸烟者 (NI)、轻度吸烟者 (LS)、中度吸烟者(MS) 及重度吸烟者 (HS)；
并测量了強制呼气流量（FEF）。
想了解6组间FEF的差异。
</i>


<h4>请参考以下步骤，输出分析结果。</h4>
"
)
),

hr(),
source("ui_1.R", local=TRUE, encoding = "utf-8")$value,
hr(),
source("ui_1m.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########

tabPanel("双因素方差分析和多重比较",

headerPanel("比较多组样本的双因素方差分析（Two-Way ANOVA）和多重比较"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>

<ul>
<li> 测定在控制因子2之后因子1之间的均值是否显著不同
<li> 测定在控制因子1之后因子2之间的均值是否显著不同
<li> 测定因子1和因子2是否具有影响结果的相互作用
<li> 双向方差分析分析各组的组间差异，可以测定因子的哪个对的均值存在显著差异

</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 数据包含几个独立的因子群（或2个向量）
<li> 各因子群/集是独立的且等同近似正态分布
<li> 因子群的各个均值遵循具有相同方差的正态分布，并且可以比较
</ul>

<i>
<h4>示例</h4>

假设侧重性别和3个饮食组对收缩压的影响。3个饮食组包括严格素食者（SV）、蛋奶素食者（LV）和正常人（NOR）；
并测量了收缩压。
性别和饮食组的影响可能是相互关联（作用）的。
想了解饮食组和性别对收缩压的影响，以及两者之间是否相互联系。
</i>


<h4>请参考以下步骤，输出分析结果。</h4>
"
)
),

hr(),
source("ui_2.R", local=TRUE, encoding = "utf-8")$value,
hr(),
source("ui_2m.R", local=TRUE, encoding = "utf-8")$value,
hr()
),
#

##########----------##########----------##########
tabPanel("非参数方法",

headerPanel("多样本比较的Kruskal-Wallis非参数检验和多重比较"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>这种方法比较的是观测数据的秩，而不是均值和标准差。是单因素方差分析的替代，此方法无需假设数据分布。</b>

<h4><b> 1. 功能</b></h4>

<ul>
<li> 测定各因子组之间的均值是否有显著差异
<li> 测定因子组的均值是否存在显著差异，假设单向方差分析发现各组间存在显著差异
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 数据包含以两个向量显示的几个单独的因子群
<li> 一个向量是观测值，一个向量是在不同的因子群中标记的值
<li> 各个因子群是独立的，不需要假设分布
</ul>

<i>
<h4>示例</h4>

假设想发现被动吸烟对癌症的发病率是否有影响。
在一项研究中，研究了6组吸烟者：非吸烟者 (NS)、被动吸烟者 (PS)、非吸入吸烟者 (NI)、轻度吸烟者 (LS)、中度吸烟者(MS) 及重度吸烟者 (HS)；
并测量了強制呼气流量（FEF）。
想了解6组间FEF的差异。
</i>


<h4>请参考以下步骤，输出分析结果。</h4>
"
)
),
hr(),
source("ui_np1.R", local=TRUE, encoding = "utf-8")$value,
hr(),
source("ui_np1m.R", local=TRUE, encoding = "utf-8")$value,
hr()
),

##########----------##########----------##########

tablang("6MFSanova"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))
#)
