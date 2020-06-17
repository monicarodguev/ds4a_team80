shinyUI(
 dashboardPagePlus(
   title = 'Omnivida_T80', 
   skin = 'black',
   collapse_sidebar = FALSE,
   sidebar_fullCollapse = FALSE,
   sidebar_background = 'light',
   enable_preloader = TRUE,
   loading_duration = 1,
   header = dashboardHeaderPlus(
     title = uiOutput('title'), titleWidth = '230px', fixed = F,
     tags$li(
       class = "dropdown",     
       uiOutput('select_lenguage_output')
     )
    ),
   body = dashboardBody(
     uiOutput('head_styles'),
     uiOutput('tabItems')
   ),
   sidebar = dashboardSidebar(width = "273px",collapsed = TRUE, uiOutput('sidebar'))
 ) 
)