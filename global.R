# Load packages
require(shiny)
require(shinyWidgets)
require(shinytoastr)
require(shinycustomloader)

require(bs4Dash)
require(plotly)
require(echarts4r)
require(reactable)

require(ggplot2)
require(plotly)
require(spotifyr)
require(dplyr)

source("functions.R")

# credentials
credentials <- read.csv("credentials.csv")
access_token <- get_spotify_access_token(
  client_id = as.character(credentials$SPOTIFY_CLIENT_ID[1]),
  client_secret = as.character(credentials$SPOTIFY_CLIENT_SECRET[1])
)

# columns to choose from
plot_choices <- c("danceability", "energy",
                  "speechiness", "acousticness",
                  "instrumentalness", "liveness",
                  "valence")

# https://glin.github.io/reactable/articles/examples.html