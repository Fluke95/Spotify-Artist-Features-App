##  ............................................................................
##  Changing filter criteria                                                 ####
results_searchFilter <- reactiveVal(FALSE, "Fill inputs")

# observe events
observeEvent(eventExpr   = c(input$searchArtistInput),
             handlerExpr = c(results_searchFilter(TRUE)),
             ignoreInit  = TRUE)

observeEvent(eventExpr   = c(input$artistsInput),
             handlerExpr = c(results_searchFilter(TRUE)),
             ignoreInit  = TRUE)

observeEvent(eventExpr   = c(input$selectedArtistsInput),
             handlerExpr = c(results_searchFilter(TRUE)),
             ignoreInit  = TRUE)

observeEvent(input$go_button, {
  results_searchFilter(FALSE)
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
##  selected artists - init & reset                                          ####
# initialize selected artists
selected_artists_container <- reactiveVal(c())

# reset selected artists
observeEvent(input$reset_artists, {
  
  selected_artists_container(NULL)
  selected_artists_container <- reactiveVal(c())
  
  req(selected_artists())
  # req(input$searchArtistInput)
  # req(selected_artists_container())
  
  updateSelectizeInput(session,
                       "selectedArtistsInput",
                       choices = NULL,
                       selected = "")
  
})

##  ............................................................................
##  add selected artists                                                     ####
observeEvent(input$AddArtist_button, {
  
  req(selected_artists())
  validate(
    need(input$searchArtistInput != "", "")
  )
  
  selected_artists <- input$artistsInput
  
  selected_artists_ids_revisited <- c()
  for (i in 1:length(selected_artists)){
    
    current_artist <- spotifyr::get_artist(
      id = selected_artists[i],
      authorization=access_token)
    
    current_updated_artist <- current_artist$id
    names(current_updated_artist) <- current_artist$name
    selected_artists_ids_revisited <- c(selected_artists_ids_revisited, current_updated_artist)
  }
  
  updated_artists <- append(selected_artists_container(), selected_artists_ids_revisited)
  selected_artists_container(updated_artists)
  
})

###
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
##  artists names and id `dictionary`                                        ####
artists_ids_names <- eventReactive(input$go_button, {
  
  req(selected_artists())
  req(input$searchArtistInput)
  req(input$selectedArtistsInput)
  
  validate(
    need(length(input$selectedArtistsInput) > 0, "Select at least 1 artist.")
  )
  
  artist_input <- input$selectedArtistsInput
  
  ids_names <- data.frame()
  for (i in 1:length(artist_input)){
    
    current_artist <- spotifyr::get_artist(
      id = artist_input[i],
      authorization=access_token)
    
    current_artist_df <- data.frame(
      artist_id = current_artist$id,
      artist_name = current_artist$name
    )
    
    ids_names <- rbind(ids_names, current_artist_df)
  }
  ids_names
})

##  ............................................................................
##  get all artists songs                                                    ####
fetch_tracks <- eventReactive(input$go_button, {
  
  req(selected_artists())
  req(input$searchArtistInput)
  req(input$selectedArtistsInput)
  req(artists_ids_names())
  
  artist_input <- input$selectedArtistsInput
  print(artist_input)
  
  albums <- data.frame()
  for (j in 1:length(artist_input)){
    artist_songs <- get_artists_album_tracks(artist_input[j])
    print(head(artist_songs))
    albums <- rbind(albums, artist_songs)
  }
  
  all_songs <- get_track_features(albums) %>% 
    dplyr::mutate(duration_ms = duration_ms / 1000) %>% 
    dplyr::rename(duration_seconds = duration_ms)
  merged <- dplyr::inner_join(albums, all_songs, by = c("id"))
  
  # merge with artist names
  artists_ids_names <- artists_ids_names()
  merged <- merged %>% 
    dplyr::inner_join(artists_ids_names, by = c("artist_id")) %>% 
    dplyr::select(artist_name, album_name, name, dplyr::everything(),
                  -id, -album_id, -artist_id) %>% 
    dplyr::distinct(artist_name, album_name, name, .keep_all = TRUE)
  
  merged
})

##  ............................................................................
##  help                                                                     ####
observeEvent(input$help_button, {
  
  shinyWidgets::sendSweetAlert(
    session = session,
    title = "Need some help?",
    text = HTML(paste0(
      "
      More detailed help may be found here in (not) so distant future.<br>
      by now, look <a href='https://developer.spotify.com/documentation/web-api/reference/tracks/get-audio-features/'>here</a> for Spotify API Documentation
      "
    )),
    html = TRUE,
    type = "info",
    btn_labels = "OK"
  )
})

##  ............................................................................
##  notification on 'Go' button                                              ####
# observeEvent(input$go_button, {
#   
#   toastr_info(message = "Your Request is on the way",
#               title = "Please wait, it may take a while...",
#               newestOnTop = TRUE,
#               position = "bottom-center")
# })
