# Get the last validated step before current position.

This function returns the indice of the last validated step before the
current step.

## Usage

``` r
Add2History(history, step, substep, param.name, value)
```

## Arguments

- history:

  A \`data.frame()\`

- step:

  A \`character()\`

- substep:

  A \`character()\`

- param.name:

  A \`character()\`

- value:

  The value corresponding to the param.name

## Value

A \`data.frame()\`

## Examples

``` r
history <- InitializeHistory()
Add2History(history, "Example step", "First sub-step", "my param", "THE value")
#>           Step        Substep Parameter     Value
#> 1 Example step First sub-step  my param THE value
```
