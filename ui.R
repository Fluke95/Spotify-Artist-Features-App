bs4DashPage(
  sidebar_collapsed = FALSE,
  controlbar_collapsed = FALSE,
  enable_preloader = TRUE,
  loading_duration = 1,
  controlbar_overlay = FALSE,
  loading_background = "DarkOliveGreen",
  # ............................................................................
  # navbar ---------------------------------------------------------------------
  navbar = bs4DashNavbar(
    status = "gray-light",
    skin = "dark",
    fixed = TRUE,
    rightUi = tagList(
      actionLink("help_button", "Help", icon = icon("info"))
    )
  ),
  # ............................................................................
  # sidebar --------------------------------------------------------------------
  sidebar = bs4DashSidebar(
    expand_on_hover = TRUE,
    skin = "dark",
    status = "olive",
    title = h4(id="h4-main-title", "Spotify Artist Features"),
    tags$style(HTML("#h4-main-title{color: mediumseagreen; font-style:italic;}")),
    brandColor = NULL,
    src = NULL,
    elevation = 3,
    opacity = 0.8,
    bs4SidebarMenu(
      id = "current_tab",
      flat = FALSE,
      compact = TRUE,
      child_indent = FALSE,
      bs4SidebarMenuItem(
        "Visualization",
        tabName = "PLOT",
        icon = "chart-bar"
      ),
      bs4SidebarMenuItem(
        "Table",
        tabName = "TABLE",
        icon = "table"
      )
    )
  ),
  # ............................................................................
  # controlbar -----------------------------------------------------------------
  controlbar = bs4DashControlbar(
    inputId = "controlbar",
    expand_on_hover = TRUE,
    skin = "dark",
    width = 300,
    # search for artists
    textInput(
      inputId = "searchArtistInput",
      label = "Search for artist", 
      placeholder = "for example: Nickelback"
    ),
    # pick an artist
    selectizeInput(
      inputId = "artistsInput",
      label = "Select artist",
      choices = " ",
      multiple = FALSE,
    ),
    # add selected artists for analysis
    shinyWidgets::actionBttn(
      inputId = "AddArtist_button",
      label = "Add Artist", 
      style = "material-flat",
      color = "primary",
      icon = icon("plus-square")
    ),
    # remove them
    shinyWidgets::actionBttn(
      inputId = "reset_artists",
      label = "Reset artists", 
      style = "bordered",
      color = "warning",
      icon = icon("trash")
    ),
    # list of selected artists
    selectizeInput(
      inputId = "selectedArtistsInput",
      label = "Selected artists",
      choices = " ",
      multiple = TRUE
    ),
    # go button
    shinyWidgets::actionBttn(
      inputId = "go_button",
      label = "Let's Go!", 
      style = "material-flat",
      color = "success",
      icon = icon("play-circle")
    )
  ),
  # ............................................................................
  # body -----------------------------------------------------------------------
  body = bs4DashBody(
    tags$head(includeHTML(("google-analytics.html"))),
    useToastr(),
    bs4TabItems(
      #  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
      # visualization ----------------------------------------------------------
      bs4TabItem(
        tabName = "PLOT",
        fluidRow(
          bs4Card(
            # title = "Scatter", 
            closable = FALSE, 
            elevation = 4,
            width = 12,
            icon = "fa fa-line-chart",
            status = "success",
            solidHeader = FALSE, 
            maximizable = TRUE, 
            collapsible = TRUE,
            shinyWidgets::dropdownButton(
              tags$h3("Choose axes labels"),
              selectInput(inputId = 'scatter_horizontal',
                          label = 'Horizontal Axis',
                          choices = plot_choices,
                          selected = "valence"),
              selectInput(inputId = 'scatter_vertical',
                          label = 'Vertical Axis',
                          choices = plot_choices,
                          selected = "energy"),
              circle = TRUE,
              status = "warning",
              icon = icon("gear"),
              width = "300px"
            ),
            shinycustomloader::withLoader(
              plotly::plotlyOutput("scatter_plot"),
              type="html",
              loader="loader5")
          ),
          bs4Card(
            # title = "Density", 
            closable = FALSE, 
            elevation = 4,
            width = 12,
            status = "success", 
            solidHeader = FALSE, 
            maximizable = TRUE, 
            collapsible = TRUE,
            shinyWidgets::dropdownButton(
              tags$h3("Choose Feature"),
              selectInput(inputId = 'density_horizontal',
                          label = ' ',
                          choices = plot_choices,
                          selected = "valence"),
              circle = TRUE,
              status = "primary",
              icon = icon("gear"),
              width = "300px"
            ),
            shinycustomloader::withLoader(
              plotly::plotlyOutput("density_plot"),
              type="html",
              loader="loader5")
          )
        )
      ),
      #  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
      # table ------------------------------------------------------------------
      bs4TabItem(
        tabName = "TABLE",
        fluidRow(
          bs4Card(
            # title = "Density", 
            closable = FALSE, 
            elevation = 4,
            width = 12,
            status = "success", 
            solidHeader = FALSE, 
            maximizable = TRUE, 
            collapsible = TRUE,
            shinycustomloader::withLoader(
              reactable::reactableOutput("rawStatsTable"),
              type="html",
              loader="loader5")
          )
        )
      )
    )
  )
)