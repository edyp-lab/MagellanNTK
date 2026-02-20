# Updates the status of steps in a given range

Updates the status of steps in a given range

## Usage

``` r
ToggleState_Screens(cond, range, is.enabled, rv)
```

## Arguments

- cond:

  A \`boolean\`

- range:

  A \`vector\` of integers. The min of this vector must be greater of
  equal to 0 and the max must be less or equal to the size of the vector
  rv\$steps.enabled

- is.enabled:

  A \`boolean\`

- rv:

  A \`list\` containing at least a slot named 'steps.enabled' which is a
  vector of integers

## Value

An updated version of the vector rv\$steps.enabled

## Examples

``` r
NULL
#> NULL

```
