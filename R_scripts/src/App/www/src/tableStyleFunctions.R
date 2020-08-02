habito_indicator = function(
  value = c("Alcohol", "Alimentacion", "Cigarrillo",              
            "Consumo de cafe", "Ejercicio", "Estado anímico",
            "Mascotas", "Metodo de planificacion", "Sustancias psicoactivas")
) {
  label <- switch(value,
                  Alcohol = "Alcohol", Alimentacion = "Alimentacion", Cigarrillo = "Cigarrillo",              
                  Consumo_de_cafe = "Consumo de cafe", Ejercicio = "Ejercicio", Estado_animico = "Estado anímico",
                  Mascotas = "Mascotas", Metodo_de_planificacion = "Metodo de planificacion", Sustancias_psicoactivas = "Sustancias psicoactivas"      
  )
  
  # Add img role and tooltip/label for accessibility
  args <- list(role = "img", title = label)
  
  if (value == "Alcohol") {
    args <- c(args, list(shiny::icon("wine-bottle")))
  } else if (value == "Alimentacion") {
    args <- c(args, list(shiny::icon("apple-alt")))
  } else if (value == "Cigarrillo") {
    args <- c(args, list(shiny::icon("smoking")))
  } else if (value == "Consumo de cafe") {
    args <- c(args, list(shiny::icon("mug-hot")))
  } else if (value == "Ejercicio") {
    args <- c(args, list(shiny::icon("dumbbell")))
  } else if (value ==  "Estado anímico") {
    args <- c(args, list(shiny::icon("laugh-beam")))
  } else if (value == "Mascotas") {
    args <- c(args, list(shiny::icon("paw")))
  } else if (value == "Metodo de planificacion") {
    args <- c(args, list(shiny::icon("pills")))
  } else if (value == "Sustancias psicoactivas") {
    args <- c(args, list(shiny::icon("cannabis")))
  } 
  
  do.call(span, args)
}

bar_chart <- function(label, width = "100%", height = "14px", fill = "#00bfc4", background = NULL) {
  bar <- div(style = list(background = fill, width = width, height = height))
  chart <- div(style = list(flexGrow = 1, marginLeft = "6px", background = background), bar)
  div(style = list(display = "flex", alignItems = "center"), label, chart)
}