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
      # colnames = c("Title", "Video ID", "Publication Date", "Thumbnail", "Views", "Likes", "Dislikes", "Comments", "Likes ~ Views Ratio", "Dislikes ~ Views Ratio", "Comments ~ Views Ratio"),
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