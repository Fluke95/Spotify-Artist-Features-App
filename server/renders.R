##  ............................................................................
##  get_track_features                                                       ####
output$scatter_plot <- renderPlotly({
  
  req(input$go_button)
  
  req(fetch_tracks())
  
  req(selected_artists())
  req(input$searchArtistInput)
  req(selected_artists_container())
  req(input$selectedArtistsInput)
  
  data <- fetch_tracks()
  
  p <- ggplot(data = data,
              aes(x = valence, y = energy, color=artist_name, label=name, label2=album_name)) +
    geom_jitter() +
    geom_vline(xintercept = 0.5) +
    geom_hline(yintercept = 0.5) +
    scale_x_continuous(expand = c(0, 0), limits = c(0, 1)) +
    scale_y_continuous(expand = c(0, 0), limits = c(0, 1))
  
  ggplotly(p, tooltip = c("x", "y", "label", "label2"))
  
})
##  ............................................................................
##  get_track_features                                                       ####
output$density_plot <- renderPlotly({
  
  req(input$go_button)
  
  req(fetch_tracks())
  
  req(selected_artists())
  req(input$searchArtistInput)
  req(selected_artists_container())
  req(input$selectedArtistsInput)
  
  data <- fetch_tracks()
  
  p <- ggplot(data, aes(x=danceability, fill=artist_name)) +
    geom_density(alpha=0.4)
  ggplotly(p)
})

##  ............................................................................
##  get_track_features                                                       ####
output$rawStatsTable <- DT::renderDataTable({
  
  req(input$go_button)
  
  req(fetch_tracks())
  
  req(selected_artists())
  req(input$searchArtistInput)
  req(selected_artists_container())
  req(input$selectedArtistsInput)
  
  data <- fetch_tracks()
  
  data %>% 
    dplyr::select(-id, -album_id, -artist_id) %>% 
    DT::datatable(
      # colnames = c("),
      extensions = 'Buttons',
      options = list(
        pageLength = 20,
        lengthMenu = c(10, 20, 50, 100, nrow(data)),
        dom = "Blftipr",
        scrollX = TRUE,
        buttons = c('csv', 'excel')),
      rownames = FALSE,
      class = "cell-border") 
  
})