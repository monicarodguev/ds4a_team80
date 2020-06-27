output[['DOCUMENTATION_accordion_tabitem_datacleaning']] = renderUI({
  tagList(
    accordionItem(
      id = 1,
      title = "Data Cleaning",
      color = "black",
      collapsed = TRUE,
      "Data Cleaning process"
    )
  )
})
output[['DOCUMENTATION_accordion_tabitem_exploratoryanalysis']] = renderUI({
  tagList(
    accordionItem(
      id = 2,
      title = "Exploratory Analysis",
      color = "black",
      collapsed = TRUE,
      "Exploratory Analysis process"
    )
  )
})
output[['DOCUMENTATION_accordion_tabitem_buildingmodel']] = renderUI({
  tagList(
    accordionItem(
      id = 3,
      title = "Building Model",
      color = "black",
      collapsed = TRUE,
      "Building Model process"
    )
  )
})
output[['DOCUMENTATION_accordion_tabitem_backend']] = renderUI({
  tagList(
    accordionItem(
      id = 4,
      title = "Back - End",
      color = "black",
      collapsed = TRUE,
      "Backend Process"
    )
  )
})
output[['DOCUMENTATION_accordion_tabitem_frontend']] = renderUI({
  tagList(
    accordionItem(
      id = 5,
      title = "Front End",
      color = "black",
      collapsed = TRUE,
      "Front End process"
    )
  )
})

output[['DOCUMENTATION_accordion']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          #title = "Accordion Demo",
          #width = NULL,
          accordion(
            uiOutput('DOCUMENTATION_accordion_tabitem_datacleaning'),
            uiOutput('DOCUMENTATION_accordion_tabitem_exploratoryanalysis'),
            uiOutput('DOCUMENTATION_accordion_tabitem_buildingmodel'),
            uiOutput('DOCUMENTATION_accordion_tabitem_backend'),
            uiOutput('DOCUMENTATION_accordion_tabitem_frontend')
          )
        )
      )
    )
  )
  
})

