# Discover Skipped Steps

Discover Skipped Steps

## Usage

``` r
Discover_Skipped_Steps(steps.status)
```

## Arguments

- steps.status:

  A vector of integers which reflects the status of the steps in the
  pipeline. Thus, the length of this vector is equal to the number of
  steps

## Value

A vector of integers of the same length as steps.status and where
skipped steps are identified with '-1'

## Examples

``` r
steps <- c(1, 1, 0, 1)
Discover_Skipped_Steps(steps)
#> [1]  1  1 -1  1
```
