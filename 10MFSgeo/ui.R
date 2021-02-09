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

source("../tab/tab.R")
source("../tab/panel.R")
source("../tab/func.R")


#shinyUI(
tagList(
  
  includeCSS("../www/style.css"),
  stylink(),
  tabOF(),
  
  navbarPage(
    theme = shinythemes::shinytheme("cerulean"),
    title = a("MephasGEO", href = "https://alain003.phs.osaka-u.ac.jp/mephas/", style = "color:white;"),
    
    #title ="MephasGEO",
    collapsible = TRUE,
    #id="navbar",
    position="fixed-top",
    
    
#panel 0 DATA处理
    tabPanel("Differential Gene Expression Analysis",

             titlePanel("Differential Gene Expression Analysis"),
             
             conditionalPanel(
               condition = "input.explain_on_off",
               HTML(
               "    
<h4><b>Functions</b></h4>
<p><b>1. Download and analyze gene microarray data from GEO database</b></p>
<ul> 
<li>Data preprocess: log2-transformation、normalization、probs and gene-ID transformation
<li>Visaulization: Cluster and PCA
</ul>
<p><b>2. Use LIMMA to find significantly differenttial genes in different expression level groups.</b></p>
<ul> 
<li> Produce boxplot, volcano plot, and heatmap for gene expression level
</ul>
<p><b>3. Pathway analysis</b></p>
<ul> 
<li> GO analysis, KEGG analysis
</ul>


<h4><b>Notice</b></h4>
<p><b>1. Cannot support all the GEO (GLP) data </b></p>
<p><b>2. If you want to download data again, plear click refresh button, or re-start this application </b></p>
<p><b>3. Donnot go to 'Input group' panel before the completion of data preprocess. If the table is uncomplete, please download the data again.</b></p>

<i><h4>Case Example</h4>
To take GSE16020 as example, this data is used to study the effect of autosomal dominant monocytopenia in polymorphonuclear leukocytes. 
According to the condition, they were divided into control group and autosomal dominant monocytopenia group, 12 cases in control group, and 8 cases in autosomal dominant monocytopenia group. Different RNA extraction methods have an impact on gene expression.
We hope to use MephasGEO to find differentially expressed genes.
</h4></i>
<h4> Please follow the <b>Steps</b>, and <b>Outputs</b> will give real-time analytical results </h4>
    

    ")),
             
    hr(),
            
    source("0_datainput_ui.R", local=TRUE,encoding = "utf-8")$value,
    hr(),
    ),

tabstop(),
tablink()
)

#tablang(),

#navbarMenu("",icon=icon("link"))

)



