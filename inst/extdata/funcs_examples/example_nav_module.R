\donttest{
  library(shiny)
  server_env <- environment() # will see all dtwclust functions
  server_env$dev_mode <- FALSE
  
  # Uncomment and Change this for a process workflow
  # name <- 'PipelineDemo_Process1'
   #name <- 'PipelineDemo_Description'
  # layout <- c('h')
  
  
  # Uncomment and Change this for a pipeline workflow
  name <- 'PipelineDemo'
  layout <- c('v', 'h')
  
  
  path <- system.file('workflow', package='MagellanNTK')
  files <- list.files(file.path(path, name, 'R'), full.names = TRUE)
  for(f in files)
    source(f, local = TRUE, chdir = TRUE)
  
  
  
  ui <- fluidPage(
  tagList(
    fluidRow(
      column(width=2, actionButton('simReset', 'Remote reset',  class='info')),
      column(width=2, actionButton('simEnabled', 'Remote enable/disable', class='info')),
      column(width=2, actionButton('simSkipped', 'Remote is.skipped', class='info'))
    ),
    hr(),
    uiOutput('UI')
  )
)

server <- function(input, output){
  
  data(lldata)
  
  rv <- reactiveValues(
    dataIn = lldata,
    dataOut = NULL
  )
  
  
  
  output$UI <- renderUI({nav_ui(name)})

  observe({
    rv$dataOut <- nav_server(id = name,
                             dataIn = reactive({rv$dataIn}),
                             remoteReset = reactive({input$simReset}),
                             is.skipped = reactive({input$simSkipped%%2 != 0}),
                             is.enabled = reactive({input$simEnabled%%2 == 0})
      )
  })
}



shiny::shinyApp(ui, server)


}

