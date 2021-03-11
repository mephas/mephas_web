if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
#if (!require("ROCR")) {install.packages("ROCR")}; library("ROCR")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_cn.R")
source("../tab/panel_cn.R")
source("../tab/func.R")
source("../tab/func2.R")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("逻辑回归", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "逻辑回归",
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
<b>逻辑回归</b>用于模拟一个特定类或事件的现有二进制输出的概率，例如通过/未通过、赢/输、活/死或健康/生病。逻辑回归使用逻辑函数模拟二元因变量。

<h4><b> 1. 功能</b></h4>
<ul>
<li> 上传数据文件时，预览数据集，并检查数据输入的正确性</li>
<li> 构建模型时，（根据需要）对一些变量进行预处理</li>
<li> 计算基本描述性统计量，绘制变量图</li>
</ul>

<h4><b> 2. 关于数据（训练集）</b></h4>

<ul>
<li> 数据需要包括<b>一个二进制因变量(Y)</b> 和 <b> 至少一个自变量(X) </b>。</li>
<li> 数据的行数必须多于列数。</li>
<li> 不要在同一列中混用字符和数字</li>
<li> 用于构建模型的数据称为<b>训练集</b>。</li>
</ul>

<h4><i>示例</i></h4>

<i>假设想探讨乳腺癌数据集，并开发一个模型来尝试将可疑细胞分为良性（B）或恶性（M）。因变量是二进制结果（B/M）。（1）建立一个模型，计算良性或恶性的概率，并测定患者病情是良性还是恶性；（2）找出二元因变量与其他变量之间的关系，即找出哪个变量对因变量有显著的影响。
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
tabPanel("模型构建和数据预测",

headerPanel("逻辑回归"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 建立简单或多元逻辑回归模型</li>
<li> 得出回归估计，包括（1）用t检验、p值和95% CI进行系数估计，（2）R<sup>2</sup>和经调整的R<sup>2</sup>和（3）F检验进行回归的总体显著性</li>
<li> 获得更多信息：（1）预测因变量和残差，（2）基于AIC的变量选择，（3）ROC图，（4）ROC图的敏感性和特异性表</li>
<li> 上传新数据，得到预测</li>
<li> 对新数据包含新因变量的评价</li>
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 因变量是二进制数据</li>
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

tablang(),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

)
)

