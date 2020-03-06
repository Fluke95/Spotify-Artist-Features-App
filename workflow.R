# libraries
library(spotifyr)
library(dplyr)

# authentication
# credentials
credentials <- read.csv("credentials.csv")
Sys.setenv(SPOTIFY_CLIENT_ID = credentials$SPOTIFY_CLIENT_ID[1])
Sys.setenv(SPOTIFY_CLIENT_SECRET = credentials$SPOTIFY_CLIENT_SECRET[1])
access_token <- get_spotify_access_token()

# step 1 - search for an artist -> selector where only 1 artist can be chosen
artist <- spotifyr::search_spotify("tame impala",
                                   type = "artist") %>% 
  dplyr::select(name, id)

# image - also display
artists$images[[1]]$url[1]

artist <- artists[1, ]


# step 2 - multiple selector: albums
albums <- spotifyr::get_artist_albums(id = artist$id[1], include_groups = "album")
albums

# step 3 - get tracks from albums
# abbey_road <- spotifyr::get_album(albums$id[1])
abbey_road_songs <- spotifyr::get_album_tracks(albums$id[1])

# step 4 - get track features
song_features <- spotifyr::get_track_audio_features(abbey_road_songs$id[1])

all_songs <- tibble()
for (i in 1:nrow(abbey_road_songs)){
  single_song <- spotifyr::get_track_audio_features(abbey_road_songs$id[i])
  all_songs <- rbind(all_songs, single_song)  
}

hist(all_songs$danceability)
plot(all_songs$danceability, all_songs$energy)


##
# Change density plot fill colors by groups
ggplot(all_songs, aes(x=danceability, fill=type)) +
  geom_density(alpha=0.4)

# wykres punktowy
ggplot(data = all_songs, aes(x = valence, y = energy#,
                             # color = artist_name
)) +
  geom_jitter() +
  geom_vline(xintercept = 0.5) +
  geom_hline(yintercept = 0.5) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))


beatles <- artist$id[1]
tame_impala <- artist$id[1]
artist_ids <- c(beatles, tame_impala)

all_artists_tracks <- data.frame()
for (x in 1:length(artist_ids)){
  artist_songs <- get_artists_album_tracks(artist_ids[x])
  all_artists_tracks <- rbind(all_artists_tracks, artist_songs)
}

all_features <- get_track_features(all_artists_tracks)
merged <- inner_join(all_artists_tracks, all_features, by = c("id"))

merged <- merged %>% 
  dplyr::mutate(duration_ms = duration_ms / 1000) %>% 
  dplyr::rename(duration_seconds = duration_ms)

# 1
u <- ggplot(merged, aes(x=danceability, fill=artist_id)) +
  geom_density(alpha=0.4)

ggplotly(u)

# 2
p <- ggplot(data = merged,
       aes(x = valence, y = energy, color=artist_id, label=name, label2=album_name)) +
  geom_jitter() +
  geom_vline(xintercept = 0.5) +
  geom_hline(yintercept = 0.5) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, 1)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 1))

ggplotly(p, tooltip = c("x", "y", "label", "label2"))


##
##  ............................................................................
##  On changing filters                                                     ####
summaryShowVideoInfo_searchFilter <- reactiveVal(FALSE, "Select videos")
summaryShowPlot_searchFilter <- reactiveVal(FALSE, "Select videos")
summaryShowTags_searchFilter <- reactiveVal(FALSE, "Select videos")
summaryShowChannelInfo_searchFilter <- reactiveVal(FALSE, "Select videos")

observeEvent(eventExpr   = c(input$summarySelectVideo),
             handlerExpr = c(summaryShowVideoInfo_searchFilter(TRUE), 
                             summaryShowPlot_searchFilter(TRUE),
                             summaryShowTags_searchFilter(TRUE)),
             ignoreInit  = TRUE)

observeEvent(eventExpr   = c(input$summarySelectCheckbox),
             handlerExpr = summaryShowChannelInfo_searchFilter(TRUE),
             ignoreInit  = TRUE)

observeEvent(input$summaryActionClick, {
  
  summaryShowVideoInfo_searchFilter(FALSE)
  summaryShowPlot_searchFilter(FALSE)
  summaryShowTags_searchFilter(FALSE)
  summaryShowChannelInfo_searchFilter(FALSE)
  
})