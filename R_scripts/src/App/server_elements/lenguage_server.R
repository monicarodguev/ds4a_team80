lenguage_outputs <- reactiveValues()

lenguage_outputs[['lenguage_table']] = reactive({
  # if(input[['select_lenguage_input']] == 'English'){
    xx = select(lenguage_param, -Spanish_text)
    #xx = 'Span'
  # } else if(input[['select_lenguage_input']] == 'Spanish'){
  #   xx = select(lenguage_param, -English_text)
  #   #xx = 'Engl'
  # }
  xx %>% 
   set_names(c('Section', 'component', 'text'))
})

lenguage_outputs[["sidebarText_EDA"]] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'sidebar', component == 'EDA')[['text']] })
lenguage_outputs[["sidebarText_ID_INFORM"]] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'sidebar', component == 'ID_INFORM')[['text']] })
lenguage_outputs[["sidebarText_DEVELOPERS"]] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'sidebar', component == 'DEVELOPERS')[['text']] })
lenguage_outputs[["sidebarText_MODEL"]] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'sidebar', component == 'MODEL')[['text']] })
lenguage_outputs[["sidebarText_DOCUMENTATION"]] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'sidebar', component == 'DOCUMENTATION')[['text']] })

lenguage_outputs[['bodyText_mathias.profile']] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'body', component == 'mathias_profile')[['text']] })
lenguage_outputs[['bodyText_monica.profile']] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'body', component == 'monica_profile')[['text']] })
lenguage_outputs[['bodyText_julian.profile']] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'body', component == 'julian_profile')[['text']] })
lenguage_outputs[['bodyText_ricardo.profile']] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'body', component == 'ricardo_profile')[['text']] })
lenguage_outputs[['bodyText_camila.profile']] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'body', component == 'camila_profile')[['text']] })
lenguage_outputs[['bodyText_jesus.profile']] = reactive({ filter(.data = lenguage_outputs[["lenguage_table"]](), Section == 'body', component == 'jesus_profile')[['text']] })



