# Cleaning work enviroment ------------------------------------------------

rm(list = ls())

# Loading libraries -------------------------------------------------------

library(tidyverse)
library(lubridate)
library(openxlsx)

# Loading dataSet ---------------------------------------------------------

Pipe.Data_1 = 'R_scripts/src/App/input/Data_1/' %>% 
  list.files(full.names = TRUE) %>% 
  set_names(nm = str_remove_all( string = list.files('R_scripts/src/App/input/Data_1/'), pattern = '.xlsx')) %>% 
  map(
    ~ {
      readxl::read_xlsx(path = .x) %>% 
        as_tibble %>% 
        mutate_if(.predicate = is.POSIXt, .funs = as.Date)
    }
  ) 


# Revisiones particulares ----

# 1) 'act' y 'act_desagregado' ----
{
act_desagregado = Pipe.Data_1[["act_desagregado"]] %>% 
  filter(
    str_detect(pregunta, 'DURANTE LAS ULTIMAS 4 SEMANAS') |
      str_detect(pregunta, 'COMO CALIFICARIA EL CONTROL DE SU ASMA')
  ) %>% 
  mutate(
    pregunta = if_else(
      str_detect(pregunta, '¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS?'),
      pregunta,
      str_remove_all(string = pregunta, pattern = 'DURANTE LAS ULTIMAS 4 SEMANAS')
    ) %>% str_trim,
    respuesta_puntaje = {case_when(
      # pregunta: ¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS? ----
      str_detect(pregunta,'¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS?') &
        str_detect(respuesta, 'NADA CONTROLADA') ~ 1,
      str_detect(pregunta,'¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS?') &
        str_detect(respuesta, 'MAL CONTROLADA') ~ 2,
      str_detect(pregunta,'¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS?') &
        str_detect(respuesta, 'ALGO CONTROLADA') ~ 3,
      str_detect(pregunta,'¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS?') &
        str_detect(respuesta, 'BIEN CONTROLADA') ~ 4,
      str_detect(pregunta,'¿COMO CALIFICARIA EL CONTROL DE SU ASMA DURANTE LAS ULTIMAS 4 SEMANAS?') &
        str_detect(respuesta, 'TOTALMENTE CONTROLADA') ~ 5,
      # ----
      
      # pregunta: CON QUE FRECUENCIA LOS SINTOMAS DE ASMA (SILBIDOS EN EL PECHO... ----
      pregunta == "¿CON QUE FRECUENCIA LOS SINTOMAS DE ASMA (SILBIDOS EN EL PECHO, TOS, FALTA DE AIRE, OPRESION O DOLOR EN EL PECHO) LO/LA HICIERON DESPERTAR DURANTE LA NOCHE O MAS TEMPRANO QUE DE COSTUMBRE POR LA MAÑANA?" &
        str_detect(respuesta, 'MAS DE 4 NOCHES A LA SEMANA') ~ 1,
      pregunta == "¿CON QUE FRECUENCIA LOS SINTOMAS DE ASMA (SILBIDOS EN EL PECHO, TOS, FALTA DE AIRE, OPRESION O DOLOR EN EL PECHO) LO/LA HICIERON DESPERTAR DURANTE LA NOCHE O MAS TEMPRANO QUE DE COSTUMBRE POR LA MAÑANA?" &
        str_detect(respuesta, 'DE 2 A 3 NOCHES EN A LA SEMANA') ~ 2,
      pregunta == "¿CON QUE FRECUENCIA LOS SINTOMAS DE ASMA (SILBIDOS EN EL PECHO, TOS, FALTA DE AIRE, OPRESION O DOLOR EN EL PECHO) LO/LA HICIERON DESPERTAR DURANTE LA NOCHE O MAS TEMPRANO QUE DE COSTUMBRE POR LA MAÑANA?" &
        str_detect(respuesta, 'UNA O DOS VECES') ~ 3,
      pregunta == "¿CON QUE FRECUENCIA LOS SINTOMAS DE ASMA (SILBIDOS EN EL PECHO, TOS, FALTA DE AIRE, OPRESION O DOLOR EN EL PECHO) LO/LA HICIERON DESPERTAR DURANTE LA NOCHE O MAS TEMPRANO QUE DE COSTUMBRE POR LA MAÑANA?" &
        str_detect(respuesta, 'UNA VEZ A LA SEMANA') ~ 4,
      pregunta == "¿CON QUE FRECUENCIA LOS SINTOMAS DE ASMA (SILBIDOS EN EL PECHO, TOS, FALTA DE AIRE, OPRESION O DOLOR EN EL PECHO) LO/LA HICIERON DESPERTAR DURANTE LA NOCHE O MAS TEMPRANO QUE DE COSTUMBRE POR LA MAÑANA?" &
        str_detect(respuesta, 'NUNCA') ~ 5,
      # ----
      
      # pregunta: ¿CON QUE FRECUENCIA SINTIO FALTA DE AIRE? ----
      
      str_detect(pregunta,'¿CON QUE FRECUENCIA SINTIO FALTA DE AIRE?') &
        str_detect(respuesta, 'MAS DE UNA VEZ AL DIA') ~ 1,
      str_detect(pregunta,'¿CON QUE FRECUENCIA SINTIO FALTA DE AIRE?') &
        str_detect(respuesta, 'UNA VEZ AL DIA') ~ 2,
      str_detect(pregunta,'¿CON QUE FRECUENCIA SINTIO FALTA DE AIRE?') &
        str_detect(respuesta, 'DE 3 A 6 VECES A LA SEMANA') ~ 3,
      str_detect(pregunta,'¿CON QUE FRECUENCIA SINTIO FALTA DE AIRE?') &
        str_detect(respuesta, '1 O 2 VECES A LA SEMANA') ~ 4,
      str_detect(pregunta,'¿CON QUE FRECUENCIA SINTIO FALTA DE AIRE?') &
        str_detect(respuesta, 'NUNCA') ~ 5,
      
      # ----
      
      # pregunta: ¿CON QUE FRECUENCIA SU ASMA LE IMPIDIO LLEVAR A CABO SUS TAREAS HABITUALES EN EL TRABAJO, EL ESTUDIO O EL HOGAR? ----
      
      pregunta == '¿CON QUE FRECUENCIA SU ASMA LE IMPIDIO LLEVAR A CABO SUS TAREAS HABITUALES EN EL TRABAJO, EL ESTUDIO O EL HOGAR?' &
        respuesta == 'SIEMPRE' ~ 1,
      pregunta == '¿CON QUE FRECUENCIA SU ASMA LE IMPIDIO LLEVAR A CABO SUS TAREAS HABITUALES EN EL TRABAJO, EL ESTUDIO O EL HOGAR?' &
        str_detect(respuesta, 'CASI SIEMPRE') ~ 2,
      pregunta == '¿CON QUE FRECUENCIA SU ASMA LE IMPIDIO LLEVAR A CABO SUS TAREAS HABITUALES EN EL TRABAJO, EL ESTUDIO O EL HOGAR?' &
        str_detect(respuesta, 'ALGUNAS VECES') ~ 3,
      pregunta == '¿CON QUE FRECUENCIA SU ASMA LE IMPIDIO LLEVAR A CABO SUS TAREAS HABITUALES EN EL TRABAJO, EL ESTUDIO O EL HOGAR?' &
        str_detect(respuesta, 'POCAS VECES') ~ 4,
      pregunta == '¿CON QUE FRECUENCIA SU ASMA LE IMPIDIO LLEVAR A CABO SUS TAREAS HABITUALES EN EL TRABAJO, EL ESTUDIO O EL HOGAR?' &
        str_detect(respuesta, 'NUNCA') ~ 5,
      
      # ----
      
      # pregunta: ¿CON QUE FRECUENCIA USO SU INHALADOR DE EFECTO INMEDIATO O SE HIZO NEBULIZACIONES (POR EJEMPLO, SALBUTAMOL?) ----
      
      pregunta == '¿CON QUE FRECUENCIA USO SU INHALADOR DE EFECTO INMEDIATO O SE HIZO NEBULIZACIONES (POR EJEMPLO, SALBUTAMOL?)' &
        str_detect(respuesta, 'MAS DE 3 VECES AL DIA') ~ 1,
      pregunta == '¿CON QUE FRECUENCIA USO SU INHALADOR DE EFECTO INMEDIATO O SE HIZO NEBULIZACIONES (POR EJEMPLO, SALBUTAMOL?)' &
        str_detect(respuesta, '1 O 2 VECES AL DIA') ~ 2,
      pregunta == '¿CON QUE FRECUENCIA USO SU INHALADOR DE EFECTO INMEDIATO O SE HIZO NEBULIZACIONES (POR EJEMPLO, SALBUTAMOL?)' &
        str_detect(respuesta, '2 O 3 VECES A LA SEMANA') ~ 3,
      pregunta == '¿CON QUE FRECUENCIA USO SU INHALADOR DE EFECTO INMEDIATO O SE HIZO NEBULIZACIONES (POR EJEMPLO, SALBUTAMOL?)' &
        str_detect(respuesta, '1 VEZ A LA SEMANA O MENOS') ~ 4,
      pregunta == '¿CON QUE FRECUENCIA USO SU INHALADOR DE EFECTO INMEDIATO O SE HIZO NEBULIZACIONES (POR EJEMPLO, SALBUTAMOL?)' &
        str_detect(respuesta, 'NUNCA') ~ 5
      
      # ----
    )}
  ) %>%  
  # identificando encuestas repetidas en un mismo dia ----
  group_by(patient_id, fe_resultado, pregunta) %>% mutate( id_encuesta_patient = row_number() ) %>% ungroup %>% 
  # ----
  group_by(patient_id, fe_resultado, id_encuesta_patient) %>% 
  mutate(
    cantidad_preguntas = n(),
    puntaje_encuesta = sum(respuesta_puntaje)
  ) %>% 
  filter(cantidad_preguntas == 5) 
  
act = act_desagregado %>% 
      summarise(
        cantidad_preguntas = n(),
        respuesta_puntaje = sum(respuesta_puntaje)
      ) %>% 
      left_join(
          Pipe.Data_1[["act"]]
      ) %>% 
      mutate(diff = respuesta_puntaje - nm_puntaje) %>% 
      filter( abs(diff) <= 1 ) %>% 
      select(-diff, -ds_resultado) %>% 
      ungroup %>% 
      left_join(
        Pipe.Data_1[["act"]] %>% 
          select("nm_puntaje", "ds_resultado") %>% 
          distinct %>% 
          mutate(ds_resultado = str_to_sentence(ds_resultado)),
        by = c('respuesta_puntaje' = 'nm_puntaje')
      ) %>% 
    select(-nm_puntaje) %>% 
    rename(nm_puntaje = respuesta_puntaje)
}
# ----

