#' @description
#' Pour customiser ce fichier, il faut juste remplacer la châine de caractères
#' "nomPipeline" par le nom de votre pipeline, toujours précédé par "nomPipeline"
#' Par exemple, si vous développez un pipeline appelé "Test", alors la chaîne de remplacement
#' devra être "PipelineTest".
#' 
#' #' @rdname nomPipeline
#' @export
#' 
nomPipeline_Description_conf <- function(){
  MagellanNTK::Config(
    fullname = 'nomPipeline_Description',
    mode = 'process'
  )
}

#' @param id A `character(1)` which is the 'id' of the module.
#' 
#' @rdname nomPipeline
#' 
#' @author Samuel Wieczorek, Manon Gaudin
#' 
#' @export
#'
nomPipeline_Description_ui <- function(id){
  ns <- NS(id)
}


#' @rdname nomPipeline
#' @export
#' 
nomPipeline_Description_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  path = NULL,
  btnEvents = reactive({NULL})
){
  # Define default selected values for widgets
  # By default, this list is empty for the Description module
  # but it can be customized
  widgets.default.values <- list()
  
  # Define default values for reactive values
  # By default, this list is empty for the Description module
  # but it can be customized
  rv.custom.default.values <- list(
    history = MagellanNTK::InitializeHistory()
  )
  
  ###########################################################################-
  #
  #----------------------------MODULE SERVER----------------------------------
  #
  ###########################################################################-
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Necessary code hosted by MagellanNTK
    # DO NOT MODIFY THESE LINE
    core.code <- MagellanNTK::Get_Workflow_Core_Code(
      mode = 'process',
      name = id,
      w.names = names(widgets.default.values),
      rv.custom.names = names(rv.custom.default.values)
    )
    
    eval(str2expression(core.code))

    ###########################################################################-
    #
    #-----------------------------DESCRIPTION-----------------------------------
    #
    ###########################################################################-
    output$Description <- renderUI({

      # Find .Rmd file used to describe the step
      # # On recherche dans le répertoire 'md' du pipeline s'il y a un fichier
      # du même nom que celui-ci. Si c'est le cas, on en affiche le contenu
      # dans l'écran principal
      file <- normalizePath(file.path(
        system.file('workflow', package = 'MagellanNTK'),
        unlist(strsplit(id, '_'))[1], 
        'md', 
        paste0(id, '.Rmd')))
      
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList(
          if (file.exists(file))
            includeMarkdown(file)
          else
            p('No Description available')
        )
      )
    })
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      
      # Le core engine dans MagellanNTK (fichier core_process.R) gère les boutons
      # de navigation et envoie à tous les modules de process la valeur
      # bu bouton qui change à chaque click (lconcatenation du nom de l'étape dans
      # le process et du nombre de clicks sur le bouton). Dans les modules de 
      # process, cette valeur est recupérée dans la variable btnEvents()
      # Ici, on filtre les click sur le bouton Run/RunProceed depuis l'étape de Description
      req(grepl('Description', btnEvents()))
      
      req(dataIn())
      rv$dataIn <- dataIn()

      rv.custom$history <- Add2History(rv.custom$history, 'Description', 'Description', 'Initialization', '-')
      
      len <- length(rv$dataIn)
      rv$dataIn[[len]] <- SetHistory(rv$dataIn[[len]], rv.custom$history)
      
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv$dataIn
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  }
  )
}
