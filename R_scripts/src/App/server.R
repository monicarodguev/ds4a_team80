shinyServer(
  function(input, output, session){
    
    source(file = 'server_elements/lenguage_server.R', local = TRUE, encoding = 'UTF-8')
    
    source(file = 'ui_elements/header.R', local = TRUE, encoding = 'UTF-8')
    source(file = 'ui_elements/body.R', local = TRUE, encoding = 'UTF-8')
    source(file = 'ui_elements/sidebar.R', local = TRUE, encoding = 'UTF-8')
    
    
    
  }
)