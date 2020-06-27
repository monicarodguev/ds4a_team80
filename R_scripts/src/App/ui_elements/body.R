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

# tabItems content --------------------------------------------------------

output[["tabItem_EDA"]] = renderUI({
  tagList(
    uiOutput('EDA_filter_box'),
    uiOutput('EDA_info_box'),
    fluidRow(
      column(6, uiOutput('EDA_scatterplot_adherence')),
      column(6, uiOutput('EDA_radarplot_act'))
    )#,
    #fluidRow(
    #  column(
    #    12#,
    #    #uiOutput
    #  )
    #)
    
  )
})
output[["tabItem_ID_INFORM"]] = renderUI({
  tagList(
    #h4( lenguage_outputs[['sidebarText_ID_INFORM']]() ),
    uiOutput('IDINFORM_search_box'),
    uiOutput('IDINFORM_panel_ui')
    
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
    h4( lenguage_outputs[['sidebarText_DOCUMENTATION']]() ),
    uiOutput('DOCUMENTATION_accordion')
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
