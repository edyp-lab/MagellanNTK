# Get the last validated step before current position.

This function returns the indice of the last validated step before the
current step.

## Usage

``` r
InitializeHistory()
```

## Value

A \`data.frame()\` with four columns: 'Process', 'Step', 'Parameter' and
'Value'

## Examples

``` r
InitializeHistory()
#> [1] Process   Step      Parameter Value    
#> <0 rows> (or 0-length row.names)
```
