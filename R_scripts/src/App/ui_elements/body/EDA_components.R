# plots section ----

output[['EDA_radarplot_adherence_plot']] <- renderEcharts4r({
  
  seleccion = input[['EDA_var_radarplot']] # c("Encuesta ACT", "Calidad de vida")
  
  data_base = filter(
    .data = dataset[['datos_basicos']],
    ( ciudad %in% input[['EDA_filter.ciudad']] | is.na(ciudad) ) &
      ( escolaridad %in% input[['EDA_filter.escolaridad']] | is.na(escolaridad) ) &
      ( genero %in% input[['EDA_filter.genero']] | is.na(genero) ) &
      ( ocupacion %in% input[['EDA_filter.ocupacion']] | is.na(ocupacion) ) &
      ( between(edad, input[['EDA_filter.edad']][1],  input[['EDA_filter.edad']][2]) )
  ) %>% .[['patient_id']]
  
  if(seleccion == 'Encuesta ACT') {
  
    dict = dataset[["act_desagregado"]] %>% 
      select(pregunta) %>%  distinct %>% 
      mutate(pregunta_cod =  paste('ACT', 1:5))
    
    data = dataset[["act_desagregado"]] %>% 
      filter(year(fe_resultado) < 2020, id_encuesta_patient == 1) %>% 
      filter(patient_id %in% data_base) %>% 
      group_by(patient_id) %>% 
      filter(fe_resultado == max(fe_resultado)) %>% 
      filter(patient_id %in% dataset[["base_lgbm"]][["id"]]) %>% 
      ungroup %>%
      left_join(
        select(dataset[["base_lgbm"]], id, grupo),
        by = c('patient_id' = 'id')
      ) %>% 
      group_by(grupo, pregunta) %>% 
      summarise(respuesta_media = round(mean(respuesta_puntaje), 3) ) %>% 
      left_join(dict) %>% 
      select(pregunta_cod, respuesta_media, names(.))
    
    
    indicator_data = data.frame(
      name = unique(data[["pregunta_cod"]]), 
      max = 5
    )
    
    opt = list(
      title = list(text = 'Encuesta ACT por grupo de riesgo (respuesta media)', left = 'center'),
      tooltip = list(trigger = 'item'),
      legend = list(data = unique(dataset[["base_lgbm"]][['grupo']]), left = 'left', top = '5%'),
      grid = list(
        left = '30%',
        top = '10%',
        bottom = '10%',
        right = '20%'
      ),
      radar = list(
        center = c('50%', '55%'),
        name = list(
          textStyle = list(
            color = '#fff',
            backgroundColor = '#999',
            borderRadius = 3,
            padding = c(3, 5),
            fontSize = 12
          ),
          nameGap = 7
        ),
        #axisLabel = list(rotate = 90)
        indicator = indicator_data,
        splitNumber = 5,
        splitArea = list( show = TRUE )
      ),
      series = list(
        list(
          name = paste0('0 No Risk'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '0 No Risk'))),
          itemStyle = list(color = '#039e1d')
        ),
        
        list(
          name = paste0('1 Low'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '1 Low'))),
          itemStyle = list(color = '#1ce63d')
        ),
        
        list(
          name = paste0('2 Medium'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '2 Medium'))),
          itemStyle = list(color = '#adab03')
        ),
        
        list(
          name = paste0('3 High'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '3 High'))),
          itemStyle = list(color = '#d60202')
        )
        
      )
    )  
    
    plot = jsonlite::toJSON(x = opt, auto_unbox = T, pretty = T) %>% paste %>% 
      echarts4r::echarts_from_json()
      
  } else if (seleccion == 'Calidad de vida') {
    
    
    data = dataset[["calidad_de_vida_relacioada_en_salud"]] %>% 
      filter(year(fe_alta) < 2020) %>% 
      filter(patient_id %in% data_base) %>% 
      group_by(patient_id) %>% 
      filter(fe_alta == max(fe_alta)) %>% 
      filter(patient_id %in% dataset[["base_lgbm"]][["id"]]) %>% 
      ungroup %>%
      left_join(
        select(dataset[["base_lgbm"]], id, grupo),
        by = c('patient_id' = 'id')
      ) %>% 
      group_by(grupo, dimensiones) %>% 
      summarise(respuesta_media = round(mean(`0_100`, na.rm = T), 3) ) %>% 
      select(dimensiones, respuesta_media)
    
    indicator_data = data.frame(
      name = unique(data[["dimensiones"]]), 
      max = 100
    )
    
    opt = list(
      title = list(text = 'Calidad de Vida (respuesta media)', left = 'center'),
      tooltip = list(trigger = 'item'),
      legend = list(data = unique(dataset[["base_lgbm"]][['grupo']]), left = 'left', top = '5%'),
      grid = list(
        left = '30%',
        top = '10%',
        bottom = '10%',
        right = '20%'
      ),
      radar = list(
        center = c('50%', '55%'),
        name = list(
          textStyle = list(
            color = '#fff',
            backgroundColor = '#999',
            borderRadius = 3,
            padding = c(3, 5),
            fontSize = 12
          ),
          nameGap = 7
        ),
        #axisLabel = list(rotate = 90)
        indicator = indicator_data,
        splitNumber = 5,
        splitArea = list( show = TRUE )
      ),
      series = list(
        list(
          name = paste0('0 No Risk'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '0 No Risk'))),
          itemStyle = list(color = '#039e1d')
        ),
        
        list(
          name = paste0('1 Low'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '1 Low'))),
          itemStyle = list(color = '#1ce63d')
        ),
        
        list(
          name = paste0('2 Medium'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '2 Medium'))),
          itemStyle = list(color = '#adab03')
        ),
        
        list(
          name = paste0('3 High'),
          type = 'radar',
          data = t(as.matrix(filter(data, grupo == '3 High'))),
          itemStyle = list(color = '#d60202')
        )
        
      )
    )  
    
    plot = jsonlite::toJSON(x = opt, auto_unbox = T, pretty = T) %>% paste %>% 
      echarts4r::echarts_from_json()
        
  } else { plot = NULL }
    
  
  plot
  
})

