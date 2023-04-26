#****************************************************************************************************************************************************1.2. Exp distribution
sidebarLayout(

	sidebarPanel(

  h4(tags$b("第1步  选择数据源")),
  p("基于数学公式、模拟数据或用户数据"),
	  #Select Src
	  selectInput(
	    "InputSrc_e", "Select plot",
      c("基于数学公式" = "MathDist",
        "基于模拟数据" = "SimuDist",
        "基于用户数据" = "DataDist")),
	  hr(),
	  #Select Src end
	 h4(tags$b("第2步 设置参数")),
	  #condiPa 1
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'MathDist'",
	    #"Draw an Exponential Distribution", p(br()),
      HTML("<b>设置E（比率）的参数</b></h4>"),
	    numericInput("r", HTML(" 比率 (>0) 表示变化率、输入率"), value = 2, min = 0),
      hr(),
      numericInput("e.mean", HTML("或 根据均值和SD（均值=SD）计算速率，输入均值"), value = 0.5, min = 0),
      verbatimTextOutput("e.rate"),
      p("Mean = SD = 1/Rate"),
	    hr(),

	    numericInput("e.xlim", "2. 改变x轴的范围, x轴须 > 0", value = 5, min = 1)

	  ),
	  #condiPa 2
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'SimuDist'",
	    numericInput("e.size", "模拟数据样本量", value = 100, min = 1,step = 1),
	    sliderInput("e.bin", "直方图中柱子的个数", min = 0, max = 100, value = 0),
	    p("如果个数是 0, 直方图将使用默认个数。")
	  ),
	  #condiPa 2 end

	  #condiPa 3
	  conditionalPanel(
	    condition = "input.InputSrc_e == 'DataDist'",

	    tabsetPanel(
      	      tabPanel("手动输入",p(br()),
    p("数据可以用「，」，「分号」，「回车」，「空格」，「制表符」进行分隔。"),
    p(tags$b("从CSV（一列）复制数据并粘贴到框中")),      	        
    tags$textarea(
      	          id = "x.e", #p
      	          rows = 10,
      	          "2.6\n0.5\n0.8\n2.3\n0.3\n2\n0.5\n4.4\n0.1\n1.1\n0.7\n0.2\n0.7\n0.6\n3.7\n0.3\n0.1\n1\n2.6\n1.3"
      	        ),
      	        p("缺失值输入NA")
      	        ),
      	      tabPanel.upload.num(file ="e.file", header="e.header", col="e.col", sep="e.sep")

	     ),
	    sliderInput("bin.e", "直方图中的分箱数", min = 0, max = 100, value = 0),
	    p("当分箱数为0时，绘图将使用默认分箱数")
	  ), #condiPa 3 end
    hr(),
    h4(tags$b("第3步 显示概率")),
    numericInput("e.pr", HTML("红线左侧的面积比例 = Pr(X < x<sub>0</sub>), x<sub>0</sub>为红线位置"), value = 0.05, min = 0, max = 1, step = 0.05),
    hr()
	), #sidePa end

  	mainPanel(
  		h4(tags$b("Outputs")),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'MathDist'",
  		  h4("基于数学公式"),
  		  tags$b("指数分布图"),
  		  plotOutput("e.plot", click = "plot_click9"),#
  		  verbatimTextOutput("e.info"),
        p(br()),
        p(tags$b("红线的位置")),
  		  #p(tags$b("The position of Red-line, x<sub>0</sub>")),
  		  #verbatimTextOutput("e"),
      hr(),
    #   plotly::plotlyOutput("e.plot.cdf")
	       plotOutput("e.plot.cdf") 
  		),
  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'SimuDist'",
  		 h4("基于模拟数据的绘图"),
  		  tags$b("随机数的直方图"),
  		  plotly::plotlyOutput("e.plot2"),#click = "plot_click10",
  		  #verbatimTextOutput("e.info2"),
  		  downloadButton("download2", "随机数下载"),

  		  p(tags$b("样本描述性统计量")),
  		  tableOutput("e.sum")
  		),

  		conditionalPanel(
  		  condition = "input.InputSrc_e == 'DataDist'",
        tags$b("数据预览"),
        DT::DTOutput("Y"),
  		  h4("用户数据的绘图"),
  		  tags$b("上传数据的密度分布"),
  		  plotly::plotlyOutput("makeplot.e2"),
  		  tags$b("上传数据的直方图"),
  		  plotly::plotlyOutput("makeplot.e1"),
        tags$b("上传数据的累积概率分布（CDF）"),
        plotly::plotlyOutput("makeplot.e3"),
  		  p(tags$b("样本描述性统计量")),
  		  tableOutput("e.sum2")

  		)



	)
)

