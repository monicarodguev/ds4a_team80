output[['head_styles']] = renderUI(expr = {
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "css/styles.css")
    )
})

output[['select_lenguage_output']] = renderUI(expr = {
  column(
    10,
    align = "center",
    pickerInput(
      inline = TRUE,
      inputId = "select_lenguage_input",
      label = "Leng.",
      choices = df[["val"]],
      choicesOpt = list(content = df[["img"]])
    )
  )
    
})


# developersBox -----------------------------------------------------------

output[['userBox_Mathias']] = renderUI({
  widgetUserBox(
    title = "Mathías Verano",
    subtitle = "Subtitle",
    type = NULL,
    width = 12,
   # src = "img/profile_photo/mathias_profile.jpg",
     src = "img/profile_photo/mathias_profile.jpg",
    color = "red",
    closable = FALSE,
    "add text here",
    footer = "The footer here!"
  )
})
output[['userBox_Monica']] = renderUI({
  widgetUserBox(
    title = "Mónica Rodríguez",
    subtitle = "Subtitle",
    type = NULL,
    width = 12,
    src = "img/profile_photo/unknown_profile.png",
    color = "yellow",
    closable = FALSE,
    "add text here",
    footer = "The footer here!"
  )
})
output[['userBox_Ricardo']] = renderUI({
  widgetUserBox(
    title = "Ricardo Bonilla",
    subtitle = "Subtitle",
    type = NULL,
    width = 12,
    src = "img/profile_photo/unknown_profile.png",
    color = "yellow",
    closable = FALSE,
    "add text here",
    footer = "The footer here!"
  )
})
output[['userBox_Camila']] = renderUI({
  widgetUserBox(
    title = "Camila Lozano",
    subtitle = "Subtitle",
    type = NULL,
    width = 12,
    src = "img/profile_photo/unknown_profile.png",
    color = "yellow",
    closable = FALSE,
    "add text here",
    footer = "The footer here!"
  )
})
output[['userBox_Jesus']] = renderUI({
  widgetUserBox(
    title = "Jesús Parra",
    subtitle = "Subtitle",
    type = NULL,
    width = 12,
    src = "img/profile_photo/unknown_profile.png",
    color = "yellow",
    closable = FALSE,
    "add text here",
    footer = "The footer here!"
  )
})
output[['userBox_Julian']] = renderUI({
  widgetUserBox(
    title = "Julián Gutierrez",
    subtitle = "Subtitle",
    type = NULL,
    width = 12,
    src = "img/profile_photo/unknown_profile.png",
    color = "yellow",
    closable = FALSE,
    "add text here",
    footer = "The footer here!"
  )
})

# tabItems content --------------------------------------------------------

output[["tabItem_EDA"]] = renderUI({
  tagList(
    h4( lenguage_outputs[['sidebarText_EDA']]() )
  )
})
output[["tabItem_ID_INFORM"]] = renderUI({
  tagList(
    h4( lenguage_outputs[['sidebarText_ID_INFORM']]() )
  )
})
output[["tabItem_DEVELOPERS"]] = renderUI({
  tagList(
    fluidRow(
      column(4, uiOutput('userBox_Mathias')),
      column(4, uiOutput('userBox_Monica')),
      column(4, uiOutput('userBox_Ricardo'))
    ),
    br(),
    fluidRow(
      column(4, uiOutput('userBox_Camila')),
      column(4, uiOutput('userBox_Jesus')),
      column(4, uiOutput('userBox_Julian'))
    )
  )
})
output[["tabItem_MODEL"]] = renderUI({
  tagList(
    h4( lenguage_outputs[['sidebarText_MODEL']]() )
  )
})

output[["tabItem_DOCUMENTATION"]] = renderUI({
  tagList(
    h4( lenguage_outputs[['sidebarText_DOCUMENTATION']]() )
  )
})

output[["tabItems"]] = renderUI({
  tabItems(
    tabItem(
      tabName = 'sidebarItem_EDA',
      uiOutput('tabItem_EDA')
    ),
    tabItem(
      tabName = 'sidebarItem_ID_INFORM',
      uiOutput('tabItem_ID_INFORM')
    ),
    tabItem(
      tabName = 'sidebarItem_DEVELOPERS',
      uiOutput('tabItem_DEVELOPERS')
    ),
    tabItem(
      tabName = 'sidebarItem_MODEL',
      uiOutput('tabItem_MODEL')
    ),
    tabItem(
      tabName = 'sidebarItem_DOCUMENTATION',
      uiOutput('tabItem_DOCUMENTATION')
    )
  )
})
