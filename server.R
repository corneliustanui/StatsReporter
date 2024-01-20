
# load custom functions
source("./Funs/custom_table_funs.R")
source("./Funs/custom_graph_funs.R")

# increase capacity to load big files to 100MB
options(shiny.maxRequestSize = 500*1024^2) 

# server
server <- function(input, output, session){
  
  # import data
  data_frame <- reactive({
    req(input$data_file)
    
    inFile <- input$data_file
    
    # read .rds
    if (endsWith(inFile$name, '.rds')){
      data_frame <- readRDS(input$data_file$datapath) %>% as.data.frame()
      return(data_frame) 
      
      # read .csv
    } else if (endsWith(inFile$name, '.csv')){
      data_frame <- read.csv(input$data_file$datapath) %>% as.data.frame()
      return(data_frame)
      
      # read .xls or .xlsx
    } else if (endsWith(inFile$name, '.xlsx') | endsWith(inFile$name, '.xls')){
      data_frame <- read_excel(input$data_file$datapath) %>% as.data.frame()
      return(data_frame)
      
      # read .dta
    } else if (endsWith(inFile$name, '.dta')){
      data_frame <- read_dta(input$data_file$datapath) %>% as.data.frame()
      
      # remove labels
      data_frame <- sapply(data_frame, haven::zap_label) %>% as.data.frame()
      
      return(data_frame)}
    
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
                        lengthMenu = c(2, 3, 5, 10, 15, 20, 25),
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
      observeEvent(
        
        eventExpr = input$table_type,
        
        handlerExpr = {
          if (input$table_type == ".csv"){
            
            # 1) Default .csv table
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
            
            # 2) .pdf table
          } else if (input$table_type == ".pdf"){
            output$download_dt_table <- downloadHandler(
              file = function() {
                paste("Summary Table_", 
                      primaryVarName, "_", 
                      secondaryVarName, "_", 
                      Sys.Date(), ".pdf", sep="")
              },
              
              content = function(file) {
                pdf(file = file)
                grid.table(summary_dt_table)
                dev.off()
              }
            )
            
            # 3) .html table
          } else if (input$table_type == ".html"){
            output$download_dt_table <- downloadHandler(
              file = function() {
                paste("Summary Table_", 
                      primaryVarName, "_", 
                      secondaryVarName, "_", 
                      Sys.Date(), ".html", sep="")
              },
              
              content = function(file) {
                print(xtable(x = summary_dt_table), 
                      type = "html", 
                      file = file,
                      include.rownames = FALSE, 
                      html.table.attributes = "class = 'table-bordered'")
                
              }
            )
          } 
        },
        
        label = "Download tables",
        ignoreNULL = TRUE
      )
      
      # copy summary table
      
      
      # generate graphs
      summaryGraph <- univar_graphs(data = data_frame(), 
                                    var = {{primaryVarName}})
      # output summary stats graph
      output$summary_graph <- renderPlot({summaryGraph})
      
      # download summary graph
      observeEvent(
        eventExpr = input$graph_type,
        
        handlerExpr = {
          if (input$graph_type == ".png"){
            # req(input$graph_type)
            
            # 1) Default PNG graph
            output$download_dt_graph <- downloadHandler(
              filename = function(){paste0("Summary Graph_",
                                           primaryVarName, "_",
                                           Sys.Date(), ".png")},
              
              content = function(file){ggsave(filename = file,
                                              plot = summaryGraph,
                                              width = 20,
                                              height = 10,
                                              units = "cm",
                                              dpi = 320)})
            
            # 2) PDF graph
          } else if (input$graph_type == ".pdf"){
            output$download_dt_graph <- downloadHandler(
              
              filename = function(){paste0("Summary Graph_",
                                           primaryVarName, "_",
                                           Sys.Date(), ".pdf")},
              
              content = function(file){ggsave(filename = file,
                                              plot = summaryGraph,
                                              width = 20,
                                              height = 10,
                                              units = "cm",
                                              dpi = 320)})
            
            # 3) SVG graph
          } else if (input$graph_type == ".svg"){
            
            output$download_dt_graph <- downloadHandler(
              
              filename = function(){paste0("Summary Graph_",
                                           primaryVarName, "_",
                                           Sys.Date(), ".svg")},
              
              content = function(file){ggsave(filename = file,
                                              plot = summaryGraph,
                                              device = "svg",
                                              width = 20,
                                              height = 10,
                                              units = "cm",
                                              dpi = 320)})
          }
        },
        
        label = "Download graphs",
        ignoreNULL = TRUE
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
      
      output$summary_graph <- NULL
      
      # clear report type checkbox
      updateRadioButtons(
        session = session,
        inputId = "table_type",
        selected = ".csv",
        inline = TRUE
      )
      
      # clear report type checkbox
      updateRadioButtons(
        session = session,
        inputId = "graph_type",
        selected = ".png",
        inline = TRUE
      )
    },
    
    label = "Clear inputs",
    ignoreNULL = TRUE
  )
  
}


