# Loading libraries -------------------------------------------------------

library(tidyverse)
#library(lubridate)
library(tidymodels)


# Configuring enviroment work and defining path parameters ----------------

setwd('D:/2_Documentos Mathías/DS4A/Final_Project')

dataPath = 'Data'

# Loading dataset ---------------------------------------------------------

dataset = file.path(dataPath) %>% 
  list.files(full.names = T) %>% 
  set_names( 
    str_remove_all(string = list.files(path = file.path(dataPath)), pattern = '.xlsx') %>%  
      iconv(from = 'UTF-8', to = 'ASCII//TRANSLIT') %>% 
      str_to_upper %>% 
      str_replace_all(pattern = '\\s+', '_')
  ) %>% 
  map(readxl::read_xlsx) %>% 
  map(
    ~ {
      .x %>% 
        rename_all(
          .funs = ~ {
            .x %>% 
              iconv(from = 'UTF-8', to = 'ASCII//TRANSLIT') %>% 
              str_to_upper %>% 
              str_replace_all(pattern = '\\s+', '_')
          }
        ) %>% 
        rename_at(
          .vars = vars( contains("NUMERO_IDENTIFICACION"), contains("IDENTIFICACION") ), 
          .funs = ~ "ID"
        )
    }
  )





