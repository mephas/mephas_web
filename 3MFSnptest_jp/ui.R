if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("reshape")) {install.packages("reshape")}; library("reshape")
if (!requireNamespace("exactRankTests",quietly = TRUE)) {install.packages("exactRankTests")}; require("exactRankTests",quietly = TRUE)  
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
#title = a("Non-parametric Test for Medians", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "中央値のノンパラメトリック検定",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("1標本",

headerPanel("1標本のウィルコクソン符号順位検定"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
    "
<p>この方法は、データが正規分布であるとは予想されない場合に1標本t検定の代わりに使用します。この方法では、実際の値ではなく観察の順位を使用します。</p>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> データのもとである母集団における中央値/位置と、指定した中央値との間に統計的有意差があるかを調べる</li>
<li> データの基本記述統計量を把握する</li>
<li> データの箱ひげ図、分布ヒストグラム、密度分布などの記述統計プロットを把握する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは1種類の値 (または1つの数ベクトル) のみ</li>
<li> 指定した中央値からの距離を測定する意義のあるデータである</li>
<li> 値は独立した観察である</li>
<li> データの分布の形の前提条件がなく、正規分布ではない可能性がある</li>
</ul>

<h4><i>使用例</i></h4>
<i>特定の患者群9例からうつ病評価尺度 (DRS) のデータを得たとします。DRS尺度のスコアが1を超えるとうつ病を示す場合、患者のDRSが1より有意に大きいかを調べたいとします。
</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>


    "
)
),

hr(),
source("ui_1.R", local=TRUE)$value,
hr()

),

##########----------##########----------##########

tabPanel("独立2標本",

headerPanel("独立した2標本のウィルコクソン順位和検定 (マンホイットニーのU検定)"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(

    "
<p>この方法は、データが正規分布であるとは予想されない場合に2標本t検定の代わりに使用します。</p>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 2群のデータのもとである2つの母集団の間で、中央値に統計的有意差があるかを調べる</li>
<li> 2群のデータの分布の位置が異なるかを調べる</li>
<li> データの基本記述統計量を把握する</li>
<li> データの箱ひげ図、分布ヒストグラム、密度分布などの記述統計プロットを把握する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは2種類の値 (または2つの数ベクトル) のみ</li>
<li> 2群の値の距離を測定する意義のあるデータである</li>
<li> 値は独立した観察である</li>
<li> データの分布の形の前提条件がない</li>
<li> データは正規分布ではない可能性がある</li>
</ul>

<h4><i>使用例</i></h4>
<i>特定の患者群19例からうつ病評価尺度 (DRS) のデータを得たとします。19例のうち、女性は9例、男性は10例です。患者のDRSスコアに男性と女性で有意差があるか、または年齢とDRSスコアの間に関連があるかを調べたいとします。
</i>
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

headerPanel("対応のある2標本のウィルコクソン符号順位検定"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
    "
<b>対応のある場合は、2群間の差と0を比較します。したがってこれは1標本の検定となります。</b>
<p>この方法は、データが正規分布であるとは予想されない場合に対応のあるt検定の代わりに使用します。</p>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 対応のあるデータの差と0の間に統計的有意差があるかを調べる</li>
<li> データの基本記述統計量を把握する/li>
<li> データの箱ひげ図、分布ヒストグラム、密度分布などの記述統計プロットを把握する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは2種類の値 (または2つの数ベクトル) のみ</li>
<li> 指定した中央値からの距離を測定する意義のあるデータである</li>
<li> 値は対応があるか、またはマッチさせた観察である</li>
<li> データの分布の形の前提条件がない</li>
<li> データは正規分布ではない可能性がある</li>
</ul>

<h4><b> 3. マッチした、あるいは対応のあるデータの例 </b></h4>
<ul>
<li>  1例のの検査前と検査後のスコア</li>
<li>  2標本がマッチしている、あるいは対応がある場合</li>
</ul>


<h4><i>使用例</i></h4>
<i>治療が有効であることを示す目的で、治療前と治療後でDRSに有意差があるか、または治療前と治療後の差と0の間に有意差があるかを知りたいとします。
</i>
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

))

