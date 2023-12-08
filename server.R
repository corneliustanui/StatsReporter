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
      choices = choices_primary_var
    )
    
    # secondary_var
    choices_secondary_var <- colnames(data_frame())
    freezeReactiveValue(input, "secondary_var")
    
    updateSelectInput(
      session = getDefaultReactiveDomain(),
      inputId = "secondary_var",
      choices = choices_secondary_var
    )
    
    # tertiary_var
    choices_tertiary_var <- colnames(data_frame())
    freezeReactiveValue(input, "tertiary_var")
    
    updateSelectInput(
      session = getDefaultReactiveDomain(),
      inputId = "tertiary_var",
      choices = choices_tertiary_var
    )
  }
)
  
  # generate tables when button "Run" is clicked 
  observeEvent(input$generate_report, {
    
    output$raw_table <- renderDataTable(data_frame())
    }
  )
  
  # clear tables when button "Clear report" is clicked 
  observeEvent(input$clear_report, {
    
    output$raw_table <- NULL
    }
  )
  

}