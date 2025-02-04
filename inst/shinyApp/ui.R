library(shiny)
library(plotly)

options(width = 300)

shinyUI(
  navbarPage('scPower',
    tabPanel("Description",
            includeHTML("introduction.html")),
    tabPanel("Power to detect DE/eQTL genes",
     sidebarLayout(
       sidebarPanel(
         tags$head(
           tags$style(type="text/css","label{ display: table-cell; text-align: left;vertical-align: middle; } .form-group { display: table-row;}")),
         h4("Study parameters"),
         actionButton("recalc", "Calculate"),
         h4("General parameters"),
         radioButtons("study", label = "Study type",
                      choices = list("DE study" = "de", "eQTL study" = "eqtl"),
                      selected = "de"),
         selectInput("celltype", label = "Cell type",
                     choices = list()),
         numericInput("ct.freq", label = "Cell type frequency",
                      value = 0.25,step=0.05,min=0,max=1),
         selectInput("ref.study", label = "Reference study",
                     choices = list(),
                     selected = "Blueprint (Monocytes)"),
         numericInput("budget", label = "Total budget", value = 50000, step=500,min=0),
         selectInput("grid", label = "Parameter grid",
                     choices = list("samples - cells"="sc",
                                    "samples - reads"="sr",
                                    "cells - reads"="cr")),
         numericInput("rangeX_min",label="Samples (min)",value=10),
         numericInput("rangeX_max",label="Samples (max)",value=50),
         numericInput("rangeY_min",label="Cells (min)",value=2000),
         numericInput("rangeY_max",label="Cells (max)",value=10000),
         numericInput("steps","Steps",value=5,min=0,step=1),
         hr(),
         h4("Cost and experimental parameters"),
         numericInput("costKit", label = "Cost 10X kit",
                      value = 5600, step=100,min=0),
         numericInput("costFlowCell", label = "Cost flow cell",
                      value = 14032, step=100,min=0),
         numericInput("readsPerFlowcell", label = "Number reads per flow cell",
                      value = 4100*10^6, step=10000,min=0),
         numericInput("cellsLane", label = "Cells per lane", value = 20000,
                      step=500,min=0),
         hr(),
         h4("Multiple testing correction"),
         numericInput("pval",label="P-value",
                      value=0.05,step=0.01,min=0,max=1),
         selectInput("MTmethod", label = "Multiple testing method",
                     choices = list("FWER"="Bonferroni",
                                    "FDR"="FDR",
                                    "none"="none"),
                     selected="FDR"),
         hr(),
         h4("Mapping and Multiplet estimation"),
         numericInput("map.eff", label = "Mapping efficiency",
                      value = 0.8,step=0.05,min=0,max=1),
         numericInput("multipletRate", label = "Multiplet rate",
                      value = 7.67e-06,step=1e-6,min=0),
         numericInput("multipletFactor", label = "Multiplet factor",
                      value = 1.82, step=0.1,min=1),
         hr(),
         h4("Expression cutoffs"),
         numericInput("minUMI", label = "Minimal number of UMI per gene",
                      value = 3, step=1,min=1),
         numericInput("percIndiv", label = "Fraction of individuals",
                      value = 0.5,step=0.05,min=0,max=1),
         hr(),
         h4("Special parameters"),
         checkboxInput("speedCalc", "Skip power for lowly expressed genes", value = FALSE),
         checkboxInput("simPower", "Use simulated power for eQTLs",value=FALSE),
         width = 4
       ),
       mainPanel(
         h4("Parameter grid with detection power"),
         plotlyOutput("powerPlot"),
         br(),
         div(paste0("The figure represents the detection power that can be gained with each parameter combination of ",
                    "cells per individual and read depth. ",
                    "The third parameter, the sample size, is defined uniquely by the other two parameters and the ",
                    "overall experimental budget.")),
         br(),
         div(paste0("To update the plots with the currently set parameter combinitons on the left,",
                    "please click the Calculate button.",
                    "The calculation for a specific parameter combination can take ",
                    "up to 1-2 minutes.")),
         br(),
         div("Click on a specific point in the plot to visualize the exact trace in the plots below"),
         br(),
         h4("Influence of parameters on power"),
         plotlyOutput("readPlot"),
         br(),
         div(paste("The figure depicts the influence of the individual parameters on the",
                   "overall detection power as well as the expression probability (probability that",
                   "the DE/eQTL genes are detected) and the DE/eQTL power (probability that",
                   "the DE/eQTL genes are found significant). The plot on the left depicts",
                   "the influence of the parameter on the y axis, while the parameter",
                   "on the x axis is kept constant (taking the value of the selected study).",
                   "The plots on the right shows the same for the parameter on the x axis.",
                   "The selected study is visualized by a horizontal bar."))
          )
       )
    ),
    tabPanel("Power to detect cell types",
             sidebarLayout(
               sidebarPanel(

                 h4("Study parameters"),
                 numericInput("numSamples", label = "Samples", value = 50, step=10,min=0),
                 numericInput("ctFreq", label = "Cell type frequency",
                              value = 0.1,step=0.05,min=0,max=1),
                 numericInput("probCT", label = "Detection power",
                              value = 0.95,step=0.05),
                 sliderInput("cellsCT", label = "Minimal number of cells", min = 1,
                             max = 100, value = c(10, 50)),
                 hr(),
                 width = 4
               ),
               mainPanel(
                 h4("Required cells per person to detect rare cell types with a certain power"),
                 plotlyOutput("freqPlot"),
                 br(),
                 div("The figure shows the required number of cells per individual (y-axis, log scale)
                     to detect the minimal number of cells from a target cell type per individuum (x-axis) with a certain
                     probability. The power depends on the total number of individuals and the frequency of the
                     target cell type. Note that the required number of cells per sample only counts
                     correctly measured cells (no doublets etc), so the number is a lower bound for the required cells to be sequenced.
                     ")
                 )
              )
          ),
    hr(),
    p(a("Contact",href="https://www.helmholtz-muenchen.de/ueber-uns/service/kontakt/index.html"),
      ", ",
      a("Imprint",href="https://www.helmholtz-muenchen.de/impressum/index.html"),
      ", ",
      a("Privacy statement",href="https://www.helmholtz-muenchen.de/en/data-protection-statement/index.html"))
  )
)
