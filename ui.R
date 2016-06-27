library(shiny)
library(plotly)
shinyUI(fluidPage(
        #Application title
        titlePanel("Trend of Fukushima Daichi Radiations"),
       helpText("Data Source:",a("JAEA",href="http://emdb.jaea.go.jp/emdb/en/portals/b224/")),
        # Sidebar 
        sidebarLayout(
                sidebarPanel(
                        helpText("Daichi's major contaminants were isotopes of volatile
                                 elements: Iodine-131 (8 day half-life), 
                                 Cesium-134 (2 year half-life), 
                                 and Cesium-137 (30 year half-life)"),
                        selectInput("food", "Select Food",
                                    c("Staple Foods" = "stapleFood",
                                      "Water" = "water",
                                      "Fish" = "fish",
                                      "Birds and Animals" = "birds",
                                      "Rice" = "rice")),
                        selectInput("iso", "Select Isotope Type",
                                    c("Iodine-131" = "Iodine_131",
                                      "Cesium-134" = "Cesium_134",
                                      "Cesium-137" = "Cesium_137")),
                        submitButton("Create Plot"),
                        hr(),
                        helpText("Upload your data for comparison: a csv file with column names:
                                date,daichi_distance,Iodine_131, 
                                 Cesium_134,Cesium_137,lat and lng."),
                        fileInput('file1', 'Choose CSV File',accept='.csv'),
                        submitButton("Analyze your Data")
                ),
                # Generated distribution plots
                mainPanel(
                        plotOutput("stapleFoodPlot"),
                        hr(),
                        plotlyOutput("daichiDistance"),
                        tableOutput('contents')
                )
        )
))
