#****************************************************************************************************************************************************model
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#formula {height: 50px; background: ghostwhite; color: blue;word-wrap: break-word;}")),
tags$head(tags$style("#str {overflow-y:scroll; max-height: 200px; background: lavender}")),
tags$head(tags$style("#fit {overflow-y:scroll; max-height: 500px; background: lavender;color: black;}")),
tags$head(tags$style("#step {overflow-y:scroll;max-height: 500px; background: lavender};")),


h4(tags$b("モデルを構築する")),
p("前のタブでデータを作成します。"),
hr(),      

h4(tags$b("Step 1. モデルを構築する変数を選択する")),      

uiOutput('y'),    
uiOutput('x'),
#uiOutput('fx'),

radioButtons("intercept", "3. (オプション) 切片/定数項を維持または除去する", ##> intercept or not
     choices = c("切片/定数項を除去する" = "-1",
                 "切片/定数項を維持する" = ""),
     selected = ""),

uiOutput('conf'), 
hr(),
h4(tags$b("Step 2. モデルをチェックし結果を生成する")),
tags$b("有効なモデルの例： Y ~ X1 + X2"),
verbatimTextOutput("formula"),
p("式中の'-1'は、切片/定数項が除去されていることを表します。"),
hr(),

h4(tags$b("Step 3. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),
p(br()),
actionButton("B1", (tags$b("結果を表示>>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()


),

mainPanel(

h4(tags$b("Output 1. データの確認")),
tabsetPanel(
  tabPanel("変数情報", br(),
verbatimTextOutput("str")
),
tabPanel("データの一部", br(),
 p("データタブでデータを編集してください"),
DT::DTOutput("Xdata2")
)
),
hr(),

h4(tags$b("Output 2. モデルの結果")),
#actionButton("B1", h4(tags$b("1：出力2.モデルの結果を表示/更新をクリックしてください")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),

tabsetPanel(

tabPanel("モデル推定",  br(),
    
HTML(
"
<b> 説明 </b>
<ul>
<li> 各変数の値は推定された係数 (95%信頼区間)、T統計量 (t = )、各変数の有意性に関するP値 (p = ) です。</li>
<li> 各変数のT検定でP < 0.05であれば、この変数がモデルで統計的に有意であることを表します。</li>
<li> 観察は標本の数を示します。</li>
<li> R2 (R<sup>2</sup>)は線形回帰モデルの適合度を示しており、独立変数が従属変数の分散を集合的に説明する割合を表します。
R2 = 0.49と仮定します。この結果は、従属変数の変動の49％が説明され、残りの51%は説明されていないことを示唆します。</li>
<li> 調整 R2 (調整 R<sup>2</sup>)は、異なる数の独立変数を含む回帰モデルで適合度を比較するために使用します。</li>
<li> F統計量 (回帰における全体的な有意性に関するF検定) では、複数の係数を同時にとって判定します。 
     F=(R^2/(k-1))/(1-R^2)/(n-k)；nは標本サイズ、kは変数＋定数項の数</li>
</ul>
"
),
#verbatimTextOutput("フィット（Fit）")
p(tags$b("結果")),
htmlOutput("fit"),
downloadButton("downloadfit", "CSVに保存"),
downloadButton("downloadfit.latex", "LaTexコードを保存")

    ),

tabPanel("フィッティング(Data Fitting)",  br(),

    DT::DTOutput("fitdt0")
),

tabPanel("ANOVA",  br(),

HTML(
"<b> 説明 </b>
<ul> 
<li> DF<sub>変数</sub> = 1</li>
<li> DF<sub>残差</sub> = [サンプルの数] - [変数の数] -1</li>
<li> MS = SS/DF</li>
<li> F = MS<sub>変数</sub> / MS<sub>残差l</sub> </li>
<li> P Value < 0.05:  変数はモデルにとって有意です.</li>
</ul>"
    ),
    p(tags$b("ANOVA テーブル")),  
    DT::DTOutput("anova")),

tabPanel("AIC変数選択",  br(),
    HTML(
    "<b> 説明 </b>
  <ul> 
    <li> 赤池情報量（Akaike Information Criterion (AIC)） は、段階的（Stepwise）なモデルの選択に使用します。</li>
    <li> モデルの適合性はAIC値に従ってランク付けされ、AIC値がもっとも小さいモデルが「最良」と判断されることがあります。</li>
  </ul>"
    ),

    p(tags$b("AICによるモデル選択")),
    verbatimTextOutput("step"),
    downloadButton("downloadsp", "TXTに保存")

    ),

tabPanel("診断プロット",   br(),
HTML(
"<b> 説明 </b>
<ul> 
<li> 残差のQ-Q正規プロットは、残差の正規性をチェックします。 ポイントの線形性は、データが正規分布していることを示しています。</li>
<li> 残差vsフィッティングプロットは外れ値を見つけます</li>
</ul>"
),
p(tags$b("1. 残差のQ-Q正規プロット")),
plotly::plotlyOutput("p.lm1"),
p(tags$b("2. 残差vsフィッティングプロット")),
plotly::plotlyOutput("p.lm2")

    ),
tabPanel("3D散布図", p(br()),
HTML(
"<b> 説明 </b>
<ul> 
<li> 3D散布図は、従属変数（Y）と2つの独立変数（X1、X2）の関係を示しています。
<li> グループ変数は点をグループに分けられています。
</ul>"
),

uiOutput("vx1"),
uiOutput("vx2"),
uiOutput("vgroup"),
plotly::plotlyOutput("p.3dl")
)

)
)
)