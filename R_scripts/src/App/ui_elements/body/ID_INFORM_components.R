# IDINFORM_all ------------------------------------------------------------

output[['IDINFORM_empty']] = renderUI({
  
  # tagList(
  #   tags$div(
  #     h4('')
  #     style="padding: 70px 0; border: 1px solid #ff0000;text-align: center;"
  #   )
  # )
  
  panel(
    #style='padding:700px 0;',
    h1('Test')
  )
  
})

#ff0000



# IDINFORM_Basico ---------------------------------------------------------

output[['IDINFORM_Basico_table']] = renderReactable({
  
  data_basica = dataset[["datos_basicos"]] %>% 
    filter(patient_id == input[["IDINFORM_search"]]) 
  
  adherencia = dataset[['adherencia']] %>% 
    filter(
      patient_id == input[["IDINFORM_search"]]
    ) %>% 
    filter(fe_entrevista == max(fe_entrevista)) %>% 
    mutate(fe_entrevista = as.Date(fe_entrevista)) 
    
  grupo_riesgo = dataset[['base_lgbm']] %>% 
    filter(id == input[["IDINFORM_search"]]) %>% .[['grupo']]
    
  estado = if_else(
    nrow(adherencia) == 0,
    'Sin medicion',
    adherencia[['morisky_green']]
  )
  
  color = case_when(
    estado == 'Adherente' ~ '#32a852',
    estado == 'No adherente' ~ '#a83232',
    estado == 'No aplica' ~ '#6b6b6b',
    estado == 'Sin medicion' ~ '#000000'
  )
  
  ultima_fecha = if_else(
    nrow(adherencia) == 0,
    '####-##-##',
    paste0(adherencia[['fe_entrevista']])
  )
  
  data.frame(
    var1 = c('Patient ID', 'Edad', 'Genero', 'Estado Civil'),
    var2 = c(data_basica[["patient_id"]], data_basica[["edad"]], data_basica[["genero"]], data_basica[["estadocivil"]]),
    var3 = c('Departamento', 'Ciudad', 'Zona', 'Acompañante'),
    var4 = c(data_basica[["departamento"]], data_basica[["ciudad"]], data_basica[["zona"]], data_basica[["acompaa__ante"]]),
    var5 = c('Tipo de Afiliacion', 'Regimen', 'Ocupacion', 'Relacion Laboral'),
    var6 = c(data_basica[["tipoafiliacion"]], data_basica[["regimen"]], data_basica[["ocupacion"]], data_basica[["relacionlaboral"]])
  ) %>% 
    reactable(
      columns = {list(
        var1 = colDef(
          name = '', align = 'left', width = 180,
          style = list(color = 'black', fontWeight = "bold", borderBottom = "3px solid #eee"),
          footer = 'Estado de adherencia'
        ),
        var2 = colDef(
          name = '', align = 'center', width = 190,
          style = list( borderRight = "3px solid #eee", borderBottom = "3px solid #eee"),
          footer = estado,
          footerStyle = list(color = color, fontWeight = "bold")
        ),
        var3 = colDef(
          name = '', align = 'left', width = 180,
          style = list(color = 'black', fontWeight = "bold", borderBottom = "3px solid #eee"),
          footer = 'Grupo de riesgo'
        ),
        var4 = colDef(
          name = '', align = 'center', width = 190,
          style = list( borderRight = "3px solid #eee", borderBottom = "3px solid #eee"),
          footer = grupo_riesgo, 
          footerStyle = list(
            color = case_when(
              grupo_riesgo == '0 No Risk' ~ '#039e1d',
              grupo_riesgo == '1 Low' ~ '#1ce63d',
              grupo_riesgo == '2 Medium' ~ '#adab03',
              T ~ '#d60202'
            ),
            fontWeight = "bold"
          )
        ),
        var5 = colDef(
          name = '', align = 'left', width = 180,
          style = list(color = 'black', fontWeight = "bold", borderBottom = "3px solid #eee"),
          footer = 'Ultima medicion'
        ),
        var6 = colDef(
          name = '', align = 'center', width = 190,
          style = list( borderBottom = "3px solid #eee"),
          footer = ultima_fecha
        )
      )},
      defaultColDef = colDef(footerStyle = list(fontWeight = "bold"))
    )
})

