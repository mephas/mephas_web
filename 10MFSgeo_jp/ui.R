library(shiny)
#if (!require("BiocManager")) install.packages("BiocManager", update = F, ask = F)
#if (!require("rhandsontable")) install.packages("rhandsontable", update = F, ask = F)
#if (!require("DT")) install.packages("DT", update = F, ask = F)

#if (!require("GEOquery")) BiocManager::install("GEOquery",update = F,ask = F)
#if (!require("limma")) BiocManager::install("limma",update = F,ask = F)
#if (!require("gplots")) BiocManager::install("gplots",update = F,ask = F)
library(GEOquery)
library(limma)
library(gplots)
library(DT)

#if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
#if (!requireNamespace("mephas.tools",quietly = TRUE)) {remotes::install_github("mephas/mephas.tools", upgrade="never")}; require("mephas.tools",quietly = TRUE)

#if(!require("factoextra")) install.packages("factoextra",update = F,ask = F) #聚类
#if(!require("ggpubr")) install.packages("ggpubr",update = F,ask = F)
library(factoextra)
library(ggplot2)
library("FactoMineR");
library("factoextra");

#绘图用
#火山图
#if(!require("EnhancedVolcano")) BiocManager::install("EnhancedVolcano",update = F,ask = F)
library(EnhancedVolcano)
#热图
#if(!require("tidyverse")) install.packages("tidyverse",update = F,ask = F)
library('tidyverse')
#if(!require("pheatmap")) install.packages("pheatmap",update = F,ask = F)
library("pheatmap")

#if (!require("devtools")) install.packages("devtools",update = F,ask = F)
#if (!requireNamespace("d3heatmap",quietly = TRUE)) devtools::install_github("rstudio/d3heatmap", upgrade="never")
library("d3heatmap")

#if(!require("heatmaply")) install.packages("heatmaply",update = F,ask = F)
library("heatmaply")#好看的heatmaply
##if(!require("shinyHeatmaply")) install.packages("shinyHeatmaply",update = F,ask = F)
#library("shinyHeatmaply")

##if(!require("dplyr")) install.packages("dplyr",update = F,ask = F)
#library("dplyr")
#if(!require("clusterProfiler")) install.packages("clusterProfiler",update = F,ask = F)
#suppressMessages(library(clusterProfiler))


#代码生成
#if(!require("shinyAce")) install.packages("shinyAce",update = F,ask = F)
library(shinyAce)

#生成文字隐藏
#if(!require("shinyjs")) install.packages("shinyjs",update = F,ask = F)
library(shinyjs)
#if(!require("shinydashboard")) install.packages("shinydashboard",update = F,ask = F)
library(shinydashboard)
library(rhandsontable)

#setwd(dirname(rstudioapi::getActiveDocumentContext()$path))#不能有中文路径 用途是切换工作目录到本文件的目录中
source("../tab/tab_jp.R")
source("../tab/panel_jp.R")
source("../tab/func.R")


#shinyUI(
tagList(
  
  includeCSS("../www/style_jp.css"),
  stylink(),
  tabOF(),
  
  navbarPage(
    #theme = shinythemes::shinytheme("cerulean"),
    #title = a("MephasGEO", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
    title ="MephasGEO",
    collapsible = TRUE,
    #id="navbar",
    position="fixed-top",
    
##########----------##########----------##########  
#panel 0 DATA处理
    tabPanel("発現変動遺伝子解析​",
             titlePanel("発現変動遺伝子解析​"),
             
             conditionalPanel(
               condition = "!input.explain_on_off",
               HTML(
               "    
<h4><b>使用できる機能</b></h4>
<p><b>1：GEOデータベースからダウンロードした遺伝子チップの実験データを処理する</b></p>
<ul> 
<li>データ処理：log2変換、データ正則化、プローブおよび遺伝子ID変換</li>
<li>可視化：クラスター分析、PCA分析</li>
</ul>
<p><b>2：LIMMA分析を用いて、異なるグループで発現レベルに有意差がある遺伝子を同定する</b></p>
<ul> 
<li> 遺伝子発現量のボックスプロット、Volcanoプロット、およびヒートマップの作成
</ul>
<p><b>3：変動遺伝子のパスウェイ解析</b></p>
<ul> 
<li> GO解析、KEGG解析</li>
</ul>


<h4><b>注意事項</b></h4>
<p><b>1：現在すべてのGEOデータとGPLプラットフォームデータをサポートしていないので、ご了承ください。</b></p>
<p><b>2：データを再度ダウンロードする前に、ボタンをクリックしてインターフェイスを更新（Refresh）するか、プログラムを再起動してください。</b></p>
<p><b>3：データの前処理が完了する前に、グループ化情報入力インターフェイスをクリックしないでください。 テーブルの表示が不完全な場合は、データを再度ダウンロードしてください。</b></p>

<i><h4>使用例</h4></i>
例として、GSE16020チップを用いて、多形核白血球中常染色体優性単球減少症の影響を研究する。データは対照群と常染色体優性単球減少症群に分けられ、それぞれ12例、8例のデータがある。
RNA抽出法の違いが遺伝子発現に影響を及ぼすとする。ここでは、本ツールを用いて、変動遺伝子を探索する。
<h4><b>手順</b>にしたがって進むと、<b>アウトプット</b>に解析結果がリアルタイムで出力されます。</h4>
    

    ")),
             
             hr(),
             
             source("0_datainput_ui.R", local=TRUE, encoding = "utf-8")$value,
             hr()
    ),

##########----------##########----------##########

tablang("10MFSgeo"),
tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

))


