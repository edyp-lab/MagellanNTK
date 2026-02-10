# Get datasets from packages which owns datasets of a given class

Get datasets from packages which owns datasets of a given class

## Usage

``` r
GetListDatasets(class = NULL, demo_package = NULL)
```

## Arguments

- class:

  A \`character()\` which is the class of the datasets one looking for

- demo_package:

  A \`character()\` which specifies a particular package to search

## Value

A \`vector\` in which items are the name of datasets which inherits the
class given in parameter

## Examples

``` r
foo1 <- GetListDatasets()
```
