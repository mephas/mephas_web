#****************************************************************************************************************************************************3.1. 2-np-way

sidebarLayout(

sidebarPanel(

  h4(tags$b("Step 1. Data Preparation")), 

  p(tags$b("1. Give names to your Values and Factor Group ")),

  tags$textarea(id = "cnnp2", rows = 2, "FEF\nSmoke"),p(br()),

  p(tags$b("2. Input data")),

tabsetPanel(
      ##-------input data-------##
    tabPanel("Manual Input", p(br()),
    conditionalPanel(
    condition = "input.explain_on_off",
    p(tags$i("Example here was the FEF data from smokers and smoking groups. Detailed information can be found in the Output 1."))
    ),

    p(tags$b("Please follow the example to input your data")),
  p("Data point can be separated by , ; /Enter /Tab"),
    p(tags$b("Sample Values")),
      tags$textarea(id = "xnp2",rows = 10,
"4.21\n3.35\n3.72\n3.76\n3.67\n3.77\n2.69\n4.31\n2.87\n4.11\n3.47\n2.8\n4.14\n2.67\n5.31\n4.23\n4.52\n2.56\n4.26\n3.03\n4.85\n3.57\n1.38\n3.59\n3.56\n4.72\n3.82\n4.04\n4.2\n4.27\n3.84\n3.57\n3.05\n3.87\n2.09\n3.53\n3.19\n3.05\n4.38\n4.06\n3.12\n3.43\n3.25\n3.15\n5.05\n3.79\n2.92\n4.8\n3.67\n1.97\n3.71\n3.94\n4.75\n3.78\n2.76\n3.47\n5.15\n4.59\n3.36\n4.45\n4.43\n2.72\n4.6\n2.89\n4.33\n4.07\n4.29\n3.43\n3.1\n4.46\n3.38\n3.18\n6.47\n3.42\n5.15\n3.21\n4.2\n3.72\n2.56\n4\n5.27\n4.45\n4.04\n3.8\n2.98\n4.11\n3.17\n4.51\n4.02\n5.33\n3.04\n4.11\n3.35\n4.47\n4.69\n3.79\n3.05\n3.38\n4.75\n4.74\n2.44\n3.85\n4.38\n5.65\n3.75\n3.83\n3.9\n3.36\n2.34\n4.25\n3.85\n3.47\n2.5\n3.76\n4.1\n4.18\n5.03\n4.61\n2.95\n3.16\n4.15\n4.22\n3.24\n1.57\n2.92\n3.26\n3.01\n4.11\n3.06\n3.43\n3.15\n2.98\n4.58\n3.27\n3.81\n3.93\n4.14\n4.02\n4.01\n4.3\n3.52\n4.96\n3.92\n3.93\n3.56\n4.39\n3.51\n3.77\n3.67\n3.74\n4.83\n4.56\n5.1\n2.11\n3.89\n3.64\n4.02\n4.68\n3.88\n3.4\n2.99\n5.19\n3.09\n3.01\n2.83\n3.49\n3.79\n4.82\n4.17\n2.83\n3.09\n3.87\n4.98\n4.08\n4.8\n5.8\n2.99\n4.41\n2.96\n4.86\n3.6\n3.57\n4.08\n4.55\n5.58\n4.2\n4.17\n3.9\n3.85\n2.53\n2.57\n5.14\n3.94\n4.76\n3.97\n4.58\n4.79\n4.01\n1.88\n5.57\n2.83\n2.94\n2.16\n3.07\n3.54\n3.1\n2.25\n3.6\n3.71\n4.95\n3.46\n2.32\n2.9\n3.24\n3.79\n3.93\n2.61\n2.99\n3.93\n2.3\n3.97\n3.83\n2.64\n3.8\n4.38\n4.07\n0.96\n3.11\n4.73\n2.01\n2.82\n3.5\n3.28\n3.16\n3.12\n5.4\n1.15\n4.57\n5.31\n2.84\n3.62\n3.72\n1.67\n3.21\n3.09\n3.46\n5.12\n4.54\n4.57\n5\n2.96\n3.73\n4.21\n2.58\n3.28\n3.12\n2.36\n3.73\n3.85\n2.71\n3.63\n3.53\n2.55\n2.81\n4.01\n2.46\n3.65\n3.13\n4.32\n3.52\n2.61\n3.29\n3.63\n3.39\n2.02\n3.2\n2.61\n3.99\n4.34\n2.51\n3.7\n3.56\n3.1\n3.64\n4.35\n2.67\n3.45\n4.41\n2.53\n3.77\n3.49\n2.76\n2.1\n2.72\n4.49\n3.25\n2.56\n3.59\n1.74\n3.49\n3.32\n2.58\n3.31\n2.36\n3.83\n3.65\n3.74\n3.27\n3.68\n2.7\n4.52\n1.89\n3.55\n3.08\n3.99\n2.81\n3.41\n2.03\n1.77\n2.9\n1.79\n3.53\n3.77\n3.88\n3.28\n3.85\n4.13\n3.2\n3.86\n3.46\n4.06\n2.13\n3.29\n2.85\n3.46\n3.65\n3.81\n2.89\n3.32\n3.73\n3.62\n3.57\n2.71\n2.91\n1.92\n3.07\n2.95\n4.01\n2.22\n4.27\n3.12\n2.6\n4.41\n3.29\n2.89\n3.92\n3.04\n2.19\n4.73\n3.34\n3.34\n2.3\n2.47\n3.28\n2.75\n4.09\n4.13\n3.73\n4.52\n3.5\n4.27\n4.19\n4.59\n3.78\n2.4\n3.92\n4.23\n2.88\n4.21\n2.87\n3.85\n4.9\n3.24\n2.38\n1.29\n3.62\n3.4\n3.68\n3.47\n3.34\n3.25\n2.74\n4.46\n3.07\n3.96\n2.99\n2.75\n1.66\n3.72\n3.47\n3.45\n4.39\n3.75\n3.05\n2.85\n3.63\n4.25\n4.04\n3.09\n2.59\n2.96\n3.55\n3.59\n4.15\n2.87\n3.32\n4.14\n3.94\n2.87\n3.02\n2.29\n3.76\n3.35\n3.92\n4.04\n2.76\n3.98\n4.35\n1.45\n3.19\n3.53\n3.14\n3.58\n3.51\n2.75\n2.49\n2.21\n3.91\n5.21\n3.23\n2.83\n2.57\n4.27\n2.53\n4.37\n2.33\n2.63\n2.2\n2.85\n4.06\n3.83\n2.45\n3.5\n2.89\n3.38\n3.17\n4.33\n3.75\n3.64\n4.53\n2.95\n2.11\n4.51\n1.73\n3.47\n3.88\n2.09\n3.15\n4.11\n2.76\n2.88\n3.15\n2.97\n3.43\n3.8\n1.92\n2.64\n3.25\n1.72\n3.49\n2.94\n3.8\n2.58\n2.86\n1.35\n3.55\n2.31\n3.34\n2.48\n2.84\n3.62\n4.03\n2.62\n3.7\n2.29\n2.01\n3.48\n3.65\n3.47\n2.7\n3.31\n3.9\n2.93\n2.78\n2.52\n2.68\n3.49\n4.42\n2.66\n4.97\n3.6\n4.49\n3.41\n2.63\n3.39\n4.09\n3.02\n2.1\n3.42\n3.73\n2.68\n2.75\n3.34\n3.75\n3.67\n4.24\n1.72\n1.45\n2.27\n3.39\n3.93\n3.66\n1.57\n3.44\n3.14\n2.81\n2.99\n3.2\n3.77\n2.37\n4.93\n2.99\n3.54\n2.92\n4.66\n1.65\n2.01\n4.41\n2.44\n4.08\n2.1\n4.2\n2.89\n3.24\n3.33\n2.91\n3.67\n4.48\n2.45\n3.63\n3.51\n3.38\n4.03\n2.49\n3.6\n3.16\n2.35\n3.05\n3.2\n2.45\n3.29\n4.47\n3.56\n3.47\n3.32\n2.2\n2.52\n2.8\n2.62\n3.51\n2.98\n3.58\n3.38\n3.86\n2.33\n2.45\n4.22\n3.41\n2.12\n2.73\n3.25\n4.51\n5.21\n3.25\n3.36\n2.69\n4.68\n3.54\n2.58\n2\n3.63\n2.1\n2.33\n2.1\n2.91\n4.58\n2.81\n4.07\n2.9\n4.02\n2.41\n3.55\n3.85\n4.38\n3.35\n3.23\n3.63\n2.6\n3.63\n2.81\n3.78\n4.9\n3.78\n5.1\n2.87\n3.01\n2.52\n3.03\n2.18\n2.64\n3.18\n3.3\n2.91\n3.28\n2.6\n3.16\n3.44\n2.21\n4.08\n4.03\n2.76\n3.3\n4.38\n5.06\n1.66\n2.74\n3.58\n2.92\n3.24\n3.06\n1.77\n2.64\n2.27\n0.56\n2.57\n3.29\n4.03\n3.71\n3.33\n2.93\n3.58\n4.18\n3.85\n3.26\n4.27\n2.94\n1.82\n1.83\n2.23\n1.49\n3.61\n2.61\n2.94\n3.39\n0.89\n1.89\n1.97\n3.63\n3.23\n4.36\n1.23\n2.87\n2.46\n2.87\n2.49\n3.05\n2.57\n2.2\n2.7\n3.75\n3.46\n2.18\n1.48\n3.19\n1.77\n2.42\n1.66\n2.49\n2.52\n1.97\n3.63\n2.11\n3.14\n4.36\n4.38\n3.57\n2.82\n3.05\n2.77\n2.09\n2.3\n3.95\n3.16\n2.94\n4.27\n3.29\n2.48\n2.35\n2.88\n3.24\n1.94\n0.75\n2.8\n3.58\n2.71\n2.69\n2.54\n3.58\n2.71\n3.26\n3.74\n3.5\n2.76\n3.36\n3.23\n2.39\n3.1\n2.76\n3.05\n2.88\n3.14\n2.6\n2.78\n2.42\n2.91\n3.23\n2.63\n1.67\n3.17\n2.33\n3.13\n3.98\n3\n3.23\n3.89\n3.07\n2.45\n1.55\n2.45\n3.18\n4.2\n3.09\n2.97\n2.83\n3.85\n3.41\n2.47\n3.93\n2.9\n1.49\n4.13\n3.5\n1.84\n2.18\n2.35\n2.4\n3.39\n2.69\n3.07\n3.78\n2.14\n2.23\n4.48\n2.95\n3.67\n2.14\n2.39\n3.29\n2.57\n2.39\n2.86\n2.71\n2.85\n2.02\n2.16\n3.97\n2.75\n3.97\n3.77\n1.58\n3.51\n2.59\n2.72\n1.91\n3.49\n3.73\n4.47\n4.12\n1.68\n2.72\n2.3\n2.84\n3.4\n1.53\n2.91\n4.51\n1.66\n3.17\n3.13\n1.91\n2.82\n3.3\n2.49\n2.59\n3.63\n2.41\n3.19\n2.64\n2.7\n2.2\n3.31\n1.54\n3.72\n2.3\n2.35\n2.75\n3.44\n2.87\n3.58\n3.05\n2.75\n4.5\n2.78\n3.1\n3.31\n2.03\n1.78\n1.45\n2.19\n3.14\n4.03\n2.86\n2.38\n1.02\n1.25\n4.52\n3.43\n3.47\n3.1\n2.87\n2.78\n1.37\n2.06\n1.68\n2.93\n2.8\n2.48\n2.67\n3.11\n2.76\n1.43\n3.08\n1.85\n1.89\n2.79\n2.43\n2.95\n1.84\n2.8\n2.57\n1.76\n1.92\n0.73\n2.21\n3.24\n1.54\n2.89\n2.1\n3.37\n2.8\n2.66\n0.99\n1.36\n1.92\n2.63\n3.56\n1.82\n3.74\n2.85\n1.54\n3.65\n2.29\n3\n3.22\n2.46\n3.49\n3.56\n4.81\n1.91\n3.94\n2.75\n1.63\n2.55\n2.96\n2.43\n4.3\n3.06\n3.39\n3.47\n1.49\n3.35\n3.69\n3.71\n2.82\n1.83\n1.05\n1.67\n2.13\n3.85\n4.45\n1.53\n2.49\n2.33\n1.86\n2.89\n1.77\n2.75\n3.22\n1.82\n3.13\n2.49\n3.36\n2.35\n2.31\n0.88\n2.63\n3.45\n2.15\n2.95\n3.06\n2.86\n1.69\n3.02\n3.79\n1.3\n2.33\n2.48\n1.63\n3.17\n4.32\n2.2\n1.22\n2.01\n0.85\n2.36\n2.85\n3.8\n1.12\n2.63\n2.51\n2.64\n1.62\n3.5\n2.1\n2.6\n2.6\n3\n1.22\n2.85\n1.6\n0.34\n1.97\n4.56\n2.76\n2.24\n2.83\n2.29\n2.92\n2.03\n2.05\n3.02\n1.65\n2.08\n2.69\n2.51\n2.55\n3.25\n2.42\n2.88\n3.67\n2.22\n2.19\n2.86\n2.25\n0.88\n1.54\n3.17\n3.21\n2.58\n3.21\n2.88\n2.51\n0.04\n2.11\n2.2\n3.88\n3.48\n2.15\n2.3\n3.23\n1.16\n2.04\n1.87\n3.04\n2.84\n2.87\n2.35\n2.68\n3.31\n2.09\n2.48\n3.06\n3.77\n1.94\n4.55\n2.97\n2.11\n4.1\n2.89\n3.22\n2.14\n2.24\n2.98\n2.13\n1.65\n1.67\n0.15\n3.27\n1.59\n2.46"
),
    p(tags$b("Factor group")),
      tags$textarea(id = "fnp2",rows = 10,

"NS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nNS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nPS\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nNI\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nLS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nMS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS\nHS"
),

    p("Missing value is input as NA to ensure 2 sets have equal length; otherwise, there will be error")

        ),
      ##-------csv file-------##
tabPanel("Upload Data", p(br()),

    p(tags$b("This only reads 2 columns from your data file")),
    p(tags$b("1st column is numeric values")),
    p(tags$b("2nd and 3rd columns are factors" )),
    fileInput('filenp2', "1. Choose CSV/TXT file",
              accept = c("text/csv","text/comma-separated-values,text/plain",".csv")),
    #helpText("The columns of X are not suggested greater than 500"),
    p(tags$b("2. Use 1st row as column names?")),
    checkboxInput("headernp2", "Yes", TRUE),
    p(tags$b("3. Use 1st column as row names? (No duplicates)")),
    checkboxInput("colnp2", "Yes", TRUE),

    radioButtons("sepnp2", 
      "Which Separator for Data?",
      choiceNames = list(
        HTML("Comma (,): CSV often use this"),
        HTML("One Tab (->|): TXT often use this"),
        HTML("Semicolon (;)"),
        HTML("One Space (_)")
        ),
          choiceValues = list(",", "\t", ";", " ")
      ),

    p("Correct Separator ensures data input successfully"),

    a(tags$i("Find some example data here"),href = "https://github.com/mephas/datasets")
    )
),
hr(),
  h4(tags$b("Hypothesis")),
  p(tags$b("Null hypothesis")),
  p("The means from each group are equal"),
  p(tags$b("Alternative hypothesis")),
  p("At least two factor groups have significant different means"),
  conditionalPanel(
    condition = "input.explain_on_off",
  p(tags$i("In this example, we wanted to know if the FEF values were different among the 6 smoking groups"))
  ),
  hr(),
  h4(tags$b("Step 2. Choose Multiple Comparison Methods")),
  radioButtons("methodnp2", 
  "Which method do you want to use? See explanations below",
  choiceNames = list(
    HTML("Bonferroni's"),
    HTML("Sidak's"),
    HTML("Holm's"),
    HTML("Holm-Šidak"),
    HTML("Hochberg's "),
    HTML("Benjamini-Hochberg"),
    HTML("Benjamini-Yekutieli")
    ),
  choiceValues = list("bonferroni", "sidak", "holm", "hs", "hochberg", "bh", "by")
  ),
  HTML(
  "<b> Explanations </b>

    <li> <b>Bonferroni</b> adjusted p-values = max(1, pm); m= k(k-1)/2 multiple pairwise comparisons
    <li> <b>Sidak</b> adjusted p-values = max(1, 1 - (1 - p)^m)
    <li> <b>Holm's</b>  adjusted p-values = max[1, p(m+1-i)]; i is ordering index
    <li> <b>Holm-Sidak</b> adjusted p-values = max[1, 1 - (1 - p)^(m+1-i)]
    <li> <b>Hochberg's</b> adjusted p-values = max[1, p*i]
    <li> <b>Benjamini-Hochberg</b> adjusted p-values = max[1, pm/(m+1-i)]
    <li> <b>Benjamini-Yekutieli</b> adjusted p-values = max[1, pmC/(m+1-i)]; C = 1 + 1/2 + ... + 1/m

  "
    )


),

mainPanel(

  h4(tags$b("Output 1. Descriptive Results")),

    tabsetPanel(

    tabPanel("Data Preview", p(br()),
    DT::DTOutput("tablenp2"),
    p(tags$b("1. The categories in the Factor Group")),
    DT::DTOutput("level.tnp2")
        ),

    tabPanel("Descriptive Statistics", p(br()),
      p(tags$b("Descriptive statistics by group")),
      DT::DTOutput("basnp2.t")
      ),

    tabPanel("Box-Plot",p(br()),

      plotly::plotlyOutput("mmeannp2", width = "80%")
      )
    ),

    hr(),

  h4(tags$b("Output 2. Test Results")), p(br()),

  p(tags$b("Reject Null Hypothesis if p <= 0.025")),

  DT::DTOutput("dunntest.t"),p(br()),
      conditionalPanel(
    condition = "input.explain_on_off",
  
    p(tags$i("In this example, smoking groups showed significant, so we could conclude that FEF were not significantly different in LS-NI, LS-PS, and NI-PS groups. For other groups, P <0.025. "))#,
    )

  #downloadButton("downloadnp2.2", "Download Results")


  )
)