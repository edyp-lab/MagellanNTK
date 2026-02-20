# Get the last validated step before current position.

This function returns the indice of the last validated step before the
current step.

## Usage

``` r
Add2History(history, process, step.name, param.name, value)
```

## Arguments

- history:

  A \`data.frame()\`

- process:

  A \`character()\`

- step.name:

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
Add2History(history, 'Example', 'First step', "my param", 'THE value')
#>   Process       Step Parameter     Value
#> 1 Example First step  my param THE value

```
