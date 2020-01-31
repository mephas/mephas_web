##----------#----------#----------#----------
##
## ONOFF tab
##
## Language: EN
## 
## DT: 2019-01-09
##
##----------#----------#----------#----------

tabPanel(switchInput(
   inputId = "explain_on_off",
   label = "<i class=\"fa fa-book\"></i>", # Explanation in Details
    #labelWidth = "250px",
    inline = TRUE,
#handleWidth = "100px",
    size = "mini"
),

value = "help",
HTML('

<h1>How to install the pacakge Mephas</h1>
<h2>Preparation</h2>
<p>Installation of Mephas needs newest R(3.6.2), Rstudio and devtools packages.
<br>Install them into your PC.</p>
<p>> <code>install.packages("devtools")</code></p>
<p>This takes about <span style="color:#ff0000;">30 min</span> in our test computer. Take a cup of coffee.</p>
<video src="install_devtools.mp4" width="500" height="300" controls>See videos</video>
<h2>Installation</h2>
<p>> <code>devtools::install_github("mephas/mephas")</code></p>
<p>This takes about 3 min in our test computer.</p>
<video src="install_mephas.mp4" width="500" height="300" controls>See videos</video>
<h2>See helps and test run</h2>
<p>> <code>devtools::install_github("mephas/mephas")</code></p>
<p>This takes about 3 min in our test computer.</p>
<p>e.g. run ttest modules<br><br></p>
<p>> <code>library("mephas")</code><br></p>
<p>> <code>mephasOpen("ttest")</code><br><br></p>
<video src="read_helps_and_run_modules.mp4" width="500" height="300" controls>See videos</video>
	')
)

#tabPanel("",icon = icon("fa-book"),value = "hint")


