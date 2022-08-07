if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("DT")) {install.packages("DT")}
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_cn.R", encoding="utf-8")
source("../tab/panel_cn.R", encoding="utf-8")
source("../tab/func.R", encoding="utf-8")
source("../tab/func2.R", encoding="utf-8")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("线性回归", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "线性回归", 
collapsible = TRUE,
id="navibar", 
position="fixed-top",
##########----------##########----------##########


tabPanel("数据",

headerPanel("准备数据"),

conditionalPanel(
condition = "input.explain_on_off",

HTML(
'
<div style = "background-color: #AED6F1; width: 80%; border-radius: 3px;">

<b>线性回归</b>是对因变量和一个或多个自变量之间的关系进行建模的线性方法。
一个解释变量(自变量)的情况称为<b>（简单）线性回归</b>。
对于两个以上的解释变量，该过程称为<b>多元线性回归</b>。 

<h4><b> 1. 功能</b></h4>
<ul>
<li> 上传数据文件时，预览数据集，并检查数据输入的正确性</li>
<li> 构建模型时，（根据需要）对一些变量进行预处理</li>
<li> 计算基本描述性统计量，绘制变量图</li>
</ul>

<h4><b> 2. 关于数据（训练集）</b></h4>

<ul>
<li> 数据需要包括<b>一个因变量（Y） </b> 和<b> 至少一个自变量（X）</b>。</li>
<li> 数据的行数必须多于列数。</li>
<li> 不要在同一列中混用字符和数字</li>
<li> 用于构建模型的数据称为<b>训练集</b></li>
</ul>

<h4><i>示例</i></h4>

<li> 假设在一项研究中，医生记录了10名婴儿的出生体重，年龄（月龄），年龄组（a：年龄 < 4个月，b：4个月以上）和收缩压。
这里想（1）预测婴儿出生体重，（2）找出出生体重与其他变量之间的关系，即找出哪个变量对因变量有显著影响。

</i>


<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。准备好数据后，请在下一个选项卡中构建模型。</h4>
</div>

'
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("模型构建和数据预测",

headerPanel("线性回归"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"


<h4><b> 1. 功能</b></h4>
<li><b>模型构建</b></li>
<ul>
<li> 建立简单或多元线性回归模型 </li>
<li> 得出回归估计，包括（1）用t检验、p值和95% CI进行系数估计，（2）R<sup>2</sup> 和经调整的R<sup>2</sup>，（3）F检验进行回归的总体显著性</li>
<li> 获得更多信息：（1）预测因变量和残差，（2）模型的ANOVA表，（3）基于AIC的变量选择，（4）基于残差和预测因变量的诊断图</li>
<li> 上传新数据，得到预测</li>
<li> 对新数据包含新因变量的评价</li>
</ul>

<h4><b> 2. 关于数据（训练集）</b></h4>

<ul>
<li> 因变量是实数值，在一个基本的正态分布下是连续的。</li>
<li> 请在上一个<b>数据</b>页面中准备训练集数据。</li>
<li> 新数据（测试集）应覆盖模型中使用的所有自变量。</li>

</ul>

<h4>请按照<b>步骤</b>建模，然后单击<b>输出</b>获取分析结果。</h4>
"
)
),

hr(),
source("ui_model.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tablang("7_1MFSlr"),
tabstop(),
tablink()
)
)
