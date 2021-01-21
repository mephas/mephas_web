#****************************************************************************************************************************************************plsr
sidebarLayout(

sidebarPanel(

tags$head(tags$style("#pls {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_r {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_rmsep {overflow-y:scroll;max-height: 300px; background: white};")),
tags$head(tags$style("#pls_msep {overflow-y:scroll; max-height: 300px; background: white};")),
tags$head(tags$style("#pls_tdtrace {overflow-y:scroll; max-height: 200px; background: white};")),


h4(tags$b("モデルを構築する")),
p("データタブでデータを作成します。"),
hr(), 
h4(tags$b("Step 1. モデルを構築するパラメータを選択する")),    

uiOutput('y.r'), 
uiOutput('x.r'), 


numericInput("nc.r", "3. 新しい成分の数 (A <= Xの次元)", 4, min = 1, max = NA),

radioButtons("val.r", "4. クロスバリデーションを行う?",
choices = c("いいえ、すべてのデータを使用する" = 'none',
           "10-fold　クロスバリデーション" = "CV",
           "Leave-one-out　クロスバリデーション" = "LOO"),
selected = 'CV'),

radioButtons("method.r", "5. 使用するPLSアルゴリズム?",
  choices = c("SIMPLS: 簡単で速い方法です" = 'simpls',
           "カーネル法のアルゴリズム" = "kernelpls",
           "ワイド・カーネル法のアルゴリズム" = "widekernelpls",
           "古典的な直交スコアアルゴリズム" = "oscorespls"),
selected = 'simpls'),
p("これらのアルゴリズムの結果には、大きな差はありません。"),

shinyWidgets::prettySwitch(
   inputId = "scale.r",
   label = tags$b("データをスケーリングする?"), 
   value=TRUE,
   status = "info",
   fill = TRUE
  ),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("PLSRは、複数の従属変数を使用して、Y行列とX行列の間の線形関係を見つけることができます。 
  したがって、この例では、time, Diam, and Age　を従属変数として使用し、他の変数は独立変数です。")),
p(tags$i("予測能力の高い成分を見つけたかったのです。")),
p(tags$i("データタブから、Xが20x25の行列であることがわかったため、aの最大値は19です。A=20の場合はエラーが発生します。")),
p(tags$i("この例では、MSEPとRMSEPに従って、3つのコンポーネント（A = 3）を選択することにしました。 10-fold　CVとシンプルで高速なアルゴリズムを使用しました。"))
),

hr(),

h4(tags$b("Step 2. データとモデルが準備できたら、青色のボタンをクリックしてモデルの結果を生成")),
#actionButton("pls1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o"))
p(br()),
actionButton("pls1", (tags$b("結果を表示 >>")),class="btn btn-primary",icon=icon("bar-chart-o")),
p(br()),
p(br()),
hr()
),

mainPanel(

h4(tags$b("Output 1. データの確認")),
p(tags$b("データの一部")),
 p("データタブでデータを編集してください"),
DT::DTOutput("pls.x"),

hr(),
#actionButton("pls1", h4(tags$b("Click 1: Output 2. Show Model Results / Refresh")),  style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
h4(tags$b("Output 2. モデルの結果")),

tabsetPanel(
tabPanel("PLSRの結果",p(br()),

HTML(
"
<b>説明</b>

<ul>
<li> 1成分、2成分、...、n成分からの結果が表示されます。</li>
<li> 'CV'はクロスバリデーションの推定値です。</li>
<li> 'adjCV' (RMSEPおよびMSEP) はバイアスを補正したクロスバリデーションの推定値です。</li>
<li> R^2は、フィットした値と得られた反応の間の相関係数の二乗と同じです。トレーンには調整されていないR^2、CVには調整済みのR^2が表示されます。</li>
<li> R^2が高い場合やMSEP/RSMEPが低い場合は成分数を指定することが勧められます。</li>
</ul>
"
),
p("10-fold クロスバリデーションではデータを毎回ランダムに10個に分割するため、更新後の結果は必ずしも同じにはなりません。"),
hr(),
verbatimTextOutput("pls"),
p(tags$b("R^2")),
verbatimTextOutput("pls_r"),
p(tags$b("予測の平均二乗誤差 (MSEP)")),
verbatimTextOutput("pls_msep"),
p(tags$b("予測の平均二乗誤差根 (RMSEP)")),
verbatimTextOutput("pls_rmsep"),
conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("複数の従属変数（Y）を選択したため、結果は各Yによって示されました。")),
p(tags$i("PLSRはYとXの両方から新しい変数を生成するため、R^2はPCRよりも優れています。 Yで説明された分散（％）もPCRよりも高くなっています。"))
)

),

tabPanel("データフィッティング",p(br()),

p(tags$b("Yの予測値")),
DT::DTOutput("pls.pres"),br(),
p(tags$b("残差 (Y-Yの予測値)")),
DT::DTOutput("pls.resi"),br(),
p(tags$b("係数")),
DT::DTOutput("pls.coef")

),

tabPanel("成分", p(br()),
  HTML("
<b>説明</b>
<ul>
<li> このプロットでは2つのスコアから成分の関係をグラフにします。スコアプロットを使用してデータの構造を評価し、クラスター、外れ値、および傾向を検出することができます。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
</ul>
  "),
  hr(),
uiOutput("g.pls"),
uiOutput("type.pls"),
p(tags$b("A >=2のとき、2成分を選択して2D負荷量プロットを表示する")),
numericInput("c1.r", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("c2.r", "2. y-axisの成分", 2, min = 1, max = NA),

conditionalPanel(
condition = "input.explain_on_off",
p(tags$i("このプロットでは、component1とcomponent2の散布図をプロットし、327、332が外れ値であることがわかりました。"))
),
  plotly::plotlyOutput("pls.s.plot"),
  DT::DTOutput("pls.s")
  ),

tabPanel("負荷量", p(br()),
  HTML("
<b>説明</b>
<ul>
<li> このプロットは、変数からPCへの寄与度を示します (左側のパネルでPCを選択します)。</li>
<li> 赤色は負の効果、青色は正の効果を表しています。</li>
<li> 分散の累積割合 (分散表) を使用して、その因子が説明する分散の量を調べることができます。</li>
<li> 記述統計の場合は、分散の80% (0.8) が説明できれば十分です。</li>
<li> データについて他の解析も行う場合は、分散の90%以上を因子によって説明する必要があります。</li>
</ul>
  "),
  hr(),
  plotly::plotlyOutput("pls.l.plot"),
  DT::DTOutput("pls.l")
  ),

tabPanel("成分と負荷量の2Dプロット", p(br()),
  HTML("
<b>説明</b>
<ul>
<li> このプロット (バイプロット) では、主成分と負荷量を重ねています (左側のパネルでPCを選択します)。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>

  "),
    hr(),

p(tags$b("A >=2のとき、2成分を選択して負荷量の2Dプロットを表示する")),
numericInput("c11.r", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("c22.r", "2. y-axisの成分", 2, min = 1, max = NA),
  plotly::plotlyOutput("pls.bp")
  ),

tabPanel("成分と負荷量の3Dプロット" ,p(br()),
  HTML("
<b>説明</b>
<ul>
<li> これは2Dプロットの拡張です。このプロットでは、3つのPCの成分と負荷量を重ねます (左パネルでPCおよび線分の長さを選択します)。</li>
<li> このプロットには、2Dプロットと同様の機能があります。 トレースは、クリックすると非表示にできる変数です。</li>
<li> データが正規分布に従っていて外れ値がない場合には、点はゼロを中心としてランダムに分布します。</li>
<li> 負荷量は、各成分に対して最も効果が大きな変数を特定します。</li>
<li> 負荷量の範囲は-1から1です。負荷量が-1または1に近い場合は、その変数が成分に強い影響を与えていることを表します。負荷量が0に近い場合は、その変数が成分にあまり影響を与えていないことを表します。</li>
</ul>
  "),
hr(),
p(tags$b("このプロットの初回ロード時は少し時間がかかります")),

p(tags$b("A >=3のとき、3成分を選択して負荷量の3Dプロットを表示する")),
numericInput("td1.r", "1. x-axisの成分", 1, min = 1, max = NA),
numericInput("td2.r", "2. y-axisの成分", 2, min = 1, max = NA),
numericInput("td3.r", "3. z-axisの成分", 3, min = 1, max = NA),

numericInput("lines.r", "4. (オプション) ラインスケール（長さ）を変更する", 0.1, min = 1, max = NA),
plotly::plotlyOutput("pls.tdplot"),
p(tags$b("トレースの凡例")),
verbatimTextOutput("pls_tdtrace")
)
)

)

)