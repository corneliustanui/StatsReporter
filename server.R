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
      session = getDefaultReactiveDomain(),
      inputId = "primary_var",
      choices = choices_primary_var,
      selected = NA
    )
    
    # secondary_var
    choices_secondary_var <- colnames(data_frame())
    freezeReactiveValue(input, "secondary_var")
    
    updateSelectInput(
      session = getDefaultReactiveDomain(),
      inputId = "secondary_var",
      choices = choices_secondary_var,
      selected = NA
    )
    
    # tertiary_var
    choices_tertiary_var <- colnames(data_frame())
    freezeReactiveValue(input, "tertiary_var")
    
    updateSelectInput(
      session = getDefaultReactiveDomain(),
      inputId = "tertiary_var",
      choices = choices_tertiary_var,
      selected = NA
    )
  }
)
  
  # generate tables when button "Run" is clicked 
  observeEvent(input$generate_report, {
    
    output$raw_table <- renderDataTable(data_frame())
    

    # univariate table 
    primaryVarName <- input$primary_var
    
    dt_table1 <- univar_freq_table(data = data_frame(), 
                                   cat_var = {{primaryVarName}})
    
    output$dt_table <- renderTable(dt_table1)


    # bivariate table
    secondaryVarName <- input$secondary_var
    
    dt_table2 <- gen_col_percent(data = data_frame(),
                                 var1 = {{primaryVarName}},
                                 var2 = {{secondaryVarName}}, 
                                 show_p_val = TRUE)
    
    output$dt_table_2 <- renderTable(dt_table2)

    
    # trivariate table

    
    }
  )
  
  # clear tables when button "Clear report" is clicked 
  observeEvent(input$clear_report, {
    
    output$raw_table <- NULL
    
    output$dt_table <- renderText("No records: select variables and 'Run'")
    }
  )
  

}