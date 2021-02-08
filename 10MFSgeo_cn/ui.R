library(shiny)
if (!require("BiocManager")) install.packages("BiocManager", update = F, ask = F)
if (!require("rhandsontable")) install.packages("rhandsontable", update = F, ask = F)
if (!require("DT")) install.packages("DT", update = F, ask = F)

if (!require("GEOquery")) BiocManager::install("GEOquery",update = F,ask = F)
if (!require("limma")) BiocManager::install("limma",update = F,ask = F)
if (!require("gplots")) BiocManager::install("gplots",update = F,ask = F)
library(GEOquery)
library(limma)
library(gplots)
library(DT)

if (!requireNamespace("shiny", quietly = TRUE)) {install.packages("shiny")}; require("shiny",quietly = TRUE)
if (!requireNamespace("mephas.tools",quietly = TRUE)) {remotes::install_github("mephas/mephas.tools", upgrade="never")}; require("mephas.tools",quietly = TRUE)

if(!require("factoextra")) install.packages("factoextra",update = F,ask = F) #聚类
if(!require("ggpubr")) install.packages("ggpubr",update = F,ask = F)
library(factoextra)
library(ggplot2)
library("FactoMineR");
library("factoextra");

#绘图用
#火山图
if(!require("EnhancedVolcano")) BiocManager::install("EnhancedVolcano",update = F,ask = F)
library(EnhancedVolcano)
#热图
if(!require("tidyverse")) install.packages("tidyverse",update = F,ask = F)
library('tidyverse')
if(!require("pheatmap")) install.packages("pheatmap",update = F,ask = F)
library("pheatmap")

if (!require("devtools")) install.packages("devtools",update = F,ask = F)
if (!requireNamespace("d3heatmap",quietly = TRUE)) devtools::install_github("rstudio/d3heatmap", upgrade="never")
library("d3heatmap")

if(!require("heatmaply")) install.packages("heatmaply",update = F,ask = F)
library("heatmaply")#好看的heatmaply
#if(!require("shinyHeatmaply")) install.packages("shinyHeatmaply",update = F,ask = F)
#library("shinyHeatmaply")

#if(!require("dplyr")) install.packages("dplyr",update = F,ask = F)
#library("dplyr")
if(!require("clusterProfiler")) install.packages("clusterProfiler",update = F,ask = F)
suppressMessages(library(clusterProfiler))


#代码生成
if(!require("shinyAce")) install.packages("shinyAce",update = F,ask = F)
library(shinyAce)

#生成文字隐藏
if(!require("shinyjs")) install.packages("shinyjs",update = F,ask = F)
library(shinyjs)
if(!require("shinydashboard")) install.packages("shinydashboard",update = F,ask = F)
library(shinydashboard)





shinyUI(
  tagList(
  
  includeCSS("../www/style.css"),
  stylink(),
  tabOF(),
  
  navbarPage(
    theme = shinythemes::shinytheme("cerulean"),
    #title = a("Cluster analysis", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
    
    title ="MephasGEO",
    collapsible = TRUE,
    #id="navbar",
    position="fixed-top",
    
    
#panel 0 DATA处理
    tabPanel("Data1",
             titlePanel("差异基因分析"),
             
             conditionalPanel(
               condition = "!input.explain_on_off",
               HTML(
               "    
<h4><b>功能</b></h4>
<p><b>1：对从GEO数据库中下载的基因芯片实验数据进行处理</b></p>
<ul> 
<li>数据处理：log2转换、数据正则化、探针与基因ID的转换
<li>可视化：聚类分析、PCA分析
</ul>
<p><b>2：使用LIMMA分析，确定在不同分组中表达量具有显著差异的基因</b></p>
<ul> 
<li> 生成单基因表达值箱线图、火山图、热图
</ul>
<p><b>3：对差异基因进行通道分析</b></p>
<ul> 
<li> 生成GO分析、KEGG分析
</ul>


<h4><b>注意</b></h4>
<p><b>1：暂时无法支持全部GEO数据与GPL平台数据，敬请谅解。</b></p>
<p><b>2：请在重新下载数据前点击按钮刷新界面，或重新启动程序。</b></p>
<p><b>3：请不要在数据预处理完成前点击分组信息输入界面。若出现表格显示不全的状况，请重新下载数据。</b></p>

<i><h4>示范例子</h4>
以GSE16020芯片为例，研究多形核白细胞中常染色体显性单核细胞减少症的影响。根据病情分为对照组和常染色体显性单核细胞减少症组，对照组12例，常染色体显性单核细胞减少症组8例，不同的RNA提取方法对基因的表达量有影响。
我们希望通过MephasGEO，来寻找差异表达的基因。
</h4></i>
<h4> 请遵照 <b>步骤</b>执行， 程序将会实时性地返回<b>结果</b> </h4>
    

    "
             )
             ),
             
             hr(),
            
             source("0_datainput_ui.R", local=TRUE,encoding = "utf-8")$value)




  ),

tabstop(),
tablink()
#navbarMenu("",icon=icon("link"))

))



