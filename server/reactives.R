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
  
  updateSelectizeInput(session,
                       "artistsInput",
                       choices = artists_selected$name,
                       selected = artists_selected$name[1])
  
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
  newValue <- append(selected_artists_container(), selected_artists)
  selected_artists_container(newValue)
  
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