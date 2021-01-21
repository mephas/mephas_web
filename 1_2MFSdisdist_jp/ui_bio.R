#****************************************************************************************************************************************************1. binom
sidebarLayout(

	sidebarPanel(
	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),		#Select Src
	selectInput(
	    "InputSrc_b", "選択肢",
	    c("数式ベース" = "MathDist",
	      "シミュレーションベース" = "SimuDist",
	      "ユーザデータベース" = "DataDist")),
	hr(),

	#Select Src end
		h4(tags$b("Step 2. パラメータの設定")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
	    HTML("<b> 1. パラメータの設定</b>"),
		numericInput("m", "試行/標本数：n > 0", value = 10, min = 1 , max = 1000000000),
		numericInput("p", "成功/事象の確率：p > 0", value = 0.2, min = 0, max = 1, step = 0.1),
		HTML("
<li> 平均（Mean） = np
<li> 分散（Variance） = np(1-p)
			")
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		p(tags$i("この例から、n = 10（10個の白血球）、p = 0.2（1個の白血球細胞がリンパ球である確率）がわかります。"))
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist'",
		hr(),
		tags$b(" 2. 観察値の変更"),
		numericInput("k", "観察された成功/事象の数 (赤色の点)", value = 2, min =  0, max = 1000, step = 1)
		),
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		p(tags$i("観察された数は2つのリンパ球です。"))
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'SimuDist'",
		numericInput("size", "乱数のサンプルサイズ", value = 100, min = 1, max = 1000000, step = 1),
		sliderInput("bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
		p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_b == 'DataDist'",
	    tabsetPanel(
	      tabPanel("手入力",p(br()),
    p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")), 			
    		tags$textarea(
        	id = "x", #p
        	rows = 10, "3\n5\n3\n4\n6\n3\n6\n6\n5\n2\n5\n4\n5\n5\n5\n2\n6\n8\n4\n2"
			),
      		p("欠測値はNAと入力してください")
	     ), #tab1 end
			tabPanel.upload.num(file ="file", header="header", col="col", sep="sep")

	    ),
      sliderInput("bin1","ヒストグラムのビンの数", min = 0, max = 100, value = 0),
        p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します")
	  )
	  #condiPa 3 end

	), #sidePa end




mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist'",
		  h4("数式ベースプロット"),
		  p(tags$b("二項確率プロット")),
		  p("青色の曲線は、平均n*p、sd n*p*(1-p) の正規分布。二項分布の正規近似を表しています。"),
		  plotly::plotlyOutput("b.plot"),
		  p(tags$b("観察された成功/事象 (赤色の点) の数の確率")),
		  tableOutput("b.k"),
		 hr(),
     plotly::plotlyOutput("b.plot.cdf")   
		),
		conditionalPanel(
		  condition = "input.InputSrc_b == 'MathDist' && input.explain_on_off",
		  p(tags$i("説明：2つのリンパ球の確率は約0.03でした"))
		),

		conditionalPanel(
		  condition = "input.InputSrc_b == 'SimuDist'",
		  h4("シミュレーションベースプロット"),
		  p(tags$b("乱数のヒストグラム")),
		  plotly::plotlyOutput("b.plot2"),
		  downloadButton("download1", "乱数をダウンロードする"),
		  p(tags$b("サンプルの記述統計")),
		  tableOutput("sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_b == 'DataDist'",
		h4("ユーザーデータの分布"),
 		p(tags$b("アップロードデータのヒストグラム")),
		plotly::plotlyOutput("makeplot.1"),
    tags$b("アップロードデータからのCDF"),
    plotly::plotlyOutput("makeplot.11"),
		p(tags$b("サンプルの記述統計")),
		tableOutput("sum2")

		)

	) #main pa end


)
