library(plotly)
library(shinydashboard)
library(shinyjs)
library(tidyverse)
library(RColorBrewer)
library(DT)
library(shiny)
library(markdown)

# load data
dat <- read_csv("ohi_dat_clean.csv") # change file path beore uploading to Shiny

# load modeled data
dat_mod <- read_csv("dat_modeled.csv")

# find min/max for slider
#dat %>% group_by(dimension) %>% filter(!is.na(value)) %>% dplyr::summarise(min = min(value), max = max(value)) %>% write_csv("slider.csv")
slider <- read_csv("slider.csv")

# light grey boundaries
l <- list(color = toRGB("grey"), width = 0.5)

# specify map projection/options
g <- list(
  showframe = FALSE,
  showcoastlines = FALSE,
  projection = list(type = 'Mercator')
)
