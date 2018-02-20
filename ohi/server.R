# library(plotly)
# library(shinydashboard)
# library(shinyjs)
# library(tidyverse)
# library(RColorBrewer)
# library(DT)
# library(shiny)
# 
# # load data
# dat <- read_csv("ohi_dat_clean.csv") # change file path beore uploading to Shiny
# 
# # load modeled data
# dat_mod <- read_csv("dat_modeled.csv")
# 
# # find min/max for slider
# #dat %>% group_by(dimension) %>% filter(!is.na(value)) %>% dplyr::summarise(min = min(value), max = max(value)) %>% write_csv("slider.csv")
# slider <- read_csv("slider.csv")

# # light grey boundaries
# l <- list(color = toRGB("grey"), width = 0.5)
# 
# # specify map projection/options
# g <- list(
#   showframe = FALSE,
#   showcoastlines = FALSE,
#   projection = list(type = 'Mercator')
# )

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # landing page
  observeEvent(once = TRUE,ignoreNULL = FALSE, ignoreInit = FALSE, eventExpr = dat, { 
    # event will be called when histdata changes, which only happens once, when it is initially calculated
    showModal(modalDialog(
      #title = "Ocean Health Index Map and Data Explorer", 
      h1('Welcome!'),
      tags$p('This webapp displays analysis from the Ocean Health Index (OHI), a tailorable marine assessment framework to comprehensively and quantitatively evaluate ocean health.'),
      useShinyjs(),  # Set up shinyjs
      actionButton("go_button", "Read more..."),
      hidden(
        p(id = "element", tags$br(), tags$b("The OHI measures progress towards a suite of key societal ‘goals’ representing the benefits and services people expect healthy oceans to provide."), "By analyzing these goals together and scoring them from 0-100, OHI assessments provide an integrated picture of the state of the ecosystem and can be communicated to a wide range of audiences.", tags$br(), tags$br(), "Originally developed by an interdisciplinary team of scientists", tags$em("(Halpern et al., 2012, Nature)"), "global assessments have been repeated every year since 2012", tags$em("(Halpern et al., 2015, PLOS One; Halpern et al. in review)."), tags$br(), tags$br(), "The OHI framework is standardized yet tailorable to different contexts and spatial scales. This is possible because the core framework of how goals are scored does not change while the goal models themselves are developed with local information and local decisions specific to the context." )
      )  )) } 
    )
  
  # load hidden text
  observeEvent(input$go_button, {
    show("element")
  })
  
  
  # Reactive values for slider input 
  my_reactives <- reactiveValues( react_ind = list(0, 100) )

  # this first event is a hack that allows 
  observe( {
    input$go_button
    my_reactives$react_ind <- input$v_4
  })
  observe( {
    input$v_1
    my_reactives$react_ind <- input$v_1
  })
  observe( {
    input$v_2
    my_reactives$react_ind <- input$v_2
  })
  observe( {
    input$v_3
    my_reactives$react_ind <- input$v_3
  })
  observe( {
    input$v_4
    my_reactives$react_ind <- input$v_4
  })
  observe( {
    input$v_5
    my_reactives$react_ind <- input$v_5
  })
  observe( {
    input$v_6
    my_reactives$react_ind <- input$v_6
  })

  
  temp <- reactive( {     # filter dat by user input
    dat %>% filter(goal == input$goal & 
                     dimension == input$dimension & 
                     value >= my_reactives$react_ind[1] & value <= my_reactives$react_ind[2] ) })
  
  temp_mod <- reactive( {     # filter dat by user input
    dat_mod %>% filter(goal == input$goal & 
                       dimension == input$dimension) })

  # Main Map
  output$map <- renderPlotly({
    
    plot_geo( temp() ) %>% 
      add_trace(
        z = ~value, 
        zmin = slider$min[slider$dimension == input$dimension],
        zmax = slider$max[slider$dimension == input$dimension],
        color = ~value, colors = 'Blues',
        frame = ~scenario,
        text = ~region_name, locations = ~a3_code, marker = list(line = l)
      ) %>%
      colorbar(title = 'Value', tickprefix = '') %>%
      layout(
        title = paste('Ocean Health Index:<br>',input$goal, input$dimension),
        geo = g) %>% 
      
      animation_button(
        x = 1, xanchor = "right", y = 0, yanchor = "bottom")
    
  })
  
  # Main Map
  output$map_mod <- renderPlotly({
    
    plot_geo( temp_mod() ) %>% 
      add_trace(
        z = ~estimate, 
        zmin = -3,
        zmax = 3,
        color = ~estimate_cat, 
        colorscale = list(c(-1, 'rgb(0,0,255)'), c(0, 'rgb(0,0,0)'), c(1, 'rgb(255,0,0)')),
        reversescale = TRUE,
        text = ~region_name, locations = ~a3_code, marker = list(line = l)
      ) %>%
      colorbar(title = 'Regression Coefficient', tickprefix = '') %>%
      layout(
        title = "Change from 2012 - 2017",
        geo = g)
    
  })
  
  # Plot
  output$dt <- DT::renderDataTable({ temp() })
  
  # Download Selected Data
  output$download_data <- downloadHandler(
    # This function returns a string which tells the client browser what name to use when saving the file.
    filename = function() {
      paste0(
        paste(input$goal, input$dimension, input$react_ind[1], input$react_ind[2], sep = "_"),
        ".csv")
    },
    
    # This function should write data to a file given to it by the argument 'file'.
    content = function(file) {
      # Write to a file specified by the 'file' argument
      write.table(temp(), file, sep = ",", row.names = FALSE)
    }
  )
  
  # Download All Data
  output$download_all_data <- downloadHandler(
    # This function returns a string which tells the client browser what name to use when saving the file.
    filename = function() {
      paste0("all_ohi_dat", ".csv")
    },
    
    # This function should write data to a file given to it by the argument 'file'.
    content = function(file) {
      # Write to a file specified by the 'file' argument
      write.table(dat, file, sep = ",", row.names = FALSE)
    }
  )
  
}