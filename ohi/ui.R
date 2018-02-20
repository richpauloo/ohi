library(plotly)
library(shinydashboard)
library(shinyjs)
library(tidyverse)
library(RColorBrewer)
library(DT)
library(shiny)

ui <- 
  dashboardPage(skin = "black", 
               
    dashboardHeader(title = "Ocean Health Index", titleWidth = 300),
    
    # sidebar panels for 'goal' and 'dimension'
    dashboardSidebar(width = 300,
                     
      radioButtons("goal", 
                   label = "Goal", 
                   choices = c('Artisanal opportunities' = 'AO',
                               'Biodiversity' = 'BD',
                               'Coastal Protection' = 'CP',
                               'Carbon Storage' = 'CS',
                               'Clean Water' = 'CW',
                               #'Economies' = 'ECO',
                               #'Fisheries' = 'FIS',
                               'Food provision' = 'FP',
                               #'Habitat' = 'HAB',
                               #'Iconic species' = 'ICO',
                               #'Index' = 'Index',
                               'Livlihoods & economies' = 'LE',
                               #'Livlihoods' = 'LIV',
                               #'Lasting special places' = 'LSP',
                               'Mariculture' = 'MAR',
                               'Natural products' = 'NP',
                               'Sense of Place' = 'SP',
                               #'Species condition' = 'SPP',
                               'Tourism & Recreation' = 'TR'),
                   selected = c("CW")),
      radioButtons("dimension", 
                   label = "Dimension",
                   choices = c('future' = 'future','pressures' = 'pressures','resilience' = 'resilience',
                               'score' = 'score','status' = 'status','trend' = 'trend'),
                   selected = "score"),
      
      # sliders for 'value' are conditional on the selected 'dimension'
      
      conditionalPanel(
          condition = "input.dimension == 'future'",
          sliderInput("v_1", label = "Value",
                      min = slider$min[slider$dimension == "future"],
                      max = slider$max[slider$dimension == "future"],
                      value = c(slider$min[slider$dimension == "future"], 
                                slider$max[slider$dimension == "future"]),
                      step = 1)),
        
        conditionalPanel(
          condition = "input.dimension == 'pressures'",
          sliderInput("v_2", label = "Value",
                      min = slider$min[slider$dimension == "pressures"],
                      max = slider$max[slider$dimension == "pressures"],
                      value = c(slider$min[slider$dimension == "pressures"], 
                                slider$max[slider$dimension == "pressures"]),
                      step = 1)),
        
        conditionalPanel(
          condition = "input.dimension == 'resilience'",
          sliderInput("v_3", label = "Value",
                      min = slider$min[slider$dimension == "resilience"],
                      max = slider$max[slider$dimension == "resilience"],
                      value = c(slider$min[slider$dimension == "resilience"], 
                                slider$max[slider$dimension == "resilience"]),
                      step = 1)),
      
        conditionalPanel(
          condition = "input.dimension == 'score'",
          sliderInput("v_4", label = "Value",
                      min = slider$min[slider$dimension == "score"],
                      max = slider$max[slider$dimension == "score"],
                      value = c(slider$min[slider$dimension == "score"], 
                                slider$max[slider$dimension == "score"]),
                      step = 0.1)),
        
        conditionalPanel(
          condition = "input.dimension == 'status'",
          sliderInput("v_5", label = "Value",
                      min = slider$min[slider$dimension == "status"],
                      max = slider$max[slider$dimension == "status"],
                      value = c(slider$min[slider$dimension == "status"], 
                                slider$max[slider$dimension == "status"]),
                      step = 1)),
        
        conditionalPanel(
          condition = "input.dimension == 'trend'",
          sliderInput("v_6", label = "Value",
                      min = slider$min[slider$dimension == "trend"],
                      max = slider$max[slider$dimension == "trend"],
                      value = c(slider$min[slider$dimension == "trend"], 
                                slider$max[slider$dimension == "trend"]),
                      step = 1))
      ),
    

    
    # Body
    dashboardBody(
      tags$head( tags$style(HTML("
                        blockquote {
                        padding: 10px 20px;
                        margin: 0 0 20px;
                        font-size: 13px;
                        border-left: 5px solid #eee;
                        }
                        "))),
      fluidRow(
        tabBox(width = 12, height = NULL,
               tabPanel("Map", value = 1,
                        tags$style(type = "text/css", "#map {height: calc(100vh - 100px) !important;}"),
                        plotlyOutput("map")),
               tabPanel("5 year change", value = 2,
               tags$style(type = "text/css", "#map {height: calc(100vh - 100px) !important;}"),
               plotlyOutput("map_mod")),
               tabPanel("Data", 
                        fluidRow(
                        column(width = 12,
                               box(title = NULL, width = NULL,
                                   DT::dataTableOutput("dt")),
                                 box(title = "Download Data", width = NULL,
                                     downloadButton("download_data", "Download Selected Data"),
                                     tags$br(),
                                     tags$br(),
                                     downloadButton("download_all_data", "Download All Data")))
                        )),
               tabPanel(title = "About", 
                        includeMarkdown("about.md"))
               )
        )
      )
    )
  

