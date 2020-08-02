output[['sidebar']] = renderUI(expr = {
    dashboardSidebar(
      sidebarMenu(id = 'menuItem',
        menuItem(
          #text = lenguage_outputs[["sidebarText_EDA"]](), 
          text = 'Analisis Exploratorio',
          tabName = "sidebarItem_EDA", 
          icon = icon("chart-bar")
        ),
        menuItem(
          #text = lenguage_outputs[["sidebarText_ID_INFORM"]](), 
          text = 'Reporte de pacientes',
          icon = icon("heartbeat"), 
          tabName = "sidebarItem_ID_INFORM"#,
          #badgeLabel = "new", 
          #badgeColor = "green"
        ),
        # menuItem(
        #   text = lenguage_outputs[["sidebarText_MODEL"]](), 
        #   icon = icon("medkit"), 
        #   tabName = "sidebarItem_MODEL",
        #   badgeLabel = "empty", 
        #   badgeColor = "green"
        # ),
        menuItem(
          #text = lenguage_outputs[["sidebarText_DEVELOPERS"]](), 
          text = 'Desarrolladores',
          icon = icon("laptop-code"), 
          tabName = "sidebarItem_DEVELOPERS"#,
          #badgeLabel = "empty", 
          #badgeColor = "green"
        ),
        menuItem(
          #lenguage_outputs[["sidebarText_DOCUMENTATION"]](), 
          text = 'Documentacion',
          icon = icon("file-alt"), 
          tabName = "sidebarItem_DOCUMENTATION"#,
          #badgeLabel = "empty", 
          #badgeColor = "green"
        ),
        menuItem(
          #lenguage_outputs[["sidebarText_DOCUMENTATION"]](), 
          text = 'Descripcion del proyecto',
          icon = icon("play-circle"), 
          tabName = "sidebarItem_VIDEO",
          selected = T
          #badgeLabel = "empty", 
          #badgeColor = "green"
        )
      )
    )
  })


