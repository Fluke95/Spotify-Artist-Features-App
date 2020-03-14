##  ............................................................................
##  get_artists_album_tracks                                                 ####
get_artists_album_tracks <- function(artist_id){
  
  require(dplyr)
  require(spotifyr)
  
  # step 2 - multiple selector: albums
  albums <- spotifyr::get_artist_albums(id = artist_id,
                                        include_groups = "album",
                                        authorization=access_token)
  
  all_artist_tracks <- data.frame()
  for (album in 1:nrow(albums)){
    album_songs <- spotifyr::get_album_tracks(id=albums$id[album],
                                              authorization=access_token) %>% 
      dplyr::select(id, name)
    album_songs$album_name <- albums$name[album]
    album_songs$album_id <- albums$id[album]
    
    all_artist_tracks <- rbind(all_artist_tracks, album_songs)
  }
  all_artist_tracks$artist_id <- artist_id
  return(all_artist_tracks)
}

##  ............................................................................
##  get_track_features                                                       ####
get_track_features <- function(tracks_df){
  
  require(dplyr)
  require(spotifyr)
  
  all_tracks <- data.frame()
  for (track in 1:nrow(tracks_df)){
    single_track <- spotifyr::get_track_audio_features(
      ids=tracks_df$id[track],
      authorization=access_token)
    
    all_tracks <- rbind(all_tracks, single_track)
  }
  
  all_tracks <- all_tracks %>% 
    dplyr::select(-key, -mode, -type, -uri, -track_href, -analysis_url, -time_signature)
  return(all_tracks)
}