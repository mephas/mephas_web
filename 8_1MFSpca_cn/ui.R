if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("psych")) {install.packages("psych")}; library("psych")
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

#title = a("Dimensional Analysis 1", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "维度分析 1", 

collapsible = TRUE,
id="navibar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("数据",

headerPanel("准备数据"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能  </b></h4>
<ul>
<li> 上传数据文件时，预览数据集，并检查数据输入的正确性</li>
<li> 构建模型时，（根据需要）对一些变量进行预处理</li>
<li> 计算基本描述性统计量，绘制变量图</li>
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 数据的行数必须多于列数。</li>
<li> 数据需要全部为数值数据</li>
</ul>


<h4><i>示例1: 小鼠基因表达数据</i></h4>

<i>这一数据测得20只小鼠在一次饮食实验中的基因表达。部分小鼠表现出相同的基因型，部分基因变量存在相关性。从基因表达数据中计算出线性不相关的主成分。</i>

<h4><i>示例2: 化学数据</i></h4>

<i>
假设在一项研究中，已测得7类药物的9种化学属性。有些化学物质有潜在的联系。探索化学变量之间潜在的关系结构，并缩小到较少数量的变量。
</i>

<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。准备好数据后，请在接下来的选项卡中找出模型。</h4>
"
)
),
hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),


##########----------##########----------##########
tabPanel("主成分分析（PCA）",

headerPanel("主成分分析（PCA）"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>主成分分析（PCA）</b>是一种数据简化技术，其将大量的相关变量转换为一组小很多的不相关变量，即主成分。

<h4><b> 1. 功能</b></h4>
<ul>
<li> 从<b>平行分析</b>估计成分数</li>
<li> 获得相关矩阵并绘制图</li>
<li> 获得主成分和载荷结果表</li>
<li> 获得2D和3D主成分和载荷分布图</li>
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 所有的分析数据都是数值数据</li>
<li> 样本量大于自变量数，即行数大于列数</li>
</ul>

<h4>请按照<b>步骤</b>建模，然后单击<b>输出</b>获取分析结果。</h4>
")
),
hr(),
source("ui_pca.R", local=TRUE, encoding="UTF-8")$value,
hr()

), #penal tab end

##########----------##########----------##########
tabPanel("探索性因子分析（EFA）",

headerPanel("探索性因子分析（EFA）"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>探索性因子分析（EFA）</b>是一种统计方法，用于根据潜在少数未观察到的变量描述观察到的、相关的变量之间的变异性，即称为因子。

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 从<b>平行分析</b>估计成分数</li>
<li> 获得相关矩阵和绘图</li>
<li> 获得因子和载荷结果表和载荷结果表</li>
<li> 获得2D和3D的因子和载荷分布图</li>
</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 所有的分析数据都是数值数据</li>
<li> 样本量大于自变量数，即行数大于列数</li>
</ul>

<h4>请按照<b>步骤</b>建模，然后单击<b>输出</b>获取分析结果。</h4>
")
),
hr(),
source("ui_fa.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########

tablang(),
tabstop(),
tablink()

))

##########----------##########----------####################----------##########----------####################----------##########----------##########
#)
