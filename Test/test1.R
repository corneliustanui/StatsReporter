options(renv.verbose = FALSE)
deps <- renv::dependencies(getwd())
renv::snapshot(getwd(), packages = deps$Package, prompt = FALSE)
#> Error in renv_snapshot_validate_report(valid, prompt, force) : 
#>   aborting snapshot due to pre-flight validation failure
options(renv.verbose = NULL)
renv::snapshot(getwd(), packages = deps$Package, prompt = FALSE)