output[['EDA_scatterplot_adherence_plot']] <- renderEcharts4r({
  
  
  data_base = filter(
    .data = dataset[['datos_basicos']],
    ( ciudad %in% input[['EDA_filter.ciudad']] | is.na(ciudad) ) &
      ( escolaridad %in% input[['EDA_filter.escolaridad']] | is.na(escolaridad) ) &
      ( genero %in% input[['EDA_filter.genero']] | is.na(genero) ) &
      ( ocupacion %in% input[['EDA_filter.ocupacion']] | is.na(ocupacion) ) &
      ( between(edad, input[['EDA_filter.edad']][1],  input[['EDA_filter.edad']][2]) )
  ) %>% .[['patient_id']]
  
  variable = case_when(
    input[['EDA_var_x_axis']] == 'Genero' ~ 'genero',
    input[['EDA_var_x_axis']] == 'Escolaridad' ~ 'escolaridad',
    input[['EDA_var_x_axis']] == 'Estado Civil' ~ 'estadocivil',
    input[['EDA_var_x_axis']] == 'Ciudad' ~ 'ciudad',
    input[['EDA_var_x_axis']] == 'Departamento' ~ 'departamento',
    input[['EDA_var_x_axis']] == 'Estrato' ~ 'estrato',
    input[['EDA_var_x_axis']] == 'Regimen' ~ 'regimen',
    input[['EDA_var_x_axis']] == 'Ocupacion' ~ 'ocupacion',
    input[['EDA_var_x_axis']] == 'Tipo de afiliacion' ~ 'tipoafiliacion'
  )
  
  if(input[['EDA_var_x_axis']] %in%  c("Genero", "Escolaridad","Estado Civil", 'Departamento', 'Estrato', 'Regimen', 'Ocupacion', 'Tipo de afiliacion')){
    
    plot =  dataset[["datos_basicos"]] %>% 
      filter(patient_id %in% data_base) %>% 
      filter(patient_id %in% dataset[["base_lgbm"]][["id"]] ) %>% 
      #.[['estadocivil']] %>%  table
      mutate(
        estadocivil = case_when(
          estadocivil %in% c('Casada', 'Casado') ~ 'Casado',
          estadocivil %in% c('Separada', 'Separado') ~ 'Separado',
          estadocivil %in% c('Soltera', 'Soltero') ~ 'Soltero',
          estadocivil %in% c('Viuda', 'Viudo') ~ 'Viudo',
          T ~ estadocivil
        )
      ) %>% 
      group_by_at(.vars = vars(variable)) %>% 
      summarise(Cantidad = n()) %>% 
      filter_at(.vars = vars(variable), ~ !is.na(.x) ) %>% 
      set_names('name', 'Cantidad') %>% 
      e_charts(name) %>% 
      e_pie(Cantidad) %>% 
      e_tooltip()
  }
  
  if(input[['EDA_var_x_axis']] == 'Edad'){plot = NULL}
  
  plot
  #data() %>% 
  #   e_charts(x) %>% 
  # e_bar(y)
})

