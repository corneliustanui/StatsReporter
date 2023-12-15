
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
  
  observeEvent(data_frame(), {
    
    # primary_var
    choices_primary_var <- colnames(data_frame())
    freezeReactiveValue(input, "primary_var")
    
    updateSelectInput(
      session = session,
      inputId = "primary_var",
      choices = choices_primary_var,
      selected = NA
    )
    
    # secondary_var
    choices_secondary_var <- colnames(data_frame())
    freezeReactiveValue(input, "secondary_var")
    
    updateSelectInput(
      session = session,
      inputId = "secondary_var",
      choices = choices_secondary_var,
      selected = NA
    )
    
    # tertiary_var
    choices_tertiary_var <- colnames(data_frame())
    freezeReactiveValue(input, "tertiary_var")
    
    updateSelectInput(
      session = session,
      inputId = "tertiary_var",
      choices = choices_tertiary_var,
      selected = NA
    )
  }
)
  
  # generate tables when button "Run" is clicked 
  observeEvent(input$generate_report, {
    
    # output raw data table
    output$raw_table <- renderDataTable(data_frame())
    

    # inputs
    primaryVarName <- input$primary_var

    secondaryVarNameShow <- input$show_secondary_var
    secondaryVarName <- input$secondary_var

    tertiaryVarNameShow <- input$show_tertiary_var
    tertiaryVarName <- input$tertiary_var

    if(is.null(primaryVarName) & secondaryVarNameShow == 0){
      summary_dt_table <- NULL} 
    else if (!is.null(primaryVarName) & secondaryVarNameShow == 0){
      req(primaryVarName)
      summary_dt_table <- univar_data_summary_stats(data = data_frame(), 
                                                    var = {{primaryVarName}})} 
    else if (!is.null(primaryVarName) & secondaryVarNameShow == 1 & !is.null(secondaryVarName)){
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

    
    # trivariate table
      
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
    }
  )
  
  # clear tables when button "Clear report" is clicked 
  observeEvent(input$clear_report, {
    
    # clear inputs
    # primary_var
    choices_primary_var <- colnames(data_frame())
    freezeReactiveValue(input, "primary_var")
    
    updateSelectInput(
      session = session,
      inputId = "primary_var",
      choices = choices_primary_var,
      selected = NA
    )
    
    # show_secondary_var
    updateAwesomeCheckbox(session = session, 
                          inputId = "show_secondary_var", 
                          value = FALSE)
    
    # secondary_var
    choices_secondary_var <- colnames(data_frame())
    freezeReactiveValue(input, "secondary_var")
    
    updateSelectInput(
      session = session,
      inputId = "secondary_var",
      choices = choices_secondary_var,
      selected = NA
    )
    
    # show_tertiary_var
    updateAwesomeCheckbox(session = session, 
                          inputId = "show_tertiary_var", 
                          value = FALSE)
    
    # tertiary_var
    choices_tertiary_var <- colnames(data_frame())
    freezeReactiveValue(input, "tertiary_var")
    
    updateSelectInput(
      session = session,
      inputId = "tertiary_var",
      choices = choices_tertiary_var,
      selected = NA
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
    }
  )
  
  # clear secondary_var show_secondary_var when  = 0
  observeEvent(input$show_secondary_var == 0, {
    
    # secondary_var
    choices_secondary_var <- colnames(data_frame())
    freezeReactiveValue(input, "secondary_var")
    
    updateSelectInput(
      session = session,
      inputId = "secondary_var",
      choices = choices_secondary_var,
      selected = NA
      )
    
    # show_tertiary_var
    updateAwesomeCheckbox(session = session, 
                          inputId = "show_tertiary_var", 
                          value = FALSE)
    
    
    # tertiary_var
    choices_tertiary_var <- colnames(data_frame())
    freezeReactiveValue(input, "tertiary_var")
    
    updateSelectInput(
      session = session,
      inputId = "tertiary_var",
      choices = choices_tertiary_var,
      selected = NA
       )
    }
  )
  
  # clear tertiary_var show_tertiary_var when  = 0
  observeEvent(input$show_tertiary_var == 0, {
    
    # tertiary_var
    choices_tertiary_var <- colnames(data_frame())
    freezeReactiveValue(input, "tertiary_var")
    
    updateSelectInput(
      session = session,
      inputId = "tertiary_var",
      choices = choices_tertiary_var,
      selected = NA
      )
    }
  )

}