# Config class definition

This class is used to store the configuration of any process used with
MagellanNTK It contains a validity function to ensure that the format is
correct.

Validity: \* The first step must be called 'Description', it is a
mandatory step. Thus, the first item of the mandatory vector is TRUE. To
be continued...

\## Initialization \### Generic process

A generic process \* Generic pipeline : xxxx \* Description pipeline:
This case is for a process called 'Description' which is the first
process module of a pipeline

Wrapper function to the constructor of the class

## Usage

``` r
Config(
  fullname = "",
  mode = "",
  steps = NULL,
  mandatory = NULL,
  steps.source.file = NULL
)

# S4 method for class 'Config'
initialize(.Object, fullname, mode, steps, mandatory, steps.source.file)

Config(
  fullname = "",
  mode = "",
  steps = NULL,
  mandatory = NULL,
  steps.source.file = NULL
)
```

## Arguments

- fullname:

  xxx

- mode:

  xxx

- steps:

  xxx

- mandatory:

  xxx

- steps.source.file:

  xxx

- .Object:

  xxx

## Value

NA

## Slots

- `fullname`:

  xxxx

- `name`:

  xxx

- `parent`:

  xxx

- `mode`:

  xxx

- `steps`:

  xxx

- `mandatory`:

  xxx

- `ll.UI`:

  xxx

- `steps.source.file`:

  xxx

## Examples

``` r
# Example of a generic process
generic.proc <- Config(
    fullname = "PipelineDemo_Process1",
    mode = "process",
    steps = c("Step 1", "Step 2"),
    mandatory = c(TRUE, FALSE)
)


# Example of a generic pipeline
generic.pipe <- Config(
    fullname = "Pipe1_PipelineDemo",
    mode = "pipeline",
    steps = c("Process 1", "Process 2"),
    mandatory = c(TRUE, FALSE)
)

# Example of a root pipeline (process has no parent)
root.pipe <- Config(
    mode = "pipeline",
    fullname = "PipelineDemo",
    steps = c("Process1", "P-rocess2 bis", "Process3"),
    mandatory = c(FALSE, FALSE, TRUE)
)


# Example of a description module (process has no steps)
description.process <- Config(
    fullname = "PipelineDemo_Description",
    mode = "process",
    steps = "",
    mandatory = ""
)


generic.proc
#>     ------- Config -------
#>    fullname: PipelineDemo_Process1
#>    name: Process1
#>    parent: PipelineDemo
#>    mode: process
#>    names(steps): Description Step1 Step2 Save
#>    steps: Description Step 1 Step 2 Save
#>    mandatory: TRUE TRUE FALSE TRUE
#>    names(ll.UI): 
#>    ll.UI: 
#> 
generic.pipe
#>     ------- Config -------
#>    fullname: Pipe1_PipelineDemo
#>    name: PipelineDemo
#>    parent: Pipe1
#>    mode: pipeline
#>    names(steps): Description Process1 Process2 Save
#>    steps: Description Process 1 Process 2 Save
#>    mandatory: TRUE TRUE FALSE TRUE
#>    names(ll.UI): 
#>    ll.UI: 
#> 
root.pipe
#>     ------- Config -------
#>    fullname: PipelineDemo
#>    name: PipelineDemo
#>    parent: 
#>    mode: pipeline
#>    names(steps): Description Process1 Process2bis Process3 Save
#>    steps: Description Process1 P-rocess2 bis Process3 Save
#>    mandatory: TRUE FALSE FALSE TRUE TRUE
#>    names(ll.UI): 
#>    ll.UI: 
#> 
description.process
#>     ------- Config -------
#>    fullname: PipelineDemo_Description
#>    name: Description
#>    parent: PipelineDemo
#>    mode: process
#>    names(steps): 
#>    steps: 
#>    mandatory: 
#>    names(ll.UI): 
#>    ll.UI: 
#> 
```
