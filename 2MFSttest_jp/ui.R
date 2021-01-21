if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("reshape")) {install.packages("reshape")}; library("reshape")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########
navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("Parametric T Test for Means", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "平均のパラメトリックT検定",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########
tabPanel( "1標本",

headerPanel("1標本T検定"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> T検定の結果から、データの平均値と指定された平均値との間に統計的有意差があるかを調べる</li>
<li> データの基本記述統計量を把握する</li>
<li> データの箱ひげ図、平均sdプロット、QQプロット、分布ヒストグラム、密度分布プロットなどの記述統計プロットを把握し、データが正規分布に近いかを調べる</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは1種類の値 (または１つの数ベクトル) のみ</li>
<li> 値は独立した観察であり、ほぼ正規分布である</li>
</ul>

<i><h4>使用例</h4>
リンパ節陽性患者 (独立した観察) 50例の年齢データを収集し、リンパ節陽性患者の一般的な年齢が50歳であったかを調べたいとします。
</h4></i>


<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b> に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_1.R", local=TRUE)$value,

hr()


),


##########----------##########----------##########
tabPanel("独立2標本",

headerPanel("独立2標本T検定"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> T検定の結果から、2組のデータの間で平均値に有意差があるかを調べる</li>
<li> データの基本記述統計量を把握する</li>
<li> データの箱ひげ図、平均sdプロット、QQプロット、分布ヒストグラム、密度分布プロットなどの記述統計プロットを把握し、データが正規分布に近いかを調べる</li>

</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは2つの別々の群/セット (または2つの数ベクトル)</li>
<li> 2つの別々の群/セットは独立しており、ほぼ正規分布となっている</li>
</ul>

<i><h4>使用例</h4>
リンパ節陽性患者 (独立した観察) 50例の年齢データを収集し、そのうち25例はエストロゲン受容体 (ER) 陽性、25例はER陰性であったとして一般的にER陽性患者の年齢はER陰性患者と有意差があるのか、あるいはERが年齢と関連するのかを調べたいとします。
</h4></i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>

"
)
),

hr(),

source("ui_2.R", local=TRUE)$value,

hr()

),


##########----------##########----------##########
tabPanel("対応のあるサンプル",

headerPanel("対応のあるT検定"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>対応のある場合、2群の差を0と比較します。したがってこれは1標本の検定となります。</b>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 対応のある2標本の差が0に等しいかを調べる</li>
<li> データの基本記述統計量を把握する</li>
<li> データの箱ひげ図、平均sdプロット、QQプロット、分布ヒストグラム、密度分布プロットなどの記述統計プロットを把握し、データが正規分布に近いかを調べる</li>

</ul>


<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは2つの別々の群/セット (または2つの数ベクトル))</li>
<li> マッチした、あるいは対応のある2標本</li>
<li> 対応のある標本の差がほぼ正規分布となっている</li>
</ul>

<h4><b> 3. マッチした、あるいは対応のあるデータの例 </b></h4>
<ul>
<li>  検査前と検査後のスコア</li>
<li>  マッチさせた、あるいは対応させた2標本がある場合</li>
</ul>


<h4><i>使用例</i></h4>
<i>ある薬剤が睡眠時間に影響を及ぼすかを知るためにデータを収集したと仮定します。その薬剤の服用前と服用後の睡眠時間のデータを10例から収集しました。これが「対応のある」例です。この薬剤の服用前と服用後で睡眠時間に有意差があるか、または服用前と服用後の差が0と有意差があるかを知りたいとします。</i>


<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>

"
)
),

hr(),

source("ui_p.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########
tablang(),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))
)
)
