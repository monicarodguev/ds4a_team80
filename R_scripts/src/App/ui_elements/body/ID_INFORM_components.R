# IDINFORM_Basico ---------------------------------------------------------



# IDINFORM_Hospitalizaciones ----------------------------------------------


# IDINFORM_ACT ------------------------------------------------------------


# IDINFORM_Habitos --------------------------------------------------------


# IDINFORM_Adherencia -----------------------------------------------------

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
output[['IDINFORM_Basico']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          heading = tags$b('Información básica'),
          h4('Contenido')
        )
      )
    )
  )
})
output[['IDINFORM_Hospitalizaciones']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          heading = tags$b('Hospitalizaciones'),
          h4('Contenido')
        )
      )
    )
  )
})
output[['IDINFORM_ACT']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          heading = tags$b('Encueta ACT'),
          h4('Contenido')
        )
      )
    )
  )
})
output[['IDINFORM_Habitos']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          heading = tags$b('Habitos'),
          h4('Contenido')
        )
      )
    )
  )
})
output[['IDINFORM_Adherencia']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          heading = tags$b('Adherencia'),
          h4('Contenido')
        )
      )
    )
  )
})



# reactive code

# reactive values ----

IDINFORM_outputs <- reactiveValues(
  
  'IDINFORM_panel' = tagList(
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
  
)

# ----

IDINFORM_outputs[['IDINFORM_panel']] = reactive({
  if(input[['IDINFORM_search']] == ''){
    xx = tagList(
      fluidRow(
        column(
          12, align = 'center', offset = 4,
          column(
            3, align = 'center',
            panel(
              h4('Seleccione a un paciente'),
              status = 'warning'
            )
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
              uiOutput('IDINFORM_Basico'),
              uiOutput('IDINFORM_Adherencia'),
              uiOutput('IDINFORM_Hospitalizaciones'),
              uiOutput('IDINFORM_ACT'),
              uiOutput('IDINFORM_Habitos'),
              status = 'success'
            )
          )
        )
      )
    } else {
      xx = tagList(
        fluidRow(
          column(
            12, align = 'center', offset = 4,
            column(
              3, align = 'center',
              panel(
                h4('El código no existe'),
                status = 'danger'
              )
            )
          )
        )
      )
    }
    
  xx 
})

output[['IDINFORM_panel_ui']] = renderUI({
  IDINFORM_outputs[['IDINFORM_panel']]()
})