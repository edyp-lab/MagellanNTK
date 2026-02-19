# Standardize names

Standardize names

## Usage

``` r
SetHistory(obj.se, history)
```

## Arguments

- obj.se:

  An instance of the class \`SummarizedExperiment\`

- history:

  A \`data.frame()\`

## Author

Samuel Wieczorek

## Examples

``` r
data(lldata)
history <- GetHistory(lldata, 1)
#> Called from: GetHistory(lldata, 1)
#> debug: if (x == "Description") {
#>     if ("Convert" %in% names(dataIn)) 
#>         history <- S4Vectors::metadata(dataIn[["Convert"]])[["history"]]
#> } else if (x == "Save") {
#>     history <- NULL
#> } else if (x %in% names(dataIn)) {
#>     history <- DaparToolshed::GetHistory(dataIn[[x]])
#> }
#> Error in GetHistory(lldata, 1): object 'x' not found
history <- rbind(history, c('Example', 'Step Ex', 'ex_param', 'Ex'))
#> Error in rbind(history, c("Example", "Step Ex", "ex_param", "Ex")): cannot coerce type 'closure' to vector of type 'list'
lldata[[1]] <- SetHistory(lldata[[1]], history)
```
