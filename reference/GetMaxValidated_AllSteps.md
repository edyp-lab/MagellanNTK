# Get the last validated step

This function returns the indice of the last validated step among all
the steps

## Usage

``` r
GetMaxValidated_AllSteps(steps.status)
```

## Arguments

- steps.status:

  A vector of strings where each item is the status of a step. The
  length of this vector is the same of the number of steps.

## Value

A \`integer(1)\` which is the indice of the value

## Examples

``` r
GetMaxValidated_AllSteps(c(1,1,0,1,0,0))
#> [1] 4
```
