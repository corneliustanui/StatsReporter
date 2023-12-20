# packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(shinyjs)
library(tidyverse)
library(magrittr)
library(DT)
library(renv)
library(markdown)


# Define UI
ui <- navbarPage(
  
  useShinyjs(),
  
  title = strong("Stats Reporter"),
  
  tabPanel(title = "Home", 
           icon = icon("home"),
           
           column(width = 12),
           
           
           htmltools::includeMarkdown("./www/about.md")),
  
  tabPanel(title = "Stats", 
           icon = icon("chart-simple"),
           
           column(width = 3,
                  
                  style = "background-color:#C8E9E9;
                           border-style:inset;
                           border-top-color: #32a1ce;
                           border-left-color: #32a1ce;
                           border-width:3px;
                           border-radius:2%;
                           font-size:13px;
                           border-bottom-width: 15px;
                           border-bottom-color: #C8E9E9;
                           border-right-color: #C8E9E9;",
                  
                  h3("Import Data"),
                  
                  fileInput(inputId = "data_file",
                            label = NULL,
                            multiple = FALSE,
                            accept = ".csv",
                            buttonLabel = "Browse for file",
                            placeholder = "Only .csv files",
                            width = "270px"),
                  
                  h3("Report Fields"),
                  varSelectInput(inputId = "primary_var", 
                                 label = "Select primary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = FALSE,
                                 width = "270px",
                                 size = "0.5px"),
                  
                  awesomeCheckbox(inputId = "show_secondary_var", 
                                  label = "Add a secondary variable?", 
                                  value = FALSE),
                  
                  varSelectInput(inputId = "secondary_var",
                                 label = "Select secondary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = FALSE,
                                 width = "270px",
                                 size = "0.5px"),
                  
                  awesomeCheckbox(inputId = "show_tertiary_var", 
                                  label = "Add a tertiary variable?", 
                                  value = FALSE),
                  
                  varSelectInput(inputId = "tertiary_var", 
                                 label = "Select tertiary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = FALSE,
                                 width = "270px",
                                 size = "0.5px"),
                  
                  h3("Generate Report"),
                  actionButton(inputId = "generate_report", 
                               label = "Run",
                               icon = icon ("play"),
                               style = "background-color:#317EBD;
                                        color:white;
                                        border-color:#BEBEBE;
                                        border-style:none;
                                        border-width:3px;
                                        border-radius:2%;
                                        font-size:13px;"),
                  
                  actionBttn(inputId = "clear_report",
                             label = "Clear Report",
                             icon = icon("eraser"),
                             style = "stretch",
                             color = "success",
                             size = "sm",
                             block = FALSE,
                             no_outline = FALSE)
                  ),
           
           column(width = 9,
                  
                  tabsetPanel(
                    tabPanel(strong("Instructions"), 
                             
                             icon = icon ("circle-info"),
                             
                             htmltools::includeMarkdown("./www/instructions.md")),
                    
                    
                    tabPanel(strong("Data"), 
                             
                             icon = icon ("database"),
                             
                             div(DT::dataTableOutput("raw_table") %>% 
                                   withSpinner(
                                     type = 6, 
                                     size = 0.5,
                                     color = "#317EBD"
                                   ),
                                 style = "font-size: 70%; width:100%; margin:auto")),
                    
                    tabPanel(strong("Tables"), 
                             
                             icon = icon ("table"),
                             
                             br(),
                             
                             div(tableOutput("dt_table") %>% 
                                   withSpinner(
                                     type = 6, 
                                     size = 0.5,
                                     color = "#317EBD"
                                   ), 
                                 style = "font-size: 70%; width: 70%"),
                             
                             checkboxGroupInput(inputId = "report_type",
                                                label = "Report file type",
                                                choices = c(".csv", ".docx", ".pdf", ".html"),
                                                selected = NULL,
                                                inline = TRUE,
                                                width = NULL),
                             
                             downloadButton("download_dt_table", 
                                            label = "Download",
                                            style = "background-color:#317EBD;
                                                     color:white;
                                                     border-color:#BEBEBE;
                                                     border-style:none;
                                                     border-width:3px;
                                                     border-radius:2%;
                                                     font-size:13px;")
                             
                    ),
                    
                    tabPanel(strong("Graphs"), 
                             
                             icon = icon ("magnifying-glass-chart"), 
                             br(),
                             
                             div(tableOutput("dt_graph"), 
                                 style = "font-size: 70%; width: 70%"),
                             
                             checkboxGroupInput(inputId = "graph_type",
                                                label = "Graph file type",
                                                choices = c(".png", ".svg"),
                                                selected = NULL,
                                                inline = TRUE,
                                                width = NULL),
                             
                             downloadButton("download_dt_graph", 
                                            label = "Download",
                                            style = "background-color:#317EBD;
                                                     color:white;
                                                     border-color:#BEBEBE;
                                                     border-style:none;
                                                     border-width:3px;
                                                     border-radius:2%;
                                                     font-size:13px;")
                             )
                      )
              )
       )
)
