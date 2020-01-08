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
        checkboxInput("fakeData", "Fake Data", FALSE),
        
        
        hr(),
        hr(),
        titlePanel("Parse the XML"),
        hr(),
        selectInput("param","Parameter", choices=colnames(DF)),
        mainPanel(
            width = "100%",
            plotOutput("barPlot")
        )
        
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
               # proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500), group = "markers",  label = ~org, color = "red")
            }
            else{
                
                proxy <- leafletProxy("mymap", data = locationsQ)
                
            }
        
            proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500),  label = ~org, color = "red")
            
            
        })
    

    output$barPlot <- renderPlot({
        
        
        barplot(table(unlist(DF[[input$param]])),
                main=paste(toupper(substr(input$param, 1, 1)), substr(input$param, 2, nchar(input$param)), sep=""),
                xlab="Parameters",
                col = sample(rainbow(n=30))
                )
        
    })
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
