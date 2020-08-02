radarPlot_patientID = function(
  title_text = NULL,
  indicator_data,
  data, 
  Id_patient
){
  Id_patient_filter = Id_patient
  data = filter(data, Id_patient %in% c(as.character(Id_patient_filter), 'Ideal'))
  
  legend_data = c(
    paste0('Patient: ', filter(data, Id_patient == 'Ideal')[['Id_patient']]),
    paste0('Patient: ', filter(data, Id_patient != 'Ideal')[['Id_patient']])
  )
  
  list(
    title = list(text = title_text, left = 'center'),
    tooltip = c(),
    legend = list(data = legend_data, left = 'left'),
    radar = list(
      center = c('50%', '55%'),
      name = list(
        textStyle = list(
          color = '#fff',
          backgroundColor = '#999',
          borderRadius = 3,
          padding = c(3, 5)
        )
      ),
      indicator = set_names(indicator_data ,'name', 'max'),
      splitNumber = 5,
      splitArea = list( show = TRUE )
    ),
    series = list(
      list(
        name = 'Series_1',
        type = 'radar',
        data = list(
          list(
            name = paste0('Patient: ', filter(data, Id_patient == 'Ideal')[['Id_patient']]),
            value = filter(data, Id_patient == 'Ideal')[,-1] %>% c %>% unlist,
            itemStyle = list(
              color = 'green'
            )
          ),
          list(
            name = if_else(
              Id_patient == filter(data, Id_patient != 'Ideal')[['Id_patient']],
              paste0('Patient: ', filter(data, Id_patient != 'Ideal')[['Id_patient']]),
              ''
            ),
            value = filter(data, Id_patient != 'Ideal')[,-1] %>% c %>% unlist,
            itemStyle = list(
              color = '#0b5ad6'
            )
          )
        )
      )
    )
  ) %>% 
    jsonlite::toJSON(auto_unbox = T, pretty = T) %>% paste %>% 
    echarts4r::echarts_from_json() %>% 
    return()
  
  
}

radarPlot_Habitos_patientID = function(
  title_text = NULL,
  indicator_data,
  data, 
  Id_patient,
  legend_data
){
  Id_patient_filter = Id_patient
  

  
  list(
    title = list(text = title_text, left = 'center'),
    tooltip = c(),
    legend = list(data = legend_data, left = 'left'),
    radar = list(
      center = c('50%', '55%'),
      name = list(
        textStyle = list(
          color = '#fff',
          backgroundColor = '#999',
          borderRadius = 3,
          padding = c(3, 5)
        )
      ),
      indicator = set_names(indicator_data ,'name', 'max'),
      splitNumber = 5,
      splitArea = list( show = TRUE )
    ),
    series = list(
      list(
        name = 'Series_1',
        type = 'radar',
        data = list(
          list(  
            name = legend_data,
            value = data %>% select(indicator_data[["Variables"]]) %>% c %>% unlist,
            itemStyle = list(
              color = '#0b5ad6'
            )
          )
        )
      )
    )
  ) %>% 
    jsonlite::toJSON(auto_unbox = T, pretty = T) %>% paste %>% 
    echarts4r::echarts_from_json() %>% 
    return()
  
  
}


timeSeries_Probability = function(
  data,
  title_text = NULL,
  Probability_umbral = 60
){
  list(
    
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
      data = data[['fe_date']] %>%  c %>%  unlist 
    ),
    yAxis = list(type = 'value', axisLabel = list( formatter = '{value} %' ), min = 0, max = 100),
    visualMap = list(
      show = FALSE,
      pieces = list(
        list(
          gt = 0,
          lte = Probability_umbral,
          color = 'green'
        ),
        list(
          gt = Probability_umbral,
          lte = 100,
          color = 'red'
        )
      )
    ),
    series = list(
      list(
        name = 'Probability',
        type = 'line',
        data = data[['Probability']]*100 %>%  c %>%  unlist,
        tooltip = list(formatter = " {a}: {c}% </br> Date: {b} ")
      ),
      
      list(
        name = 'Umbral',
        type = 'line',
        markLine = list(
          lineStyle = list(
            type = 'dashed',
            color = 'black'
          ),
          data = list(list( yAxis = Probability_umbral )),
          label = list( formatter = '{c} %' )
        )
      )
      
    )
  ) %>% 
    jsonlite::toJSON(auto_unbox = T, pretty = T) %>% 
    echarts4r::echarts_from_json() %>% 
    return()
}




