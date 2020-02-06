shinydashboardPlus::dashboardPagePlus(
  skin = "green",
  header = shinydashboardPlus::dashboardHeaderPlus(
    title = "Spotify Artist Features"
  ),
  shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      id = "sidebar_menu",
      shinydashboard::menuItem(
        "item 1",
        tabName = "TABLE",
        icon = shiny::icon("dashboard")
      ),
      shinyjs::hidden(
        div(id = "show_table",
            actionLink("info_tabele", "help", icon = icon("asterisk")),
            selectizeInput(
              inputId = "tabeleWybor",
              label = "Wybierz tabele",
              choices = "",
              # options = list(
              #   placeholder = 'pick one',
              #   onInitialize = I('function() { this.setValue(""); }')
              # )
            ),
            uiOutput("tabeleGeneruj_ui"),
            actionButton(inputId = "WykresPrzygotowanie", "Przygotuj dane do wykresu")
        )
      ),
      shinydashboard::menuItem(
        "item 2",
        tabName = "PLOT",
        icon = shiny::icon("bar-chart")
      ),
      shinyjs::hidden(
        div(id = "show_plot",
            actionLink("info_wykres", "Pomoc", icon = icon("asterisk")),
            shinyWidgets::pickerInput(
              inputId = "wykresRodzaj",
              label = "Wybierz typ wykresu",
              choices = c("Liniowy", "Kolumnowy", "Histogram"),
              multiple = FALSE
            ),
            uiOutput("WykresWybranyRodzaj"),
            actionButton(inputId = "WykresKlik", "Pokaz wykres")
        )
      )
    )
  ),
  shinydashboard::dashboardBody(
    shinyjs::useShinyjs(),
    tags$head(includeHTML(("google-analytics.html"))),
    shinydashboard::tabItems(
      shinydashboard::tabItem(
        tabName = "TABLE",
        fluidRow(
          shinydashboardPlus::gradientBox(
            DT::dataTableOutput("tabelePokaz"),
            title = "Table",
            width = 12,
            icon = "fa fa-th",
            boxToolSize = "md"
          )
        )
      ),
      shinydashboard::tabItem(
        tabName = "PLOT",
        fluidRow(
          shinydashboardPlus::gradientBox(
            # plotlyOutput(
            #   "wykresPokaz") %>% 
            #   shinycustomloader::withLoader(type = "image", loader = "hourglass.gif"),
            title = "Plot",
            width = 12,
            icon = "fa fa-line-chart",
            boxToolSize = "md"
          )
        )
      )
    )
  )
)
