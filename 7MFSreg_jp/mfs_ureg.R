
if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(xtable)) {install.packages("xtable")}; library(xtable)
if (!require(stargazer)) {install.packages("stargazer")}; library(stargazer)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
#if (!require(plotROC)) {install.packages("plotROC")}; library(plotROC)
if (!require(ROCR)) {install.packages("ROCR")}; library(ROCR)
if (!require(survival)) {install.packages("survival")}; library(survival)
if (!require(survminer)) {install.packages("survminer")}; library(survminer)


##' This is the description of this function, 4
##'
##' This is the details of this function, 4
##' @title Tests for cross tab data
##' @return The shiny web page of the tests for cross tab data
##'
##' @import shiny
##' @import ggplot2
##' @import survival
##' @import survminer
##'
##' @importFrom xtable xtable
##' @importFrom stargazer stargazer
##' @importFrom ggfortify autoplot
##' @importFrom 
##' @importFrom ROCR performance prediction

##' @examples
##' mfs_condist()

##' @export
mfs_ureg<- function(){
  
  source("ureg_ui.R", local = TRUE)
  source("ureg_sv.R", local = TRUE)

  app <- shinyApp(ui = ui, server = server)
  runApp(app, launch.browser = TRUE, quiet = TRUE)

}
mfs_ureg()
