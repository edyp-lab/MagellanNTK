# MagellanNTK

Le package MagellanNTK est un moteur de gestion de workflows qui permet
d’exécuter une série de process d’analyses sur des jeux de données. Il
contient des fonctions génériques d’entrée/sortie de dataset qui sont
adaptées à des formats de données de type list.

Pour utiliser les fonctionnalités de MagellanNTK, il est nécessaire
d’utiliser des workflows soit enregistrés sur l’ordinateur, soit
disponibles dans un package

La principale puissance de ce package est que ces fonctions natives sont
entièrement configurableS. MagellanNTK offre une gestion de workflow

## Installation

You can install the development version of MagellanNTK from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("edyp-lab/MagellanNTK")
```

# MagellanNTK

MagellanNTK is a R package which proposes a framework to navigate
between steps of a complex data processing tool when the succession of
processes is mostly chronological.

For example, if a process is composed of three steps, then it is very
easy to run the first steps, then the second and finally the last one.
It is like a dataflow manager.

Moreover, this navigation system, which is at the core of MagellanNTK,
can by used at several levels. It can then be possible to define, for
example, a super-process (i.e. a pipeline) in which each step is a whole
process containing itself several steps.

## Install

    devtools::install_github('edyp-lab/MagellanNTK')

## Using MagellanNTK

MagellanNTK can be launched in two different modes: a ‘user’ mode and a
‘dev’ mode. The ‘user’ mode is the default mode.

    library(MagellanNTK)
    wf.name <- 'PipelineDemo'
    wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
    MagellanNTK(wf.path, wf.name)

# Launching a workflow

    library(MagellanNTK)
    path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
    shiny::runApp(workflowApp("PipelineDemo_Process1", path, dataIn = lldata))

# Launching a single process

In the following example, on lance MAgellan avec seulement le process
‘ProcessA’.

    library(MagellanNTK)
    wf.name <- 'PipelineDemo_ProcessA'
    wf.path <- system.file('workflow/PipelineDemo', package = 'MagellanNTK')
    MagellanNTK(wf.path, wf.name)
