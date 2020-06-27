# Loading libraries --------------------------------------------------------

message("Start - Loading libraries - Section I \n")

library(tidyverse)
library(readxl)
library(leaflet)
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(dashboardthemes)
library(shinydashboardPlus)
library(shinyjs)
library(echarts4r)

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


# Data set ----------------------------------------------------------------

# data testing

ACT_df <- data.frame(
  axis = paste('ACT', 1:5),
  min = rep(1, 5),
  median = rep(3, 5),
  mean = c(3,4,3,2,5),
  max = rep(5,5)
)

patient = c('123456', '1258')
