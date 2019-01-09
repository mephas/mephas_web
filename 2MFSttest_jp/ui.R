
##----------#----------#----------#----------
##
## 2MFSttest UI
##
## Language: JP
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

shinyUI(

tagList(

navbarPage(
  
  title = "平均値の差の検定",

##---------- Panel 1 ---------

tabPanel( "一群",

headerPanel("一群のt検定"),

  HTML(
    "
    <b>注 </b>

      <ul>
      <li> X は説明変数 
      <li> &#956 は母集団の平均値 
      <li> &#956&#8320 は特定の値 
      </ul>

    <b>前提として </b>

      <ul>
      <li> 母集団は連続した数値で、正規分布に従う 
      <li> それぞれのxは独立しており正規分布に近い 
      <li> データはランダムに抽出されています 
      </ul>                         
    "
    ),

  hr(),

source("p1_ui.R", local=TRUE)$value


),

##---------- Panel 2 ---------

tabPanel("独立二群",

headerPanel("二群のt検定"),

  HTML(
    "
    <b> 注 </b>
      <ul>
      <li> The independent observations are designated X and Y
      <li> &#956&#8321 is the population mean of X; &#956&#8322 is the population mean of Y 
      </ul>

    <b> 前提として </b>

      <ul>
      <li> 比較される2つの集団は、正規分布に従うべきである
      <li> XとYは、比較される2つの集団から独立してサンプリングされるべきである
      <li> 比較される2つの集団は、同じ分散を有するべきである
      </ul>
      "
      ),

    hr(),

source("p2_ui.R", local=TRUE)$value

    ),

##---------- Panel 3 ---------

tabPanel("関連した二群",

    headerPanel("関連した二組のt検定"),

    HTML("

    <b> 注 </b>
    
      <ul>
      <li> The dependent observations are designated X and Y        
      <li> &#916 is the underlying mean differences between X and Y 
      </ul>

    <b> 前提として </b>
      
      <ul>
      <li> The differences of paired samples are approximately normally distributed                           
      <li> The differences of paired samples are numeric and continuous and based on the normal distribution  
      <li> The data collection process was random without replacement                                           
      "
      ),

  helpText("A typical example of the pared sample is that the repeated measurements, where subjects are tested prior to a treatment, say for high blood pressure, and the same subjects are tested again after treatment with a blood-pressure lowering medication"),


   hr(),

   source("p3_ui.R", local=TRUE)$value

    ),

##---------- other panels ----------

source("../0tabs/home_jp.R",local=TRUE)$value,
source("../0tabs/stop_jp.R",local=TRUE)$value

  )
 )
)

