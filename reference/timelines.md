# Shiny module for the process timeline

Shiny module for the process timeline

## Usage

``` r
timeline_process_ui(id)

timeline_process_server(
  id,
  config,
  status = reactive({
     NULL
 }),
  position = reactive({
     1
 }),
  enabled = reactive({
     NULL
 })
)

timeline_process(config, status, position, enabled)

timeline_pipeline_ui(id)

timeline_pipeline_server(id, config, status, position, enabled)

timeline_pipeline(config, status, position, enabled)
```

## Arguments

- id:

  A \`character()\` as the id of the Shiny module

- config:

  An instance of the class \`Config\`

- status:

  A boolean which indicates whether the current status of the process ,

- position:

  An integer which reflects the current position of the cursor within
  the steps.

- enabled:

  A vector of booleans with the same length as the number of steps ( See
  the slot steps in the config object). Each element indicates if the
  corresponding step is enabled (TRUE) or (DISABLED)

## Value

A shiny app

## Examples

``` r
if(interactive()){
config <- Config(
    mode = "process",
    fullname = "PipelineDemo_Preprocessing",
    steps = c('Filtering', 'Normalization'),
    mandatory = c(FALSE, TRUE)
)
status <- reactive({c(1, 1, 0, 0)})
pos <- reactive({2})
enabled <- reactive({c(0, 0, 1, 1)})
shiny::runApp(timeline_process(config, status, pos, enabled))
}


if(interactive()){
config <- Config(
    mode = "pipeline",
    fullname = "PipelineDemo",
    steps = c('DataGeneration', 'Preprocessing', 'Clustering'),
    mandatory = c(TRUE, FALSE, FALSE)
)
status <- reactive({c(1, 1, -1, 1, 0)})
pos <- reactive({4})
enabled <- reactive({c(0, 0, 0, 0, 1)})
shiny::runApp(timeline_pipeline(config, status, pos, enabled))
}
```