# IDINFORM_Hospitalizaciones ----------------------------------------------

# IDINFORM_ACT ------------------------------------------------------------

output[['IDINFORM_act_table']] = renderReactable({
  
  gradient_color = colorRampPalette(c("red", "green"))
  gradient_color = gradient_color(5)
  
  dataset[["act_desagregado"]] %>% 
    filter(patient_id == input[["IDINFORM_search"]], id_encuesta_patient == 1) %>% 
    filter(fe_resultado == max(fe_resultado))  %>% 
    select( pregunta, respuesta, respuesta_puntaje, fe_resultado  ) %>% 
    reactable(
      columns = list(
        pregunta = colDef( 
          name = 'Pregunta', align = 'left', width = 500,
          style = list(color = 'black', fontWeight = "bold", borderBottom = "3px solid #eee"),
          footer = paste0('Ultima respuesta: ', max(.[['fe_resultado']])),   footerStyle = list(color = 'black', fontWeight = "bold")
        ),
        respuesta = colDef(
          name = 'Respuesta', align = 'center', width = 200,
          style = list(color = 'black', borderBottom = "3px solid #eee"),
          footer = 'Resultado Final',   footerStyle = list(color = 'black', fontWeight = "bold")
        ),
        respuesta_puntaje = colDef(
          name = 'Puntaje', align = 'center', style = list(color = 'black', borderBottom = "3px solid #eee"),
          cell = function(value) {
            # Format as percentages with 1 decimal place
            value_1 <- paste0(format( (value/5) * 100, nsmall = 1), '%' )
            bar_chart(value, width = value_1, fill = gradient_color[value], background = "#e1e1e1")
          },
          footer = case_when(
            sum(.[['respuesta_puntaje']]) == 25 ~ paste0('(',sum(.[['respuesta_puntaje']]),')', ' Totalmente controlada'),
            between(sum(.[['respuesta_puntaje']]), 20, 24) ~ paste0('(',sum(.[['respuesta_puntaje']]),')', ' No totalmente controlada'),
            between(sum(.[['respuesta_puntaje']]), 1, 19) ~ paste0('(',sum(.[['respuesta_puntaje']]),')', ' No esta controlada')
          ),
          footerStyle = list(
            color = case_when(
              between(sum(.[['respuesta_puntaje']]), 1, 10) ~ gradient_color[1],
              between(sum(.[['respuesta_puntaje']]), 11, 15) ~ gradient_color[2],
              between(sum(.[['respuesta_puntaje']]), 16, 20) ~ gradient_color[3],
              between(sum(.[['respuesta_puntaje']]), 20, 24) ~ gradient_color[4],
              sum(.[['respuesta_puntaje']]) == 25 ~ gradient_color[5]
            ), 
            fontWeight = "bold")
        ),
        fe_resultado = colDef(show = F)
        
      ),
      theme = reactableTheme(
        headerStyle = list(justifyContent = "center"),
        cellStyle = list(display = "flex", flexDirection = "column", justifyContent = "center")
      )
    )
  
})


# IDINFORM_Habitos --------------------------------------------------------

output[['IDINFORM_Habitos_table']] = renderReactable({
  
  dataset[["habitos"]] %>% 
    select(patient_id , tipo, habito2) %>%  
    distinct %>% 
    filter(
      patient_id == input[['IDINFORM_search']]
      #patient_id == 500588
    ) %>%
    full_join( dataset[["habitos"]] %>% select(tipo) %>%  distinct ) %>% 
    mutate(habito2 = if_else(is.na(habito2), 'No reportado', habito2)) %>% 
    mutate(symbol = tipo) %>% 
    select(symbol, tipo, habito2) %>% 
    set_names(c('symbol','Tipo', 'Habito')) %>% 
    reactable(
      columns = list(
        symbol = colDef(
          name = '', align = 'left', width = 30,
          #style = list(color = 'black', fontWeight = "bold", borderBottom = "3px solid #eee"),
          cell =  function(value) habito_indicator(value)
        ),
        Tipo = colDef(
          name = 'Habito', align = 'left', width = 200,
          #style = list(color = 'black', fontWeight = "bold", borderBottom = "3px solid #eee"),
        ),
        Habito = colDef(
          name = 'Descripcion', align = 'center', width = 200,
          #style = list( borderRight = "3px solid #eee", borderBottom = "3px solid #eee") 
        )
      ),
      highlight = TRUE
    )
})

