
# load scripts
source("Funs/custom_table_funs.R")
source("ui.R")
source("server.R")

# Preview the app
shinyApp(ui = ui, server = server)