shinydashboardPlus::dashboardPagePlus(
  skin = "green",
  header = shinydashboardPlus::dashboardHeaderPlus(
    title = "Spotify Artist Features"
  ),
  # ............................................................................
  # sidebar                                                                 ----
  shinydashboard::dashboardSidebar( 
    shinydashboard::sidebarMenu(
      id = "sidebar_menu",
      # help
      actionLink("help_button", "Help", icon = icon("asterisk")),
      # type artist name
      textInput(
        inputId = "searchArtistInput",
        label = "Search for artists",
        placeholder = "for example: Nickelback"
      ),
      # pick an artist
      selectizeInput(
        inputId = "artistsInput",
        label = "Select artists",
        choices = " ",
        multiple = TRUE,
      ),
      # add selected artists for analysis
      actionButton(inputId = "AddArtist_button", 
                   label = "Add Artist"),
      selectizeInput(
        inputId = "selectedArtistsInput",
        label = "Selected artists",
        choices = " ",
        multiple = TRUE,
        options = list(
          'plugins' = list('remove_button'),
          'create' = TRUE,
          'persist' = FALSE)
      ),
      
      actionButton(inputId = "go_button", "Go!"),
      # ........................................................................
      # plots panel                                                         ----
      shinydashboard::menuItem(
        "Visualization",
        tabName = "PLOT",
        icon = shiny::icon("bar-chart")
      ),
      hidden(
        div(
          id = "plot_customization",
          # shinyWidgets::pickerInput(
          #   inputId = "",
          #   label = "",
          #   choices = "",
          #   multiple = TRUE,
          #   options = pickerOptions(
          #     `actionsBox` = TRUE,
          #     `liveSearch`  = TRUE,
          #     liveSearchPlaceholder = "")
          # ),
          actionButton(inputId = "showPlots_button", "Show Plots")
        )
      ),
      # ........................................................................
      # table panel                                                         ----
      shinydashboard::menuItem(
        "Table",
        tabName = "TABLE",
        icon = shiny::icon("dashboard")
      ),
      hidden(
        div(
          id = "table_customization",
          actionButton(inputId = "showTable_button", "Show Table")
        )
      )
    )
  ),
  # ............................................................................
  # body                                                                    ----
  shinydashboard::dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(includeHTML(("google-analytics.html"))),
    shinydashboard::tabItems(
      shinydashboard::tabItem(
        tabName = "PLOT",
        fluidRow(
          shinydashboardPlus::gradientBox(
            # plotlyOutput(
            #   "wykresPokaz") %>% 
            #   shinycustomloader::withLoader(type = "image", loader = "hourglass.gif"),
            title = "Scatter",
            width = 12,
            icon = "fa fa-line-chart",
            boxToolSize = "md"
          ),
          shinydashboardPlus::gradientBox(
            # plotlyOutput(
            #   "wykresPokaz") %>% 
            #   shinycustomloader::withLoader(type = "image", loader = "hourglass.gif"),
            title = "Density",
            width = 12,
            icon = "fa fa-line-chart",
            boxToolSize = "md"
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "TABLE",
        fluidRow(
          shinydashboardPlus::gradientBox(
            DT::dataTableOutput("rawStatsTable"),
            title = "Table",
            width = 12,
            icon = "fa fa-line-chart",
            boxToolSize = "md"
          )
        )
      )
    )
  )
)
