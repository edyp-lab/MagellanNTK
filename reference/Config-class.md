# Config class definition

This class is used to store the configuration of any process used with
MagellanNTK It contains the following slots:

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

  The complete name of the pipeline or the process (in this case, it is
  the concatenation of the name of the pipeline and the name of the
  process itself, separated by '\_')

- mode:

  A \`character()\` which indicates whether the current module is used
  as a 'process' nor a 'pipeline.' Default value is NULL

- steps:

  A vector containing the names of steps in a process or a pipeline.

- mandatory:

  A vector of boolean where each element indicates whether the
  corresponding steps is mandatory or not. It has the same length of the
  vector steps.

- steps.source.file:

  A \`vector\` of which each item is the source code of the
  corresponding step.

- .Object:

  The object

## Value

An instance of the class \`Config\`

## Slots

- `fullname`:

  The name of the process which is the concatenation of the name of the
  pipeline and the name of the process itself, separated by '\_'.

- `name`:

  The name of the process nor pipeline.

- `parent`:

  The name of the pipeline/process which owns this instance

- `mode`:

  A \`character()\` which indicates if the configuration is about a
  whole process nor a process of a pipeline.

- `steps`:

  A \`vector\` of \`character()\` which contains the primary steps of
  the pipeline. Two steps will be automatically inserted in this vector:
  'Description 'in the first position and 'Save' at the end.

- `mandatory`:

  A \`vector\` of \`boolean()\` in which each item is the necessary code
  for the GUI of a step. The size of this vector is the number of steps

- `ll.UI`:

  A \`vector\` of Shiny source code. Each item is the necessary code for
  the GUI of a step. The size of this vector is the number of steps

- `steps.source.file`:

  A \`vector\` of which each item is the source code of the
  corresponding step.

- `steps`:

  A \`vector\` of \`character()\` which contains the primary steps of
  the pipeline. Two steps will be automatically inserted in this vector:
  'Description 'in the first position and 'Save' at the end.

- `mandatory`:

  A \`vector\` of \`boolean()\` in which each item is the necessary code
  for the GUI of a step. The size of this vector is the number of steps

## Examples

``` r
# Example of a single process with one step
proc1step <- Config(
    fullname = "PipelineDemo_DataGeneration",
    mode = "process",
    steps = c("DataGeneration"),
    mandatory = c(TRUE)
)


# Example of a single process with two steps
# Example of a generic pipeline
proc2steps <- Config(
    fullname = "PipelineDemo_PreProcessing",
    mode = "process",
    steps = c('Filtering', 'Normalization'),
    mandatory = c(TRUE, FALSE)
)

# Example of pipeline with three process
pipe3proc <- Config(
    mode = "pipeline",
    fullname = "PipelineDemo",
    steps = c('DataGeneration', 'Preprocessing', 'Clustering'),
    mandatory = c(TRUE, FALSE, FALSE)
)


# Example of a particular description module (A process with no step)
description.process <- Config(
    fullname = "PipelineDemo_Description",
    mode = "process",
    steps = "",
    mandatory = ""
)
```