output[['IDINFORM_Habitos_radarplot']] = renderEcharts4r({
  
  dimensiones_dict = dataset[['calidad_de_vida_relacioada_en_salud']] %>% 
    select(dimensiones) %>% 
    distinct
  
  #input[['IDINFORM_search']] = 502989
  #input[['IDINFORM_search']] = 547351
  data = dataset[['calidad_de_vida_relacioada_en_salud']] %>% 
    filter( patient_id == input[['IDINFORM_search']] ) %>% 
    filter( fe_alta == max(fe_alta) ) %>% 
    full_join(dimensiones_dict) %>% 
    mutate( patient_id = input[['IDINFORM_search']], fe_alta = if_else(is.na(fe_alta), '####-##-##', as.character(fe_alta)) ) %>% 
    pivot_wider(id_cols = c('patient_id', 'fe_alta'), names_from = 'dimensiones', values_from = '0_100')

  title_text = paste0('Ultima medicion: ', data[["fe_alta"]])
  legend_data = c(
    paste0('Patient: ', data[['patient_id']])
  )
  
  indicator_data = dimensiones_dict %>% 
    mutate(Values = 100) %>%  rename('Variables' = 'dimensiones')
  
  radarPlot_Habitos_patientID(
    title_text = title_text,
    indicator_data = indicator_data,
    data = data,
    Id_patient = input[['IDINFORM_search']],
    legend_data = legend_data
  )
  
})

# IDINFORM_Adherencia -----------------------------------------------------

# Plots ----

