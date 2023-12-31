library(rsconnect)

# a function to stop the script when one of the variables cannot be found
# and to strip quotation marks from the secrets when you supplied them
error_on_missing_name <- function(name) {
  var <- Sys.getenv(name, unset = NA)
  if(is.na(var)) {
    stop(paste0("cannot find ", name, " !"), call. = FALSE)
  }
  gsub("\"", "", var)
}

# Authenticate
setAccountInfo(name = error_on_missing_name("SHINY_ACC_NAME"),
               token = error_on_missing_name("TOKEN"),
               secret = error_on_missing_name("SECRET"))

# Deploy the application.
deployApp(appFiles = c('www/about.md',
                       'www/instructions.md',
                       
                       'www/primary_table.png',
                       'www/secondary_table.png',
                       'www/tertiary_table.png',
                       
                       'Funs/custom_table_funs.R',
                       'Funs/custom_graph_funs.R',
                       
                       'ui.R', 
                       'server.R',
                       'app.R'),
          appName = error_on_missing_name("MASTERNAME"),
          forceUpdate = TRUE)
