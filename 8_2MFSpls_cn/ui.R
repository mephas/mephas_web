if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
if (!requireNamespace("pls",quietly = TRUE)) {install.packages("pls")}; require("pls",quietly = TRUE)
if (!requireNamespace("spls",quietly = TRUE)) {install.packages("spls")}; require("spls",quietly = TRUE)
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_cn.R")
source("../tab/panel_cn.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

navbarPage(

theme = shinythemes::shinytheme("cerulean"),
#title = a("Dimensional Analysis 2", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "维度分析 2",
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

<h4><b> 2. 关于数据（训练集）</b></h4>

<ul>
<li> 数据需要全部为数值数据</li>
<li> 用于构建模型的数据称为<b>训练集</b></li>
</ul>

<i><h4>示例：NKI数据</h4>

假设在一项研究中想探讨一些淋巴结阳性乳腺癌患者的无转移生存率。数据包含临床危险因素：（1）年龄：患者诊断时的年龄（岁）和（2）复发时年份；
以及在早期研究中发现对无转移生存期有预后意义的70个基因的基因表达测量。在这个示例中，可创建一个模型，其可以找到年龄、复发的年份和基因表达测量之间的关系。

<h4>示例：肝毒性数据</h4>

该数据集包含在对照实验中接触无毒、中等毒或严重毒剂量对乙酰氨基酚的大鼠的表达测量和临床测量。

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
tabPanel("主成分回归（PCR）",

headerPanel("主成分回归（PCR）"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>主成分回归（PCR）</b> 是一种基于主成分分析（PCA）的回归分析技术。其在响应和自变量之间查找最大方差的超平面。

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 获得相关矩阵和绘图</li>
<li> 获得模型的结果</li>
<li> 获得因子和载荷结果表</li>
<li> 获得2D和3D的因子和载荷分布图</li>
<li> 获得预测的因变量</li>
<li> 上传新数据并进行预测</li>

</ul>

<h4><b> 2. 关于数据 </b></h4>

<ul>
<li> 所有的分析数据都是数值数据.</li>
<li> 新数据（测试集）应覆盖模型中使用的所有自变量。</li>
</ul>

<h4>请按照<b>步骤</b>建模，然后单击<b>输出</b>获取分析结果。</h4>
")
),
hr(),
source("ui_pcr.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pcr_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("偏最小二乘回归（PLSR）",

headerPanel("偏最小二乘回归（PLSR）"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>偏最小二乘回归（PLSR）</b>）是一种回归分析技术，其通过将预测变量和可观测变量投影到一个新的空间来寻找一个线性回归模型。

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 获得相关矩阵和绘图</li>
<li> 获得模型的结果</li>
<li> 获得因子和载荷结果表</li>
<li> 获得2D和3D的因子和载荷分布图</li>
<li> 获得预测的因变量</li>
<li> 上传新数据并进行预测</li>

</ul>

<h4><b> 2. 关于数据（训练集） </b></h4>

<ul>
<li> 所有的分析数据都是数值数据</li>
<li> 新数据（测试集）应覆盖模型中使用的所有自变量。</li>
</ul>

<h4>请按照<b>步骤</b>建模，然后单击<b>输出</b>获取分析结果。</h4>
")
),

hr(),
source("ui_pls.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
),


##########----------##########----------##########
tabPanel("稀疏偏最小二乘回归（SPLSR）",

headerPanel("稀疏偏最小二乘回归（SPLSR）"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>稀疏偏最小二乘回归（SPLSR）</b>は、元の予測因子のわずかな線形組み合わせを作成し、良好な予測性能と変数の選択を同時に達成することを目的とした回帰分析法です。

<h4><b> 1. 功能  </b></h4>
<ul>
<li> 获得相关矩阵和绘图</li>
<li> 获得一个模型的结果</li>
<li> 获得因子和载荷结果表</li>
<li> 获得2D和3D的因子和载荷分布图</li>
<li> 获得预测的因变量</li>
<li> 上传新数据并进行预测</li>
</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット) </b></h4>

<ul>
<li> 所有的分析数据都是数值数据</li>
<li> 新数据（测试集）应覆盖模型中使用的所有自变量。</li>
</ul>

<h4>请按照<b>步骤</b>建模，然后单击<b>输出</b>获取分析结果。</h4>
")
),
hr(),
source("ui_spls.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_spls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tablang(),
tabstop(),
tablink()


))
