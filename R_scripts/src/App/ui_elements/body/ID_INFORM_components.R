output[['IDINFORM_search_box']] = renderUI({
  tagList(
    fluidRow(
      column(
        4,
        panel(
          searchInput(
            inputId = "IDINFORM_search",
            label = "Click search icon to update or hit 'Enter'", 
            placeholder = "Search patient",
            btnSearch = icon("search"), 
            btnReset = icon("remove"),
            width = "100%"
          ),
          status = 'info'
        )
      )
    )
  )
  
})


output[['IDINFORM_panel_ui']] = renderUI({
  IDINFORM_outputs[['IDINFORM_panel']]()
})

# reactive code

IDINFORM_outputs <- reactiveValues()

IDINFORM_outputs[['IDINFORM_panel']] = reactive({
  if(input[['IDINFORM_search']] == ''){
    xx = tagList(
      fluidRow(
        column(
          12,
          panel(
            h4('Seleccione a un paciente'),
            status = 'warning'
          )
        )
      )
    ) 
    } else if(input[['IDINFORM_search']] %in% patient) {
      xx = tagList(
        fluidRow(
          column(
            12,
            panel(
              h4('Reporte del paciente'),
              status = 'success'
            )
          )
        )
      )
    } else {
      xx = tagList(
        fluidRow(
          column(
            12,
            panel(
              h4('El código no existe'),
              status = 'danger'
            )
          )
        )
      )
    }
    
  xx 
})

