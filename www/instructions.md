> The panel on the left contains input controls that allow the user to import data and select variables on which analyses are to be performed. The following simple 5 steps outline this process: -

##### **Step 1: Import Data**

Load the data file (this can be `.rds`, `.csv`, `.xls`, `.xlsx`, or `.dta`) using the ***Import Data*** prompt. It is the responsibility of the analyst to ensure the [data is tidy](https://r4ds.had.co.nz/tidy-data.html) before running the analysis on this app.

Note: Loading `.dta` files is generally discouraged. Convert the files first to any of the other formats listed above.

##### **Step 2: View Data**

Click ***Run*** to display the imported data in the ***Data*** tab. Optionally, use ***Clear Report*** to clear the ***Data***, as well as all the tabs and the input controls.

##### **Step 3: Generate Univariate Summary Tables & Graphs**

Using the ***Select primary variable***, pick a variable of your interest -- this can be categorical or numerical -- click the blue ***Run*** button, and navigate to the ***Tables*** tab to view the table of summary statistics generated. This is the so called univariate analysis as it entails only one variable. Navigate to the ***Graphs*** tab to see figures generated upon clicking ***Run***, corresponding to the summary tables generated as a result of the various possible variable selections. The summary table and graph can be downloaded by clicking the ***Download*** button below the table or graph, in `.csv`, `.pdf`, or `.htlm`, and `.png`, `.pdf`, or `.svg` formats respectively.

##### **Step 4: Generate Bivariate Summary Tables & Graphs**

Using the ***Select secondary variable***, pick a variable of your interest -- this can <u><mark>only</mark></u> be categorical -- click ***Run***, and navigate to the ***Tables*** tab to view the table of summary statistics generated. This is the so called bivariate analysis as it entails two variables. A contingency table is generated if both primary and secondary variables are categorical, and hence a test of association is performed, using a Chi-square test with [Yate's continuity correction](https://sphweb.bumc.bu.edu/otlt/mph-modules/ph717-quantcore/r-for-ph717/R-for-PH71713.html). In the event that the primary variable is numerical and secondary variable is categorical, the the statistical test performed is Kruskal-Wallis, which tests the null hypothesis that medians of the numerical primary variable are the equal for at least two groups of the secondary categorical variable. This is the non-parametric equivalent of One-Way ANOVA. The analyst should ensure accurate interpretation of the results, given that the application of non-parametric tests is preferred to parametric tests in this context.

##### **Step 5: Generate Trivariate Summary Tables & Graphs**

(TODO: Implementation in progress!) Using the ***Select tertiary variable***, pick a variable of your interest -- this can <u><mark>only</mark></u> be categorical -- click ***Run***, and navigate to the ***Tables*** tab to view the table of summary statistics generated. This is the so called multivariate (specifically trivariate) analysis as it entails three variables. A contingency table is generated if the primary, the secondary, and the tertiary variables are all categorical, and hence a test of association is performed, using a Chi-square test with [Yate's continuity correction](https://sphweb.bumc.bu.edu/otlt/mph-modules/ph717-quantcore/r-for-ph717/R-for-PH71713.html) but on only primary variable and the overall frequencies of both the secondary and the tertiary variables (row totals, which essentially are equivalent to the frequencies of the tertiary variables). In the event that the primary variable is numerical and both the secondary and tertiary variables are categorical, the the statistical test performed is Kruskal-Wallis, which tests the null hypothesis that medians of the numerical primary variable are the equal for at least two groups each of the secondary and tertiary categorical variable. This is the non-parametric equivalent of Two-Way ANOVA. The analyst should ensure accurate interpretation of the results, given that the application of non-parametric tests is preferred to parametric tests in this context. TODO: Implement tests of interaction effects.

<footer id = "footer"> <a id = "copyright" style = "margin: 0 auto; display:block; text-align: center"> © 2023 - 2024 by Cornelius Tanui </a> </footer>