# 2) Datos basicos ----

datos_basicos = Pipe.Data_1[["datos_basicos"]] %>% 
  mutate(
    estadocivil = str_remove(estadocivil, '\\(A\\)') %>%  str_trim,
    estadocivil = case_when(
      genero == 'F' & estadocivil == 'CASADO' ~ 'CASADA',
      genero == 'F' & estadocivil == 'SEPARADO' ~ 'SEPARADA',
      genero == 'F' & estadocivil == 'SOLTERO' ~ 'SOLTERA',
      genero == 'F' & estadocivil == 'VIUDO' ~ 'VIUDA',
      T ~ estadocivil
    ),
    preferencia = if_else( is.na(preferencia), 'Sin informacion', preferencia),
    genero = case_when(
      genero == 'M' ~ 'Masculino',
      genero == 'F' ~ 'Femenino'
    )
  ) %>% 
  mutate_if(.predicate = is.character, .funs = str_to_sentence)

# ----


case_when(
  'asdas' == 1 ~ '1',
  1 == 1 ~ 'sda'
)

Pipe.Data_1_export = list(
  'act' = act,
  'act_desagregado' = act_desagregado,
  antecedentes_familiares = Pipe.Data_1[["antecedentes_familiares"]],
  antecedentes_patologicos = Pipe.Data_1[["antecedentes_patologicos"]],
  calidad_de_vida_relacioada_en_salud = Pipe.Data_1[["calidad_de_vida_relacioada_en_salud"]], # filtrar ultima fecha
  habitos = Pipe.Data_1[["habitos"]], # filtrar ultima fecha
  medicamentos = Pipe.Data_1[["medicamentos"]],
  vacunacion = Pipe.Data_1[["vacunacion"]],
  datos_basicos = datos_basicos,
  adherencia = Pipe.Data_1[["adherencia"]]
) %>% 
  map(.f = ~ .x %>% ungroup %>% mutate_if( .predicate = is.character, .funs = str_to_sentence))  
  
