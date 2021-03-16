if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
#if (!require("plotly")) {install.packages("plotly")}; library("plotly")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("stargazer")) {install.packages("stargazer")}; library("stargazer")
#if (!require("ROCR")) {install.packages("ROCR")}; library("ROCR")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")
source("../tab/func2.R")

tagList(

includeCSS("../www/style_jp.css"),
stylink(),
tabOF(),

##########--------------------##########--------------------##########

navbarPage(
theme = shinythemes::shinytheme("cerulean"),
#title = a("ロジスティック回帰", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "ロジスティック回帰",
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
<b>ロジスティック回帰</b>は、合格/不合格、勝ち/負け、生存/死亡、健康/病気など、既存の二値のアウトプットについて、特定のクラスまたは事象が生じる確率をモデル化するために使用します。
ロジスティック回帰では、ロジスティック関数を使用して、二値の従属変数をモデル化します。

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> データファイルをアップロードし、データセットのプレビューを表示してデータが正しく入力されていることをチェックする</li>
<li> モデルを構築するために、必要に応じて一部の変数をあらかじめ処理する</li>
<li> 基本記述統計量を得て、変数のプロットを描く</li>
</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット) </b></h4>

<ul>
<li> データに<b>1つの二値従属変数 (Y) </b> および <b> 少なくとも1つの独立変数 (X) </b>が含まれている必要あります。</li>
<li> 列より行の数を多くしてください。</li>
<li> 同じ列に文字と数字を混ぜないこと</li>
<li> モデルを構築するために使用するデータを<b>トレーニングセット</b>と呼びます。</li>
</ul>

<h4><i>使用例</i></h4>

<i>乳がんのデータセットを調べ、疑いのある細胞を良性 (B) または悪性 (M) と分類するモデルを開発したいとします。従属変数は二値アウトカムです (B/M)。(1) モデルを構築して良性と悪性の確率を計算し、患者の病巣が良性であるか悪性であるかを決定し、(2) 二値の従属変数と他の変数の関係を検出する、すなわち、どの変数が従属変数に有意に寄与しているかを検出したいとします。

</i>

<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。データの準備ができたら、次のタブでモデルを探します。</h4>
"
)
),

hr(),
source("ui_data.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("モデルの構築とデータの予測",

headerPanel("ロジスティック回帰"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> ロジスティック単回帰モデルまたは重回帰モデルを構築する</li>
<li> (1) t検定の係数、p値、95% CIの推定値、(2)  R<sup>2</sup> and adjusted R<sup>2</sup>、 (3) 回帰における全体の有意性に関するF検定を含む回帰の推定を行う</li>
<li> 追加の情報を得る：(1) 予測された従属変数と残差、(2) AICに基づいた変数の選択、(3) ROCプロット、および (4) ROCプロットに関する感度と特異度</li>
<li> 新しいデータをアップロードし予測を得る</li>
<li> 新しい従属変数を含む新たなデータを評価する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 従属変数は二値である</li>
<li> 前の<b>データ</b>タブでトレーニングセットデータを作成します。</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数をカバーしている必要があります。</li>
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

tablang("7_2MFSlogit"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

)
)

