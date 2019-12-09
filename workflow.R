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
artists <- spotifyr::search_spotify("the beatles",
                                    type = "artist")

# image - also display
artists$images[[1]]$url[1]

artist <- artists[1, ]

# step 2 - multiple selector: albums
albums <- spotifyr::get_artist_albums(id = artist$id[1], include_groups = "album")
albums

# step 3 - get tracks from albums
abbey_road <- spotifyr::get_album(albums$id[1])
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
