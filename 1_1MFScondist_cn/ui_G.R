#****************************************************************************************************************************************************1.3. gamma
sidebarLayout(

	sidebarPanel(

	h4(tags$b("第1步  选择数据源")),
	p("基于数学公式、模拟数据或用户数据"),
	#Select Src
	selectInput(
	    "InputSrc_g", "选择绘图",
      c("基于数学公式" = "MathDist",
        "基于模拟数据" = "SimuDist",
        "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
	h4(tags$b("第2步 设置参数")),
	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'MathDist'",
	    #h3("Draw a Gamma Distribution", p(br())),
	    HTML("<b>1. 设置参数 Gamma(k, &#952)</b>"),
	    numericInput("g.shape", HTML("k > 0, 形状参数"), value = 9, min = 0),
		numericInput("g.scale", HTML("&#952 > 0, 刻度参数"), value = 0.5, min = 0),
hr(),
numericInput("g.mean", HTML("或根据均值和SD（均值=SD）计算 k 和 &#952, 输入均值"), value = 0.5, min = 0),
numericInput("g.sd", HTML("输入SD"), value = 0.5, min = 0),

verbatimTextOutput("g.rate"),
HTML("<li> Mean = k&#952
			<li> Variance = k&#952<sup>2</sup>"),
		hr(),

		numericInput("g.xlim", "改变x轴的范围, x轴须 > 0", value = 20, min = 1)
	  ),
	  #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'SimuDist'",
	    numericInput("g.size", "模拟数据样本量", value = 100, min = 1, step = 1),
	    sliderInput("g.bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
		p("如果个数是 0, 直方图将使用默认个数。")

	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_g == 'DataDist'",
	    tabsetPanel(

	      tabPanel("手动输入",p(br()),
    p("数据可以用「，」，「分号」，「回车」，「空格」，「制表符」进行分隔。"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")), 
    			
			tags$textarea(
        	id = "x.g", #p
       	 rows = 10, "4.1\n9.3\n11.7\n2\n2\n5.8\n1.6\n1.9\n4.7\n5.8\n3.1\n3.1\n3\n11\n1.2\n5.7\n10\n13.8\n3.8\n3.1"
				        ),
      		p("缺失值输入NA")
	     	 ), #tab1 end
			tabPanel.upload.num(file ="g.file", header="g.header", col="g.col", sep="g.sep")
	    ),
      	sliderInput("bin.g","直方图中的分箱数", min = 0, max = 100, value = 0),
      	p("当分箱数为0时，绘图将使用默认分箱数")
	  ),
	  #condiPa 3 end
	  hr(),
		h4(tags$b("第3步 显示概率")),
	 	numericInput("g.pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub>为红线位置"), value = 0.05, min = 0, max = 1, step = 0.05),
 		hr()
	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_g == 'MathDist'",
		  h4("基于数学公式"),
		  tags$b("伽马分布图"),
		  plotOutput("g.plot", click = "plot_click11"),
         verbatimTextOutput("g.info"),
         #HTML("<p><b>红线的位置, x<sub>0</sub></b></p>"),
		 #p(tags$b("The position of Red-line, x<sub>0</sub>")),
         #tableOutput("g")
     hr(),
    #  plotly::plotlyOutput("g.plot.cdf")
	   plotOutput("g.plot.cdf")
		),

		conditionalPanel(
		  condition = "input.InputSrc_g == 'SimuDist'",
		 h4("基于模拟数据的绘图"),

		tags$b("随机数的直方图"),
        plotly::plotlyOutput("g.plot2"),#click = "plot_click12",

        #verbatimTextOutput("g.info2"),
        downloadButton("download3", "随机数下载"),
        p(tags$b("样本描述性统计量")),
        tableOutput("g.sum")

		),

		conditionalPanel(
		condition = "input.InputSrc_g == 'DataDist'",
		tags$b("数据预览"),
		DT::DTOutput("Z"),
		h4("用户数据的绘图"),
		tags$b("上传数据的密度分布"),
        plotly::plotlyOutput("makeplot.g2"),
        tags$b("上传数据的直方图"),
        plotly::plotlyOutput("makeplot.g1"),
        tags$b("上传数据的累积概率分布（CDF）"),
        plotly::plotlyOutput("makeplot.g3"),
        p(tags$b("样本描述性统计量")),
        tableOutput("g.sum2")
		)

	)
	)

