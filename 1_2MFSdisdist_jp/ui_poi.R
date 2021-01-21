#****************************************************************************************************************************************************2. poisson
sidebarLayout(

	sidebarPanel(
	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),		#Select Src
	selectInput(
	    "InputSrc_p", "選択肢",
	    c("数式ベース" = "MathDist",
	      "シミュレーションベース" = "SimuDist",
	      "ユーザデータベース" = "DataDist")),
	hr(),
	#Select Src end
		h4(tags$b("Step 2. パラメータの設定")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist'",
	    HTML("<b> 1. パラメータの設定</b>"),
		numericInput("lad", "率 = 平均 = 分散", value = 2.3, min = 0, max = 10000000000, step = 1),
      numericInput("k2", "発生の観察期間> 0", value = 12, min = 0 , max = 1000000000)
      ),
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
	    p(tags$i("例から、率は2.3で、期間は12か月です。"))
	  ),
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist'",
      hr(),

      tags$b(" 2. 観察値の変更"),
      numericInput("x0", "発生の観察期間 (赤色の点)", value = 5, min = 0 , max = 1000000000)
      ),
      conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
      p(tags$i("観測値は<= 5であり、5か月後の累積確率（つまり、1-0〜5か月の累積確率）を知りたいとします。"))
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'SimuDist'",
		numericInput("size.p", "乱数のサンプルサイズ", value = 100, min = 1, max = 1000000, step = 1),
		sliderInput("bin.p", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
		p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'DataDist'",
	    tabsetPanel(
	      tabPanel("手入力",p(br()),
    p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
    p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")), 
    		
    	tags$textarea(
        id = "x.p", #p
        rows = 10,
        "1\n3\n4\n3\n3\n3\n5\n3\n2\n1\n1\n3\n2\n4\n1\n2\n5\n4\n2\n3"
         ),
      p("欠測値はNAと入力してください")
	     ), #tab1 end
		tabPanel.upload.num(file ="file.p", header="header.p", col="col.p", sep="sep.p")

	    ),
      sliderInput("bin1.p","ヒストグラムのビンの数", min = 0, max = 100, value = 0),
       p("ビンの数が0の場合、プロットはデフォルトのビンの数を使用します")
	  )
	  #condiPa 3 end

	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_p == 'MathDist'",
		  h4("数式ベースプロット"),
		  p("青色の曲線は、平均 = 率、sd = 率の正規分布。二項分布の正規近似を表しています。"),
 		p(tags$b("Poisson probability plot")),
    	plotly::plotlyOutput("p.plot"),
    	p(tags$b("観測された発生数での確率（赤点）")),
    	tableOutput("p.k"),
    hr(),
     plotly::plotlyOutput("p.plot.cdf")   
    	),
    	conditionalPanel(
		  condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
    	p(tags$i("説明：5か月までの確率分布は0.97でした。 したがって、6か月後の確率分布は約0.03でした。"))
		),

		conditionalPanel(
		  condition = "input.InputSrc_p == 'SimuDist'",
 		p(tags$b("乱数のヒストグラム")),
        plotly::plotlyOutput("p.plot2"),

        downloadButton("download2", "乱数をダウンロードする"),
        p(tags$b("サンプルの記述統計")),
        tableOutput("sum.p")

		),

		conditionalPanel(
		condition = "input.InputSrc_p == 'DataDist'",
		h4("ユーザーデータの分布"),
 		p(tags$b("アップロードデータのヒストグラム")),
        plotly::plotlyOutput("makeplot.2"),
        p(tags$b("サンプルの記述統計")),
    		tags$b("アップロードデータからのCDF"),
    		plotly::plotlyOutput("makeplot.22"),        
        tableOutput("sum2.p")


		)

	) #main pa end


)
