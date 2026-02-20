# Get the last validated step before current position.

This function returns the indice of the last validated step before the
current step.

## Usage

``` r
GetMaxValidated_BeforePos(pos = NULL, rv)
```

## Arguments

- pos:

  A \`integer()\` which is the indice of the active position.

- rv:

  A \`list()\` which stores reactiveValues()

## Value

A \`integer()\`

## Examples

``` r
pos <- 3
rv <- list(steps.status = c(1,1,0,1,0,0), current.pos = 3)
GetMaxValidated_BeforePos(pos, rv)
#> [1] 2
```
