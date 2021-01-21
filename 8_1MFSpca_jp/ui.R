if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("psych")) {install.packages("psych")}; library("psych")
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

#title = a("Dimensional Analysis 1", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "次元分析 1", 

collapsible = TRUE,
id="navibar", 
position="fixed-top",


##########----------##########----------##########

tabPanel("データ",

headerPanel("データの準備"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> データファイルをアップロードし、データセットのプレビューを表示してデータが正しく入力されていることをチェックする</li>
<li> モデルを構築するために、必要に応じて一部の変数をあらかじめ処理する</li>
<li> 基本記述統計量を得て、変数のプロットを描く</li>
</ul>

<h4><b> 2. 使用するデータについて</b></h4>

<ul>
<li> 列より行の数を多くしてください</li>
<li> すべてのデータが数値データである必要あります</li>
</ul>


<h4><i>使用例1：マウスの遺伝子発現データ</i></h4>

<i>このデータは、食餌に関する実験で使用したマウス20匹から得た遺伝子発現の測定値です。一部のマウスは同じ遺伝子型で、一部の遺伝子変数は相関しています。遺伝子発現データと線形相関を示さない主成分を計算したいとします。</i>

<h4><i>使用例2：化学データ</i></h4>

<i>
ある試験で、7種類の薬剤について9種類の化学的属性を測定しました。一部の化学的属性には潜在的な関連がありました。一連の化学的属性の変数の潜在的な関連構造を探索し、変数を絞りたいとします。
</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
"
)
),
hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),


##########----------##########----------##########
tabPanel("主成分分析(PCA)",

headerPanel("主成分分析(PCA)"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>主成分分析(PCA)</b>は、変数のうち関連する変数を、互いに関連のない主成分と呼ばれる変数にまとめてデータの数を減らす方法です。

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> <b>並列分析</b>から成分の数を推定する</li>
<li> 相関行列を作成し、プロットを描く</li>
<li> 主成分と負荷量の結果を示す表を作成する</li>
<li> 主成分と負荷量の分布プロットを2Dと3Dで作成する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 解析のすべてのデータは数値データである</li>
<li> 独立変数の数よりも標本数のほうが多く、行のほうが列よりも多い</li>
</ul>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。データの準備ができたら、次のタブでモデルを探します。</h4>
")
),
hr(),
source("ui_pca.R", local=TRUE, encoding="UTF-8")$value,
hr()

), #penal tab end

##########----------##########----------##########
tabPanel("探索的因子分析(EFA)",

headerPanel("探索的因子分析(EFA)"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>探索的因子分析(EFA)</b>は、観察された相関する変数の変動を、因子と呼ばれる、より少ない潜在的変数で記述するために使用する統計法です。

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> <b>並列分析</b>から成分の数を推定する</li>
<li> 相関行列とプロットを作成する</li>
<li> 因子と負荷量の結果を示す表を作成する</li>
<li> 因子と負荷量の分布プロットを2Dと3Dで作成する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 解析のすべてのデータは数値データである</li>
<li> 独立変数の数よりも標本数のほうが多く、行のほうが列よりも多い</li>
</ul>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
")
),
hr(),
source("ui_fa.R", local=TRUE, encoding="UTF-8")$value,
hr()
),

##########----------##########----------##########

tablang(),
tabstop(),
tablink()

))

##########----------##########----------####################----------##########----------####################----------##########----------##########
#)