output[['IDINFORM_Adherencia_radarPlot']] = renderEcharts4r({
  
  data = dataset[["base_lgbm"]] %>% 
    select(id, grupo, edad_n, adh_sum_6_n, med_num_doses_otra_avg_6_n, inc_inc_sum_12_n) %>% 
    mutate(
      adh_sum_6_n = -adh_sum_6_n,
      inc_inc_sum_12_n = -inc_inc_sum_12_n
    ) %>% 
    rename(Id_patient = id) #%>% 
    #rename_at(.vars = vars(-contains('_ind'), - Id_patient, -grupo, -prob), .funs = ~ paste(.x, 'n', sep = '_')) %>% 
    #rename_at(.vars = vars(contains('_ind')), .funs = ~ str_sub(.x, start = 1, end = -5)) 
    
  data_patient = data %>% 
    filter(
      Id_patient == input[["IDINFORM_search"]]  
    ) %>% mutate(Id_patient = as.character(Id_patient)) %>% select(-grupo) %>% 
    bind_rows(
      bind_cols(
        
          filter(data,grupo == '0 No Risk') %>% 
          filter( between( adh_sum_6_n, quantile(adh_sum_6_n, 0.25), quantile(adh_sum_6_n, 0.75)  )  ) %>% 
          arrange(adh_sum_6_n) %>%  .[c(1,nrow(.)) ,] %>%  select(adh_sum_6_n),
          
          filter(data,grupo == '0 No Risk') %>% 
            filter( between( edad_n , quantile(edad_n , 0.25), quantile(edad_n , 0.75)  )  ) %>% 
            arrange(edad_n ) %>%  .[c(1,nrow(.)) ,] %>%  select(edad_n ),
          
          filter(data,grupo == '0 No Risk') %>% 
            filter( between( med_num_doses_otra_avg_6_n, quantile(med_num_doses_otra_avg_6_n, 0.25), quantile(med_num_doses_otra_avg_6_n, 0.75)  )  ) %>% 
            arrange(med_num_doses_otra_avg_6_n) %>%  .[c(1,nrow(.)) ,] %>%  select(med_num_doses_otra_avg_6_n),
          
          filter(data,grupo == '0 No Risk') %>% 
            filter( between( inc_inc_sum_12_n, quantile(inc_inc_sum_12_n, 0.25), quantile(inc_inc_sum_12_n, 0.75)  )  ) %>% 
            arrange(inc_inc_sum_12_n) %>%  .[c(1,nrow(.)) ,] %>%  select(inc_inc_sum_12_n)
          
      ) %>% mutate(Id_patient = c('Ideal 0.25', 'Ideal')) %>% filter(Id_patient == 'Ideal')
    )  %>% select('edad_n', 'adh_sum_6_n', 'med_num_doses_otra_avg_6_n', 'inc_inc_sum_12_n', Id_patient) %>% 
    set_names('Edad', 'Adherencia', '# Dosis (6 meses)', 'Inconsistencias', 'Id_patient')
  
  indicator_data = data.frame(
    name = c('Edad', 'Adherencia', '# Dosis (6 meses)', 'Inconsistencias'),
    min = c( min(data[['edad_n']]), min(data[['adh_sum_6_n']]), min(data[['med_num_doses_otra_avg_6_n']]), min(data[['inc_inc_sum_12_n']])),
    max = c( max(data[['edad_n']]), max(data[['adh_sum_6_n']]), max(data[['med_num_doses_otra_avg_6_n']]), max(data[['inc_inc_sum_12_n']]))  
  )
  
  legend_data = c(
    paste0('Paciente: ', filter(data_patient, Id_patient == 'Ideal')[['Id_patient']]),
    paste0('Paciente: ', filter(data_patient, !str_detect(Id_patient, 'Ideal'))[['Id_patient']])
  )
  
  {opt = list(
    title = list(text = 'Paciente Ideal', left = 'center'),
    tooltip = list(trigger = 'item'),
    legend = list(data = legend_data, left = 'left', top = '5%'),
    grid = list(
      left = '30%',
      top = '10%',
      bottom = '10%',
      right = '20%'
    ),
    radar = list(
      radius = 120,
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
        name = paste0('Paciente: ', filter(data_patient, !str_detect(Id_patient, 'Ideal'))[['Id_patient']]),
        type = 'radar',
        data = as.matrix(filter(data_patient, !str_detect(Id_patient, 'Ideal'))),
        itemStyle = list(color = '#0b5ad6')#,
        
        # tooltip = list(
        #   trigger = 'item'#,
        #   #formatter = eval(JS('asdsa'))
        # )
        
      ),
      
      list(
        name = "Paciente: Ideal",
        type = 'radar',
        data = as.matrix(filter(data_patient, Id_patient == 'Ideal')),
        itemStyle = list(color = 'green')
      )
    )
  )}  
  
  jsonlite::toJSON(x = opt, auto_unbox = T, pretty = T) %>% paste %>% 
    echarts4r::echarts_from_json() #%>% 
    #e_tooltip( formatter = 'asdsa' )
    
  
})

