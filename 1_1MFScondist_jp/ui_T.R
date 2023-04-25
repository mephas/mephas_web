#****************************************************************************************************************************************************1.5. T
sidebarLayout(
	sidebarPanel(

	h4(tags$b("Step 1. データソースを選ぶ")),
	p("数式ベース、シミュレーションベース、又は、ユーザのデータベース"),
	#Select Src
	selectInput(
	    "InputSrc_t", "選択肢",
      c("数式ベース" = "MathDist",
        "シミュレーションベース" = "SimuDist",
        "ユーザデータベース" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("Step 2. パラメータの設定")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'MathDist'",
	    HTML("<b>1. パラメータの設定(T(v))</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for T(v)</h4></b>"),
 		numericInput("t.df", HTML("v > 0:自由度 (形に関連)"), value = 4, min = 0),
 		hr(),
numericInput("t.sd", HTML("またはSDから率を計算するためにSDを入力"), value = 0.5, min = 0),
verbatimTextOutput("t.rate"),
p("SD = v/(v-2)"),

		  hr(),
		  #p(tags$b("You can adjust x-axes range")),
		  numericInput("t.xlim", "x軸の範囲を変更します。", value = 5, min = 1)
		  #numericInput("t.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'SimuDist'",
        numericInput("t.size", "シミュレートした数の標本サイズ", value = 100, min = 1, step = 1),
        sliderInput("t.bin", "ヒストグラムのビンの数", min = 0, max = 100, value = 0),
		p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'DataDist'",

	    tabsetPanel(
	       tabPanel("手入力",p(br()),
		p("データポイントは「,」「;」「Enter」「Tab」で区切ることができます。"),
		p(tags$b("データはCSV（1列）からコピーされ、ボックスに貼り付けられます")),
        		
    		tags$textarea(
        id = "x.t", #p
        rows = 10,
"-0.52\n-0.36\n-1.15\n-1.46\n0.54\n-1.6\n0.1\n-0.48\n-0.69\n-1.66\n0.59\n0.11\n-0.01\n0.32\n-1.31\n1.25\n-0.19\n-0.66\n0.75\n-1.86"
),
      	p("欠損値はNAとして入力されます")
	     	 ), #tab1 end
tabPanel.upload.num(file ="t.file", header="t.header", col="t.col", sep="t.sep")

	    ),
      sliderInput("bin.t","ヒストグラムのビンの数", min = 0, max = 100, value = 0),
        p("ビンの数が0の場合はプロットでデフォルトのビンの数が使用されます。")
	  ),
	  #condiPa 3 end
	  	hr(),
		 	h4(tags$b("Step 2. 確率を表示する")),
	 		numericInput("t.pr", HTML("赤線の左側の面積の割合 = Pr(X < x<sub>0</sub>)で、赤線の位置が x<sub>0</sub> です。"), value = 0.025, min = 0, max = 1, step = 0.05),
	 		hr()

	), #sidePa end


	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_t == 'MathDist'",
		  h4("数式ベースプロット"),
		tags$b("T分布プロット"),
        p("青色の曲線は標準の正規分布"),

        plotOutput("t.plot", click = "plot_click3"),
        verbatimTextOutput("t.info"),

        #HTML("<p><b>The position of Red-line, x<sub>0</sub></b></p>"),
        #p(tags$b("The position of Red-line, x<sub>0</sub>")),
        #tableOutput("t")
        hr(),
      plotly::plotlyOutput("t.plot.cdf")  
		),

		conditionalPanel(
		  condition = "input.InputSrc_t == 'SimuDist'",
		   h4("シミュレーションベースプロット"),

		tags$b("乱数から作成したヒストグラム"),
        plotly::plotlyOutput("t.plot2"),#click = "plot_click4",


        #verbatimTextOutput("t.info2"),
        downloadButton("download5", "乱数をダウンロードする"),
        p(tags$b("サンプルの記述統計")),
        tableOutput("t.sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_t == 'DataDist'",
		tags$b("データの確認"),
		DT::DTOutput("TT"),
		h4("データの分布"),
        tags$b("アプロードされたデータの密度プロット"),
        plotly::plotlyOutput("makeplot.t2"),
        tags$b("アプロードされたデータのヒストグラム"),
        plotly::plotlyOutput("makeplot.t1"),
        tags$b("アプロードされた累積密度プロット（CDF）"),
        plotly::plotlyOutput("makeplot.t3"),
        p(tags$b("データの記述統計")),
		tableOutput("t.sum2")

		)

	) #main pa end


	)



