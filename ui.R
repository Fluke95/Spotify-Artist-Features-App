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
    fixed = TRUE#,
    # rightUi = tagList(
    #   bs4UserMenu(
    #     name = "Divad Nojnarg", 
    #     status = "primary",
    #     # src = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg", 
    #     src = NULL,
    #     title = "What's new",
    #     subtitle = "Author", 
    #     footer = p("The footer", class = "text-center"),
    #     "Updates"
    #   )
    # )
  ),
  # ............................................................................
  # sidebar --------------------------------------------------------------------
  sidebar = bs4DashSidebar(
    expand_on_hover = TRUE,
    skin = "dark",
    status = "olive",
    title = h4(id="h4-main-title", "Spotify Artist Features"),
    tags$style(HTML("#h4-main-title{color: mediumseagreen;}")),
    brandColor = NULL,
    # src = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg",
    src = NULL,
    elevation = 3,
    opacity = 0.8,
    bs4SidebarMenu(
      id = "current_tab",
      flat = FALSE,
      compact = TRUE,
      child_indent = FALSE,
      # bs4SidebarHeader("Cards"),
      bs4SidebarMenuItem(
        selectizeInput(
          inputId = "artistsInput",
          label = "Select artists",
          choices = " ",
          multiple = TRUE,
        ),
        text = "Galleries",
        icon = "cubes",
        startExpanded = FALSE
      ),
      bs4SidebarMenuItem(
        "Visualization",
        tabName = "PLOT",
        icon = "sliders"
      ),
      bs4SidebarMenuItem(
        "Table",
        tabName = "TABLE",
        icon = "suitcase"
      )
    )
  ),
  # ............................................................................
  # controlbar -----------------------------------------------------------------
  controlbar = bs4DashControlbar(
    inputId = "controlbar",
    expand_on_hover = TRUE,
    skin = "dark",
    title = "My right sidebar",
    width = 300,
    setSliderColor(sliderId = 1, "black"),
    sliderInput(
      inputId = "obs", 
      label = "Number of observations:",
      min = 0, 
      max = 1000, 
      value = 500
    ),
    column(
      width = 12,
      align = "center",
      radioButtons(
        inputId = "dist", 
        label = "Distribution type:",
        c("Normal" = "norm",
          "Uniform" = "unif",
          "Log-normal" = "lnorm",
          "Exponential" = "exp")
      )
    )
  ),
  # ............................................................................
  # body -----------------------------------------------------------------------
  body = bs4DashBody(
    bs4TabItems(
      #  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
      # visualization ----------------------------------------------------------
      bs4TabItem(
        tabName = "PLOT",
        fluidRow(
          bs4Card(
            title = "Closable card with dropdown", 
            closable = FALSE, 
            elevation = 4,
            width = 6,
            status = "warning", 
            solidHeader = FALSE, 
            maximizable = TRUE, 
            collapsible = TRUE,
            dropdownMenu = dropdownItemList(
              dropdownItem(url = "https://www.google.com", name = "Link to google"),
              dropdownItem(url = "#", name = "item 2"),
              dropdownDivider(),
              dropdownItem(url = "#", name = "item 3")
            ),
            plotOutput("plot")
          ),
          bs4Card(
            title = "Closable card with dropdown", 
            closable = FALSE, 
            elevation = 4,
            width = 6,
            status = "warning", 
            solidHeader = FALSE, 
            maximizable = TRUE, 
            collapsible = TRUE,
            # labelStatus = NULL,
            # labelText = NULL,
            # labelTooltip = NULL,
            bs4Ribbon(
              text = "Plot 2",
              status = "danger",
              size = "xl"
            ),
            dropdownMenu = dropdownItemList(
              dropdownItem(url = "https://www.google.com", name = "Link to google"),
              dropdownItem(url = "#", name = "item 2"),
              dropdownDivider(),
              dropdownItem(url = "#", name = "item 3")
            ),
            plotOutput("plot")
          )
        )
      ),
      #  . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
      # table ------------------------------------------------------------------
      bs4TabItem(
        tabName = "TABLE",
        h4("Value Boxes"),
        fluidRow(
          bs4ValueBox(
            value = 150,
            subtitle = "New orders",
            status = "primary",
            icon = "shopping-cart",
            href = "#"
          )
        ),
        h4("Info Boxes"),
        fluidRow(
          bs4InfoBox(
            tabName = "cardsAPI",
            title = "Navigate to Cards API section",
            value = 1410,
            icon = "laptop-code"
          )
        )
      )
      ##
    )
  )
)