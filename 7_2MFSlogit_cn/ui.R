if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!require("plotly")) {install.packages("plotly")}; library("plotly")
# if (!require("psych")) {install.packages("psych")}; library("psych")
# if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
# if (!require("ROCR")) {install.packages("ROCR")}; library("ROCR")
# if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")
# if (!require("dplyr")) {install.packages("dplyr")}; library("dplyr")
Sys.setlocale(locale = "Chinese")


source("../tab/tab_cn.R", encoding="utf-8")
source("../tab/panel_cn.R", encoding="utf-8")
source("../tab/panel_plotinfo_cn.R", encoding="utf-8")
source("../tab/func.R", encoding="utf-8")
source("../tab/func2.R", encoding="utf-8")

tagList(

includeCSS("../www/style_cn.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
#theme = shinythemes::shinytheme("cerulean"),
#title = a("逻辑回归", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "逻辑回归",
collapsible = TRUE,
id="navibar", 
position="fixed-top",
##########----------##########----------##########

tabPanel("准备数据",

headerPanel("准备数据"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>逻辑回归</b>通常用于分类和预测性分析。
逻辑回归根据给定的自变量数据集来估计事件的发生概率，如发生或未发生。 
由于结果是一个概率，因此范围在0和1之间。 
在逻辑回归中，对概率结果作Logit变换，即发生的概率除以未发生的概率。

<h4><b> 1. 功能</b></h4>
<ul>
<li> 上传数据文件时，预览数据集，并检查数据输入的正确性
<li> 构建模型时，根据需要，对一些变量进行预处理
<li> 计算基本描述性统计量，绘制图表
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 数据需要包括<b>一个二分类因变量(Y)</b> 和 <b> 至少一个自变量(X) </b>
<li> 数据的行数必须多于列数
<li> 不要在同一列中混用字符和数字
<li> 用于构建模型的数据称为<b>训练集</b>
<li> 用于预测的数据称为<b>测试集</b>
</ul>

<i><h4>示例</h4>

假设想探讨乳腺癌细胞的分类，并开发一个模型尝试将可疑细胞分为良性（B）或恶性（M）。
因变量是二分类结果（B/M）。
（1）建立一个模型，计算良性或恶性的概率，并测定患者病情是良性还是恶性；
（2）找出二元因变量与其他变量之间的关系，即找出哪个变量对因变量有显著的影响。
</i>

<h4>请参考以下步骤，准备数据。之后在第二个页面中建立模型。</h4>
"
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("模型构建和预测",

headerPanel("逻辑回归"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 功能</b></h4>
<ul>
<li> 建立简单或多元逻辑回归模型
<li> 得出回归估计，包括（1）用t检验、p值和95% CI进行系数估计，（2）R<sup>2</sup>和经调整的R<sup>2</sup>和（3）F检验进行回归的总体显著性
<li> 获得更多信息：（1）预测因变量和残差，（2）基于AIC的变量选择，（3）ROC图，（4）ROC图的敏感性和特异性表
<li> 上传新数据，得到预测
<li> 对新数据包含新因变量的评价
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 因变量是二分类数据
<li> 请在上一个<b>数据</b>页面中准备训练集数据。
<li> 新数据（测试集）应覆盖模型中使用的所有自变量。
</ul>

<h4>请参考以下步骤，输出分析结果。</h4>
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

tablang("7_2MFSlogit"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

)
)

