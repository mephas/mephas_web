if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style_jp.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("離散確率分布", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "離散確率分布",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("二項分布",p(br()),

headerPanel("二項分布"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> 二項分布B(n,p) のプロットを得る (nは合計標本サイズ、pは合計標本からの成功確率または事象の確率。np = 平均、np(1-p) = 分散)</li>
<li> 特定の位置 (赤色の点) の確率を得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>血球がリンパ球である確率が0.2のとき、白血球10個のうち2個がリンパ球である確率を調べたいとします。</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>

"
)
),
hr(),
source("ui_bio.R", local=TRUE, encoding = "utf-8")$value,
hr()

),


##########----------##########----------##########

tabPanel("ポアソン分布",

headerPanel("ポアソン分布"),
#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> ポアソン分布P (率) のプロットを描く (率は予想される発生数。率 = 平均 = 分散)</li>
<li> 特定の位置 (赤色の点) の確率を得る</li>
</ul>

<i><h4>使用例</h4>
12ヵ月間の腸チフス熱による死亡数が、パラメータ率2.3のポアソン分布であると仮定し、6ヵ月間の死亡数の確率分布を調べたいとします。</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>

"
)
),
hr(),
source("ui_poi.R", local=TRUE, encoding = "utf-8")$value,
hr()

),

##########----------##########----------##########
tablang("1_2MFSdisdist"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))


))

