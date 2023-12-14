# packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(tidyverse)
library(magrittr)
library(DT)
library(renv)

# Define UI
ui <- navbarPage(
  title = strong("Stats Reporter"),
  
  tabPanel(title = NULL, 
           icon = icon("chart-simple"),

           column(width = 4,
                  
                  h3("Import data file"),
                  fileInput(inputId = "data_file",
                            label = NULL,
                            multiple = FALSE,
                            accept = ".csv",
                            buttonLabel = "Browse for file",
                            placeholder = "Only .csv files"),
                  
                  h3("Report Fields"),
                  varSelectInput(inputId = "primary_var", 
                                 label = "Select primary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = TRUE,
                                 width = NULL,
                                 size = NULL),
                  
                  awesomeCheckbox("show_secondary_var", label = "Add a grouping variable?", value = FALSE),
                  
                  conditionalPanel(
                    
                    condition = "input.show_secondary_var == true",
                    
                    varSelectInput(inputId = "secondary_var",
                                   label = "Select secondary variable",
                                   data = NULL,
                                   selected = NULL,
                                   multiple = FALSE,
                                   selectize = TRUE,
                                   width = NULL,
                                   size = NULL),
                    
                    awesomeCheckbox("show_tertiary_var", label = "Add a second variable?", value = FALSE),
                    
                    conditionalPanel(
                      condition = "input.show_tertiary_var == true",
                      
                      varSelectInput(inputId = "tertiary_var", 
                                     label = "Select tertiary variable",
                                     data = NULL,
                                     selected = NULL,
                                     multiple = FALSE,
                                     selectize = TRUE,
                                     width = NULL,
                                     size = NULL)
                    )
                  ),

                  h3("Generate report"),
                  actionButton(inputId = "generate_report", 
                               label = "Run",
                               icon = icon ("play"),
                               style = "background-color:#317EBD;
                                        color:#FFFFF7;
                                        border-color:#BEBEBE;
                                        border-style:none;
                                        border-width:0px;
                                        border-radius:7%;
                                        font-size:13px;
                                        width:30#"),
                  
                  actionBttn(inputId = "clear_report",
                             label = "Clear report",
                             icon = icon("eraser"),
                             style = "stretch",
                             color = "success",
                             size = "sm",
                             block = FALSE,
                             no_outline = FALSE)
                  
           ),
           
           column(width = 8,
                  tabsetPanel(
                    tabPanel(strong("Data"), 
                             
                             icon = icon ("clipboard-list"),
                             
                             div(DT::dataTableOutput("raw_table"), 
                                 style = "font-size: 70%; width: 70%")),

                    tabPanel(strong("Tables"), 
                             
                             icon = icon ("lightbulb"),
                             
                             h3("Download report"),
                             
                             checkboxGroupInput(inputId = "report_type",
                                                label = "Report file type",
                                                choices = c(".docx", ".pdf", ".html"),
                                                selected = NULL,
                                                inline = TRUE,
                                                width = NULL),
                             
                             downloadButton("download_dt_table", label = "Download"),

                             div(tableOutput("dt_table"), 
                                 style = "font-size: 70%; width: 70%")
                             
                             ),
                    
                    tabPanel(strong("Graphs"), 
                             icon = icon ("magnifying-glass-chart"), 
                             "List of graphs")
                    )
             )
      )
)
