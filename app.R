
# load scripts
source("ui.R")
source("server.R")

# Preview the app
shinyApp(ui = ui, server = server)