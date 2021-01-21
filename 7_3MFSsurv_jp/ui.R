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
#title = a("Survival Analysis", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "生存分析",
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
<li> モデルの<b>従属変数</b>の代わりに<b>生存データオブジェクト</b>を作成する</li>
</ul>

<h4><b> 2. 使用するデータについて (トレーニングセット)</b></h4>

<ul>
<li> データに<b>1つの生存時間変数と、1つの1/0打ち切り変数</b> および <b> 少なくとも1つの独立変数 (X) が必要です。</b></li>
<li> 列より行の数を多くしてください。</li>
<li> 同じ列に文字と数字を混ぜないこと</li>
<li> モデルを構築するために使用するデータを<b>トレーニングセット</b>と呼びます。</li>
</ul>

<h4><i>使用例 1: 右で打ち切った糖尿病データ</i></h4>
<i>ある試験で、糖尿病性網膜症の治療としてレーザー凝固法を使用し、いくつかの観察結果を得ました。各患者の片眼をレーザー治療に無作為化し、
他方の眼には治療を行いませんでした。それぞれの眼について、目的の事象は、治療開始から視力検査結果が2回連続して5/200未満になるまでの時間でした。
このため、観察期間として約6ヵ月間のラグタイム (来院は3ヵ月ごと) が組み込まれます。このデータセットにおける生存時間は、視力を失うまでの実際の時間 (月) から
事象までの最小時間 (6.5ヵ月) を差し引いた時間です。打ち切りステータスは、0= 打ち切り、1 = 視力喪失です。治療：0 = 治療なし、1= レーザー治療年齢は診断時の年齢です。
</i>


<h4><i>使用例 2: 左を切り捨て右を打ち切ったNki70データ</i></h4>
<i>100例のリンパ節陽性乳がん患者の無転移生存について調べたいとします。しかし、試験参加時期は参加者間でずれがあります。
データには5つの臨床的リスク因子が含まれています：(1) 径：腫瘍径、(2) N：病変のあるリンパ節の数、(3) ER：エストロゲン受容体の状態、
(4) グレード：腫瘍のグレード、および (5) 年齢：診断時の患者の年齢。また、先行する試験で70の遺伝子の発現状態が無転移生存の予測因子であることがわかりました。
時間変数は、無転移フォローアップ時間 (月) です。打ち切りインジケータ変数：1 = 転移または死亡、0 = 打ち切り
<br><br>
<p>生存時間と独立変数の関連を調べたいとします。<p>
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
tabPanel("KM モデル",

headerPanel("ノンパラメトリック・カプラン・マイヤー推定量とログランク検定"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p> <b>カプラン・マイヤー推定量</b>は積極限推定量とも呼ばれ、寿命データから生存関数を推定するために使用します。</p>
<p> <b>ログランク検定</b>は、2標本の生存分布を比較する仮説検定です。ログランク検定では、各事象が観察された時間における2群のハザード関数の推定を比較します。</p>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> カプラン・マイヤー生存確率を推定する</li>
<li> グループ変数ごとに、カプラン・マイヤー生存曲線、累積事象分布曲線、および累積ハザード曲線を作成する</li>
<li> ログランク検定を行って、2群の生存曲線を比較する</li>
<li> 対応のあるログランク検定を行って、3群以上の生存曲線を比較する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>
<ul>
<li> データタブで生存データオブジェクトを作成してください。　</li>
<li> このモデルではカテゴリ変数が必要です。　</li>
</ul>
<h4> <b>手順</b>にしたがってモデルを構築し、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
"
)
),

hr(),
source("ui_km.R", local=TRUE, encoding="UTF-8")$value,
hr()
), ## tabPanel

##########----------##########----------##########

tabPanel("コックス(Cox)モデルと予測",

headerPanel("セミパラメトリック・コックス回帰"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b>コックス回帰</b>はコックス比例ハザード回帰とも呼ばれ、比例ハザードの仮定が成り立つ場合 (または成り立つと仮定される場合)、ハザード関数を考慮せずに効果のパラメータを推定することが可能です。コックス回帰では、予測変数が生存に与える作用は経時的に一定であり、1つの尺度で相加的であると仮定します。</p>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> コックス回帰モデルを構築する</li>
<li> (1) 係数の推定、(2) トレーニングデータからの予測、(3) 残差、(4) 調整生存曲線、(5) 比例ハザード検定、および (6) 診断プロットなどのモデルの推定を行う</li>
<li> 新しいデータをアップロードし予測を得る</li>
<li> 新しい従属変数を含む新たなデータを評価する</li>
<li> Brierスコアと時間依存AUCを得る</li>
</ul>



<h4><b> 2. 使用するデータについて (トレーニングセット)</b></h4>

<ul>
<li> データタブでトレーニングデータを作成します。</li>
<li> データタブで生存データオブジェクトSurv(time, event) を作成します。</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数をカバーしている必要があります。</li>
</ul>

<h4> <b>手順</b> にしたがってモデルを構築し、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
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

tabPanel("AFTモデルと予測",

headerPanel("パラメトリック加速死亡時間モデル (accelerated failure time [AFT]) モデル"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<p><b>加速死亡時間 (accelerated failure time [AFT]) モデル</b>
は、共変量の作用がある定数だけ疾患の経過を加速または減速することを仮定するパラメトリック・モデルです。</p>

<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> AFTモデルを構築する</li>
<li> パラメータの係数、残差、診断プロットなど、モデルの推定値を得る</li>
<li> トレーニングデータから予測されるフィットした値を得る</li>
<li> 新しいデータをアップロードし予測を得る</li>
<li> 新しい従属変数を含む新たなデータを評価する</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データタブでトレーニングデータを作成してください</li>
<li> データタブで生存データオブジェクトSurv(time, event) を作成してください。</li>
<li> 新しいデータ (テストセット) は、モデルに使用するすべての独立変数をカバーしている必要があります。</li>
</ul>

<h4> <b>手順</b>にしたがってモデルを構築し、<b>アウトプット</b>をクリックすると解析結果が得られます。</h4>
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

tablang(),
tabstop(),
tablink()

)
##-----------------------over
)
