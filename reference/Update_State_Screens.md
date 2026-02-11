# Update the status enabled/disabled of the steps of a pipeline/process

Update the status enabled/disabled of the steps of a pipeline/process

## Usage

``` r
Update_State_Screens(is.skipped, is.enabled, rv)
```

## Arguments

- is.skipped:

  A \`boolean\` indicating whether the current step of a process or
  process of a pipeline has the status SKIPPED

- is.enabled:

  A \`boolean\` indicating whether the current step of a process or
  process of a pipeline is enabled (TRUE) or not (FALSE)

- rv:

  A \`list\` containing at least an item named 'steps.status' which is a
  vector of of names for the steps of a pipeline nor a process.

## Value

A \`vector\` of boolean which gives the status enabled (TRUE) or
disabled (FALSER) of the steps from a pipeline nor a process.

## Examples

``` r
NULL
#> NULL
```
