#****************************************************************************************************************************************************1.2. Exp distribution
sidebarLayout(

	sidebarPanel(

	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	  #Select Src
	  selectInput(
	    "InputSrc_e", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist",
        "ユーザデータベース" = "DataDist")),
	  hr(),
	  #Select Src end
	h4(tags$b("Step 2. パラメータの設定")),
	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'MathDist'",
	    #"Draw an Exponential Distribution", p(br()),
      HTML("<b>パラメータの設定(E(Rate))</b></h4>"),
	    numericInput("r", HTML(" 率(> 0) とは変化率を指します。率を入力"), value = 2, min = 0),
      hr(),
      numericInput("e.mean", HTML("または平均とSD (平均 = SD) から率を計算するために平均を入力"), value = 0.5, min = 0),
      verbatimTextOutput("e.rate"),
      p("Mean = SD = 1/Rate"),
	    hr(),

	    numericInput("e.xlim", "2. x軸の範囲(> 0)を変更します。", value = 5, min = 1)

	  ),
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'SimuDist'",
	    numericInput("e.size", "シミュレートした数の標本サイズ", value = 100, min = 1,step = 1),
	    sliderInput("e.bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
	    p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")
	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'DataDist'",

	    tabsetPanel(
      	      tabPanel("手入力",p(br()),
		p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
		p(tags$b("データはCSV(1列)からコピーされ、ボックスに貼り付けられます")),    	        
    tags$textarea(
      	          id = "x.e", #p
      	          rows = 10,
      	          "2.6\n0.5\n0.8\n2.3\n0.3\n2\n0.5\n4.4\n0.1\n1.1\n0.7\n0.2\n0.7\n0.6\n3.7\n0.3\n0.1\n1\n2.6\n1.3"
      	        ),
      	p("欠損値はNAとして入力されます")
      	        ),
      	      tabPanel.upload.num(file ="e.file", header="e.header", col="e.col", sep="e.sep")

	     ),
	    sliderInput("bin.e", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
	    p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")
	  ), #condiPa 3 end
    hr(),
    h4(tags$b("Step 3. 確率を表示する")),
    numericInput("e.pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.05, min = 0, max = 1, step = 0.05),
    hr()
	), #sidePa end

  	mainPanel(
  		h4(tags$b("Outputs")),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'MathDist'",
  		  h4("数式ベースプロット"),
  		  tags$b("指数分布プロット"),
  		  plotOutput("e.plot", click = "plot_click9"),#
  		  verbatimTextOutput("e.info"),
        #p(br()),
        #p(tags$b("赤線の位置")),
  		  #p(tags$b("赤線の位置、 x<sub>0</sub>")),
  		  #verbatimTextOutput("e"),
      hr(),
    #   plotly::plotlyOutput("e.plot.cdf") 
	       plotOutput("e.plot.cdf") 
  		),
  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'SimuDist'",
  		 h4("シミュレーションベースプロット"),
  		  tags$b("乱数から作成したヒストグラム"),
  		  plotly::plotlyOutput("e.plot2"),#click = "plot_click10",
  		  #verbatimTextOutput("e.info2"),
  		  downloadButton("download2", "乱数をダウンロードする"),

  		  p(tags$b("サンプルの記述統計")),
  		  tableOutput("e.sum")
  		),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'DataDist'",
		tags$b("データの確認"),
        DT::DTOutput("Y"),
		h4("データの分布"),
        tags$b("アプロードされたデータの密度プロット"),
  		  plotly::plotlyOutput("makeplot.e2"),
        tags$b("アプロードされたデータのヒストグラム"),
  		  plotly::plotlyOutput("makeplot.e1"),
        tags$b("アプロードされた累積密度プロット（CDF）"),
        plotly::plotlyOutput("makeplot.e3"),
        p(tags$b("データの記述統計")),
  		  tableOutput("e.sum2")

  		)



	)
)

