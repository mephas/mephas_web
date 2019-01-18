
##----------#----------#----------#----------
##
## 2MFSttest UI
##
## Language: CN
## 
## DT: 2019-01-08
##
##----------#----------#----------#----------

shinyUI(

tagList(
source("../0tabs/font_cn.R",local=TRUE, encoding="UTF-8")$value,

navbarPage(
  
  title = "均值检验",

##---------- Panel 1 ---------

tabPanel("单样本",
    
headerPanel("单样本t检验"),

  HTML("
    <b> 注 </b>
      <ul>
      <li> X 是独立变量 </li>
      <li> &#956 是来自总体的平均值 </li>
      <li> &#956&#8320 是特定的待比较的平均值 </li>
      </ul>

    <b>前提假设</b>
    
      <ul>
      <li> X 是连续的数值，并且基于正态分布 </li>
      <li> X的每个观测（样本）是独立的和近似正态分布的 </li>
      <li> 数据采集过程随机无更换 </li>
      </ul>
      "),

  hr(),

  source("p1_ui.R", local=TRUE, encoding = "UTF-8")$value


),

##---------- Panel 2 ---------

  tabPanel(
    "两个独立样本",

    headerPanel("两样本t检验"),

    HTML(
    "
    <b> 注 </b>
      <ul>
      <li> 两组独立观测值被指定为X和Y
      <li> &#956&#8321 是X的总体平均，&#956&#8322 是Y的总体平均
      </ul>

    <b> 前提假设 </b>

      <ul>
      <li> 被比较的两个样本的总体遵循正态分布
      <li> X和Y独立地从两个进行比较的总体里分别取样
      <li> 被比较的两个总体有相同的方差            
      </ul>
      "
      ),


    hr(),

    source("p2_ui.R", local=TRUE,encoding = "UTF-8")$value

    ),
  
##---------- Panel 3 ---------

  tabPanel("成对样本",

    headerPanel("成对样本的t检验"),

    HTML("

    <b> 注 </b>
    
      <ul>
      <li> 成对的或者相关联的观测值记为X和Y    
      <li> &#916是X和Y之间的差异的总体平均
      </ul>

    <b> 前提假设 </b>
      
      <ul>
      <li> 被比较的两个对应的样本的差近似地遵循正态分布
      <li> 成对样本的差异是基于正态分布的连续值
      <li> 数据抽样为无替换随机抽样     
      </ul>                                
      "
      ),

helpText("一个典型的成对样本的例子是对某种治疗结果的重复测定，比如对高血压患者的降血压药物治疗前后的血压测定，前后两次的结果组成了两组成对样本"),

   hr(),

   source("p3_ui.R", local=TRUE,encoding = "UTF-8")$value

    ),

##---------- other panels ----------

source("../0tabs/home_cn.R",local=TRUE,encoding = "UTF-8")$value,
source("../0tabs/stop_cn.R",local=TRUE,encoding = "UTF-8")$value

  )
 )
)

