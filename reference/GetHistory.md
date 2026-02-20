# Get the history of an assay

Get the history of an assay

## Usage

``` r
GetHistory(dataIn, name)
```

## Arguments

- dataIn:

  An instance of \`MultiAssayExperiment\` class

- name:

  The name of a slot in the object

## Value

A \`data.frame()\`

## Examples

``` r
data(lldata123)
GetHistory(lldata123, 'Clustering')
#>          Process           Step   Parameter  Value
#> 1        Convert        Convert           -   Init
#> 2 DataGeneration DataGeneration   SD choice      1
#> 3  Preprocessing      Filtering        Type   Mean
#> 4  Preprocessing      Filtering    Operator     <=
#> 5  Preprocessing      Filtering       Value     10
#> 6  Preprocessing  Normalization        Type    Sum
#> 7     Clustering     Clustering      Method kmeans
#> 8     Clustering     Clustering Nb clusters      2
```
