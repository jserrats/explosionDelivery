function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({

    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(5, 0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
  
  output$vulns <- DT::renderDataTable({
    DT::datatable(DF)
  })
  
  
  #create the map
  output$mymap <- renderLeaflet({
    leaflet(locationsQ) %>% 
      
      addTiles() %>% 
      addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500), color = "red")
    
  })
  
  #Edit de view as we click the checkbox
  proxy <-leafletProxy("mymap", data=locationsQ)
  
  observe({
    proxy %>% clearShapes()
    if(input$fakeData){
      
      proxy <- leafletProxy("mymap", data = locationsIP)
      proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(long), radius = sqrt(500), color = "red")
    }
    else{
      
      proxy <- leafletProxy("mymap", data = locationsQ)
      proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(lon), radius = sqrt(500), color = "red")
    }
    
    #proxy %>% addCircles(lat = ~as.double(lat), lng = ~as.double(long), radius = sqrt(500), color = "red")
    
    
  })
  
  
  output$barPlot <- renderPlot({
    
    
    barplot(table(unlist(DF[[input$param]])),
            main=paste(toupper(substr(input$param, 1, 1)), substr(input$param, 2, nchar(input$param)), sep=""),
            xlab="Parameters",
            col = sample(rainbow(n=30))
    )
    
  })
  
  
  
  
  
  
}