<!-- badges: start -->

[![Project Status: Active – The project is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check-bioc](https://github.com/edyp-lab/MagellanNTK/workflows/R-CMD-check-bioc/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions?query=workflow%3AR-CMD-check-bioc)
[![codecov.io](https://codecov.io/github/edyp-lab/MagellanNTK/coverage.svg?branch=master)](https://codecov.io/github/edyp-lab/MagellanNTK?branch=master)
[![license](https://img.shields.io/badge/license-Artistic--2.0-brightgreen.svg)](https://opensource.org/licenses/Artistic-2.0)



  [![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/edyp-lab/MagellanNTK/workflows/R-CMD-check/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions)
<!-- badges: end -->
  
# Magellan

Magellan is a R package which proposes a framework to navigate between steps of a complex data processing tool when the succession of processes is mostly chronological.

For example, if a process is composed of three steps, then it is very easy to run the first steps, then the second and finally the last one. It is like a dataflow manager.

Moreover, this navigation system, which is at the core of Magellan, can by used at several levels. It can then be possible to define, for example, a super-process (i.e. a pipeline) in which each step is a whole process containing itself several steps.


## Install

```
devtools::install_github('edyp-lab/MagellanNTK')
```

## Using MagellanNTK


MagellanNTK can be launched in two different modes: a 'user' mode and a 'dev' mode. 
The 'user' mode is the default mode.

```
library(MagellanNTK)
MagellanNTK()

data(Exp1_R25_prot, package = 'DaparToolshedData')
wf.name <- 'PipelineProtein_Normalization'
wf.path <- system.file('workflow/PipelineProtein', package = 'Prostar2')

MagellanNTK(Exp1_R25_prot, wf.path, wf.name)
```


# Launching one workflow

```
library(MagellanNTK)
data(lldata)
path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
shiny::runApp(workflowApp("PipelineDemo_Process1", path, dataIn = lldata))

```


# List of articles

* In the menu 'Get started', xxxx
* 'Articles > Create a pipeline': for developers
* 'Articles > Create a process': for developers
* 



# Future developments

* Generalize Magellan for more than two levels,
* implements a shiny app to help users to develop a module process
* Integrate synctatic analyzers for modules
