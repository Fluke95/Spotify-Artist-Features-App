##  ............................................................................
##  Showing / Hiding tab items                                               ####
observeEvent(input$sidebar_menu, {
  
  if(input$sidebar_menu == "PLOT"){
    shinyjs::toggle("plot_customization")
  } else {
    shinyjs::hide("plot_customization")
  }
  
  if(input$sidebar_menu == "TABLE"){
    shinyjs::toggle("table_customization")
  } else {
    shinyjs::hide("table_customization")
  }
  
})

##  ............................................................................
##  search for artists                                                       ####
selected_artists <- eventReactive(input$searchArtistInput, {
  
  validate(
    need(input$searchArtistInput != "", "")
  )
  
  spotifyr::search_spotify(
    q = input$searchArtistInput,
    type = "artist",
    authorization=access_token)
})

##  ............................................................................
##  select artists                                                           ####
observeEvent(input$searchArtistInput, {
  
  req(selected_artists())
  artists_selected <- selected_artists()
  artists_selected_ids <- artists_selected$id
  names(artists_selected_ids) <- artists_selected$name
  
  updateSelectizeInput(session,
                       "artistsInput",
                       choices = artists_selected_ids,
                       selected = artists_selected_ids[1])
  
})

##  ............................................................................
##  add selected artists                                                     ####
selected_artists_container <- reactiveVal(c())
observeEvent(input$AddArtist_button, {
  
  req(selected_artists())
  validate(
    need(input$searchArtistInput != "", "")
  )
  
  selected_artists <- input$artistsInput
  
  selected_artists_ids_revisited <- c()
  for (i in 1:length(selected_artists)){
    
    current_artist <- spotifyr:::get_artist(
      id = selected_artists[i],
      authorization=access_token)
    
    current_updated_artist <- current_artist$id
    names(current_updated_artist) <- current_artist$name
    selected_artists_ids_revisited <- c(selected_artists_ids_revisited, current_updated_artist)
  }
  
  updated_artists <- append(selected_artists_container(), selected_artists_ids_revisited)
  selected_artists_container(updated_artists)
  
})

observeEvent(input$AddArtist_button, {
  
  req(selected_artists())
  req(input$searchArtistInput)
  req(selected_artists_container())
  
  updateSelectizeInput(session,
                       "selectedArtistsInput",
                       choices = selected_artists_container(),
                       selected = selected_artists_container())
  
})

##  ............................................................................
##  get all artists songs                                                    ####
fetch_tracks <- eventReactive(input$go_button, {
  
  # req(selected_artists())
  # req(input$searchArtistInput)
  # req(input$selectedArtistsInput)
  artist_input <- input$selectedArtistsInput
  print(artist_input)
  
  albums <- get_artists_album_tracks(artist_input)
  print(head(albums))
  all_songs <- get_track_features(albums)
  print(head(all_songs))
  merged <- dplyr::inner_join(albums, all_songs, by = c("id"))
  print(merged)
  merged
})