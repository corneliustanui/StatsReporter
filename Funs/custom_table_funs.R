
# 1) table of univariate statistics ####  
univar_freq_table <- function(data, cat_var){
  
  # generate frequencies and percentages
  raw_table1 <- data %>% 
    group_by({{cat_var}}) %>% 
    summarise(Frequency = n()) %>% 
    mutate(Percent = paste0(round(Frequency/sum(Frequency) * 100, digits = 2), "%")) %>% 
    arrange(-Frequency)
  
  # add totals
  raw_table2 <- data.frame(0)
  
  raw_table2 <- raw_table2 %>% 
    mutate({{cat_var}} := "Total",
           Frequency = sum(raw_table1$Frequency),
           Percent = "100%")
  
  raw_table3 <- bind_rows(raw_table1, raw_table2) %>% 
    select(-X0) %>% 
    as.data.frame()
  
  return(raw_table3)
}


# 2) table of bivariate statistics ####  
gen_col_percent <- function(data, var1, var2, show_p_val = FALSE){
  
  # cell frequencies 
  raw_table1 <- data %>% 
    group_by({{var1}}, {{var2}}) %>% 
    summarise(Frequency = n(), .groups = "keep")
  
  # var1 totals
  raw_table2 <- data %>% 
    group_by({{var1}}) %>% 
    summarise(Frequency = n(), .groups = "keep") %>% 
    mutate({{var2}} := "Total")
  
  # var2 totals
  raw_table3 <- data %>% 
    group_by({{var2}}) %>% 
    summarise(Frequency = n(), .groups = "keep") %>% 
    mutate({{var1}} := "Total")
  
  # overall totals
  raw_table4 <- data %>% 
    group_by({{var1}}, {{var2}}) %>% 
    summarise(Frequency = n(), .groups = "keep") %>% 
    mutate({{var1}} := "Total",
           {{var2}} := "Total") %>% 
    group_by({{var1}}, {{var2}}) %>% 
    summarise(Frequency = sum(Frequency), .groups = "keep")
  
  # combine raw mini-tables
  final_table_long <- bind_rows(raw_table1, raw_table2, raw_table3, raw_table4)
  
  # transform long to wide
  final_table_wide <- final_table_long %>% 
    pivot_wider(names_from = {{var2}}, values_from = Frequency) %>% 
    as.data.frame()
  
  # col totals
  col_totals <- final_table_wide[nrow(final_table_wide), ]
  
  # proportions table
  col_percent_table <- final_table_wide
  
  # number of columns
  cols <- ncol(final_table_wide)
  
  # combine freq and percent, and replace NA(NA%) with "-"
  for (i in 2:cols){
    col_percent_table[, i] <- paste0(col_percent_table[, i], 
                                     "(", 
                                     round((col_percent_table[, i]/col_totals[, i])*100, 2), 
                                     "%)")
    col_percent_table[, i] <- stringr::str_replace_all(col_percent_table[, i], "NA\\(NA\\%\\)", "-")
    
  }
  col_percent_table <- as.data.frame(col_percent_table)
  
  
  # test hypothesis
  test_dat <- data %>% 
    select({{var1}}, {{var2}}) %>% 
    as.data.frame()
  
  association_test <- chisq.test(test_dat[[1]], test_dat[[2]])
  
  Hypothesis <- c(paste0("Test: ", association_test$method),
                  paste0("Statistic: ", round(association_test$statistic, 3)),
                  paste0("P-value: ", round(association_test$p.value, 3)))
  
  col_percent_table_p_val <- col_percent_table
  
  col_percent_table_p_val$`Test Hypothesis` <- c(Hypothesis, rep("", length.out = nrow(col_percent_table) - 3))
  
  
  # return table
  if (show_p_val == TRUE){
    
    return(col_percent_table_p_val)
  } else {
    return(col_percent_table)
  }
  
}



