library(readxl)
library(table1)

STIData <- read_excel("C:/Users/CORNELIUS/OneDrive/Folders/Data/STIData.xlsx")


# generate p-values
pvalue <- function(x, ...) {
  # Construct vectors of data y, and groups (strata) g
  y <- unlist(x)
  g <- factor(rep(1:length(x), times = sapply(x, length)))
  if (is.numeric(y)) {
    # For numeric variables, perform a standard 2-sample t-test
    p <- kruskal.test(y ~ g)$p.value
  } else {
    # For categorical variables, perform a chi-squared test of independence
    p <- chisq.test(table(y, g))$p.value
  }
  
  # Format the p-value, using an HTML entity for the less-than sign.
  # The initial empty string places the output on the line below the variable label.
  c("", sub("<", "&lt;", format.pval(p, digits = 3, eps = 0.001)))
}

STIData1 <- STIData %>% 
  filter(CaseStatus != 3 & !is.na(Sex...47)) %>% 
  select(`Case Status` = CaseStatus,
         Age = A1Age,
         `Level of Education` = A4LevelOfEducation,
         Sex = Sex...47) %>% 
  mutate(`Level of Education` = stringr::str_remove(`Level of Education`, "\\d"),
         `Level of Education` = stringr::str_to_sentence(`Level of Education`))

write.csv(x = STIData1,
          file = "C:/Users/CORNELIUS/OneDrive/Folders/Data/STIData_Clean.csv",
          row.names = FALSE)

caption  <- "STI Case Status"
# footnote <- "ᵃ Also known as Breslow thickness"
footnote = "ᵃ P-values for numeric variables are derived from Kruskal-Wallis test, while p-values for categorical variables are from Pearson's Chi-square test."

# tab1 ----
tab1 <- table1::table1(
  ~ Age + `Level of Education`, 
  data = STIData1,
  overall = c(right = "Total"),
  render.missing = NULL,
  render.categorical = "FREQ (PCTnoNA%)",
  droplevels = TRUE
)

# tab2 ----
tab2 <- table1::table1(
  ~ Age + `Level of Education` | `Case Status`, 
  data = STIData1,
  overall = c(right = "Total"),
  render.missing = NULL,
  render.categorical = "FREQ (PCTnoNA%)",
  extra.col = list(`P-value` = pvalue),
  droplevels = TRUE
)


# tab3 ----
tab3 <- table1::table1(
  ~ Age + `Level of Education` | `Case Status` + Sex, 
  data = STIData1,
  overall = c(right = "Total"),
  render.missing = NULL,
  render.categorical = "FREQ (PCTnoNA%)",
  extra.col = list(`P-value` = pvalue),
  droplevels = TRUE
)

# tab2 ----
tab2 <- table1::table1(
  ~ `Level of Education` | `Case Status`, 
  data = STIData1,
  overall = c(right = "Total"),
  render.missing = NULL,
  render.categorical = "FREQ (PCTnoNA%)",
  extra.col = list(`P-value` = pvalue),
  droplevels = TRUE
) %>%
  tibble::as_tibble() %>%
  gt::gt() %>%
  gt::tab_footnote(
    footnote = "P-values for numeric variables are derived from Kruskal-Wallis test, while p-values for categorical variables are from Pearson's Chi-square test.",
    locations = gt::cells_column_labels(columns = `P-value`)
  ) %>%
  gt::tab_options(
    table.font.names = "times",
    table.font.size = gt::px(10),
    data_row.padding = gt::px(.5),
    table.border.bottom.style = "hidden",
    footnotes.font.size = gt::px(8)
  )
