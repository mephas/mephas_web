sidebarLayout(
  sidebarPanel(
    useShinyjs(),
 #   tabsetPanel(     
#    tabPanel("CSV file",
    h4(tags$b("步骤1. 下载GEO数据")),#####step1 数据处理输入
    #1 填写GEO号直接生成样本
    textInput(inputId = "gse.id",
              label = h5("输入您想查找的芯片的序号（GSE）:"),
              value = "GSE16020",#"GSE32575",GSE37455 GSE16020
              placeholder = "GSE16020"),
    actionButton("gsegoButton","搜索芯片"),
    uiOutput('gpl.id'),
    
    
    
    uiOutput('text_step2'),#####step2 预处理

    
    
    uiOutput('text_step3'),#####Step3 分组信息
    uiOutput('text_step3_control'),#step3的可隐藏区
    uiOutput('text_step3_choosetext'),#step3的可隐藏区

    uiOutput("diffchoice"),#1 差异选择方式
    #uiOutput("page2example"),#2 说明文字
    
    uiOutput("diffA_tab1"),#组间比较
    uiOutput("diffB_tab1"),#组内比较 分组
    uiOutput("diffB_tab2"),#组内比较 比较
    
    uiOutput("diffrandomA"),#3 随机效应A
    uiOutput("diffrandomB"),#  随机效应B
    
    uiOutput("uploadB1"),#用以确定差异比较选择结果
    

    
    uiOutput('text_step4'),#####step4差异比较
    uiOutput('Selecontrast'),#A选择框 用来选谁和谁比较 每次出现的依据是上面的选择
    uiOutput('SelecontrastB'), #B选择框  
    uiOutput('updownreverse'), #因子转换  
    
    uiOutput("uploadB2"),#Step4结束后 引出后续的差异分析
    
    
    
    uiOutput('text_step5'),#####step5通路分析
    
    p(tags$b("You can reload this page by clicking the button below.")),
    actionButton("NUM_clear","clear")
                       
  #    ))
  ),

  mainPanel(
#    h4(tags$b("Output")),
#    h4('Plot:'),
#    plotOutput('plot_NUM'),
#    uiOutput('condi_plot'),
    tabsetPanel(
  #    tabPanel("使用说明",uiOutput("introword")),
      tabPanel("数据描述",
               uiOutput('text_Output1a'),#####Output1 
               dataTableOutput("showexpr"),
               downloadButton('downloadExpr', '下载表达矩阵'),
               uiOutput('text_Output1b'),
			   plotOutput("dataBoxBefore"),
               uiOutput('text_Output1b_2'),
               plotOutput("dataBox"),
               uiOutput('text_Output1all')

               ),

      
      tabPanel("分组信息",
               tabsetPanel(
                 tabPanel("分组特征描述",
                          #uiOutput('textgse'),#本来是想做一个提示信息
                          uiOutput('text_Output2a'),
                          uiOutput('text_Output2aall'),
                          dataTableOutput("dataPInfo")
                          
                          ),#####Output2
                 
                 tabPanel("分组信息输入",
                          uiOutput('text_Output2b'),
                          uiOutput('text_Output2ball'),
                          rHandsontableOutput("hot")
                          
                          
                          #uiOutput('test'),
                          #uiOutput('test2'),
                          #uiOutput("expr.table.test"),#test用
                   
                 )

                 
               )

               ),
      tabPanel("数据检查",
               tabsetPanel(

                 tabPanel("聚类分析",
                          uiOutput('text_Output3a'),
                          plotOutput("HC_cluster"),
                          uiOutput('text_Output3aall')),
                 tabPanel("主成分分析",
                          uiOutput('text_Output3b'),
                          plotOutput("dataPCA2"),
                          uiOutput('text_Output3ball'))
                 
               )
               ),

      tabPanel("差异表达",
               
               tabsetPanel(
                 tabPanel("LIMMA",
                          uiOutput('text_Output4a'),
                          textInput(inputId = "pvalue",
                                    label = "p-value:",
                                    value = "0.05",
                                    placeholder = "0.05"),
                          uiOutput("Limmaresulttext"),
                          dataTableOutput('testLimma'),
                          downloadButton('downloadData', 'Download'),
                          uiOutput('text_Output4aall')),
                 
                          
                 tabPanel("基因散点图",
                          uiOutput('text_Output4b'),
                          uiOutput("geneselect"),
                          plotOutput("genebotPlot"),
                          uiOutput('text_Output4ball')),#差异基因配对点图
                 tabPanel("火山图",
                          uiOutput('text_Output4c'),
                          plotOutput("volPlot"),
                          uiOutput('text_Output4call')),
                 #tabPanel("热图",plotly::plotlyOutput("heatout"))
                 tabPanel("热图",
                          uiOutput('text_Output4d'),
                          plotOutput("heatout"),
                          uiOutput('text_Output4dall'))
               )
               
               ),
      tabPanel("通路分析",
               tabsetPanel(
                 tabPanel("GO分析",
                          
                          actionButton("GopathButton","开始通路分析"),
                          uiOutput('text_Output5a'),
                          uiOutput('text_GOup'),
                          #HTML("Up genes"),
                          dataTableOutput('GoTable_up'),
                          plotOutput("GOplot_up"),
                          uiOutput('text_GOdown'),
                          #HTML("Down genes"),
                          dataTableOutput('GoTable_down'),
                          plotOutput("GOplot_down"),
                          #downloadButton("downlodGO", "Download GO result")
                          
                          ),
                 tabPanel("KEGG分析",
                          uiOutput('text_Output5b'),
                          uiOutput('text_KEGGup'),
                          #HTML("Up genes"),
                          dataTableOutput("KEGGTable_up"),
                          plotOutput("KEGGplot_up"),
                          uiOutput('text_KEGGdown'),
                          #HTML("Down genes"),
                          dataTableOutput("KEGGTable_down"),
                          plotOutput("KEGGplot_down"),
                          #downloadButton("downlodKEGG", "Download KEGG result")
                          
                          )#KEGG
               )
               
               
               ),
      tabPanel("可重复R代码",
               verbatimTextOutput("Code"),
               aceEditor("rmd", mode="markdown", value='',readOnly=T, height="500px"),
               downloadButton("gecode","生成代码")
               ),
      tabPanel("RmarkDown结果",
               uiOutput("RMarkD"),#未实装
               downloadButton('downloadreport', 'Download Result')#未实装
               )
      
    )
    
    
   
#    h4('Input Confirm:'),
#    dataTableOutput('NUM_table'),
#    h4('Results:'),
#    verbatimTextOutput("NUM_results"),
#    h4('Download:'),
#    downloadButton('NUM_download', 'Download')
  )
)

