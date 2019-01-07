
##--------------------------------------------------
##
## MFSttest ui CN
##
## 2018-11-28
##
##---------------------------------------------------

shinyUI(

tagList(
#shinythemes::themeSelector(),
navbarPage(
  #theme = shinytheme("cosmo"),
  title = "均值检验",

  ## 1. One sample -----------------------------------------------------------------
  tabPanel(
    "单样本",
    headerPanel("单样本t检验"),

    tags$b("注释"),
    HTML(
      "
      <ul>
      <li> X 是独立变量 </li>
      <li> &#956 是来自总体的平均值 </li>
      <li> &#956&#8320 是特定的待比较的平均值 </li>
      </ul>
      "
      ),

    tags$b("前提假设"),
    HTML(
      "
      <ul>
      <li> X 是连续的数值，并且基于正态分布 </li>
      <li> X的每个观测（样本）是独立的和近似正态分布的 </li>
      <li> 数据采集过程随机无更换 </li>
      "
      ),

    sidebarLayout(
      sidebarPanel(
        ##----Configuration----
        helpText("参数设置"),
        numericInput('mu', HTML("特定的待比较的平均值, &#956&#8320"), 7), #p

        helpText("假设检验"),
        tags$b("零假设"),
        HTML("<p> &#956 = &#956&#8320: X的总体平均值是 &#956&#8320 </p>"),
        radioButtons(
          "alt.pt", #p
          label = "对立假设",
          choiceNames = list(
            HTML("&#956 &#8800 &#956&#8320: X的总体平均值不是 &#956&#8320"),
            HTML("&#956 < &#956&#8320: X的总体平均值小于 &#956&#8320"),
            HTML("&#956 > &#956&#8320: X的总体平均值大于 &#956&#8320")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),
        hr(),

        ##----Import data----##
        helpText("数据导入"),

        tabsetPanel(
          ##-------input data-------##s
          tabPanel(
            "手动输入",
            p(br()),
            helpText("如有缺失值，请输入NA"),
            tags$textarea(
              id = "x", #p
              rows = 10,
              "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
              ),
        helpText("改变样本名称（可选）"),
        tags$textarea(id = "cn", rows = 1, "X") #p
            ), #tabPanel(

          ##-------csv file-------##
          tabPanel(
            "上传 .csv 格式文件",
            p(br()),
            fileInput(
              'file', '选择 .csv 格式文件', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header', '标题行', TRUE), #p
            radioButtons('sep', '分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            ) #tabPanel(
          ),

        hr(),
        h4("显示数据"),
        
        dataTableOutput("table"),
        hr(),
        h4("图形配置"),
        sliderInput("bin", "直方图中柱的宽度",min = 0.01,max = 5,value = 0.2) #p
        ),

      mainPanel(
        h3(tags$b("检验结果")),
        tableOutput("t.test"), 
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('描述统计量')),
        splitLayout(
          tableOutput("bas"), 
          tableOutput("des"), 
          tableOutput("nor")
          ),
        hr(),
        h3(tags$b("均值和标准偏差图")),
        plotOutput("meanp", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("箱线图")),
        splitLayout(
          plotOutput(
            "bp",
            width = "400px",
            height = "400px",
            click = "plot_click"
            ),
          wellPanel(
            verbatimTextOutput("info"), 
            hr(),
            helpText(
              HTML(
                "注释:
                <ul>
                <li> 图中的各个点是在同一水平线上随机地模拟和定位的 </li>
                <li> 如果存在，异常值将以红色突出显示</li>
                <li> 红色异常值可能不覆盖原本的模拟点</li>
                <li> 红色异常值仅表示同一水平线上（横轴）上的值</li>
                </ul>"
                )
              )
            )
          ),
        hr(),
        h3(tags$b('正态性图')),
        plotOutput("makeplot", width = "900px", height = "300px")
        )
      )
    ),
  ##

  ## 2. Two independent samples ---------------------------------------------------------------------------------
  tabPanel(
    "两个独立样本",

    headerPanel("双样本t检验"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("被比较的两个样本的总体都应该遵循正态分布."),
      tags$li("X和Y应独立地从两个进行比较的总体里分别取样."),
      tags$li("被比较的两个总体应该具有相同的方差.")
      ),

    tags$b("表示法"),
    HTML(
      "
      <ul>
      <li> 独立观测值被指定为X和Y.</li>
      <li> &#956&#8321 = X的总体平均; &#956&#8322 = Y的总体平均</li>
      </ul>"
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("假设"),
        tags$b("零假设"),
        HTML("<p> &#956&#8321 = &#956&#8322: X和Y有相同的总体平均值.</p>"),
        radioButtons("alt.t2", #p
          label = "对立假设",
          choiceNames = list(
            HTML("&#956&#8321 &#8800 &#956&#8322: X和Y的总体平均值不相同."),
            HTML("&#956&#8321 < &#956&#8322: X的总体平均值小于Y."),
            HTML("&#956&#8321 > &#956&#8322: X的总体平均值大于Y.")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),

        hr(),
        # for seperate
        helpText("导入数据"),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "手动输入",
            p(br()),
            helpText("如有缺失值，请输入NA"),
            tags$textarea(id = "x1",rows = 10,"4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"),
            ## disable on chrome
            tags$textarea(id = "x2",rows = 10,"6.6\n6.9\n6.9\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"),

            helpText("改变两个样本的名称（可选）"),
        tags$textarea(id = "cn2", rows = 2, "X\nY")
            ),

          ##-------csv file-------##
          tabPanel(
            "上传 .csv 格式文件",
            p(br()),
            fileInput('file2','选择 .csv 格式文件', #p
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
                )
              ),
            checkboxInput('header2', '标题行', TRUE), #p
            radioButtons('sep2','分隔符', #p
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
                ','
              )
            )
          ),
        hr(),
        h4("显示数据"),

        dataTableOutput("table2"),
        hr(),
        h4("图形配置"),
        sliderInput("bin2","直方图中柱的宽度",min = 0.01,max = 5,value = 0.2)
        ),

      mainPanel(
        h3(tags$b("检验结果")),
        tableOutput("var.test"),
        helpText("当P值＜0.05时，请进行'韦尔奇(Welch)两样本t检验'."),
        tableOutput("t.test2"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('描述性统计量')),
        splitLayout(
          tableOutput("bas2"),
          tableOutput("des2"),
          tableOutput("nor2")
          ),

        hr(),
        h3(tags$b("均值和标准偏差图")),
        plotOutput("meanp2", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("箱线图")),
        splitLayout(
          plotOutput("bp2",width = "400px",height = "400px",click = "plot_click"),
          wellPanel(
            verbatimTextOutput("info2"), 
            hr(),
            helpText(
              HTML(
                "注释:
                <ul>
                <li> 图中的各个点是在同一横轴上随机地模拟和定位的.</li>
                <li> 如果存在，异常值将以红色突出显示.</li>
                <li> 红色异常值可能不覆盖模拟点.</li>
                <li> 红色异常值仅表示水平行同一横轴上的值.</li>
                </ul>"
                )
              )
            )              
          ),
        hr(),
        h3(tags$b('正态性图')),
        plotOutput("makeplot2", width = "600px", height = "600px")
        )
      )
    ),
  ##

  ## 3. Two paried samples ---------------------------------------------------------------------------------
  tabPanel(
    "两个成对样本",

    headerPanel("成对样本的t检验"),

    helpText("一个典型的成对样本的例子是对某种治疗结果的重复测定，比如对高血压患者的降血压药物治疗前后的血压测定，前后两次的结果组成了两组成对样本"),

    tags$b("前提假设"),
    tags$ul(
      tags$li("被比较的两个对应的样本的差应该近似地遵循正态分布"),
      tags$li("成对样本的差异是基于正态分布的连续的数值"),
      tags$li("数据采集过程随机无更换")
      ),

    tags$b("注释"),
    HTML(
      "
      <ul>
      <li> 观测值为相关的x和y</li>
      <li> &#916是X和Y之间的平均差异</li>
      </ul>"
      ),

    sidebarLayout(
      sidebarPanel(
        helpText("假设检验"),
        tags$b("零假设"),
        HTML("<p> &#916 = 0: X和Y具有相同的效果</p>"),
        radioButtons("alt.pt",
          label = "对立假设",
          choiceNames = list(
            HTML("&#916 &#8800 0: X和Y的总体平均值不相等."),
            HTML("&#916 < 0: X的总体平均值小于Y."),
            HTML("&#916 > 0: X的总体平均值大于Y.")
            ),
          choiceValues = list("two.sided", "less", "greater")
          ),

        hr(),
        helpText("导入数据"),

        tabsetPanel(
          ##-------input data-------##
          tabPanel(
            "手动输入",
            p(br()),
            helpText("如有缺失值，请输入NA"),
            tags$textarea(id = "x1.p",rows = 10,
              "4.2\n5.3\n7.6\n6.7\n6.3\n3.5\n5.8\n6.3\n3.2\n4.6\n5.5\n5.2\n4.6\n4.8\n4.5\n5.3\n4.3\n4.3\n6.2\n6.7"
              ),
            ## disable on chrome
            tags$textarea(id = "x2.p",rows = 10,
              "6.6\n6.9\n6.7\n8.4\n7.8\n6.6\n8.6\n5.5\n4.6\n6.1\n7.1\n4.0\n6.5\n5.6\n8.1\n5.8\n7.9\n6.4\n6.5\n7.4"
              ),

            helpText("改变两个样本的名称（可选)"),
            tags$textarea(id = "cn.p", rows = 2, "X\nY\n(X-Y)")

            ),

          ##-------csv file-------##
          tabPanel("上传 .csv 格式文件",
            p(br()),
            fileInput(
              'file.p',
              '选择 .csv 格式文件',
              accept = c(
                'text/csv',
                'text/comma-separated-values,text/plain',
                '.csv'
              )
            ),
            checkboxInput('header.p', '标题行', TRUE), #p
            radioButtons('sep.p','分隔符',
              c(
                Comma = ',',
                Semicolon = ';',
                Tab = '\t'
                ),
              ','
              )
            )
          ),

        hr(),
        h4("显示数据"),
        dataTableOutput("table.p"),
        hr(),
        h4("图形配置"),
        sliderInput("bin.p","直方图中柱的宽度",min = 0.01,max = 5,value = 0.2)
        ),

      mainPanel(
        h3(tags$b("检验结果")),
        tableOutput("t.test.p"),
        #tags$b('Interpretation'), p("NULL"),

        hr(),
        h3(tags$b('描述性统计量')),
        splitLayout(
          tableOutput("bas.p"),
          tableOutput("des.p"),
          tableOutput("nor.p")
          ),

        hr(),
        h3(tags$b("均值和标准偏差图")),
        plotOutput("meanp.p", width = "600px", height = "300px"),

        hr(),
        h3(tags$b("两样本差的箱线图")),
        splitLayout(
          plotOutput("bp.p",width = "400px",height = "400px",click = "plot_click"),
          wellPanel(
            verbatimTextOutput("info.p"), hr(),
            helpText(
              HTML(
                "Notes:
                <ul>
                <li> 图中的各个点是在同一横轴上随机地模拟和定位的. </li>
                <li> 如果存在，异常值将以红色突出显示.</li>
                <li> 红色异常值可能不覆盖模拟点. </li>
                <li> 红色异常值仅表示水平行同一横轴上的值.</li>
                </ul>"
                )
              )
            )
          ),
        hr(),
        h3(tags$b('两样本差的正态性图')),
        plotOutput("makeplot.p", width = "900px", height = "300px")
        )
      )
    )
    ##
,
  tabPanel(
      tags$button(
      id = 'close',
      type = "button",
      class = "btn action-button",
      onclick = "setTimeout(function(){window.close();},500);",  # close browser
      "停止")
),
tabPanel(
     tags$button(
     id = 'close',
     type = "button",
     class = "btn action-button",
     onclick ="window.open('https://pharmacometrics.info/mephas/index_cn.html')","主页"))

  )
)
)

