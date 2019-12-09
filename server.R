shinyServer(function(input, output, session) {
  
  # load files from directory 'server'
  for (file in list.files("server")) {
    source(file.path("server", file), local = TRUE)
  }
  
})
