# Server side
library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(plotly)

food2 <- read_csv("food2.csv")
water2 <- read_csv("water2.csv")
fish2 <- read_csv("fish2.csv")
birds2 <- read_csv("birds2.csv")
rice2 <- read_csv("rice2.csv")
View(food2)
shinyServer(function(input, output) {
        output$stapleFoodPlot <- renderPlot({
                if(input$food == "stapleFood"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = food2$Iodine_131,
                                      "Cesium_134" = food2$Cesium_134,
                                      "Cesium_137" = food2$Cesium_137)
                        ggplot(data = food2)+
                                geom_bar(stat="identity",mapping = aes(x= date, y = iso,fill=food_categ,na.rm = TRUE))+
                                labs(list(x= "From 2011", y= "in Becquerels"))+
                                ggtitle(paste("Bar Plot of",input$iso,"in",input$food,"against Time",sep = " "))+
                                theme(plot.title = element_text(size = 20, vjust = 2),panel.background = element_rect(fill = "lightblue"))
                }
                else if(input$food == "water"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = water2$Iodine_131,
                                      "Cesium_134" = water2$Cesium_134,
                                      "Cesium_137" = water2$Cesium_137)
                        ggplot(data = water2)+
                                geom_bar(stat="identity",mapping = aes(x= date, y = iso,na.rm = TRUE))+
                                labs(list(x= "From 2011", y= "in Becquerels"))+
                                ggtitle(paste("Bar Plot of",input$iso,"in",input$food,"against Time",sep = " "))+
                                theme(plot.title = element_text(size = 20, vjust = 2),panel.background = element_rect(fill = "lightblue"))
                }
                else if(input$food == "fish"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = fish2$Iodine_131,
                                      "Cesium_134" = fish2$Cesium_134,
                                      "Cesium_137" = fish2$Cesium_137)
                        ggplot(data = fish2,mapping = aes(x = date, y = iso,na.rm = TRUE))+
                                geom_point(shape = 16)+
                                geom_smooth(se=TRUE)+
                                labs(list(x= "From 2011", y= "in Becquerels"))+
                                ggtitle(paste("Scatter Plot of",input$iso,"in",input$food,"against Time",sep = " "))+
                                theme(plot.title = element_text(size = 20, vjust = 2),panel.background = element_rect(fill = "lightblue"))
                }
                else if(input$food == "birds"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = birds2$Iodine_131,
                                      "Cesium_134" = birds2$Cesium_134,
                                      "Cesium_137" = birds2$Cesium_137)
                        ggplot(data=birds2)+
                                geom_point(mapping = aes(x=date, y = birds2$Cesium_134_Plus_Cesium_137, color= item, na.rm =TRUE))+
                                labs(list(x= "From 2011", y= "in Becquerels"))+
                                ggtitle(paste("Scatter Plot of Cesium_134 Plus Cesium_137 in Birds and Animals against Time",sep = " "))+
                                theme(plot.title = element_text(size = 20, vjust = 2),panel.background = element_rect(fill = "lightblue"))
                                
                }
                else if(input$food == "rice"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = rice2$Iodine_131,
                                      "Cesium_134" = rice2$Cesium_134,
                                      "Cesium_137" = rice2$Cesium_137)
                        ggplot(data=rice2)+
                                geom_point(mapping = aes(x=date, y = rice2$Cesium_134_Plus_Cesium_137, na.rm =TRUE))+
                                labs(list(x= "From 2011", y= "in Becquerels"))+
                                ggtitle(paste("Scatter Plot of Cesium_134 Plus Cesium_137 in Rice against Time",sep = " "))+
                                theme(plot.title = element_text(size = 20, vjust = 2),panel.background = element_rect(fill = "lightblue"))
                                
                }
        })
        output$daichiDistance <- renderPlotly({
                if(input$food == "stapleFood"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = food2$Iodine_131,
                                      "Cesium_134" = food2$Cesium_134,
                                      "Cesium_137" = food2$Cesium_137)
                plot_ly(data = food2, z = log10(iso), x = date, y = log10(Cesium_137), type = "scatter3d",color=food_categ, mode = "markers")%>%
                        layout(title="3D Plot of 2 Isotopes against Time")
                }
                else if (input$food == "fish"){
                        iso <- switch(input$iso,
                                      "Iodine_131" = fish2$Iodine_131,
                                      "Cesium_134" = fish2$Cesium_134,
                                      "Cesium_137" = fish2$Cesium_137)
                        plot_ly(data = food2, z = iso, x = fish2$daichi_distance, y = Cesium_137, type = "scatter3d", mode = "markers")%>%
                                layout(title="3D Plot of Distance to Daichi and 2 Isotopes")
                        plot_ly(type = 'scattergeo',lon = fish2$lng,lat = fish2$lat,mode = 'markers')%>%
                                layout(title="Location of Where Fish were surveyed")
                }
                else if (input$food == "water"){
                        plotly_empty() %>%
                                layout(title="No 3D or Geographical data available for Water")
                }
                else if (input$food == "birds"){
                        plotly_empty() %>%
                                layout(title="No 3D or Geographical data available for Birds and Animals")
                }
                else if (input$food == "rice"){
                        plotly_empty() %>%
                                layout(title="No 3D or Geographical data available for Rice")
                }
        })
        output$contents <- renderTable({
                inFile <- input$file1
                if (is.null(inFile))
                        return(NULL)
                user_data <- read.csv(inFile$datapath)
                paste("Summary of Your Input data")
                summary(user_data)
        })
})


