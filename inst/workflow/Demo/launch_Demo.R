library(MagellanNTK)

options(shiny.fullstacktrace = TRUE)

wf.path <- system.file('workflow/Demo', package = 'MagellanNTK')

MagellanNTK(wf.path, 'Demo')

