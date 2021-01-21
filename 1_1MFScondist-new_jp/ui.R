

if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
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
#title = a("連続確率分布", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "連続確率分布",
collapsible = TRUE,
#id="navbar",
position="fixed-top",

##########----------##########----------##########
tabPanel("正規分布",

headerPanel("正規分布"),

#condiPa 1
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<p><b>数式から正規分布を描く</b></p>
<ul>
<li>N(&#956, &#963)を使って正規分布を描く( &#956は平均 (位置)、&#963は標準偏差 (形)</li>
<li>確率分布から、ユーザーが定義した確率Pr(X &#8804; x<sub>0</sub>)でのx<sub>0</sub>の位置、すなわち変数Xが(-&#8734, x<sub>0</sub>]の区間にある確率を計算する
<br>曲線形の赤い線の左側の領域がこの確率を表しており、赤い線と横軸 (X軸) の交点がx<sub>0</sub>です。</li>
<li>変数Xが(&#956 &#8211; n &#215 &#963, &#956 + n &#215 &#963]の区間にある確率Pr(&#956 &#8211; n &#215 &#963 < X &#8804; &#956 + n &#215 &#963)を計算する
<br>曲線の青色の領域がこの確率を表しています。</li>
</ul>
<p><b>シミュレーションデータから正規分布を描く</b></p>
<ul>
<li>ユーザーが定義した標本サイズを使用して、正規分布の乱数を生成しダウンロードする</li>
<li>生成した乱数のヒストグラムを描く</li>
<li>生成した乱数の平均(&#956)と標準偏差(&#963)を計算する</li>
<li>生成した乱数の確率分布から、ユーザーが定義した確率Pr(X &#8804; x<sub>0</sub>)でのx<sub>0</sub> の位置、すなわち変数Xが(-&#8734, x<sub>0</sub>]の区間にある確率を計算する</li>
</ul>
<p><b>ユーザーのデータから正規分布を描く</b></p>
<ul>
<li>手入力、またはCSV/TXTファイルを使用してデータをアップロードする</li>
<li>データのヒストグラムと密度プロットを描く</li>
<li>データの平均(&#956)と標準偏差(&#963)を計算する</li>
<li>データの確率分布から、ユーザーが定義した確率Pr(X &#8804; x<sub>0</sub>)でのx<sub>0</sub> の位置、すなわち変数Xが(-&#8734, x<sub>0</sub>]の区間にある確率を計算する</li>
</ul>

<i><h4>使用例</h4>
N(0, 1) の形を確認し、 1. Pr(X < x<sub>0</sub>) = 0.025のときのx<sub>0</sub>の位置、および2. 平均 +/- 標準偏差(SD)の確率を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
	),


hr(),

source("ui_N.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("指数分布",

headerPanel("指数分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> E (率) の指数分布を描く (率は変化率を指す)</li>
<li> x<sub>0</sub>の確率分布、すなわち Pr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> E (率) とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>E(2) の形、およびPr(X < x<sub>0</sub>)= 0.05のときのx<sub>0</sub>の位置を調べたいとします。</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>

"

)
),

hr(),

source("ui_E.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("ガンマ分布",

headerPanel("ガンマ分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> ガンマ(&#945, &#952)からガンマ分布を描く(&#945によって形が変わり、 1/&#952によって率の変化が変わる)</li>
<li> x<sub>0</sub>の確率分布、すなわちPr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> ガンマ(&#945, &#952)とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<i><h4>使用例</h4>
ガンマ(9,0.5) の形、およびPr(X < x<sub>0</sub>)= 0.05のときのx<sub>0</sub>の位置を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_G.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("ベータ分布",

headerPanel("ベータ分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 使用できる機能</b></h4>
<ul>
<li> ベータ(&#945, &#946)からベータ分布を描く (&#945, &#946によって形が変わる)</li>
<li> x<sub>0</sub>の確率分布、すなわちPr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> ベータ(&#945, &#946)とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>ベータ(12, 12) の形、およびPr(X < x<sub>0</sub>)= 0.05のときのx<sub>0</sub>の位置を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_B.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("ステューデントのT分布",

headerPanel("ステューデントのT分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> T(v) のT分布を描く(vは標本サイズの自由度で、これにより形が変わる)</li>
<li> x<sub>0</sub>の確率分布、すなわちPr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> T(v) とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>T(4) の形、およびPr(X < x<sub>0</sub>)= 0.025のときのx<sub>0</sub>の位置を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_T.R", local=TRUE)$value,

hr()
),


##########----------##########----------##########
tabPanel("カイ二乗分布",

headerPanel("カイ二乗分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> カイ(v) のカイ二乗分布を描く (vは標本サイズの自由度で、これにより形が変わる)</li>
<li> x<sub>0</sub>の確率分布、すなわちPr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> カイ(v) とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>カイ(4) の形、およびPr(X < x<sub>0</sub>)= 0.05のときのx<sub>0</sub>の位置を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_Chi.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tabPanel("F分布",

headerPanel("F分布"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 使用できる機能</b></h4>
<ul>
<li> (df<sub>1</sub>, df<sub>2</sub>)でF分布を描く(df<sub>1</sub>およびdf<sub>2</sub>は標本サイズの自由度で、これにより形が変わる)</li>
<li> x<sub>0</sub>の確率分布、すなわちPr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> F(df<sub>1</sub>, df<sub>2</sub>)とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>F(100, 10) の形、およびPr(X < x<sub>0</sub>)= 0.05のときのx<sub>0</sub>の位置を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_F.R", local=TRUE)$value,

hr()
),

tabPanel("ユーザデータ",

headerPanel("データの分布を探す"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b>使用できる機能</b></h4>
<ul>
<li> (df<sub>1</sub>, df<sub>2</sub>)でF分布を描く(df<sub>1</sub>およびdf<sub>2</sub>は標本サイズの自由度で、これにより形が変わる)</li>
<li> x<sub>0</sub>の確率分布、すなわちPr(X &#8804; x<sub>0</sub>)が赤線の左側にある確率分布を得る</li>
<li> シミュレーションデータのタブで入力したシミュレーションの数値から確率分布を得る</li>
<li> シミュレーションデータのタブにある乱数をダウンロードする</li>
<li> シミュレートした数値の平均、標準偏差(SD)、Pr(X &#8804; x<sub>0</sub>)を得る</li>
<li> F(df<sub>1</sub>, df<sub>2</sub>)とおおよそで比較できる確率分布をデータから得る</li>
</ul>

<h4><i>使用例</i></h4>
<i>F(100, 10) の形、およびPr(X < x<sub>0</sub>)= 0.05のときのx<sub>0</sub>の位置を調べたいとします。</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
"
)
),

hr(),

source("ui_data.R", local=TRUE)$value,

hr()
),

##########----------##########----------##########
tablang(),
tabstop(),
tablink()

#navbarMenu("",icon=icon("link"))

))