Pipe.Data_1_export %>% names %>% 
  map(~ write.xlsx(x = Pipe.Data_1_export[[.x]], file = paste0('E:/ds4a_team80/R_scripts/src/App/input/Data_2/', .x, '.xlsx') ))


Pipe.Data_1[["ayudas_diagnosticas"]] %>% 
  group_by(patient_id,fecha_orden) %>% 
  summarise(n = n()) %>% 
  
  Pipe.Data_1[["disnea"]]


Pipe.Data_1[["hospitalizaciones"]] 



Pipe.Data_1[["mediciones_de_peso_y_talla"]]
Pipe.Data_1[["urgencias"]]




Pipe.Data_1[["calidad_de_vida_relacioada_en_salud"]] %>% 
  group_by(patient_id) %>% 
  filter(fe_alta == max(fe_alta)) %>% 
  summarise(n_distinct(dimensiones)) 




library(shinyjs)
library(ggplot2)
library(shiny)

ui <- fluidPage(
  useShinyjs(),
  title = "TestApp",
  h1("Test Application"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins", "Bins", 2, 20, 1, value = 10)
    ),
    mainPanel(
      fluidRow(
        div(id="p1", uiOutput("plotPanel1")),
        div(id="p2", uiOutput("plotPanel2"))
      )
    )
  ),
  tags$head(tags$script('
                        var width = 0;
                        $(document).on("shiny:connected", function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        $(window).resize(function(e) {
                          width = window.innerWidth;
                          Shiny.onInputChange("width", width);
                        });
                        '))
)

server <- function(input, output, session){
  plot1 <- reactive({
    ggplot(lm(mpg ~ ., data = mtcars), aes(.resid)) +
      geom_histogram(bins = input$bins)
  }) 
  plot2 <- reactive({
    ggplot(lm(UrbanPop ~ ., data = USArrests), aes(.resid)) +
      geom_histogram(bins = input$bins)
  }) 
  plot3 <- reactive({
    ggplot(lm(uptake ~ ., data = CO2), aes(.resid)) +
      geom_histogram(bins = input$bins)
  })
  
  output$plotPanel1 <- renderUI({
    tagList(
      tabsetPanel(
        tabPanel(
          "plot1",
          renderPlot(plot1())
        ),
        tabPanel(
          "plot2",
          renderPlot(plot2())
        ),
        tabPanel(
          "plot3",
          renderPlot(plot3())
        )
      )
    )
  })
  
  output$plotPanel2 <- renderUI({
    tagList(
      fluidRow(
        column(
          4,
          renderPlot(plot1())
        ),
        column(
          4,
          renderPlot(plot2())
        ),
        column(
          4,
          renderPlot(plot3())
        )
      ) 
    )  
  })
  
  observe( {
    req(input$width)
    if(input$width < 800) {
      shinyjs::show("plotPanel1")
      shinyjs::hide("plotPanel2")
    } else {
      shinyjs::hide("plotPanel1")
      shinyjs::show("plotPanel2")
    }
  })
}

runApp(shinyApp(ui, server))
