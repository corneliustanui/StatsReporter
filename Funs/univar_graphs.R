
# fun definition
univar_discrete_graphs <- function(data, var) {
  
  # make var available for labeling, useful outside shiny only
  # var_lab <- deparse(substitute(var))
  
  univar_discrete_graph <- data %>% 
    filter(!is.na({{var}}) & !is.null({{var}}) & {{var}} != "") %>% 
    group_by({{var}}) %>% 
    summarise(Frequency = n()) %>% 
    mutate(Pecent = round(Frequency/sum(Frequency, na.rm = TRUE)*100, 2)) %>% 
    arrange() %>% 
    ggplot(aes(x = fct_reorder({{var}}, +Pecent),
               y = Pecent,
               fill = Pecent)) +
    geom_col() +
    scale_y_continuous(labels = scales::percent_format(scale = 1)) +
    scale_x_discrete(labels = scales::label_wrap(30))+
    labs(# title = paste("Distribution of", {{var_lab}}), # used outside shiny,
         title = paste("Distribution of", {{var}}), # used inside shiny
         # x = paste("Levels of", {{var}}), # used inside shiny
         x = NULL, # used inside shiny
         # x = paste("Levels of", rlang::as_name({{var_lab}})), # used outside shiny
         y = "Percent") +
    geom_text(aes(label = paste0(Pecent, "%")),
              colour = "black",
              size = 3.5,
              vjust = -0.5) +
    
    # custom theme
    theme(plot.title = element_text(face = "bold",
                                    hjust = 0.5,
                                    size = 13.5,
                                    family = "serif",
                                    color = "black"),
          axis.title = element_text(face = "bold",
                                    size = 11.5,
                                    family = "serif",
                                    color = "black"),
          axis.text = element_text(face = "plain",
                                   size = 10,
                                   family = "serif",
                                   color = "black"),
          strip.text.x = element_text(face = "bold",
                                      size = 13.5,
                                      family = "serif",
                                      color = "black"),
          axis.text.x = element_text(angle = 25, 
                                     hjust = 1),
          legend.position = "none",
          plot.background = element_rect(fill = "white",
                                         color = "black", 
                                         linewidth = 1),
          panel.grid = element_blank(),
          panel.grid.minor.x = element_blank(),
          panel.grid.major.x = element_blank(),
          axis.line = element_line(color = "black"),
          axis.ticks = element_line(color = "black"),
          panel.background = element_blank())
  
  # return graph
  return(univar_discrete_graph)
}


# univar_discrete_graphs(data = STIData_Clean, var = Occupation)
