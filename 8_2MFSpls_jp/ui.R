if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
if (!requireNamespace("pls",quietly = TRUE)) {install.packages("pls")}; require("pls",quietly = TRUE)
if (!requireNamespace("spls",quietly = TRUE)) {install.packages("spls")}; require("spls",quietly = TRUE)
#if (!require("DT")) {install.packages("DT")}; library("DT")
#if (!require("psych")) {install.packages("psych")}; library("psych")
#if (!require("shinyWidgets")) {install.packages("shinyWidgets")}; library("shinyWidgets")

source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")

tagList(

includeCSS("../www/style_jp.css"),
stylink(),
tabOF(),

navbarPage(

#theme = shinythemes::shinytheme("cerulean"),
#title = a("Dimensional Analysis 2", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "次元分析 2",
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

<h4><b> 2. 使用するデータについて (トレーニングセット)</b></h4>

<ul>
<li> すべてのデータが数値データである必要あります。</li>
<li> モデルを構築するために使用するデータを<b>トレーニングセット</b>と呼びます。</li>
</ul>

<i><h4>使用例：NKIデータ</h4>

ある試験で、何例かのリンパ節陽性乳がん患者について無転移生存を探索的に解析したいとします。データには次の臨床的リスク因子が含まれています：(1) 年齢：診断時の年齢、および 
(2) 再発までの年数。また、先行する試験で70の遺伝子の発現状態が無転移生存の予測因子であることがわかりました。
この例では、年齢、再発までの年数、および遺伝子発現の間の関連を見つけ出すことができるモデルを作成したいとします。

<h4>使用例：肝毒性データ</h4>

このデータセットには、対照試験で、非毒性用量、中等度の毒性のある用量、重度の毒性のある用量のアセトアミノフェンに曝露したラットの遺伝子発現状態と臨床状態が含まれています。

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
tabPanel("主成分回帰(PCR)",

headerPanel("主成分回帰(PCR)"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>主成分回帰(PCR)</b> は、主成分分析 (PCA) に基づいた回帰分析です。主成分回帰では、得られた反応と独立変数の間の最大分散の超平面を見つけます。

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 相関行列とプロットを作成する</li>
<li> モデルから結果を得る</li>
<li> 因子と負荷量の結果を示す表を作成する</li>
<li> 因子と負荷量の分布プロットを2Dと3Dで作成する</li>
<li> 従属変数を予測する</li>
<li> 新しいデータをアップロードし予測を行う</li>

</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 解析のすべてのデータは数値データである</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数をカバーしている必要があります。</li>
</ul>

<h4> <b>手順</b>にしたがってモデルを構築し、<b>Outputs</b>アウトプットをクリックすると解析結果が得られます。</h4>
")
),
hr(),
source("ui_pcr.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pcr_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########
tabPanel("部分的最小二乗回帰(PLSR)",

headerPanel("部分的最小二乗回帰 (PLSR)"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>部分的最小二乗回帰(PLSR)</b>は、予測された変数と観察可能な変数を新しい空間に投影して、線形回帰モデルを見つけ出す回帰分析です。

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 相関行列とプロットを作成する</li>
<li> モデルから結果を得る</li>
<li> 因子と負荷量の結果を示す表を作成する</li>
<li> 因子と負荷量の分布プロットを2Dと3Dで作成する</li>
<li> 従属変数を予測する</li>
<li> 新しいデータをアップロードし予測を行う</li>

</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット) </b></h4>

<ul>
<li> 解析のすべてのデータは数値データである</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数をカバーしている必要があります。</li>
</ul>

<h4> <b>手順</b>にしたがってモデルを構築し、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
")
),

hr(),
source("ui_pls.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_pls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()
),


##########----------##########----------##########
tabPanel("スパース部分的最小二乗回帰(SPLSR)",

headerPanel("スパース部分的最小二乗回帰(SPLSR)"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<b>スパース部分的最小二乗回帰(SPLSR)</b>は、元の予測因子のわずかな線形組み合わせを作成し、良好な予測性能と変数の選択を同時に達成することを目的とした回帰分析法です。

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 相関マトリックスとプロットを作成する</li>
<li> モデルから結果を得る</li>
<li> 因子と負荷量の結果を示す表を作成する</li>
<li> 因子と負荷量の分布プロットを2Dと3Dで作成する</li>
<li> 従属変数を予測する</li>
<li> 新しいデータをアップロードし予測を行う</li>
</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット) </b></h4>

<ul>
<li> 解析のすべてのデータは数値データである</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数をカバーしている必要があります。</li>
</ul>

<h4> <b>手順</b>にしたがってモデルを構築し、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
")
),
hr(),
source("ui_spls.R", local=TRUE, encoding="UTF-8")$value,
hr(),
source("ui_spls_pr.R", local=TRUE, encoding="UTF-8")$value,
hr()

),

##########----------##########----------##########

tablang("8_2MFSpls"),
tabstop(),
tablink()


))
