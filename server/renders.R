##  ............................................................................
##  get_track_features                                                       ####
output$scatter_plot <- renderPlotly({
  
  req(input$go_button)
  
  validate(
    need(!results_searchFilter(), " ")
  )
  
  req(fetch_tracks())
  
  validate(
    need(nrow(fetch_tracks()) > 0, "No data for provided artists")
  )
  
  data <- fetch_tracks()
  data <- data %>% 
    dplyr::rename(Artist = artist_name,
                  Album = album_name,
                  Name = name)
  p <- ggplot(data = data,
              aes(x = !!as.name(input$scatter_horizontal),
                  y = !!as.name(input$scatter_vertical),
                  color=Artist, label=Name, label2=Album)) +
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
  
  validate(
    need(!results_searchFilter(), " ")
  )
  
  req(fetch_tracks())
  
  validate(
    need(nrow(fetch_tracks()) > 0, "No data for provided artists")
  )
  
  data <- fetch_tracks()
  data <- data %>% 
    dplyr::rename(Artist = artist_name)
  p <- ggplot(data, aes(x=!!as.name(input$density_horizontal),
                        fill=Artist)) +
    geom_density(alpha=0.4)
  ggplotly(p)
})

##  ............................................................................
##  get_track_features                                                       ####
output$rawStatsTable <- reactable::renderReactable({
  
  req(input$go_button)
  
  validate(
    need(!results_searchFilter(), " ")
  )
  
  req(fetch_tracks())
  
  validate(
    need(nrow(fetch_tracks()) > 0, "No data for provided artists")
  )
  
  data <- fetch_tracks()
  data %>% 
    reactable::reactable(
      defaultColDef = colDef(
        align = "center",
        minWidth = 70,
        headerStyle = list(background = "#f7f7f8")
      ),
      groupBy = c("artist_name", "album_name"),
      columns = list(
        artist_name = colDef(name = "Artist"),
        album_name = colDef(name = "Album", aggregate = "unique"),
        name = colDef(name = "Name"),
        danceability = colDef(name = "Danceability", format = colFormat(percent = TRUE, digits = 0)),
        energy = colDef(name = "Energy", format = colFormat(percent = TRUE, digits = 0)),
        loudness = colDef(name = "Loudness (db)"),
        speechiness = colDef(name = "Speechiness", format = colFormat(percent = TRUE, digits = 0)),
        acousticness = colDef(name = "Acousticness", format = colFormat(percent = TRUE, digits = 0)),
        instrumentalness = colDef(name = "Instrumentalness", format = colFormat(percent = TRUE, digits = 0)),
        liveness = colDef(name = "Liveness", format = colFormat(percent = TRUE, digits = 0)),
        valence = colDef(name = "Valence", format = colFormat(percent = TRUE, digits = 0)),
        tempo = colDef(name = "Tempo"),
        duration_seconds = colDef(name = "Duration (s)")
      ),
      bordered = TRUE,
      highlight = TRUE,
      filterable = TRUE, 
      showPageSizeOptions = TRUE,
      pageSizeOptions = c(10, 20, 50, 100, 500),
      defaultPageSize = 20
    )
     
})
