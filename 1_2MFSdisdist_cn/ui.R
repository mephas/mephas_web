if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
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
#title = a("离散性概率分布", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "散性概率分布",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("二项分布",p(br()),

headerPanel("二项分布"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>功能</b></h4>
<ul>
<li> 绘制二项分布B(n,p)图；n为总样本量，p为总样本中成功/事件的概率；np = 均值，np(1-p) = 方差</li>
<li> 得出某一位置（红点处）的概率</li>
</ul>

<h4><i>示例</i></h4>
<i>假设，如果任何细胞是淋巴细胞的概率为0.2，我们想知道10个白血球细胞中有2个淋巴细胞的概率</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>

"
)
),
hr(),
source("ui_bio.R", local=TRUE)$value,
hr()

),


##########----------##########----------##########

tabPanel("泊松分布",

headerPanel("泊松分布"),
#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>功能</b></h4>
<ul>
<li> 绘制泊松分布P（比率）图；比率表示预期的发生次数；比率=均值=方差</li>
<li> 得出某一位置（红点处）的概率</li>
</ul>

<i><h4>示例</h4>
假设12个月内伤寒死亡人数服从泊松分布，参数比率=2.3。6个月内死亡人数的概率分布是什么？</i>
<h4>请按照以下<b>步骤</b>，<b>输出</b>实时分析结果。</h4>

"
)
),
hr(),
source("ui_poi.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tablang(),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))

