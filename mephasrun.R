##---------------------------------
##  Run shiny apps
##----------------------------------##

## hide messages
sink( tempfile() )
## install shiny package if necessary
#if (!require(shiny)) {install.pacakages("shiny")}; library(shiny)

## Run app
#setwd("/Users/yi/Documents/biostatshiny")
#setwd("/home/yi/github/biostatshiny")
setwd("/Users/yi/Documents/mephas_web/")

shiny::runApp("./1MFSdistribution")
shiny::runApp("./1MFSdistribution_cn")
shiny::runApp("./1MFSdistribution_jp")

shiny::runApp("./2MFSttest")
shiny::runApp("./2MFSttest_cn")
shiny::runApp("./2MFSttest_jp")

shiny::runApp("./3MFSnptest")
shiny::runApp("./3MFSnptest_cn")
shiny::runApp("./3MFSnptest_jp")

shiny::runApp("./4MFSproptest")
shiny::runApp("./4MFSproptest_cn")
shiny::runApp("./4MFSproptest_jp")

shiny::runApp("./5MFSrctabtest")
shiny::runApp("./5MFSrctabtest_cn")
shiny::runApp("./5MFSrctabtest_jp")

shiny::runApp("./6MFSanova")
shiny::runApp("./6MFSanova_cn")
shiny::runApp("./6MFSanova_jp")

shiny::runApp("./7MFSreg")
shiny::runApp("./7MFSreg_cn")
shiny::runApp("./7MFSreg_jp")

shiny::runApp("./8MFSpcapls")
shiny::runApp("./8MFSpcapls_cn")
shiny::runApp("./8MFSpcapls_jp")


if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
shiny::runApp("./1anova.csv", launch.browser=TRUE, quiet = TRUE, display.mode="showcase")

if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(Hmisc)) {install.packages("Hmisc")}; library(Hmisc)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(pastecs)) {install.packages("pastecs")}; library(pastecs)
shiny::runApp("./2ttest_en", launch.browser=TRUE, quiet = TRUE)

if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(DescTools)) {install.packages("DescTools")}; library(DescTools)  #SignTest
if (!require(RVAideMemoire)) {install.packages("RVAideMemoire")}; library(RVAideMemoire)  
if (!require(pastecs)) {install.packages("pastecs")}; library(pastecs)
shiny::runApp("./3nptest_en", launch.browser=TRUE, quiet = TRUE)

if (!require(Hmisc)) {install.packages("Hmisc")}; library(Hmisc)
if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(reshape)) {install.packages("reshape")}; library(reshape)
shiny::runApp("./4btest_en", launch.browser=TRUE, quiet = TRUE)

if (!require(gridExtra)) {install.packages("gridExtra")}; library(gridExtra)
if (!require(psych)) {install.packages("psych")}; library(psych)
shiny::runApp("./5crotb_en", launch.browser=TRUE, quiet = TRUE)


if (!require(xtable)) {install.packages("xtable")}; library(xtable)
if (!require(stargazer)) {install.packages("stargazer")}; library(stargazer)
if (!require(ggfortify)) {install.packages("ggfortify")}; library(ggfortify)
if (!require(plotROC)) {install.packages("plotROC")}; library(plotROC)
if (!require(ROCR)) {install.packages("ROCR")}; library(ROCR)
if (!require(survival)) {install.packages("survival")}; library(survival)
if (!require(survminer)) {install.packages("survminer")}; library(survminer)
shiny::runApp("./6unireg_en", launch.browser=TRUE, quiet = TRUE)

shiny::runApp("./7multireg_en", launch.browser=TRUE, quiet = TRUE)

if (!require(shiny)) {install.packages("shiny")}; library(shiny)
if (!require(ggplot2)) {install.packages("ggplot2")}; library(ggplot2)
if (!require(psych)) {install.packages("psych")}; library(psych)
if (!require(Rmisc)) {install.packages("Rmisc")}; library(Rmisc)
shiny::runApp("./8anova",  launch.browser=TRUE, quiet = TRUE)

