# libraries
# shiny
library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinycustomloader)
library(shinydashboardPlus)
library(shinythemes)
library(shinyjs)
library(shinyWidgets)
library(shinycssloaders)
# other
library(spotifyr)
library(dplyr)
library(DT)
library(ggplot2)
library(plotly)

source("functions.R")

# credentials
credentials <- read.csv("credentials.csv")
access_token <- get_spotify_access_token(
  client_id = as.character(credentials$SPOTIFY_CLIENT_ID[1]),
  client_secret = as.character(credentials$SPOTIFY_CLIENT_SECRET[1])
)
