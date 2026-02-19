library(MagellanNTK)

options(shiny.fullstacktrace = TRUE)

wf.name <- 'PipelineDemo'
wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')

MagellanNTK(wf.path, wf.name)

