# Get the first mandatory step not validated

Get the first mandatory step not validated

## Usage

``` r
GetFirstMandatoryNotValidated(range, rv)
```

## Arguments

- range:

  A \`vector\` of integers. The min of this vector must be greater of
  equal to 0 and the max must be less or equal to the size of the object

- rv:

  A \`list\` with at least two slots : \* mandatory: A vector of
  \`booelan\` which indicates whther the steps are mandatory or not \*
  steps.status: A vector of \`interger()\` which indicates the status of
  the steps

## Value

An integer which is the indice of the identified step in the vector
rv\$steps.status

## Examples

``` r
NULL
#> NULL
```
