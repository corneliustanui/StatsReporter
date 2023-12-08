# packages
library(shiny)
library(shinydashboard)
library(tidyverse)
library(magrittr)
library(table1)

# load data
# STIData <- read.csv("C:/Users/CORNELIUS/OneDrive/Folders/Data/STIData_Clean.csv")

# Define UI
ui <- navbarPage(
  title = strong("Stats Reporter"),
  
  tabPanel(title = NULL, icon = icon("chart-simple", lib = "font-awesome"),
           
           column(width = 4,
                  
                  h3("Import data file"),
                  fileInput(inputId = "data_file",
                            label = NULL,
                            multiple = FALSE,
                            accept = c(".csv", ".xls", ".xlsx"),
                            buttonLabel = "Browse for file",
                            placeholder = "Either csv, xls, or xlsx"),
                  
                  h3("Report Fields"),
                  varSelectInput(inputId = "primary_var", 
                                 label = "Select primary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = TRUE,
                                 width = NULL,
                                 size = NULL),
                  
                  varSelectInput(inputId = "secondary_var",
                                 label = "Select secondary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = TRUE,
                                 width = NULL,
                                 size = NULL),
                  
                  varSelectInput(inputId = "tertiary_var", 
                                 label = "Select tertiary variable",
                                 data = NULL,
                                 selected = NULL,
                                 multiple = FALSE,
                                 selectize = TRUE,
                                 width = NULL,
                                 size = NULL),
                  
                  h3("Generate report"),
                  actionButton("generate_report", "Run"),
                  
                  actionButton("clear_report", "Clear report"),
                  
                  h3("Download report"),
                  
                  checkboxGroupInput(inputId = "report_type",
                                     label = "Report file type",
                                     choices = c(".docx", ".pdf", ".html"),
                                     selected = NULL,
                                     inline = TRUE,
                                     width = NULL),
                  
                  downloadButton("download_demo_data", label = "Download")
                  
              ),
           
           column(width = 4,
                  tabsetPanel(
                    tabPanel("Data", DTOutput("raw_table")),
                    
                    tabPanel("Tables", "some tables"),
                    
                    tabPanel("Graphs", "List of graphs")
                    )
             )
      )
)
