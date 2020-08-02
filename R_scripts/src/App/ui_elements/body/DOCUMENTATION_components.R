output[['DOCUMENTATION_accordion']] = renderUI({
  tagList(
    fluidRow(
      column(
        12,
        panel(
          p(HTML(paste0('Para tener acceso a los codigos puede acceder al siguiente repositorio: ',a(href = 'https://github.com/monicarodguev/ds4a_team80', 'repository')))),
          p('O tambien comuniquese a alguno de los siguientes correos:'),
          p('- camilalozano@gmail.com'),
          p('- jeaparrape@gmail.com'),
          p('- monicarodguev@gmail.com'),
          p('- fmveranoc@unal.edu.co'),
          p('- ribonilla@gmail.com'),
          p('- julian.andres8212@gmail.com')
          #a(href = 'https://github.com/monicarodguev/ds4a_team80')
        ),
        tags$iframe(style="height:800px; width:100%", src="pdf/Team80_Omnivida_Week9.pdf")
        
      )
    )
  )
  
})

