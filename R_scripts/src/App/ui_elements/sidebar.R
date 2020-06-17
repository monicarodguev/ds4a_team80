output[['sidebar']] = renderUI(expr = {
    dashboardSidebar(
      sidebarMenu(
        menuItem(
          text = lenguage_outputs[["sidebarText_EDA"]](), 
          tabName = "sidebarItem_EDA", 
          icon = icon("chart-bar")
        ),
        menuItem(
          text = lenguage_outputs[["sidebarText_ID_INFORM"]](), 
          icon = icon("heartbeat"), 
          tabName = "sidebarItem_ID_INFORM",
          badgeLabel = "new", 
          badgeColor = "green"
        ),
        menuItem(
          text = lenguage_outputs[["sidebarText_MODEL"]](), 
          icon = icon("medkit"), 
          tabName = "sidebarItem_MODEL",
          badgeLabel = "new", 
          badgeColor = "green"
        ),
        menuItem(
          text = lenguage_outputs[["sidebarText_DEVELOPERS"]](), 
          icon = icon("laptop-code"), 
          tabName = "sidebarItem_DEVELOPERS",
          badgeLabel = "new", 
          badgeColor = "green"
        ),
        menuItem(
          lenguage_outputs[["sidebarText_DOCUMENTATION"]](), 
          icon = icon("file-alt"), 
          tabName = "sidebarItem_DOCUMENTATION",
          badgeLabel = "new", 
          badgeColor = "green"
        )
      )
    )
  })


