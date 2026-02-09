# Get the position of the last validated item

Get the position of the last validated item

## Usage

``` r
SetCurrentPosition(stepsstatus)
```

## Arguments

- stepsstatus:

  A vector of integers which reflects the status of the steps in the
  pipeline. Thus, the length of this vector is euqal to the number of
  steps

## Value

An integer

## Examples

``` r
status <- c(1,1,1,0,0)
SetCurrentPosition(status)
#> [1] 3


status <- c(1,1,0,1, 0)
SetCurrentPosition(status)
#> [1] 4
```
