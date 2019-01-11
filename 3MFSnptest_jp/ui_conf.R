##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------
source("p1_ui.R", local=TRUE)
source("p2_ui.R", local=TRUE)
source("p3_ui.R", local=TRUE)

shinyUI(

tagList( 

navbarPage(

title = "Non-parametric Test",  

##---------- Panel 1 ----------
tabPanel("One Sample",

headerPanel("Sign Test, Wilcoxon Signed-Rank Test"),

HTML(" 

<b> Notations </b>

  <ul>
  <li> X is the randomly collected sample 
  <li> m is the population median of X, meaning the 50 percentile of the underlying distribution of the X 
  <li> m&#8320 is the specified value 
  </ul>


<b> Assumptions </b>

  <ul>
  <li>Each observation is independent and comes from the same population
  <li>X could be continuous (i.e., interval or ratio) and ordinal
  </ul>


<p> Both can be used to test whether the median of a collection of numbers is significantly greater than or less than a specified value. </p>

  "),
hr(),

##---------- 1.1 ----------
onesample,
hr(),

##---------- 1.2 ----------

h4("Sign Test"),
p("The sign test makes very few assumptions about the nature of the distributions under test, but may lack the statistical power of the alternative tests."),

signtest,
hr(),

##---------- 1.3 ----------

h4("Wilcoxon Signed-Rank Test"),

HTML("

<p> Alternative to one-sample t-test when the data cannot be assumed to be normally distributed. It is used to determine whether the median of the sample is equal to a specified value.</p>

<b> Supplementary Assumptions </b>

<ul>
  <li> The distribution of X is symmetric
  <li> No ties (same values) in X
</ul>

  "),

<<<<<<< HEAD
wstest

=======
helpText("パラメータ設定"),
numericInput("med", HTML("特定の値, m&#8320"), 4), #p

sidebarLayout(

sidebarPanel(

  ##-------explanation-------##
h4(tags$b("符号検定")),
helpText("符号検定は、テスト中の分布の性質についてはほとんど仮定していませんが、代替テストの統計力が不足している可能性があります。"),

helpText("仮説"),
tags$b("帰無仮説"),
HTML("<p> m = m&#8320: 母集団の中央値は特定の値と等しい </p>"),

radioButtons("alt.st", label = "代替仮説", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: 母集団の中央値は特定の値と異なる"),
  HTML("m < m&#8320: 母集団の中央値は特定の値より小さい"),
  HTML("m > m&#8320: 母集団の中央値は特定の値より大きい")),
choiceValues = list("two.sided", "less", "greater"))),

  mainPanel(h3(tags$b('結果')), 
    tableOutput("sign.test")
    )  ),

sidebarLayout(
  sidebarPanel(

h4(tags$b("ウィルコクソンの符号順位検定")),
helpText("データが正規分布していると仮定できない場合の1標本t検定の代替案。 これは、サンプルの中央値が指定された値と等しいかどうかを判断するために使用されます。"),

tags$b("補足仮定"),
tags$ul(
  tags$li("Xの分布は対称である。"),
  tags$li("No ties (same values) in X")),

helpText("仮説"),
tags$b("帰無仮説"),
HTML("<p> m = m&#8320: 母集団の中央値は指定された値と同じです。 データセットの分布はデフォルト値に対して対称です </p>"),

radioButtons("alt.wsr", label = "帰無仮説", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: Xの母集団中央値が指定された値と等しくありません。 または、データセットの分布がデフォルト値に対して対称的ではない"),
  HTML("m < m&#8320: Xの母集団中央値が指定された値より小さい"),
  HTML("m > m&#8320: Xの母集団中央値が指定された値より大きい")),
choiceValues = list("two.sided", "less", "greater")),

helpText("補正"),
radioButtons("nap.wsr", label = "正規近似", 
  choices = list("標本は大きくない" = FALSE,
                 "標本は中程度の大きさ" = TRUE, 
                 "小さい標本サイズ" = TRUE), selected = FALSE),
helpText("標本サイズが１０より大きい場合、通常の近似値が適用可能です。")),

  mainPanel(h3(tags$b('結果')), 
    tableOutput("ws.test"), 
    helpText("正規近似が適用されると、検定の名前は '連続性補正付きWilcoxon符号付き順位検定'になります。")
  )
>>>>>>> 91438129ce9f03493284ca3ade7257a0747de65a
),

##---------- Panel 2 ----------

tabPanel("Two Independent Samples",

headerPanel("Wilcoxon Rank-Sum Test (Mann-Whitney U Test), Mood's Median Test"),

HTML("

<p> To determine whether a randomly selected sample will be less than or greater than a second randomly selected sample. </p>

<b> Notations </b>
  <ul>
  <li> X is the first randomly selected sample, while Y is the second</li>
  <li> m&#8321 is the population median of X, or the 50 percentile of the underlying distribution of X </li>  
  <li> m&#8322 is the population median of Y, or the 50 percentile of the underlying distribution of Y </li> 
  </ul>

<b> Assumptions </b>  
  <ul>
  <li> All the observations from both groups are independent of each other, no paired or repeated data </li>
  <li> X and Y could be continuous (i.e., interval or ratio) and ordinal (i.e., at least, of any two observations, which is the greater) </li>  
  <li> X and Y are similar in distribution's shape </li> 
  </ul>

  "),
hr(),

##---------- 2.1 ----------
twosample,
hr(),

##---------- 2.2 ----------
h4("Wilcoxon Rank-Sum Test, Mann-Whitney U Test, Mann-Whitney-Wilcoxon Test, Wilcoxon-Mann-Whitney Test"),

HTML("

<p> Not require the assumption of normal distributions; nearly as efficient as the t-test on normal distributions. </p>

<b> Supplementary Assumptions  </b>

<ul>
<li> No outliers (to determine if the distributions of the two groups are similar in shape and spread)
<li> If outliers exist, the test is used for testing distributions (to determine if the distributions of the two groups are different in shape and spread)
</ul>

<p> Outliers will affect the spread of data  </p>
  "),

wrtest,
hr(),
<<<<<<< HEAD

##---------- 2.3 ----------
h4("Mood's Median Test"),

p("A special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. "),

mmtest
=======
h4("パラメータ設定"), sliderInput("bin", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('箱ひげ図')), splitLayout(
    plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),
    wellPanel(verbatimTextOutput("info"), hr(),
      helpText(HTML("注:
                    <ul> 
                    <li> 外れ値が存在する場合は、外れ値が赤で強調表示されます。 </li>
                    <li> 赤の外れ値はシミュレートポイントをカバーしていない可能性があります。 </li>
                    <li> 赤い外れ値は、横線の値のみを示します。</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('ヒストグラム')), plotOutput("makeplot", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('記述統計')), 
  splitLayout(tableOutput("bas"), tableOutput("des"), tableOutput("nor"))) )
>>>>>>> 91438129ce9f03493284ca3ade7257a0747de65a

),

##---------- Panel 3 ----------

tabPanel("Two Paired Samples",    

headerPanel("Sign Test & Wilcoxon Signed-Rank Test"),

HTML("

<b> Assumptions </b>

<ul>
  <li> The observations of (X, Y) are paired and come from the same population 
  <li> X's and Y's could be continuous (i.e., interval or ratio) and ordinal 
  <li> D's are independent and come from the same population 
</ul>

<b> Notations </b>

<ul>
  <li> The paired observations are designated X and Y ,
  <li> D = X-Y, the differences between paired (X, Y) 
  <li> m is the population median of D, or the 50 percentile of the underlying distribution of the D. 
</ul>

<p> Given pairs of observations (such as weight pre- and post-treatment) for each subject, both test determine if one of the pair (such as pre-treatment) tends to be greater than (or less than) the other pair (such as post-treatment).</p>

"),

psample,

hr(),
##---------- 3.1 ----------

h4("Sign Test"),
p("The sign test makes very few assumptions about the nature of the distributions under test, but may lack the statistical power of the alternative tests."),

signtest.p,

hr(),
<<<<<<< HEAD
##---------- 3.2 ----------

h4("Wilcoxon Signed-Rank Test"),

HTML("

  <p> An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution. </p>

  <b> Supplementary Assumptions </b>
  
  <ul>
    <li> The distribution of D's is symmetric
    <li> No ties in D's
  </ul>

  "),
=======
h4("パラメータ設定"), sliderInput("bin2", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('箱ヒゲ図')), splitLayout(
    plotOutput("bp2", width = "400px", height = "400px", click = "plot_click2"),
    wellPanel(verbatimTextOutput("info2"), hr(),
      helpText(HTML("注:
                    <ul> 
                    <li> Points are simulated and located randomly in the same horizontal line. </li>
                    <li> Outliers will be highlighted in red, if existing. </li>
                    <li> The red outlier may not cover the simulated point. </li>
                    <li> The red outlier only indicates the value in horizontal line.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('ヒストグラム')), plotOutput("makeplot2", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('記述統計')), 
  splitLayout(tableOutput("bas2"), tableOutput("des2"), tableOutput("nor2")))  )),

  ## 3. Paired samples ---------------------------------------------------------------------------------
tabPanel("関連する二群に対する検定",    

headerPanel("符号検定 と ウィルコクソンの符号順位検定"),

p("Given pairs of observations (such as weight pre- and post-treatment) for each subject, both test determine if one of the pair (such as pre-treatment) tends to be greater than (or less than) the other pair (such as post-treatment)."),

tags$b("前提として"),
tags$ul(
  tags$li("（X、Y）の観測値は対になっており、同じ母集団からのものです。"),
  tags$li("X's and Y's could be continuous (i.e., interval or ratio) and ordinal"),
  tags$li("D's are independent and come from the same population")),

tags$b("注"),
tags$ul(
  tags$li("The paired observations are designated X and Y"),
  tags$li("D = X-Y, the differences between paired (X, Y)"),
  tags$li("m is the population median of D, or the 50 percentile of the underlying distribution of the D.")),

sidebarLayout(

sidebarPanel(

  h4(tags$b("符号テスト")),
  helpText("It makes very few assumptions, and has very general applicability but may lack the statistical power of the alternative tests."),
  
  helpText("仮説"),
  tags$b("帰無仮説"),
  p("m = 0: the difference of medians between X and Y is zero; X and Y are equally effective"),

  radioButtons("alt.ps", label = "代替仮説", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; X and Y are not equally effective"),
      HTML("m < 0: the population median of X is greater; X is more effective"),
      HTML("m > 0: the population median of Y is greater; Y is more effective")),
      choiceValues = list("two.sided", "less", "greater")) ),

mainPanel(h3(tags$b('結果')), tableOutput("psign.test"), 
          helpText("注: 'Estimated.d' denotes the estimated differences of medians")
          )),

sidebarLayout(
  sidebarPanel(

  h4(tags$b("ウィルコクソンの符号順位検定")),
  helpText("母集団が正規分布していると仮定できない場合の、マッチドペアの対応のあるt検定の代替方法。 また、2つの従属サンプルが同じ分布を持つ集団から選択されたかどうかを判断するためにも使用できます。"),
>>>>>>> 91438129ce9f03493284ca3ade7257a0747de65a
  
helpText("Ties means the same values"),

wstest.p

),
##---------- other panels ----------

source("../0tabs/home.R",local=TRUE)$value,
source("../0tabs/stop.R",local=TRUE)$value

  
))
)