# ----

# info boxes ----

output[['EDA_info_box']] = renderUI({
  
  data_base = filter(
    .data = dataset[['datos_basicos']],
    ( ciudad %in% input[['EDA_filter.ciudad']] | is.na(ciudad) ) &
      ( escolaridad %in% input[['EDA_filter.escolaridad']] | is.na(escolaridad) ) &
      ( genero %in% input[['EDA_filter.genero']] | is.na(genero) ) &
      ( ocupacion %in% input[['EDA_filter.ocupacion']] | is.na(ocupacion) ) &
      ( between(edad, input[['EDA_filter.edad']][1],  input[['EDA_filter.edad']][2]) )
  ) %>% .[['patient_id']]
  
  data = dataset[["adherencia"]] %>% 
    group_by(patient_id) %>% 
    filter(fe_entrevista == max(fe_entrevista)) %>% 
    filter( patient_id %in% dataset[["base_lgbm"]][["id"]] ) %>% 
    ungroup %>% 
    select(patient_id, morisky_green) %>% 
    full_join(
      dataset[["base_lgbm"]] %>%  select(id),
      by = c('patient_id' = 'id')
    ) %>% 
    mutate(
      morisky_green= if_else(is.na(morisky_green),'No aplica', morisky_green)
    ) %>% 
    filter( patient_id %in% data_base ) 
  
  pacientes = data[['patient_id']]  %>% unique  %>%  length
  adherentes = filter(data, morisky_green == 'Adherente')[['patient_id']]  %>% unique  %>%  length
  no_adherentes = filter(data, morisky_green == 'No adherente')[['patient_id']]  %>% unique  %>%  length
  no_aplica = filter(data, morisky_green == 'No aplica')[['patient_id']]  %>% unique  %>%  length
  
  
  tagList(
    fluidRow(
      column(
        12,
        valueBox(
          value = scales::number(pacientes, big.mark = ','),
          subtitle = tags$b(h4('# Pacientes')),
          icon = tags$i(class = "fas fa-users", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'black'
        ),
        valueBox(
          value = paste(scales::number(adherentes, big.mark = ','), scales::percent(adherentes/pacientes,prefix = '(', big.mark = '%', suffix = '%)') ) ,
          subtitle = tags$b(h4('# Pacientes en adherencia')),
          icon = tags$i(class = "far fa-thumbs-up", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'green'
        ),
        valueBox(
          value = paste(scales::number(no_adherentes, big.mark = ','), scales::percent(no_adherentes/pacientes,prefix = '(', big.mark = '%', suffix = '%)') ) ,
          subtitle = tags$b(h4('# Pacientes en No adherencia')),
          icon = tags$i(class = "far fa-thumbs-down", style = "color: rgb(255,255,255)"),
          width = 3,
          color = 'red'
        ),
        valueBox(
          value = paste(scales::number(no_aplica, big.mark = ','), scales::percent(no_aplica/pacientes,prefix = '(', big.mark = '%', suffix = '%)') ) ,
          subtitle = tags$b(h4('# Pacientes sin estado')),
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
               inputId = "EDA_filter.ciudad",
               label = "Ciudad de residencia", 
               choices = unique(dataset[['datos_basicos']][["ciudad"]]),
               multiple = TRUE,
               selected = unique(dataset[['datos_basicos']][["ciudad"]]),
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
               inputId = "EDA_filter.escolaridad",
               label = "Nivel de escolaridad", 
               choices = unique(dataset[['datos_basicos']][["escolaridad"]]),
               multiple = TRUE,
               selected = unique(dataset[['datos_basicos']][["escolaridad"]]),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 elementos seleccionados",
                 `count-selected-text` = "{0} elementos seleccionados (de un total de {1})",
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
               choices = unique(dataset[['datos_basicos']][["genero"]]),
               multiple = TRUE,
               selected = unique(dataset[['datos_basicos']][["genero"]]),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 elementos seleccionados",
                 `count-selected-text` = "{0} elementos seleccionados (de un total de {1})",
                 `selected-text-format` = "count > 2"
               )
             )
           ),
           # ----
           # filtro de eps ----
           column(
             6, align = 'center',
             pickerInput(
               #width = 4,
               inputId = "EDA_filter.ocupacion",
               label = "Ocupacion", 
               choices = unique(dataset[['datos_basicos']][["ocupacion"]]),
               multiple = TRUE,
               selected = unique(dataset[['datos_basicos']][["ocupacion"]]),
               options = list(
                 `actions-box` = TRUE,
                 `deselect-all-text` = "Ninguno",
                 `select-all-text` = "Seleccionar todos",
                 `none-selected-text` = "0 elementos seleccionados",
                 `count-selected-text` = "{0} elmentos seleccionadas (de un total de {1})",
                 `selected-text-format` = "count > 2"
               )
             )
           ),
           # ----
           # filtro de edad ----
           column(
             6, align = 'center',
             sliderInput(
               inputId = "EDA_filter.edad", 
               label = "Rango de edad:",
               step = 1, 
               min = min(dataset[["datos_basicos"]][["edad"]]), max = max(dataset[["datos_basicos"]][["edad"]]), 
               value = c(min(dataset[["datos_basicos"]][["edad"]]), max(dataset[["datos_basicos"]][["edad"]])),
               dragRange = F,
               post = ' años',
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
    panel(heading = 'Informacion basica',
      pickerInput(
        inputId = "EDA_var_x_axis",
        label = "Variable", 
        choices = c("Genero", "Escolaridad" ,"Estado Civil", 'Departamento', 'Estrato', 'Regimen', 'Ocupacion', 'Tipo de afiliacion')
      ),
      echarts4rOutput("EDA_scatterplot_adherence_plot") %>% withSpinner(type = 7, color = "#000000", size = 1)#,
      #heading = 'head',footer = 'foot',
      #status = 'info'
    )
  )
})

output[['EDA_radarplot_act']] = renderUI({
  tagList(
    panel(
      heading = 'Encuesta ACT y Calidad de Vida',
      pickerInput(
        inputId = "EDA_var_radarplot",
        label = "Variable", 
        choices = c("Encuesta ACT", "Calidad de vida")
      ),
      echarts4rOutput("EDA_radarplot_adherence_plot") %>% withSpinner(type = 7, color = "#000000", size = 1)
      #heading = 'head',footer = 'foot',
    )
  )
})


# EDA_filter.ciudad
# EDA_filter.escolaridad
# EDA_filter.genero
# EDA_filter.ocupacion
# EDA_filter.edad

output[['EDA_groupsTable']] = renderReactable({
  
  data = dataset[["base_lgbm"]] %>% 
    left_join(
      dataset[["datos_basicos"]],
      by = c('id' = 'patient_id')
    ) %>% 
    tibble %>% 
    filter(
      ( ciudad %in% input[['EDA_filter.ciudad']] | is.na(ciudad) ) &
      ( escolaridad %in% input[['EDA_filter.escolaridad']] | is.na(escolaridad) ) &
      ( genero %in% input[['EDA_filter.genero']] | is.na(genero) ) &
      ( ocupacion %in% input[['EDA_filter.ocupacion']] | is.na(ocupacion) ) &
      ( between(edad, input[['EDA_filter.edad']][1],  input[['EDA_filter.edad']][2]) )
    ) %>% 
    select(-edad) %>% 
    group_by(grupo) %>% 
    summarise(
      n = n(),
      genero = list(c(table(genero)) ),
      med_num_doses_otra_avg_6_n = list(med_num_doses_otra_avg_6_n),
      urg_j_total_sum_12_n = list(urg_j_total_sum_12_n),
      inc_inc_sum_12_n = list(inc_inc_sum_12_n),
      adh_sum_6_n = list(adh_sum_6_n),
      bio_benralizumab_avg_12_n = list(bio_benralizumab_avg_12_n),
      edad_n = list(edad_n),
    ) 
  
  reactable(
    data, 
    columns = list(
      grupo = colDef(
        name = 'Grupo', align = 'center', width = 95,
        style = function(value){
          if(value == '0 No Risk'){
            color = '#039e1d'
          } else if(value == '1 Low') {
            color = '#1ce63d'
          } else if(value == '2 Medium') {
            color = '#adab03'
          } else {
            color = '#d60202'
          }
          list(color = color, fontWeight = "bold")
        }
      ),
      n =  colDef(
        name = '# pacientes', align = 'center', width = 95
      ),
      genero = colDef(name = 'Genero', width = 70, align = 'center' ,
                      cell = function(values) { sparkline(values, type = "pie", sliceColors =c( '#a903fc', '#0356fc'), width = '40px', height = '40px') }
      ),
      med_num_doses_otra_avg_6_n = colDef(
        name = 'Promedio de dosis (6 meses)',align =  'center', width = 230,
        cell = function(values) { sparkline(
          values, type = "box", width = '220px', height = '40px',
          chartRangeMax = max(dataset[["base_lgbm"]][['med_num_doses_otra_avg_6_n']]), lineColor = 'black', medianColor = 'black', boxFillColor = '#6791e6'
        ) }
      ),
      urg_j_total_sum_12_n = colDef(
        name = 'Urgencias por asma (12 meses)',align =  'center', width = 230,
        cell = function(values) { sparkline(
          values, type = "box", width = '220px', height = '40px',
          chartRangeMax = max(dataset[["base_lgbm"]][['urg_j_total_sum_12_n']]), lineColor = 'black', medianColor = 'black', boxFillColor = '#6791e6'
        ) }
      ),
      inc_inc_sum_12_n = colDef(
        name = '# inconsistencias (12 meses)',align =  'center', width = 230,
        cell = function(values) { sparkline(
          values, type = "box", width = '220px', height = '40px',
          chartRangeMax = max(dataset[["base_lgbm"]][['inc_inc_sum_12_n']]), lineColor = 'black', medianColor = 'black', boxFillColor = '#6791e6'
        ) }
      ),
      adh_sum_6_n = colDef(
        name = '# No Adherencia (6 meses)',align =  'center', width = 230,
        cell = function(values) { sparkline(
          values, type = "box", width = '220px', height = '40px',
          chartRangeMax = max(dataset[["base_lgbm"]][['adh_sum_6_n']]), lineColor = 'black', medianColor = 'black', boxFillColor = '#6791e6'
        ) }
      ),
      
      bio_benralizumab_avg_12_n = colDef(
        name = '# Promedio de medicamentos (6 meses)',align =  'center', width = 230,
        cell = function(values) { sparkline(
          values, type = "box", width = '220px', height = '40px',
          chartRangeMax = max(dataset[["base_lgbm"]][['bio_benralizumab_avg_12_n']]), lineColor = 'black', medianColor = 'black', boxFillColor = '#6791e6'
        ) }
      ),
      
      edad_n = colDef(
        name = 'Edad',align =  'center', width = 230,
        cell = function(values) { sparkline(
          values, type = "box", width = '220px', height = '40px',
          chartRangeMax = max(dataset[["base_lgbm"]][['edad_n']]), lineColor = 'black', medianColor = 'black', boxFillColor = '#6791e6'
        ) }
      )
      
      # boxplot = colDef(cell = function(value, index) {
      #   sparkline(data$weight[[index]], type = "box")
      # })
    )
  )
  
  
})

# ----


