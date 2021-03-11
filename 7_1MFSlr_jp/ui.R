if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("DT")) {install.packages("DT")}
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")
source("../tab/func2.R")

tagList(

includeCSS("../www/style.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("線形回帰", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "線形回帰", 
collapsible = TRUE,
id="navibar", 
position="fixed-top",
##########----------##########----------##########


tabPanel("データ",

headerPanel("データの準備"),

conditionalPanel(
condition = "input.explain_on_off",

HTML(
'
<div style = "background-color: #AED6F1; width: 80%; border-radius: 3px;">

<b>線形回帰</b>は、従属変数と、1つまたは複数の独立(説明)変数の関係をモデリングする線形のアプローチです。
独立(説明)変数が1つの場合は、<b>(単純)線形回帰</b>と呼ばれます。
独立(説明)変数が2つ以上の場合は、<b>多重線形回帰</b>と呼ばれます。 

<h4><b> 1. 使用できる機能</b></h4>
<ul>
<li> データファイルをアップロードし、データセットのプレビューを表示してデータが正しく入力されていることをチェックする</li>
<li> モデルを構築するために、必要に応じて一部の変数をあらかじめ処理する</li>
<li> 基本記述統計量を計算し、変数のプロットを描く</li>
</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット)</b></h4>

<ul>
<li> データに<b>1つの従属変数 (Y) </b> と <b> 少なくとも1つの独立変数 (X)</b>が含まれている必要があります。</li>
<li> 列より行の数を多くしてください。</li>
<li> 同じ列に文字と数字を混ぜないこと</li>
<li> モデルを構築するために使用するデータを<b>トレーニングセット</b>と呼びます。</li>
</ul>

<h4><i>使用例</i></h4>

<li> ある試験で、医師が乳児10名の誕生時の体重、年齢 (月齢) 、年齢群 (a = 月齢4ヵ月未満、b = 月齢4か月以上) 、およびSBPを記録しました。
(1) 誕生時の体重を予測し、(2) 誕生時の体重とその他の変数の関係を調べたい、すなわち、どの変数が従属変数に有意に寄与しているかを調べたいとします。

</i>


<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。データの準備ができたら、次のタブでモデルを構築します。</h4>
</div>

'
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("モデルの構築とデータの予測",

headerPanel("線形回帰"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"


<h4><b> 1. 使用できる機能</b></h4>
<li><b>モデルを構築する</b></li>
<ul>
<li> 単回帰線形モデルまたは重回帰線形モデルを構築する </li>
<li> (1) t検定の係数、p値、95%CIの推定、(2) R<sup>2</sup> and adjusted R<sup>2</sup>、(3) 回帰における全体の有意性に関するF検定を含む回帰の推定を行う</li>
<li> 追加の情報を得る：(1) 予想される従属変数と残差、(2) モデルのANOVA表、(3) AICに基づいた変数の選択、および (4) 残差と、予想される従属変数に基づいた診断プロット</li>
<li> 新しいデータをアップロードし予測を得る</li>
<li> 新しい従属変数を含む新たなデータを評価する</li>
</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット)</b></h4>

<ul>
<li> 従属変数は実際の値であり、正規分布の連続変数です。</li>
<li> 前の<b>データ</b>タブでトレーニングセットデータを作成します。</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数を有している必要があります。</li>

</ul>

<h4> <b>手順</b>にしたがってモデルを構築し、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
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
)
)
