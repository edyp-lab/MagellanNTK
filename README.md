Title

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Project Status: Active – The project is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check-bioc](https://github.com/edyp-lab/MagellanNTK/actions/workflows/check-bioc.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/check-bioc.yaml)
[![R-CMD-check.yaml](https://github.com/edyp-lab/MagellanNTK/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/check-standard.yaml)
[![test-coverage.yaml](https://github.com/edyp-lab/MagellanNTK/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/test-coverage.yaml)
[![license](https://img.shields.io/badge/license-Artistic--2.0-brightgreen.svg)](https://opensource.org/licenses/Artistic-2.0)
[![Bioc release status](http://www.bioconductor.org/shields/build/release/bioc/MagellanNTK.svg)](https://bioconductor.org/checkResults/release/bioc-LATEST/MagellanNTK)
[![Bioc devel status](http://www.bioconductor.org/shields/build/devel/bioc/MagellanNTK.svg)](https://bioconductor.org/checkResults/devel/bioc-LATEST/MagellanNTK)
[![Bioc downloads rank](https://bioconductor.org/shields/downloads/release/MagellanNTK.svg)](http://bioconductor.org/packages/stats/bioc/MagellanNTK/)
[![Bioc support](https://bioconductor.org/shields/posts/MagellanNTK.svg)](https://support.bioconductor.org/tag/MagellanNTK)
[![Bioc history](https://bioconductor.org/shields/years-in-bioc/MagellanNTK.svg)](https://bioconductor.org/packages/release/bioc/html/MagellanNTK.html#since)
[![Bioc last commit](https://bioconductor.org/shields/lastcommit/devel/bioc/MagellanNTK.svg)](http://bioconductor.org/checkResults/devel/bioc-LATEST/MagellanNTK/)
[![Bioc dependencies](https://bioconductor.org/shields/dependencies/release/MagellanNTK.svg)](https://bioconductor.org/packages/release/bioc/html/MagellanNTK.html#since)
<!-- badges: end -->
  
# MagellanNTK

MagellanNTK is a R package which proposes a framework to navigate between steps of a complex data processing tool when the succession of processes is mostly chronological.

For example, if a process is composed of three steps, then it is very easy to run the first steps, then the second and finally the last one. It is like a dataflow manager.

Moreover, this navigation system, which is at the core of MagellanNTK, can by used at several levels. It can then be possible to define, for example, a super-process (i.e. a pipeline) in which each step is a whole process containing itself several steps.


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
