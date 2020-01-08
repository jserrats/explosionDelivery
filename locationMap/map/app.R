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
    
    # Pendent d'afegir checkboxes
    #     mainPanel(
    #         leafletOutput(outputId = "mymap"), #this allows me to put the checkmarks ontop of the map to allow people to view earthquake depth or overlay a heatmap
    #         absolutePanel(top = 60, left = 20, 
    #                       checkboxInput("markers", "Depth", FALSE),
    #                       checkboxInput("heat", "Heatmap", FALSE))
    # )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    

    
    #create the map
    output$mymap <- renderLeaflet({
        leaflet(locations) %>% 
            
            addTiles() %>% 
            addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500),  label = ~org, color = "red")
    })
    
    
    #Pendent de checkboxes
    
    #next we use the observe function to make the checkboxes dynamic. If you leave this part out you will see that the checkboxes, when clicked on the first time, display our filters...But if you then uncheck them they stay on. So we need to tell the server to update the map when the checkboxes are unchecked.  observe({
    # proxy <- leafletProxy("mymap", data = data)
    # proxy %>% clearMarkers()
    # 
    # 
    # 
    # 
    # 
    # observe({
    #     proxy <- leafletProxy("mymap", data = data)
    #     proxy %>% clearMarkers()
    #     if (input$heat) {
    #         proxy %>%  addHeatmap(lng=~longitude, lat=~latitude, intensity = ~mag, blur =  10, max = 0.05, radius = 15) 
    #     }
    #     else{
    #         proxy %>% clearHeatmap()
    #     }
    #     
    #     
    # })
}

# Run the application 
shinyApp(ui = ui, server = server)
