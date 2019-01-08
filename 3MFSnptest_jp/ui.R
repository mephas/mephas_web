##----------#----------#----------#----------
##
## 3MFSnptest UI
##
## Language: JP
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(
tagList( 
#shinythemes::themeSelector(),
navbarPage(

title = "ノンパラメトリック検定",  

## 1. One sample test ---------------------------------------------------------------------------------
tabPanel("一群に対する検定",

headerPanel("符号検定, ウィルコクソンの符号順位検定"),
p("ここでは、データの数値の中央値が指定された値よりも大幅に大きいか小さいかをテストできます"),

tags$b("前提として"),
tags$ul(
  tags$li("それぞれの検定は独立しており一つの母集団から抽出されたものである"),
  tags$li("数値は連続しているものとする")),

tags$b("注"),
HTML("
  <ul>
  <li> Xはサンプルから無作為に抽出された </li>
  <li> mはXの平均, 50パーセントタイルはXの分布にもとずいたものである </li>
  <li> m&#8320 は特定の</li>
  </ul>
  "),

helpText("パラメータ設定"),
numericInput("med", HTML("特定の値, m&#8320"), 4), #p

sidebarLayout(

sidebarPanel(

  ##-------explanation-------##
h4(tags$b("符号検定")),
helpText("The sign test makes very few assumptions about the nature of the distributions under test, but may lack the statistical power of the alternative tests.符号検定は、テスト中のディストリビューションの性質についてはほとんど仮定していませんが、代替テストの統計力が不足している可能性があります。"),

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
helpText("データが正規分布していると仮定できない場合の1標本t検定の代替案。 これは、サンプルの中央値が指定された値と等しいかどうかを判断するために使用されます。Alternative to one-sample t-test when the data cannot be assumed to be normally distributed. It’s used to determine whether the median of the sample is equal to a specified value."),

tags$b("補足仮定"),
tags$ul(
  tags$li("Xの分布は対称である。"),
  tags$li("No ties (same values) in X")),

helpText("仮説"),
tags$b("帰無仮説"),
HTML("<p> m = m&#8320: the population median is equal to the specified value; the distribution of the data set is symmetric about the default value </p>"),

radioButtons("alt.wsr", label = "帰無仮説", 
  choiceNames = list(
  HTML("m &#8800 m&#8320: the population median of X is not equal to the specified value; or, the distribution of the data set is not symmetric about the default value"),
  HTML("m < m&#8320: the population median of X is less than the specified value"),
  HTML("m > m&#8320: the population median of X is greater than the specified value")),
choiceValues = list("two.sided", "less", "greater")),

helpText("Correction"),
radioButtons("nap.wsr", label = "Normal Approximation", 
  choices = list("Sample size is not large" = FALSE,
                 "Sample size is moderate large" = TRUE, 
                 "Small sample size" = TRUE), selected = FALSE),
helpText("Normal approximation is applicable when sample size > 10.")),

  mainPanel(h3(tags$b('結果')), 
    tableOutput("ws.test"), 
    helpText("When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction'")
  )
),

sidebarLayout(  
sidebarPanel(

helpText("データインポート"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("誤った値はNAと表示されます"),
    tags$textarea(id="a", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),
    helpText("サンプルの名前を変更できます"), tags$textarea(id="cn", rows=2, "X")),

  ##-------csv file-------##   
  tabPanel("アップロード.csv ファイルのみ", p(br()),
    fileInput('file', '.csv ファイルを選んでください', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header', 'Header', TRUE), #p
    radioButtons('sep', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("データ"), 

dataTableOutput("table"),
hr(),
h4("パラメータ設定"), sliderInput("bin", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('Boxplot')), splitLayout(
    plotOutput("bp", width = "400px", height = "400px", click = "plot_click"),
    wellPanel(verbatimTextOutput("info"), hr(),
      helpText(HTML("注:
                    <ul> 
                    <li> Outliers will be highlighted in red, if existing. </li>
                    <li> The red outlier may not cover the simulated point. </li>
                    <li> The red outlier only indicates the value in horizontal line.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('ヒストグラム')), plotOutput("makeplot", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('記述統計')), 
  splitLayout(tableOutput("bas"), tableOutput("des"), tableOutput("nor"))) )

),

## 2 Two independent samples test ---------------------------------------------------------------------------------
tabPanel("独立二群に対する検定",

headerPanel("ウィルコクソンの符号順位検定 (マン・ホイットニーのU検定), Mood's Median Test"),

p("To determine whether a randomly selected sample will be less than or greater than a second randomly selected sample."),

tags$b("前提として"),
tags$ul(
  tags$li("All the observations from both groups are independent of each other, no paired or repeated data"),
  tags$li("X and Y could be continuous (i.e., interval or ratio) and ordinal (i.e., at least, of any two observations, which is the greater)"),
  tags$li("X and Y are similar in distribution's shape")),

tags$b("注"),
HTML("<ul>
      <li> X is the first randomly selected sample, while Y is the second</li>
      <li> m&#8321 is the population median of X, or the 50 percentile of the underlying distribution of X </li>  
      <li> m&#8322 is the population median of Y, or the 50 percentile of the underlying distribution of Y </li> 
      </ul>" ),

sidebarLayout(
sidebarPanel(
##-------explanation-------##
h4(tags$b("ウィルコクソンの符号順位検定")),
h4(tags$b("マン・ホイットニーのU検定")),
p(tags$b("マン・ホイットニー・ウィルコクソン検定")),
p(tags$b("ウィルコクソン・マン・ホイットニー検定")),

helpText("Not require the assumption of normal distributions; nearly as efficient as the t-test on normal distributions."),

tags$b("Supplementary Assumptions"),
tags$ul(
  tags$li("No outliers"),
  tags$li("If outliers exist, the test is used for testing distributions")),
helpText("Outliers will affect the spread of data"),

p(tags$b("No outliers"), "To determine if the distributions of the two groups are similar in shape and spread"),
p(tags$b("Outliers exist"), "To determine if the distributions of the two groups are different in shape and spread"),

helpText("仮説"),
tags$b("帰無仮説"),
HTML("<p> m&#8321 = m&#8322: the medians of each group are equal; the distribution of values for each group are equal </p>"),

radioButtons("alt.mwt", label = "代替仮説", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal; there is systematic difference in the distribution of values for the groups"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater")),

helpText("Correction"),
radioButtons("nap.mwt", label = "Normal Approximation", 
  choices = list("Sample size is not large" = FALSE,
                 "Sample size is moderate large" = TRUE, 
                 "Small sample size" = TRUE), selected = FALSE)),

mainPanel(
  h3(tags$b("結果")), tableOutput("mwu.test"), 
  helpText(HTML("<ul>
      <li> 'Estimated.diff' denotes the estimated differences of medians
      <li> When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction' </li>  
      </ul>" ))
  )),

sidebarLayout(
sidebarPanel(

h4(tags$b("Mood's Median Test")),
helpText("A special case of Pearson's chi-squared test. It has low power (efficiency) for moderate to large sample sizes. "),

helpText("仮説"),
tags$b("帰無仮説"),
HTML("m&#8321 = m&#8322, the medians of values for each group are equal"),

radioButtons("alt.md", label = "代替仮説", 
  choiceNames = list(
    HTML("m&#8321 &#8800 m&#8322: the population medians of each group are not equal"),
    HTML("m&#8321 < m&#8322: the population median of X is greater"),
    HTML("m&#8321 > m&#8322: the population median of Y is greater")),
  choiceValues = list("two.sided", "less", "greater"))),

mainPanel(h3(tags$b("結果")), tableOutput("mood.test") 
  ) ),

# data input
sidebarLayout(  
sidebarPanel(

helpText("データをインポート"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("誤った値はNAと表示されます"),
    tags$textarea(id="x1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="x2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("データの名前の変更ができます"), tags$textarea(id="cn2", rows=2, "X\nY")),

  ##-------csv file-------##   
  tabPanel("アップロード .csv ファイルのみ", p(br()),
    fileInput('file2', ' .csv ファイルを選んでください', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header2', 'Header', TRUE), #p
    radioButtons('sep2', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("データ"), dataTableOutput("table2"),

hr(),
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
  tags$li("The observations of (X, Y) are paired and come from the same population"),
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
  helpText("An alternative to the paired t-test for matched pairs, when the population cannot be assumed to be normally distributed. It can also be used to determine whether two dependent samples were selected from populations having the same distribution."),
  
  tags$b("Supplementary Assumptions"),
  tags$ul(
    tags$li("The distribution of D's is symmetric."),
    tags$li("No ties in D's")),

  helpText("Ties means the same values"),

  helpText("仮説"),
  tags$b("帰無仮説"),
  p("m = 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is symmetric around zero."),

  radioButtons("alt.pwsr", label = "代替仮説", 
    choiceNames = list(
      HTML("m &#8800 0: the difference of medians between X and Y is not zero; the distribution of the differences in paired values is not symmetric around zero"),
      HTML("m < 0: the population median of Y is greater"),
      HTML("m > 0: the population median of X is greater")),
    choiceValues = list("two.sided", "less", "greater")),

  helpText("Correction"),
  radioButtons("nap", label = "Normal Approximation", 
    choices = list("Sample size is not large" = FALSE,
                   "Sample size is moderate large" = TRUE,
                   "Small sample size" = TRUE), selected = FALSE),
  helpText("Normal approximation is applicable when n > 10.")),

  mainPanel(h3(tags$b('結果')), tableOutput("psr.test"), 
    helpText("When normal approximation is applied, the name of test becomes 'Wilcoxon signed rank test with continuity correction'")
    ) ),

# data input
sidebarLayout(  
sidebarPanel(

helpText("データインポート"),

  tabsetPanel(
  ##-------input data-------## 
  tabPanel("手入力", p(br()),
    helpText("誤った値はNAとして表示されます"),
    tags$textarea(id="y1", rows=10, "1.8\n3.3\n6.7\n1.4\n2.2\n1.6\n13.6\n2.8\n1.0\n2.8\n6.5\n6.8\n0.7\n0.9\n3.4\n3.3\n1.4\n0.9\n1.4\n1.8"),  ## disable on chrome
    tags$textarea(id="y2", rows=10, "8.7\n6.6\n6.0\n3.9\n1.6\n16.0\n14.1\n3.1\n4.0\n3.7\n3.1\n7.4\n6.0\n1.1\n3.0\n2.0\n5.0\n4.2\n5.0\n4.9"),
    helpText("サンプルの名前を変更できます"), tags$textarea(id="cn3", rows=2, "X\nY\n(X-Y)")),

  ##-------csv file-------##   
  tabPanel("アップロード .csvファイルのみ", p(br()),
    fileInput('file3', 'ファイルをえらんでください', accept=c('text/csv', 'text/comma-separated-values,text/plain', '.csv')),
    checkboxInput('header3', 'Header', TRUE), #p
    radioButtons('sep3', 'Separator', c(Comma=',', Semicolon=';', Tab='\t'), ',')) ),

hr(),
h4("データ"), dataTableOutput("table3"),

hr(),
h4("パラメータ設定"), sliderInput("bin3", "ヒストグラムの棒幅", min = 0.01, max = 5, value = 0.2)),

mainPanel(
  h3(tags$b('箱ヒゲ')), splitLayout(
    plotOutput("bp3", width = "400px", height = "400px", click = "plot_click3"),
    wellPanel(verbatimTextOutput("info3"), hr(),
      helpText(HTML("注:
                    <ul> 
                    <li> Outliers will be highlighted in red, if existing. </li>
                    <li> The red outlier may not cover the simulated point. </li>
                    <li> The red outlier only indicates the value in horizontal line.</li>  
                    </ul>")))),
  hr(),
  h3(tags$b('ヒストグラム')), plotOutput("makeplot3", width = "600px", height = "300px"),
  hr(),
  h3(tags$b('記述統計')), 
  splitLayout(tableOutput("bas3"), tableOutput("des3"), tableOutput("nor3"))))

)
,
##----------
tabPanel((a("ホーム",
 #target = "_blank",
 style = "margin-top:-30px;",
 href = paste0("https://pharmacometrics.info/mephas/", "index_jp.html")))),

tabPanel(
      tags$button(
      id = 'close',
     style = "margin-top:-10px;",
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止"))

))

)
