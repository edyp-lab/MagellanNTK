
# MagellanNTK

<!-- badges: start -->
[![Project Status: Active](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-CMD-check](https://github.com/edyp-lab/omXplore/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml)
[![R-CMD-check](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edyp-lab/MagellanNTK/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Le package MagellanNTK est un moteur de gestion de workflows qui permet d'exécuter une série de process d'analyses sur des jeux de données.
Il contient des fonctions génériques d'entrée/sortie de dataset qui sont adaptées à des formats de données de type list.

Pour utiliser les fonctionnalités de MagellanNTK, il est nécessaire d'utiliser des workflows soit enregistrés sur l'ordinateur, soit disponibles
dans un package



La principale puissance de ce package est que ces fonctions sont entièrement configurableI

## Installation

You can install the development version of MagellanNTK from [GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("edyp-lab/MagellanNTK")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(MagellanNTK)
## basic example code
```

  
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
