output[['VIDEO']] = renderUI({
  tagList(
    fluidRow(
      column(
        12, align = 'center',
        panel(
          tags$video(id="video2", type = "video/mp4",src = "mp4/Team 80 _ Presentation.mp4", controls = "controls", width = '100%')
        )
      )
    )
  )
  
})