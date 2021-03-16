#if (!require("Hmisc")) {install.packages("Hmisc")};library("Hmisc")
if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("ggplot2",quietly = TRUE)) {install.packages("ggplot2")}; require("ggplot2",quietly = TRUE)

#if (!require("DT")) {install.packages("DT")}; library("DT")
if (!requireNamespace("plotly",quietly = TRUE)) {install.packages("plotly")}; require("plotly",quietly = TRUE)
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
#title = a("Test for Binomial Proportions", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
title = "二項比率の検定",
collapsible = TRUE,
#id="navbar", 
position="fixed-top",

##########----------##########----------##########

tabPanel("1標本",

headerPanel("標本の比率のカイ二乗検定および正確二項検定"),

conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能</b></h4>
<ul>
<li> データのもとである母集団における率/割合と、指定した率/割合との間に有意差があるかを調べる</li>
<li> 標本の率/割合と、母集団の率/割合の一致性を調べる</li>
<li> ベルヌーイ試行での成功確率を調べる</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> データは二項分布 (成功の割合) である</li>
<li> 全標本と、指定した事象が生じた数 (サブグループの割合) がわかっている</li>
<li> 割合が指定されている (p<sub>0</sub>)</li>
</ul>

<h4><i>使用例</i></h4>
<i>一般母集団で20%の女性が不妊であり、これに対する治療があるとします。妊娠を希望する女性200例がこの治療を受けました。治療を受けた女性40例のうち、10例は妊娠しませんでした。治療を受けた女性における不妊率と、一般の不妊率である20%の間に有意差があるかを調べたいとします。 
</i>
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

headerPanel("独立した2標本の比率のカイ二乗検定"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 2群のデータのもとである母集団で、率/割合に有意差があるかを調べる </ul></li>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 2群のデータのもとである母集団は二項分布 (成功の割合) である</li>
<li> 全標本と、2群において指定した事象が生じた数 (サブグループの割合) がわかっている</li>
<li> 2群は独立した観察である</li>
</ul>

<h4><i>使用例</i></h4>
<i>試験に参加したすべての女性に少なくとも1回の出産経験があるとします。乳がん患者3220例を症例としてデータを収集しました。このうち683例は30歳以降に少なくとも1回の出産経験がありました。また、対照として乳がんのない女性10245例のデータも収集しました。このうち1498例は30歳以降に少なくとも1回の出産経験がありました。初産年齢が30歳超となる確率が、乳がん患者群と非乳がん患者群で差があるかを調べたいとします。
</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b> に解析結果がリアルタイムで出力されます。</h4>    
"
)
),
hr(),

source("ui_2.R", local=TRUE)$value,
hr()


),

##########----------##########----------##########
tabPanel("独立3つ以上の標本",

headerPanel("独立した3つ以上の標本の比率のカイ二乗検定"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 複数の群のデータのもとである母集団で、率/割合に有意差があるかを調べる</li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 群のデータのもとである母集団は二項分布 (成功の割合) である</li>
<li> 全標本と、各群で指定した事象が生じた数 (サブグループの割合) がわかっている</li>
<li> 各群は独立した観察である</li>
</ul>

<h4><i>使用例</i></h4>
<i>初産の年齢と乳がん発症の関係を調べたいとします。このため、乳がん患者3220例、乳がんのない被験者10254例のデータを収集し、被験者を各年齢群に分けました。乳がん発症の確率が、各年齢群で異なるか、または年齢が乳がんと関係があるかを調べたいと思っています。
</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b> に解析結果がリアルタイムで出力されます。</h4>     
"
)
),
hr(),

source("ui_3.R", local=TRUE)$value,
hr()
),

##########----------##########----------##########
tabPanel("独立3つ以上の標本のトレンド",

headerPanel("複数の独立標本における傾向のカイ二乗検定"),
conditionalPanel(
condition = "input.explain_on_off",
HTML(
"
<h4><b> 1. 使用できる機能  </b></h4>
<ul>
<li> 複数の群のデータのもとである母集団で、率/割合に違いがあるかを調べる </li>
</ul>

<h4><b> 2. 使用するデータについて </b></h4>

<ul>
<li> 群のデータのもとである母集団は二項分布 (成功の割合) である</li>
<li> 全標本と、各群で指定した事象が生じた数 (サブグループの割合) がわかっている</li>
<li> 各群は独立した観察である</li>
</ul>

<h4><i>使用例</i></h4>
<i>初産の年齢と乳がん発症の関係を調べたいとします。このため、乳がん患者3220例、乳がんのない被験者10254例のデータを収集し、被験者を各年齢群に分けました。がんの発現率が年齢とともに高くなるのかを調べたいとします。
</i>
<h4> <b>手順</b>にしたがって進むと、<b>アウトプット</b> に解析結果がリアルタイムで出力されます。</h4>     
"
)
),
hr(),

source("ui_t.R", local=TRUE)$value,
hr()

),


##########----------##########----------##########


tablang("4MFSproptest"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))



))


