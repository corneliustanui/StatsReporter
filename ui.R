# packages
library(shiny)
library(shinydashboard)

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
                  selectInput(inputId = "primary_var", 
                              label = "Select primary variable",
                              choices = c("Cat Var A", "Cat Var B", "Cat Var C", "Cat Var D"),
                              selected = NULL),
                  
                  selectInput(inputId = "secondary_var", 
                              label = "Select secondary variable",
                              choices = c("Cat Var A", "Cat Var B", "Cat Var C", "Cat Var D"),
                              selected = NULL),
                  
                  selectInput(inputId = "tertiary_var", 
                              label = "Select tertiary variable",
                              choices = c("Cat Var A", "Cat Var B", "Cat Var C", "Cat Var D"),
                              selected = NULL),
                  
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
                    tabPanel("Tables", "List of tables"),
                    tabPanel("Graphs", "List of graphs")
                    )
             )
      )
)
