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
history <- rbind(history, c('Example', 'Step Ex', 'ex_param', 'Ex'))
lldata[[1]] <- SetHistory(lldata[[1]], history)
```
