# Builds a vector of data

The names of the slots in dataIn are a subset of the names of the steps
(names(stepsNames)). Each item is the result of a process and whe,n a
process has been validated, it creates a new slot with its own name

## Usage

``` r
BuildData2Send(session, dataIn, stepsNames)
```

## Arguments

- session:

  internal parameter

- dataIn:

  An instance of an object of type \`list()\`.

- stepsNames:

  A vector in which items is the name of a step in the pipeline.

## Value

A vector of the same length of the vector \`stepsNames\` in which each
item is an object (the type of object used by the pipeline). This object
must have the same behavior of a \`list()\`.

## Examples

``` r
data(lldata)
stepsNames <- c('data1', 'data2', 'data3')
#BuildData2Send(lldata, stepsNames)


stepsNames <- c('data1', 'data2', 'data3', 'data4', 'data5')
#BuildData2Send(lldata, stepsNames)
```
