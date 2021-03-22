#****************************************************************************************************************************************************1.5. T
sidebarLayout(
	sidebarPanel(

	h4(tags$b("第1步  选择数据源")),
	p("基于数学公式、模拟数据或用户数据"),
	#Select Src
	selectInput(
	    "InputSrc_t", "Select plot",
	    c("基于数学公式" = "MathDist",
	      "基于模拟数据" = "SimuDist",
	      "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("第2步 设置参数")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'MathDist'",
	    HTML("<b>1. 设置参数 T(v)</b>"),
	    #HTML("<h4><b>Step 1. Set Parameters for T(v)</h4></b>"),
 		numericInput("t.df", HTML("v > 0, 自由度, 与性状有关"), value = 4, min = 0),
 		hr(),
numericInput("t.sd", HTML("或根据SD计算比率，输入SD"), value = 0.5, min = 0),
verbatimTextOutput("t.rate"),
p("SD = v/(v-2)"),

		  hr(),
		  #p(tags$b("You can adjust x-axes range")),
		  numericInput("t.xlim", "改变x轴的范围", value = 5, min = 1)
		  #numericInput("t.ylim", "Range of y-asis, > 0", value = 0.5, min = 0.1, max = 3),
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'SimuDist'",
        numericInput("t.size", "模拟数据样本量", value = 100, min = 1, step = 1),
        sliderInput("t.bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
		p("如果个数是 0, 直方图将使用默认个数。")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_t == 'DataDist'",

	    tabsetPanel(
	       tabPanel("手动输入",p(br()),
    p("数据可以用「，」，「分号」，「回车」，「空格」，「制表符」进行分隔。"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")), 
        		
    		tags$textarea(
        id = "x.t", #p
        rows = 10,
"-0.52\n-0.36\n-1.15\n-1.46\n0.54\n-1.6\n0.1\n-0.48\n-0.69\n-1.66\n0.59\n0.11\n-0.01\n0.32\n-1.31\n1.25\n-0.19\n-0.66\n0.75\n-1.86"
),
      p("缺失值输入NA")
	     	 ), #tab1 end
tabPanel.upload.num(file ="t.file", header="t.header", col="t.col", sep="t.sep")

	    ),
      sliderInput("bin.t","直方图中的分箱数", min = 0, max = 100, value = 0),
        p("当分箱数为0时，绘图将使用默认分箱数")
	  ),
	  #condiPa 3 end
	  	hr(),

		 	h4(tags$b("第3步 显示概率")),
	 		numericInput("t.pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub>为红线位置"), value = 0.025, min = 0, max = 1, step = 0.05),
	 		hr()

	), #sidePa end


	mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_t == 'MathDist'",
		  h4("基于数学公式"),
		tags$b("T分布图"),
        p("蓝色曲线是标准正态分布"),

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
		   h4("基于模拟数据的绘图"),

		tags$b("随机数的直方图"),
        plotly::plotlyOutput("t.plot2"),#click = "plot_click4",


        #verbatimTextOutput("t.info2"),
        downloadButton("download5", "随机数下载"),
        p(tags$b("样本描述性统计量")),
        tableOutput("t.sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_t == 'DataDist'",
		tags$b("数据预览"),
		DT::DTOutput("TT"),
		 h4("用户数据的绘图"),
        tags$b("上传数据的密度分布"),
        plotly::plotlyOutput("makeplot.t2"),
        tags$b("上传数据的直方图"),
        plotly::plotlyOutput("makeplot.t1"),
        tags$b("上传数据的累积概率分布（CDF）"),
        plotly::plotlyOutput("makeplot.t3"),
      p(tags$b("样本描述性统计量")),
      tableOutput("t.sum2")

		)

	) #main pa end


	)



