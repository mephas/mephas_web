##---------------------------------
##  Run shiny apps
##----------------------------------##

## hide messages
#sink( tempfile() )
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