output[['IDINFORM_Adherencia_seriesProbPlot']] = renderEcharts4r({
  
  gradient_color = colorRampPalette(c("red", "green"))
  gradient_color = gradient_color(100)
  
  data = dataset[["adherencia"]] %>% 
    filter( year(fe_entrevista) < 2020 ) %>% 
    filter(patient_id == input[['IDINFORM_search']]) %>%  
    mutate(
      fe_entrevista = as.Date(fe_entrevista),
      adherencia_numerico = case_when(
        morisky_green == 'No adherente' ~ 0,
        morisky_green == 'No aplica' ~ 0.5,
        morisky_green == 'Adherente' ~ 1
      )
    ) %>% 
    select(fe_entrevista, adherencia_numerico, morisky_green) %>% 
    arrange(fe_entrevista)
  
  data = bind_rows(
    mutate(data, fe_entrevista = as.character(fe_entrevista)),
    data.frame(
      fe_entrevista = 'Estimacion 2020-01-01',
      adherencia_numerico = round(1 - filter(dataset[['base_lgbm']], id == input[['IDINFORM_search']])[['prob_a']], 3)
    ),
    data.frame(
      fe_entrevista = 'Estimacion 2020-02-01',
      adherencia_numerico = round(1 - filter(dataset[['base_lgbm']], id == input[['IDINFORM_search']])[['prob_n']], 3)
    )
  ) %>% 
    mutate(
      color = case_when(
        fe_entrevista == 'Estimacion 2020-01-01' ~ gradient_color[round(1 - filter(dataset[['base_lgbm']], id == input[['IDINFORM_search']])[['prob_a']], 3)*100],
        fe_entrevista == 'Estimacion 2020-02-01' ~ gradient_color[round(1 - filter(dataset[['base_lgbm']], id == input[['IDINFORM_search']])[['prob_n']], 3)*100],
        morisky_green == 'No adherente' ~ 'red',
        morisky_green == 'Adherente' ~ 'green',
        morisky_green == 'No aplica' ~ 'gray'
      )
    )
  title_text = 'Historial de Adherencia'
  {opts = list(
    title = list(text = title_text, left = 'center'),
    tooltip = list(
      trigger = 'item',
      axisPointer = list(type = 'cross')
    ),
    xAxis = list(
      type = 'category',
      
      axisTick = list( alignWithLabel = T),
      axisLine = list(
        onZero = FALSE,
        lineStyle = list(
          color = 'black'
        )
        
      ),
      axisLabel = list( rotate = 45 ),
      data = data[['fe_entrevista']] %>%  c %>%  unlist 
    ),
    grid = list(
      left = '17%',
      bottom = '15%'
    ),
    yAxis = list(
      type = 'value', 
      boundaryGap = TRUE,
      axisLabel = list( 
        showMinLabel = FALSE,
        formatter = eval(JS("
        function(value, index){
          if(value >= 1){
            text = 'Adherente'
          } else if (value <= 0) {
            text = 'No Adherente'
          }
          return text;
        }                    
      ")), 
        rotate = 0
      ), 
      min = -0.2, max = 1,
      splitNumber = 1
    ),
    series = list(
      list(
        name = 'LineHistory',
        type = 'line',
        step = 'start',
        data = as.matrix(filter(data, !str_detect(fe_entrevista, 'Estimacion') )), 
        tooltip = list(
          formatter = eval(JS("
        function(param){
            if (param.data[0] == 'Estimacion 2020-01-01') {
              xAxis_label = 'Tipo de evento: Estimacion </br> Fecha: 2020-01-01  </br>  Probabilidad de Adherencia: ' + param.data[1] ;
            } else if (param.data[0] == 'Estimacion 2020-02-01') {
              xAxis_label = 'Tipo de evento: Estimacion </br> Fecha: 2020-02-01  </br>  Probabilidad de Adherencia: ' + param.data[1] ;
            }else {
              xAxis_label = 'Tipo de evento: Medicion </br> Fecha: ' + param.data[0] + '</br>' +  'Estado: ' + param.data[2]   ;
            }
            return xAxis_label
        }
        "))
        ),
        itemStyle = list(
          normal = list(color = eval(JS('function(params){return params.data[3]}')))
        ),
        lineStyle = list(
          normal = list(color = 'black')
        )
      ),
      list(
        name = 'LineEstiamtion',
        type = 'line',
        step = 'start',
        data = as.matrix(data[c(nrow(data) - 2,nrow(data) - 1,nrow(data)),]), 
        tooltip = list(
          formatter = eval(JS("
        function(param){
            if (param.data[0] == 'Estimacion 2020-01-01') {
              xAxis_label = 'Tipo de evento: Estimacion </br> Fecha: 2020-01-01  </br>  Probabilidad de Adherencia: ' + param.data[1] ;
            } else if (param.data[0] == 'Estimacion 2020-02-01') {
              xAxis_label = 'Tipo de evento: Estimacion </br> Fecha: 2020-02-01  </br>  Probabilidad de Adherencia: ' + param.data[1] ;
            }else {
              xAxis_label = 'Tipo de evento: Medicion </br> Fecha: ' + param.data[0] + '</br>' +  'Estado: ' + param.data[2]   ;
            }
            return xAxis_label
        }
        "))
        ),
        itemStyle = list(
          normal = list(color = 'gray')
        ),
        lineStyle = list(color = 'gray', type = 'dashed')
        #lineStyle = list(color = eval(JS('function(params){return params.data[3]}')), type = 'dashed')
      ),
      list(
        name = 'ScatterStates',
        type = 'scatter',
        step = 'middle',
        data = as.matrix(data),
        tooltip = list(
          formatter = eval(JS("
          function(param){
            if (param.data[0] == 'Estimacion 2020-01-01') {
              xAxis_label = 'Tipo de evento: Estimacion </br> Fecha: 2020-01-01  </br>  Probabilidad de Adherencia: ' + param.data[1] ;
            } else if (param.data[0] == 'Estimacion 2020-02-01') {
              xAxis_label = 'Tipo de evento: Estimacion </br> Fecha: 2020-02-01  </br>  Probabilidad de Adherencia: ' + param.data[1] ;
            }else {
              xAxis_label = 'Tipo de evento: Medicion </br> Fecha: ' + param.data[0] + '</br>' +  'Estado: ' + param.data[2]   ;
            }
            return xAxis_label
        }
        "))
        ),
        itemStyle = list(
          normal = list(color = eval(JS('function(params){return params.data[3]}')))
        )
        
      ),
      list(
        name = 'area_1',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = '#add8e6', opacity = 0.1),
          silent = TRUE,
          label = list(
            color = '#000000',
            opacity = 1,
            position = 'right',#,
            show = F
          ),
          data = list(
            list(
              list(
                name = 'Not Risk',
                yAxis = 1
              ),
              list(
                yAxis = 1 - 0.423
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_11',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'transparent', opacity = 1),
          silent = TRUE,
          label = list(
            color = 'rgb(3, 158, 29)',
            opacity = 1,
            position = 'right'#,
          ),
          data = list(
            list(
              list(
                name = 'Not Risk',
                yAxis = 1
              ),
              list(
                yAxis = 1 - 0.423
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_2',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'rgb(28, 230, 61)', opacity = 0.1),
          silent = TRUE,
          label = list(
            color = '#000000',
            opacity = 1,
            position = 'right',#,
            show = F
          ),
          data = list(
            list(
              list(
                name = 'Low Risk',
                yAxis = 1 - 0.423
              ),
              list(
                yAxis = 1 - 0.491
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_22',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'transparent', opacity = 1),
          silent = TRUE,
          label = list(
            color = 'rgb(28, 230, 61)',
            opacity = 1,
            position = 'right'#,
          ),
          data = list(
            list(
              list(
                name = 'Low Risk',
                yAxis = 1 - 0.423
              ),
              list(
                yAxis = 1 - 0.491
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_3',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'rgb(173, 171, 3)', opacity = 0.1),
          silent = TRUE,
          label = list(
            color = '#000000',
            opacity = 1,
            position = 'right',#,
            show = F
          ),
          data = list(
            list(
              list(
                name = 'Medium Risk',
                yAxis = 1 - 0.491
              ),
              list(
                yAxis = 1 - 0.724
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_33',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'transparent', opacity = 1),
          silent = TRUE,
          label = list(
            color = 'rgb(173, 171, 3)',
            opacity = 1,
            position = 'right'#,
          ),
          data = list(
            list(
              list(
                name = 'Medium Risk',
                yAxis = 1 - 0.491
              ),
              list(
                yAxis = 1 - 0.724
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_4',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'rgb(214, 2, 2)', opacity = 0.1),
          silent = TRUE,
          label = list(
            color = '#000000',
            opacity = 1,
            position = 'right',#,
            show = F
          ),
          data = list(
            list(
              list(
                name = 'Medium Risk',
                yAxis = 1 - 0.724
              ),
              list(
                yAxis = 0
              )
            )
          )
        )
      ),
      
      list(
        name = 'area_44',
        
        type = 'scatter',
        markArea = list(
          itemStyle = list(color = 'transparent', opacity = 1),
          silent = TRUE,
          label = list(
            color = 'rgb(214, 2, 2)',
            opacity = 1,
            position = 'right'#,
          ),
          data = list(
            list(
              list(
                name = 'High Risk',
                yAxis = 1 - 0.724
              ),
              list(
                yAxis = 0
              )
            )
          )
        )
      ),
    
      list(
        name = 'Umbral',
        type = 'line',
        step = 'middle'
      )
    )
  ) }
  e_charts() %>% 
    e_list(list = opts)
  
  
  
})

output[['IDINFORM_Adherencia_table']] = renderReactable({
  
  dataset[["base_lgbm"]] %>% 
    filter(id == input[["IDINFORM_search"]]) %>% 
    select(-id, - year, -month, - grupo, -contains('prob')) %>% 
    pivot_longer(cols = names(.)) %>% 
    mutate(
      type = str_sub(name, start = -1, end = -1),
      name = str_sub(name, start = 1, end = -3)
    ) %>% 
    pivot_wider(id_cols = 'name', names_from = 'type', values_from = 'value') %>% 
    mutate(
      diff = abs(n - a),
      color = case_when(
        name == 'inc_inc_sum_12' & n > a ~ 'red',
        name == 'adh_sum_6' & n > a ~ 'red',
        name == 'med_num_doses_otra_avg_6' & n < a ~ 'red' ,
        name == 'bio_benralizumab_avg_12' & n < a ~ 'red'   ,
        name == 'urg_j_total_sum_12' & n < a ~ 'red',
        name == 'edad' & n < a ~ 'red',
        diff == 0 ~ 'black',
        T ~ 'green'
      )
    ) %>% 
   mutate_if(.predicate = is.numeric, .funs = ~ round(.x, 2)) %>% 
   mutate(diff = paste(diff, color, sep = '_')) %>% 
   mutate(
     name = case_when(
       name ==  'nivelsocioeconomico' ~ 'Nivel Socioeconomico',
       name ==  'edad' ~ 'Edad',
       name ==  'inc_inc_sum_12' ~ 'Inconsistencias (12 meses)',
       name ==  'adh_sum_6' ~ 'No Adherencia (6 meses)',
       name ==  'med_num_doses_otra_avg_6' ~ 'Promedio de dosis (6 meses)',
       name ==  'bio_benralizumab_avg_12' ~ '# de benralizumab administrados (12 meses)',
       name ==  'urg_j_total_sum_12' ~ 'Urgencias por asma (12 meses)'
     )
   ) %>% 
    reactable(
      columns = list(
        name = colDef(name = 'Variables', align = 'center', style = list( fontWeight = "bold"), width = 250),
        a = colDef(name = 'Medicion para 2020-01-01', align = 'center', style = list( fontWeight = "bold")),
        n = colDef(name = 'Medicion para 2020-02-01', align = 'center', style = list( fontWeight = "bold")),
        diff = colDef(
          name = 'Diferencia', align = 'center', 
          cell = function(value) {str_split(string = value, pattern = '_')[[1]][1]},
          style = function(value){
            list(color = str_split(string = value, pattern = '_')[[1]][2], fontWeight = "bold")
          }
        ),
        color = colDef(show = F)
      )
    )
  
})

# ----

# IDINFORM_Hospitalizaciones ----------------------------------------------

output[['IDINFORM_Hospital_seriesPlot']] = renderEcharts4r({
  title_text = 'Historial de Hospitalizacion'
  
  
  data = dataset[["hospitalizaciones"]] %>% 
    filter(dias_de_estancia__calculada != 0) %>% 
    filter(patient_id == input[['IDINFORM_search']]) %>% 
    mutate( 
      fecha_ingreso = as.Date(fecha_ingreso),
      dias_nouci = dias_de_estancia__calculada - dias_uci - dias_uce
    ) %>% 
    arrange(fecha_ingreso) 
  
  {opts = list(
    title = list(text = title_text, left = 'center'),
    tooltip = list(
      trigger = 'axis',
      axisPointer = list(type = 'shadow')
    ),
    xAxis = list(
      type = 'category',
      
      axisTick = list( alignWithLabel = T),
      axisLine = list(
        onZero = FALSE,
        lineStyle = list(
          color = 'black'
        )
        
      ),
      axisLabel = list( rotate = 45 ),
      data = data[['fecha_ingreso']] %>%  c %>%  unlist 
    ),
    
    yAxis = list(
      name = "Dias de estancia",
      nameLocation = "center",
      nameGap = 20,
      type = 'value', 
      boundaryGap = TRUE,
      axisLabel = list( 
        showMinLabel = FALSE,
        rotate = 0
      )#, 
      #min = -0.2, max = 1,
      #splitNumber = 1
    ),
    
    series = list(
      list(
        name = 'Dias estancia Uci',
        type = 'bar',
        stack = 'equal',
        data = as.matrix(select(.data = data, fecha_ingreso, dias_uci, names(data)))
      ),
      list(
        name = 'Dias estancia Uce',
        type = 'bar',
        stack = 'equal',
        data = as.matrix(select(.data = data, fecha_ingreso, dias_uce, names(data)))
      ),
      list(
        name = 'Dias estancia sin Uci',
        type = 'bar',
        stack = 'equal',
        data = as.matrix(select(.data = data, fecha_ingreso, dias_nouci, names(data)))
      )
    )
  )}
  
  e_charts() %>% 
    e_list(list = opts)
})


# Generating boxPanels ----------------------------------------------------

output[['IDINFORM_search_box']] = renderUI({
  tagList(
    fluidRow(
      column(
        4,
        panel(
          selectInput(width = '100%',
            inputId = 'IDINFORM_search', 
            label = 'Seleccione algun ID:', 
            c(`Seleccione un paciente`='', dataset[['base_lgbm']][['id']]), 
            selectize=TRUE
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
        12, align = 'center',
        panel(
          heading = tags$b('Información básica'),
          reactableOutput("IDINFORM_Basico_table") %>% withSpinner(type = 7, color = "#000000", size = 1)
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
          echarts4rOutput('IDINFORM_Hospital_seriesPlot') %>% withSpinner(type = 7, color = "#000000", size = 1)
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
          reactableOutput("IDINFORM_act_table") %>% withSpinner(type = 7, color = "#000000", size = 1)
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
          fluidRow(
            column(
              5, align = 'center', 
              reactableOutput('IDINFORM_Habitos_table') %>% withSpinner(type = 7, color = "#000000", size = 1)
            ),
            column(
              7, align = 'center',
              echarts4rOutput('IDINFORM_Habitos_radarplot') %>% withSpinner(type = 7, color = "#000000", size = 1)
            )
          )
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
          column(
            3, align = 'center',
            echarts4rOutput('IDINFORM_Adherencia_radarPlot', width = '450px') %>% withSpinner(type = 7, color = "#000000", size = 1)
          ),
          column(
            5, align = 'center',
            echarts4rOutput('IDINFORM_Adherencia_seriesProbPlot') %>% withSpinner(type = 7, color = "#000000", size = 1)
          ),
          column(
            4, align = 'center',
            reactableOutput('IDINFORM_Adherencia_table') %>% withSpinner(type = 7, color = "#000000", size = 1)
          )
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
            12, align = 'center',
            panel(
              uiOutput('IDINFORM_Basico', style = 'text-align: center; align-items: center;'),
              uiOutput('IDINFORM_Adherencia', style = 'text-align: center;'),
              uiOutput('IDINFORM_Hospitalizaciones', style = 'text-align: center;'),
              uiOutput('IDINFORM_ACT', style = 'text-align: center;'),
              uiOutput('IDINFORM_Habitos', style = 'text-align: center;'),
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