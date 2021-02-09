#****************************************************************************************************************************************************2. poisson
sidebarLayout(

	sidebarPanel(
	h4(tags$b("第1步  选择数据源")),
	p("基于数学、模拟数据或用户数据"),		#Select Src
	selectInput(
	    "InputSrc_p", "选项",
	    c("基于数学" = "MathDist",
	      "基于模拟数据" = "SimuDist",
	      "基于用户数据" = "DataDist")),
	hr(),
	#Select Src end
		h4(tags$b("第2步  设置参数")),

	#condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist'",
	    HTML("<b> 1. 设置参数</b>"),
		numericInput("lad", "比率 = 均值 = 方差", value = 2.3, min = 0, max = 10000000000, step = 1),
      numericInput("k2", "事件发生的持续时间>0", value = 12, min = 0 , max = 1000000000)
      ),
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
	    p(tags$i("在这个例子中，比率是2.3，持续时间是12个月。"))
	  ),
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist'",
      hr(),

      tags$b(" 2. 更改观察数据"),
      numericInput("x0", "观察到的事件持续时间（红点）", value = 5, min = 0 , max = 1000000000)
      ),
      conditionalPanel(
	    condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
      p(tags$i("观察值为<= 5，假设我们想知道5个月后的累积概率（也就是说，1-0〜5个月的累计概率）。"))
	  ),
	 #condiPa 1 end

	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'SimuDist'",
		numericInput("size.p", "随机样本的个数", value = 100, min = 1, max = 1000000, step = 1),
		sliderInput("bin.p", "直方图中的分箱数", min = 0, max = 100, value = 0),
		p("当分箱数为0时，绘图将使用默认分箱数")

	  ),
	  #condiPa 2 end
	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_p == 'DataDist'",
	    tabsetPanel(
	      tabPanel("手动输入",p(br()),
    p("数据可以用「，」，「回车」，「制表符」进行分隔。"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")), 
    		
    	tags$textarea(
        id = "x.p", #p
        rows = 10,
        "1\n3\n4\n3\n3\n3\n5\n3\n2\n1\n1\n3\n2\n4\n1\n2\n5\n4\n2\n3"
         ),
      p("缺失值输入NA")
	     ), #tab1 end
		tabPanel.upload.num(file ="file.p", header="header.p", col="col.p", sep="sep.p")

	    ),
      sliderInput("bin1.p","直方图中的分箱数", min = 0, max = 100, value = 0),
       p("当分箱数为0时，绘图将使用默认分箱数")
	  )
	  #condiPa 3 end

	), #sidePa end

mainPanel(
		h4(tags$b("Outputs")),

		conditionalPanel(
		  condition = "input.InputSrc_p == 'MathDist'",
		  h4("基于数学公式的绘图"),
		  p("蓝色曲线为正态分布，均值=比率，sd =比率。它表示二项分布的正态近似。"),
 		p(tags$b("Poisson probability plot")),
    	plotly::plotlyOutput("p.plot"),
    	p(tags$b("观察到的事件数的概率（红点）")),
    	tableOutput("p.k"),
    hr(),
     plotly::plotlyOutput("p.plot.cdf")   
    	),
    	conditionalPanel(
		  condition = "input.InputSrc_p == 'MathDist' && input.explain_on_off",
    	p(tags$i("说明：到5个月的概率分布是0.97.因此，6个月以后的概率分布大约为0.03。"))
		),

		conditionalPanel(
		  condition = "input.InputSrc_p == 'SimuDist'",
 		p(tags$b("随机数的直方图")),
        plotly::plotlyOutput("p.plot2"),

        downloadButton("download2", "随机数下载"),
        p(tags$b("数据的描述性统计量")),
        tableOutput("sum.p")

		),

		conditionalPanel(
		condition = "input.InputSrc_p == 'DataDist'",
		h4("用户数据的绘图"),
 		p(tags$b("上传数据的直方图")),
        plotly::plotlyOutput("makeplot.2"),
        p(tags$b("数据的描述性统计量")),
    		tags$b("上传数据的密度分布（CDF）"),
    		plotly::plotlyOutput("makeplot.22"),        
        tableOutput("sum2.p")


		)

	) #main pa end


)
