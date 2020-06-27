# plots section ----

output[['EDA_radarplot_adherence_plot']] <- renderEcharts4r({
  ACT_df %>% 
    e_charts(axis) %>% 
    e_radar(min, max = 5.5, name = "Mínimo") %>%
    e_radar(median, max = 5.5, name = "Mediana") %>%
    e_radar(mean, max = 5.5, name = "Media") %>%
    e_radar(max, max = 5.5, name = "Máximo") %>%
    e_tooltip(trigger = "item")
})

output[['EDA_scatterplot_adherence_plot']] <- renderEcharts4r({
  #data() %>% 
  #   e_charts(x) %>% 
  # e_bar(y)
})




# ----

# info boxes ----

output[['EDA_info_box']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        valueBox(
          value = scales::number(11120, big.mark = ','),
          subtitle = tags$b(h4('# Patients')),
          icon = tags$i(class = "fas fa-users", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'black'
        ),
        valueBox(
          value = paste(scales::number(5650, big.mark = ','), scales::percent(5650/11120,prefix = '(', big.mark = '%', suffix = '%)') ) ,
          subtitle = tags$b(h4('# Patients with adherence')),
          icon = tags$i(class = "far fa-thumbs-up", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'green'
        ),
        valueBox(
          value = paste(scales::number(4500, big.mark = ','), scales::percent(4500/11120,prefix = '(', big.mark = '%', suffix = '%)') ) ,
          subtitle = tags$b(h4('# Patients without adherence')),
          icon = tags$i(class = "far fa-thumbs-down", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'red'
        ),
        valueBox(
          value = paste(scales::number(1150, big.mark = ','), scales::percent(970/11120,prefix = '(', big.mark = '%', suffix = '%)') ) ,
          subtitle = tags$b(h4('# Patients without state')),
          icon = tags$i(class = "fas fa-hand-holding-medical", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'black'
        )
      )
    )
  )  
})

# ----

# filters panel ----

output[['EDA_filter_box']] = renderUI({
  tagList(
   fluidRow(
     column(
       12,
       boxPlus(
         title = "Filtros", #tags$i(class = "fas fa-filter", style = "color: rgb(255,255,255)"),#
         icon = "fas fa-filter",
         closable = FALSE, 
         width = 12,
         enable_label = FALSE,
         label_text = NULL,
         label_status = NULL,
         status = "black", 
         solidHeader = FALSE, 
         collapsible = TRUE,
         collapsed = TRUE,
         footer_padding = FALSE,
         # Content box ----
         fluidRow(
           # filtro de lugar de residencia ----
           column(
             4,
             pickerInput(
               #width = 4,
               inputId = "EDA_filter.lugar_residencia",
               label = "Lugar de residencia", 
               choices = c("Medellín", "Bogotá", "Cali"),
               multiple = TRUE,
               selected = c("Medellín", "Bogotá", "Cali"),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 ciudades seleccionadas",
                 `count-selected-text` = "{0} ciudades seleccionadas (de un total de {1})",
                 `selected-text-format` = "count > 2"
               )
             )
           ),
           # ----
           # filtro de tipo de medicamento que consume ----
           column(
             4,
             pickerInput(
               #width = 4,
               inputId = "EDA_filter.medicamento",
               label = "Medicamento que consume", 
               choices = c("Farmaco 1", "Farmaco 2", "Farmaco 3"),
               multiple = TRUE,
               selected = c("Farmaco 1", "Farmaco 2", "Farmaco 3"),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 medicamentos seleccionados",
                 `count-selected-text` = "{0} medicamentos seleccionados (de un total de {1})",
                 `selected-text-format` = "count > 2"
               )
             )
           ),
           # ----
           # filtro de género ----
           column(
             4,
             pickerInput(
               #width = 4,
               inputId = "EDA_filter.genero",
               label = "Género", 
               choices = c("Mujer", "Hombre", "No definino"),
               multiple = TRUE,
               selected = c("Mujer", "Hombre", "No definino"),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 géneros seleccionados",
                 `count-selected-text` = "{0} géneros seleccionados (de un total de {1})",
                 `selected-text-format` = "count > 2"
               )
             )
           ),
           # ----
           # filtro de eps ----
           column(
             3,
             pickerInput(
               #width = 4,
               inputId = "EDA_filter.eps",
               label = "EPS", 
               choices = c("EPS 1", "EPS 2", "EPS 3", 'EPS 4'),
               multiple = TRUE,
               selected = c("EPS 1", "EPS 2", "EPS 3", 'EPS 4'),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 EPS seleccionados",
                 `count-selected-text` = "{0} EPS seleccionadas (de un total de {1})",
                 `selected-text-format` = "count > 2"
               )
             )
           ),
           # ----
           # filtro de edad ----
           column(
             3,
             sliderInput(
               inputId = "EDA_filter.edad", 
               label = "Rango de edad:",
               step = 1, 
               min = 0, max = 80, value = c(0, 80),
               dragRange = F,
               post = ' años',
               pre = ''
             )
           ),
           # ----
           # filtro de antiguedad ----
           column(
             3,
             sliderInput(
               inputId = "EDA_filter.antiguedad_tratamiento", 
               label = "Antiguedad en el tratamiento:",
               step = 1, 
               min = 0, max = 45, value = c(0, 45),
               dragRange = F,
               post = ' meses',
               pre = ''
             )
           ),
           # ----
           # filtro de cambios de estado ----
           column(
             3,
             sliderInput(
               inputId = "EDA_filter.cantidad_cambiosEstadp", 
               label = "Cantidad de cambios de estado:",
               step = 1, 
               min = 0, max = 4, value = c(0, 4),
               dragRange = F,
               post = ' veces',
               pre = ''
             )
           )
           # ----
         )
         # ----
       )
     )
   )
  )
})

# ----

# render plots ----

output[['EDA_scatterplot_adherence']] = renderUI({
  tagList(
    panel(
      pickerInput(
        inputId = "EDA_var_x_axis",
        label = "Variable x-axis", 
        choices = c("Edad", "Número de diagnosticos", "ACT score")
      ),
      echarts4rOutput("EDA_scatterplot_adherence_plot"),
      #heading = 'head',footer = 'foot',
      status = 'info'
    )
  )
})

output[['EDA_radarplot_act']] = renderUI({
  tagList(
    panel(
      pickerInput(
        inputId = "EDA_var_radarplot",
        label = "Variable a imprimir", 
        choices = c("ACT Score", "Score 2", "Score 3")
      ),
      echarts4rOutput("EDA_radarplot_adherence_plot"),
      #heading = 'head',footer = 'foot',
      status = 'info'
    )
  )
})

# ----


