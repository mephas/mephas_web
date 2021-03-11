#****************************************************************************************************************************************************km

sidebarLayout(


sidebarPanel(

tags$head(tags$style("#str {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmt {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmt1 {overflow-y:scroll; max-height: 350px; background: white};")),
tags$head(tags$style("#kmlr {overflow-y:scroll; max-height: 350px; background: white};")),

h4(tags$b("グループ変数を選択してモデルを構築する")),

p("データタブでデータを作成します。"),
hr(),          

p(tags$b("1. データタブで生存データオブジェクトSurv(time, event) をチェックする")), 

uiOutput('g'),
tags$i("糖尿病データの例では、カテゴリグループ変数として「レーザー」を選択します。すなわち、2つのレーザー群で生存曲線が異なるかを調べます。 "),

hr(),

h4(tags$b("ログランク検定(Log-rank Test)")),      

p(tags$b("帰無仮説")),
p("2群のハザード関数は同一"),

radioButtons("rho", "ログランク検定の方法を選択する", selected=0,
  choiceNames = list(
    HTML("1. ログランク検定"),
    HTML("2. Gehan-Wilcoxon検定とPeto&Peto修正")
    ),
  choiceValues = list(0, 1)
  ),
p("Output 2. ログランク検定タブの説明を参照してください。"),
hr(),

h4(tags$b("対応のあるログランク検定(Pairwise Log-rank Test)")),      

p(tags$b("帰無仮説")),
p("2群のハザード関数は同一"),

radioButtons("rho2", "1. ログランク検定の方法を選択する", selected=0,
  choiceNames = list(
    HTML("1. ログランク検定"),
    HTML("2. Gehan-Wilcoxon検定のPeto & Peto修正")
    ),
  choiceValues = list(0, 1)
  ),
radioButtons("pm", 
  "2. P値の調整する方法を選択する", selected="BH",
  choiceNames = list(
    HTML("Bonferroni法"),
    HTML("Bonferroni-Holm法：よく使われます。"),
    #HTML("Bonferroni-Hochberg法"),
    #HTML("Bonferroni-Hommel法"),
    HTML("偽発見率-BH(False Discovery Rate-BH)"),
    HTML("偽発見率-BY(False Discovery Rate-BY)")
    ),
  choiceValues = list("B", "BH", "FDR", "BY")
  ),
p("2. 対応のあるログランク検定タブの説明を参照してください。")

#tags$style(type='text/css', '#km {background-color: rgba(0,0,255,0.10); color: blue;}'),
#verbatimTextOutput("km", placeholder = TRUE),

),

mainPanel(

h4(tags$b("Output 1. データの確認")),
 tabsetPanel(
   tabPanel("変数情報",p(br()),
 verbatimTextOutput("str")
 
 ),
tabPanel("データの一部", br(),
p("データの全体を確認したい場合、データタブで確認してください"),
 DT::DTOutput("Xdata2")
 )

 ),
 hr(),
 
# #h4(tags$b("Output 2. Model Results")),
#actionButton("B1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. フィッティングとテスト結果")),
p(br()),
tabsetPanel(
tabPanel("カプランマイヤー生存確率(Kaplan-Meier Survival Probability)",  p(br()),
  p(tags$b("グループ別のカプランマイヤー生存確率(Kaplan-Meier Survival Probability)")),
    verbatimTextOutput("kmt")
     ),
tabPanel("グループ別のカプランマイヤープロット",  p(br()),
    radioButtons("fun2", "表示したいプロットを選んでください", 
  choiceNames = list(
    HTML("1. 生存確率"),
    HTML("2. 累積イベント"),
    HTML("3. 累積ハザード")
    ),
  choiceValues = list("pct", "event","cumhaz")
  ),
    plotOutput("km.p", width = "80%"),
     verbatimTextOutput("kmt1")
     ),
tabPanel("ログランク検定",  p(br()),
       HTML("
<b> 説明 </b>
<p>これにより、各死亡の重みづけS(t)<sup>rho</sup>で、HarringtonとFleming (1982) のG-rhoファミリーが実装されます。上式でSはカプラン・マイヤーの生存推定です。</p>
<ul>
<li>rho = 0：ログランクまたはマンテル・ヘンツェル検定</li>
<li>rho = 1：Gehan-Wilcoxon検定のPeto & Peto修正</li>
<li>p < 0.05の場合、曲線の生存確率に有意差が示されます</li>
<li> p >= 0.05の場合、曲線の生存確率に有意差が示されます</li>

</ul>"),

p(tags$b("ログランク検定の結果")),
    verbatimTextOutput("kmlr"),
    p(tags$i("この例では、2つのレーザー群の間に統計的な差はありませんでした (p = 0.8) 。またカプラン・マイヤー・プロットから、2つのレーザー群の間の生存曲線は互いに交差することがわかりました。"))
     ),

tabPanel("対応のあるログランク検定",  p(br()),


     HTML(
  "<b> 説明 </b>
  <p>これにより、各死亡の重みづけS(t)<sup>rho</sup>で、HarringtonとFleming (1982) のG-rhoファミリーが実装されます。上式でSはカプラン・マイヤーの生存推定です。</p>
  <ul> 
    <li><b>rho = 0:</b> ログランクまたはマンテル・ヘンツェル検定</li>
    <li><b>rho = 1:</b> Gehan-Wilcoxon検定のPeto & Peto修正</li>
    <li> <b>Bonferroni</b>補正は、一般的であるものの非常に保守的なアプローチです。</li>
    <li> <b>Bonferroni-Holm</b>補正はそれほど保守的ではなく、一貫してBonferroni法より強力です。</li>
    <li> BenjaminiとHochbergが開発した<b>偽発見率-BH(False Discovery Rate-BH)</b>他の方法よりも強力です。</li>
    <li> BenjaminiとYekutieliが開発した<b>偽発見率-BY(False Discovery Rate-BY)</b>他の方法よりも強力です。</li>
    <li> p < 0.05の場合、曲線の生存確率に有意差が示されます。</li>
    <li> p >= 0.05の場合、曲線の生存確率に有意差が示されます。</li>
  </ul>"
    ),
     p(tags$b("対応のあるログランク検定P値表")),

    DT::DTOutput("PLR")
     )
)

)
)