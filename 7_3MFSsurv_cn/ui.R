#if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
#if (!require("survival")) {install.packages("survival")}; library("survival")
#if (!require("survminer")) {install.packages("survminer")}; library("survminer")
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("survival", quietly = TRUE)) {install.packages("survival")}; require("survival",quietly = TRUE)
if (!requireNamespace("survminer",quietly = TRUE)) {install.packages("survminer")}; require("survminer",quietly = TRUE)
if (!requireNamespace("survAUC",quietly = TRUE)) {install.packages("survAUC")}; require("survAUC",quietly = TRUE)

#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("reshape2")) {install.packages("reshape2")}; library("reshape2")
#if (!require("survAUC")) {install.packages("survAUC")}; library("survAUC")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

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
#title = a("Survival Analysis", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "生存分析",
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
<h4><b> 1. 功能</b></h4>
<ul>
<li> 上传数据文件时，预览数据集，并检查数据输入的正确性
<li> 构建模型时，（根据需要）对一些变量进行预处理
<li> 计算基本描述性统计量，绘制变量图
<li> 准备<b>生存对象</b>替代模型中的<b>因变量</b>
</ul>

<h4><b> 2. 关于建模数据（训练集）</b></h4>

<ul>
<li> 数据需要包括<b>一个生存时间变量和一个1/0审查变量</b> 以及 <b> 至少一个自变量（X）</b>
<li> 数据的行数必须多于列数
<li> 不要在同一列中混用字符和数字
<li> 用于构建模型的数据称为<b>训练集</b>
</ul>

<i>
<h4>示例1： 糖尿病Diabetes数据</h4>

假设在一项研究中从激光凝固治疗糖尿病视网膜病变的试验中得到一些观察值。每个患者有一只眼随机接受激光治疗，另一只眼不接受治疗。对于每只眼，侧重事件是从开始治疗到连续两次访视视力下降到5/200以下的时间。因此，存在大约6个月的固有滞后时间（每3个月访视一次）。因此，本数据集中的生存时间为实际致盲时间（以月为单位）减去发生事件的最小可能时间（6.5个月）。
删失状态0 = 已删失；1 = 视力下降。治疗：0 = 无治疗，1 = 激光。年龄是诊断时的年龄
</i>


<i>
<h4>示例2： Nki70数据</h4>
假设想探讨100例淋巴结阳性乳腺癌患者的无转移生存率。但有些患者比其他患者入组晚。数据包含5个临床危险因素：（1）Diam：肿瘤的直径；（2）N：受影响的淋巴结数量；（3）ER：雌激素受体状态；（4）分级：肿瘤的分级；(5)年龄：患者诊断时的年龄（岁）；
以及在早期研究中发现对无转移生存期有预后意义的70个基因的基因表达测量。时间变量为无转移随访时间（月）。删失指标变量：1 = 转移或死亡；0 = 删失。
<br><br>
<p>探讨生存期与自变量之间的关系。<p>
</i>

<h4>请参考以下步骤，准备数据。之后在之后的页面中建立模型。</h4>
"
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()


),

##########----------##########----------##########
tabPanel("Kaplan-Meier估计",

headerPanel("非参数Kaplan-Meier估计与对数秩检验"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p> <b>Kaplan-Meier估计量</b>，又称乘积-极限估计量，是一种用于从寿命数据估计生存函数的非参数统计量。 </p>
<p> <b>对数秩检验</b>是一种比较两个样本生存分布的假设检验。该方法比较两组在每个观测事件时间的危险函数的估计值。</p>

<h4><b> 1. 功能</b></h4>
<ul>
<li> 获得Kaplan-Meier存活率估计
<li> 通过各个变量获得Kaplan-Meier生存曲线、累积事件分布曲线和累积危险曲线
<li> 进行对数秩检验，比较两组的生存曲线
<li> 进行配对对数秩检验，比较三组以上的生存曲线
</ul>

<h4><b> 2. 关于数据</b></h4>
<ul>
<li> 在数据选项卡中准备生存对象　
<li> 此模型中需要一个分类变量
</ul>
<h4>请参考以下步骤，准备数据。之后在之后的页面中建立模型。</h4>
"
)
),

hr(),
source("ui_km.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("Cox模型和预测",

headerPanel("半参数Cox回归"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b>Cox回归</b>，又称Cox比例风险回归，假设比例风险假设成立（或假设成立），则有可能在不考虑风险函数的情况下估计影响参数。
Cox回归假设预测变量对生存率的影响随着时间的推移是恒定的，并且在一个尺度上是累积的。</p>

<h4><b> 1. 功能</b></h4>
<ul>
<li> 建立Cox回归模型
<li> 获得模型的估计，例如（1）系数的估计，（2）训练数据的预测，（3）残差，（4）调整的生存曲线，（5）比例危险试验，（6）诊断图
<li> 上传新数据，得到预测
<li> 对新数据包含的新因变量进行评价
<li> 获得Brier评分和时间依赖性AUC
</ul>



<h4><b> 2. 关于建模数据（训练集）</b></h4>

<ul>
<li> 请在“数据”选项卡中准备训练数据
<li> 请在“数据”选项卡中准备生存对象，生存（时间、事件）
<li> 新数据（测试集）应覆盖模型中使用的所有自变量
</ul>

<h4>请参考以下步骤，准备数据。之后在之后的页面中建立模型。</h4>
"
)
),

hr(),
source("ui_cox.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_cox_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("AFT模型和预测",

headerPanel("加速失效时间（AFT）模型"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b>加速失效时间（Accelerated Failure Time，AFT）模型</b>
是一个参数模型，其假设一个协变量的作用是以某个常数加速或减速疾病的生命过程。</p>

<h4><b> 1. 功能</b></h4>
<ul>
<li> 建立AFT模型
<li> 获得模型估计，如参数系数、残差和诊断图
<li> 获得从训练数据预测的拟合值
<li> 上传新数据，得到预测
<li> 对新数据包含的新因变量进行评价
</ul>

<h4><b> 2. 关于数据</b></h4>

<ul>
<li> 在“数据”选项卡中准备训练数据
<li> 请在“数据”选项卡中准备生存对象，生存（时间、事件）
<li> 新数据（测试集）应覆盖模型中使用的所有自变量。
</ul>

<h4>请参考以下步骤，准备数据。之后在之后的页面中建立模型。</h4>
"
)
),

hr(),
source("ui_aft.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_aft_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel


##########----------##########----------##########

tablang("7_3MFSsurv"),
tabstop(),
tablink()

)
##-----------------------over
)
