shinyUI(
 dashboardPagePlus(
   title = 'Omnivida_T80', 
   skin = 'black',
   collapse_sidebar = TRUE,
   sidebar_fullCollapse = FALSE,
   sidebar_background = 'light',
   enable_preloader = TRUE,
   loading_duration = 2,
   header = dashboardHeaderPlus(
     title = uiOutput('title'), titleWidth = '230px', fixed = F#,
     # tags$li(
     #   class = "dropdown",     
     #   uiOutput('select_lenguage_output')
     # )
    ),
   body = dashboardBody(
     useSweetAlert(),
     chooseSliderSkin("Nice", color = "black"),
     uiOutput('head_styles'),
     uiOutput('tabItems')
   ),
   sidebar = dashboardSidebar(width = "273px",collapsed = TRUE, uiOutput('sidebar'))
 ) 
)