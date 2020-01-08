#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(dplyr)
library(leaflet.extras)
library(rgeolocate)


# Define UI for application that draws a histogram
ui <- fluidPage(

        # Show a plot of the generated distribution
        
        leafletOutput(outputId = "mymap", height =800), # output the map
        checkboxInput("fakeData", "Fake Data", FALSE)

)


server <- function(input, output) {
    
    
    
    #create the map
    output$mymap <- renderLeaflet({
        leaflet(locationsQ) %>% 
            
            addTiles() %>% 
            addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500),  label = ~org, color = "red")
    })
    
    #Edit de view as we click the checkbox
    proxy <-leafletProxy("mymap", data=locationsQ)
    
    observe({
            proxy %>% clearShapes()
            if(input$fakeData){
                
                proxy <- leafletProxy("mymap", data = locationsIP)
                proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500), group = "markers",  label = ~org, color = "red")
            }
            else{
                
                proxy <- leafletProxy("mymap", data = locationsQ)
                proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500),  label = ~org, color = "red")
            }


        })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
