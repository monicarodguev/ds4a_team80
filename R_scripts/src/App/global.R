# Loading libraries --------------------------------------------------------

message("Start - Loading libraries - Section I \n")

library(tidyverse)
library(readxl)
library(reactable)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinydashboardPlus)
library(shinyjs)
library(echarts4r)
library(jsonlite)
library(shinycssloaders)
library(sparkline)
library(lubridate)

message("End - Loading libraries - Section I \n")

# Loading libraries --------------------------------------------------------

message("Start - Loading files - Section II \n")

lenguage_param = readxl::read_xlsx(path = "www/param/lenguage_parameters.xlsx")
message('- lenguage_param loaded')
#lenguage_param = readxl::read_xlsx(path = "App/www/param/lenguage_parameters.xlsx")
message("End - Loading files - Section II \n")


df <- data.frame(
  val = c("English","Spanish")
)

df$img = c(
  img(src = 'img/flags_lenguage/english_flag.png', width = '30px', div(class = 'jhr', 'English')) %>%  as.character,
  img(src = 'img/flags_lenguage/spanish_flag.png', width = '30px', div(class = 'jhr', 'Spanish')) %>%  as.character
)


# Loading functions -------------------------------------------------------

source(file = 'www/src/plotFunctions.R', local = TRUE, encoding = 'UTF-8')
source(file = 'www/src/tableStyleFunctions.R', local = TRUE, encoding = 'UTF-8')

# Data set ----------------------------------------------------------------

# data testing

message("Start - Loading dataset - Section III \n")

dataset = 'input/Data_2' %>%
  #dataset = 'R_scripts/src/App/input/Data_2' %>%
  list.files(full.names = TRUE) %>%
  set_names(nm = str_remove_all( string = list.files('input/Data_2'), pattern = '.xlsx')) %>%
  #set_names(nm = str_remove_all( string = list.files('R_scripts/src/App/input/Data_2'), pattern = '.xlsx')) %>%
  map(
    ~ {
      readxl::read_xlsx(path = .x) %>%
        as_tibble #%>%
        #mutate_if(.predicate = is.POSIXt, .funs = as.Date)
    }
  )

dataset[['base_lgbm']] <- read.csv('input/Data_3/base_lgbm.csv', sep = '|')  



ACT_df <- data.frame(
  axis = paste('ACT', 1:5),
  min = rep(1, 5),
  median = rep(3, 5),
  mean = c(3,4,3,2,5),
  max = rep(5,5)
)



data_Pacientes = read.csv('input/BaseDatos.csv') %>% 
  as.tibble %>% 
  filter(nuls < 53)
  
patient = unique(dataset[["datos_basicos"]][["patient_id"]]) 


dataset[['act_desagregado']] = dataset[['act_desagregado']] %>%
                                  filter(year(fe_resultado) < 2020)
                                  
dataset[['calidad_de_vida_relacioada_en_salud']] = dataset[['calidad_de_vida_relacioada_en_salud']] %>%
  filter(year(fe_alta) < 2020)

dataset[['adherencia']] = dataset[['adherencia']] %>%
  filter(year(fe_entrevista) < 2020)

dataset[['hospitalizaciones']] = dataset[['hospitalizaciones']] %>%
  filter(year(fecha_ingreso) < 2020)
        


message("Start - Loading dataset - Section III \n")




