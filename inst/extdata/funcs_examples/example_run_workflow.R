if (interactive()) {
  data(sub_R25)
  
  path <- system.file("workflow/PipelineDemo", package = "MagellanNTK")
  files <- list.files(file.path(path, 'R'), full.names = TRUE)
  for(f in files)
    source(f, local = FALSE, chdir = TRUE)

  # Nothing happens when dataIn is NULL
    shiny::runApp(run_workflow("PipelineDemo_Process1", dataIn = NULL))
  
    shiny::runApp(run_workflow("PipelineDemo_Process1", dataIn = lldata))

    shiny::runApp(run_workflow("PipelineDemo_Process1", dataIn = data.frame()))
  
    shiny::runApp(run_workflow("PipelineDemo", dataIn = lldata))

    shiny::runApp(workflow("PipelineDemo", dataIn = lldata))
}


