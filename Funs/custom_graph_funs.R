
# univariate graphs
univar_graphs <- function(data, var) {
  
  # histogram for numerical variables
  if(is.numeric(data %>% select({{var}}) %>% pull)){
    
    # calculate mean
    mean_var <- data %>% 
      select({{var}}) %>% 
      summarise(mean({{var}}, na.rm = TRUE)) %>% pull()
    
    # calculate standard deviation
    sd_var <- data %>% 
      select({{var}}) %>% 
      summarise(sd({{var}}, na.rm = TRUE)) %>% pull()
    
    univar_numeric_graph <- data %>% 
      filter(!is.na({{var}}) & !is.null({{var}}) & {{var}} != "") %>% 
      ggplot(aes(x = {{var}})) +
      geom_histogram(aes(y = after_stat(density)),
                     fill = 'cornflowerblue',
                     color = "white") +
      geom_density(aes(color = "Simulated"),
                   linewidth = 0.8,
                   key_glyph = "rect",
                   lty = 1) +
      stat_function(aes(color = 'Normal Curve'),
                    fun = dnorm, args = list(mean = mean_var, 
                                             sd = sd_var),
                    linewidth = 0.7, lty = 1) +
      geom_vline(aes(xintercept = mean({{var}})),
                 color = 'black', linewidth = 0.7, lty = 1) +
      scale_colour_manual("Density", values = c("black", "#DA9100")) +
      labs(title = paste("Distribution of", {{var}}),
           # x = NULL,
           x = paste("Bins of", {{var}}),
           y = "Density") + 
      
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
            axis.text.x = element_text(angle = 0, 
                                       hjust = 1),
            
            legend.position = "top",
            legend.title = element_blank(), 
            legend.text = element_text(face = "plain",
                                       size = 10,
                                       family = "serif",
                                       color = "black"),
            legend.key = element_rect(colour = "transparent", 
                                      fill = "white"),
            legend.box = "horizontal",
            legend.key.size = unit(0.5, 'cm'),
            legend.spacing.x = unit(0.1, 'cm'),
            legend.background = element_blank(),
            
            
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
    return(univar_numeric_graph)
    
    # bar graph for categorical variables
    }else if(!is.numeric(data %>% select({{var}}) %>% pull)){
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
      labs(title = paste("Distribution of", {{var}}), 
           x = NULL,
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
}
