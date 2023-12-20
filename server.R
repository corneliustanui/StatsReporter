
# load custom functions
source("./Funs/custom_table_funs.R")

# increase capacity to load big files to 100MB
options(shiny.maxRequestSize = 100*1024^2) 

# server
server <- function(input, output, session){
  
  # import data
  data_frame <- reactive({
    req(input$data_file)
    read.csv(input$data_file$datapath)
  })
  
  observeEvent(
    eventExpr = data_frame(), 
    
    handlerExpr = {
      
      # primary_var
      choices_primary_var <- c("None", colnames(data_frame()))
      freezeReactiveValue(input, "primary_var")
      
      updateSelectInput(
        session = session,
        inputId = "primary_var",
        choices = choices_primary_var,
        selected = choices_primary_var[1]
      )
      
      # secondary_var
      choices_secondary_var <- c("None", colnames(data_frame()))
      freezeReactiveValue(input, "secondary_var")
      
      updateSelectInput(
        session = session,
        inputId = "secondary_var",
        choices = choices_secondary_var,
        selected = choices_secondary_var[1]
      )
      
      # tertiary_var
      choices_tertiary_var <- c("None", colnames(data_frame()))
      freezeReactiveValue(input, "tertiary_var")
      
      updateSelectInput(
        session = session,
        inputId = "tertiary_var",
        choices = choices_tertiary_var,
        selected = choices_tertiary_var[1]
      )
    },
    
    label = "Initialize input controls upon import of data",
    ignoreNULL = TRUE
  )
  
  observeEvent(
    eventExpr = input$primary_var, 
    
    handlerExpr = {
      req(input$primary_var)
      
      if(input$primary_var == "None"){
        shinyjs::disable("show_secondary_var")
        updateAwesomeCheckbox(session, "show_secondary_var", value = FALSE)
        
        } else if (input$primary_var != "None"){
          shinyjs::enable("show_secondary_var")
          }
      },
    
    label = "Toggle 'show_secondary_var'",
    ignoreNULL = TRUE
  )
  
  observeEvent(
    eventExpr = input$show_secondary_var, 
    
    handlerExpr = {
      if(input$show_secondary_var == FALSE){
        shinyjs::disable("secondary_var")
        } else if(input$show_secondary_var == TRUE){
          shinyjs::enable("secondary_var")
          
          choices_secondary_var <- c("None", colnames(data_frame()))
          freezeReactiveValue(input, "secondary_var")
          
          updateSelectInput(
            session = session,
            inputId = "secondary_var",
            choices = choices_secondary_var,
            selected = choices_secondary_var[1]
            )
          }
      }, 
    
    label = "Toggle 'secondary_var'",
    ignoreNULL = TRUE
  )
  
  
  observeEvent(
    eventExpr = input$secondary_var, 
    
    handlerExpr = {
      if(input$secondary_var == "None"){
        shinyjs::disable("show_tertiary_var")
        updateAwesomeCheckbox(session, "show_tertiary_var", value = FALSE)
        
        } else if(input$secondary_var != "None"){
          shinyjs::enable("show_tertiary_var")
          }
      },
    
    label = "Toggle 'show_tertiary_var'",
    ignoreNULL = TRUE
  )
  
  
  observeEvent(
    eventExpr = input$show_tertiary_var, 
    
    handlerExpr = {
      if(input$show_tertiary_var == FALSE){
        shinyjs::disable("tertiary_var")

      } else if(input$show_tertiary_var == TRUE){
        shinyjs::enable("tertiary_var")
        
        choices_tertiary_var <- c("None", colnames(data_frame()))
        freezeReactiveValue(input, "tertiary_var")
        
        updateSelectInput(
          session = session,
          inputId = "tertiary_var",
          choices = choices_tertiary_var,
          selected = choices_tertiary_var[1]
        )
      }
    },
    
    label = "Toggle 'tertiary_var'",
    ignoreNULL = TRUE
  )
  
  # generate tables when button "Run" is clicked 
  observeEvent(
    eventExpr = input$generate_report, 
    
    handlerExpr = {
      
      # output raw data table
      output$raw_table <- renderDataTable({
        DT::datatable(data_frame(),
                      selection = 'none',
                      rownames = TRUE,
                      filter = 'top',
                      extensions = c('FixedColumns'),
                      options = list(
                        searching    = TRUE,
                        scrollX      = TRUE,
                        pageLength   = 5,
                        lengthMenu = c(5, 10, 15, 20, 25),
                        FixedColumns = list(leftColumns = c(2)),
                        initComplete = JS("function(settings, json) {",
                                          "$(this.api().table().header()).css({'background-color': '#317EBD', 
                                                                                'color': 'white'});",
                                          "}")
                        )
                  )
           }
      )
      
      
      # inputs
      primaryVarName <- input$primary_var
      
      secondaryVarNameShow <- input$show_secondary_var
      secondaryVarName <- input$secondary_var
      
      tertiaryVarNameShow <- input$show_tertiary_var
      tertiaryVarName <- input$tertiary_var
      
      
      # generate summary stats tables
      if(primaryVarName ==  "None" & secondaryVarNameShow == 0){
        summary_dt_table <- NULL} 
      else if (primaryVarName !=  "None" & secondaryVarNameShow == 0){
        req(primaryVarName)
        summary_dt_table <- univar_data_summary_stats(data = data_frame(), 
                                                      var = {{primaryVarName}})} 
      else if (primaryVarName !=  "None" & secondaryVarNameShow == 1 & secondaryVarName != "None"){
        req(primaryVarName)
        req(secondaryVarNameShow)
        req(secondaryVarName)
        summary_dt_table <- bivar_data_summary_stats(data = data_frame(), 
                                                     var1 = {{primaryVarName}},
                                                     var2 = {{secondaryVarName}},
                                                     show_p_val = TRUE)
      }
      
      
      # output summary stats table
      output$dt_table <- renderTable(summary_dt_table)
      
      # download summary table
      output$download_dt_table <- downloadHandler(
        filename = function() {
          paste("Summary Table_", 
                primaryVarName, "_", 
                secondaryVarName, "_", 
                Sys.Date(), ".csv", sep="")
        },
        
        content = function(file) {
          write.csv(summary_dt_table, file, row.names = FALSE)
        }
      )
      
    },
    
    label = "Generate reports",
    ignoreNULL = TRUE
    )
  
  
  # clear tables when button "Clear Report" is clicked 
  observeEvent(
    
    eventExpr = input$clear_report,
    
    handlerExpr = {
      
      # CLEAR INPUTS
      # primary_var
      choices_primary_var <- c("None", colnames(data_frame()))
      freezeReactiveValue(input, "primary_var")
      
      updateSelectInput(
        session = session,
        inputId = "primary_var",
        choices = choices_primary_var,
        selected = choices_primary_var[1]
      )
      
      # show_secondary_var
      updateAwesomeCheckbox(session = session, 
                            inputId = "show_secondary_var", 
                            value = FALSE)
      
      # secondary_var
      choices_secondary_var <- c("None", colnames(data_frame()))
      freezeReactiveValue(input, "secondary_var")
      
      updateSelectInput(
        session = session,
        inputId = "secondary_var",
        choices = choices_secondary_var,
        selected = choices_secondary_var[1]
      )
      
      # show_tertiary_var
      updateAwesomeCheckbox(session = session, 
                            inputId = "show_tertiary_var", 
                            value = FALSE)
      
      # tertiary_var
      choices_tertiary_var <- c("None", colnames(data_frame()))
      freezeReactiveValue(input, "tertiary_var")
      
      updateSelectInput(
        session = session,
        inputId = "tertiary_var",
        choices = choices_tertiary_var,
        selected = choices_tertiary_var[1]
      )
      
      # clear outputs
      output$raw_table <- NULL
      
      output$dt_table <- renderText("No records: select variables and 'Run'")
      
      # clear report type checkbox
      updateCheckboxGroupInput(
        session = session,
        inputId = "report_type",
        selected = NA,
        inline = TRUE
      )
    },
    
    label = "Clear inputs",
    ignoreNULL = TRUE
  )
  

}
  
  
