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
#> Loading required namespace: MultiAssayExperiment
#> Warning: replacing previous import ‘S4Arrays::makeNindexFromArrayViewport’ by ‘DelayedArray::makeNindexFromArrayViewport’ when loading ‘SummarizedExperiment’
history <- rbind(history, c('Example', 'Step Ex', 'ex_param', 'Ex'))
lldata[[1]] <- SetHistory(lldata[[1]], history)
#> Warning: 'experiments' dropped; see 'drops()'
```
