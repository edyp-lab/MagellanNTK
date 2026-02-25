#' @description
#' Pour customiser ce fichier, il ya plusieurs choses possibles. La plupart des 
#' indications sont ecrites dans le code, sous forme de commentaires
#' 
#' De manière genberale, et comme pour tous les autres fichiers, il faut 
#' remplacer:
#'  * la châine de caractères "nomPipeline_nomProcess1" par la concatenation de:
#'    * le nom de votre pipeline, toujours précédé par "Pipeline".
#'    * '_' en guise de séparateur
#'    * le nom du process
#' Par exemple, si vous développez un processus nommé Process1 pour le pipeline 
#' appelé "Test", alors lil faut remplacer la chaîne "nomPipeline_nomProcess1" 
#' par "Test_Process1".
#' 
#' @rdname PipelineDemo
#' @export
#' 
nomPipeline_nomProcess1_conf <- function(){
  MagellanNTK::Config(
    fullname = 'nomPipeline_nomProcess1',
    
    
    # Ici, nous sommes dans le module d'un process et non plus celui d'un pipeline
    mode = 'process',
    
    
    # Ce template a deux étapes. Les noms des étapes peuvent contenir des espaces
    steps = c('Step1', 'Step2'),
    
    # Il n'y a pas de restirction sur le fait d'avoir obligatoirement un TRUE
    mandatory = c(FALSE, TRUE)
  )
}


#' @rdname PipelineDemo
#' @export
#'
nomPipeline_nomProcess1_ui <- function(id){
  ns <- NS(id)
}


#' @rdname PipelineDemo
#' @export
#' 
nomPipeline_nomProcess1_server <- function(id,
  dataIn = reactive({NULL}),
  steps.enabled = reactive({NULL}),
  remoteReset = reactive({0}),
  steps.status = reactive({NULL}),
  current.pos = reactive({1}),
  btnEvents = reactive({NULL})
){
  # Define default selected values for widgets
  # This is only for simple workflows
  widgets.default.values <- list(  )
  
  # Define default values for reactive values
  rv.custom.default.values <- list(  
    history = NULL
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
      req(grepl('Description', btnEvents()))
      req(dataIn())
      
      # On doit toujours avoir cette ligne qui permet d'isoler la valeur de dataIn()
      # par rapport au reste du code dans le module. De cette façon, dans le module,
      # on ne travaille que avec rv$dataIn
      rv$dataIn <- dataIn()
      
      # As there is two sub-step, creates two duplicates
      # Ces deux variables servent si par exemple, on fait d'baord  l'étape 1 ou alors
      # uniquement l'étape 2 tout de suite. Dans les deux cas, la variable de travail
      # aura été instanciée avec le dataset initial
      rv.custom$dataIn1 <- rv$dataIn
      rv.custom$dataIn2 <- rv$dataIn
      
      
      
      # Ontrouve ces 3 lignes à chaque fin d'étape ou de process
      # La variable dataOut est automatiquement retournée au core engine Process (core_process.R)
      # dès qu'elle change (programmation reactive)
      # C'est avec ça que le core détecte si un module a renvoyé une valeur
      # trigger : sert de déclencheur d'événements pour le core engine
      # value : dataset à retourner. On doit garder cette ligne meme si elle retourne NULL
      # Le seul endroit où on retourn qqch est dans la dernière étape de Save
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      
      
      # On met à jour le vecteur de statuts des etapes car on vient de valider 
      # l'étape de Description
      rv$steps.status['Description'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #-------------------------------Step1-----------------------------------
    #
    ###########################################################################-
    # Ici, on a le rnederUI global pour la premiere etape
    # Il doit y avoir un bloc renderUI({}) par étape.
    # Ce bloc a toujours la même structure de base qu'il ne faut pas modifier
    # Il doit obligatoirement porter le même nom (sans les espaces) que celui qui apparaît dans 
    # la fonction de configuration nomPipeline_nomProcess1_conf() 
    output$Step1 <- renderUI({
      shinyjs::useShinyjs()
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          # ici, on peut mettre du code pour les widgets qui sont des parametres
          uiOutput(ns('Step1_widgets_UI'))
        ),
        content = tagList(
          # Ici, on met du code pour afficher des resultats, des graphiques, 
          # tableaux, etc...
          # dans les fonctions renderUI de cette partie, pour avoir le jeu de donnees
          # on utilise la variable rv.custom$dataIn1
        )
      )
    })
    
    # Define widgets for the step
    # Ici, le nom du renderUI n'a pas de contrainte particuliere
    # Je mets toujours en prefixe le nom de l'étape pour que ce soit plus calir
    # quand le fichier est grand
    output$Step1_widgets_UI <- renderUI({
      
      # Iic, on ajoute directment la fonction d'un widget ou alors un groupe de 
      # widgets inséré dans un tagList(). Dans ce dernier cas, c'est l'ensemble des widgets
      # placé dans le tagList() qui seront désactivés avec la derniere ligne
      # La valeur par défaut des widgets doit être renseignee avec la valeur qu'il y a
      # dans la liste appelée rv.widgets$nomDuWidget
      # Ceci permettra de faire fonctionner le mécanisme automatique de reset
      widget <- # A remplir
      
      # Cette ligne est indispensable à la fin de chaque renderUI qui définit un widget
      # Elle permet de faire passer le widget en status disabled une fois que l'étape est validée
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Step1"])
    })
    
    
    
    # Dans cette éape, on fait un traitement sur le jeu de données
    # On va alors creer un nouveau SE (qui sera temporaire) et le rajouter dans le 
    # dataset de travail. Car comme par défaut, on travaille TOUJOURS sur le dernier
    # SE d'un dataset, lorsque l'on passera à l'étpae suivante, on travaillera sur 
    # le resultat de l'étape 1.
    # Les SE intermédiaires et inutiles seront supprimes à la fin du module
    # dans l'étape 'Save'
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Step1', btnEvents()))
      
      # Pour rappel, dans cette partie relative à la premiere étape, on travaille
      # avec rv.custom$dataIn1
      req(rv.custom$dataIn1)
      
      # Create temporary duplicate of dataset to perform Step1
      # # On cree un SE temporaire
      datatmp <- rv.custom$dataIn1[[length(rv.custom$dataIn1)]]
      
      ## Ici, on effectue le traitement statistique proprement dit sur le dataset
      ## datatmp
      
      # Add to history
      # On ajoute autant de lignes qu'il y a eu de paramètres
      # 
      rv.custom$history <- Add2History(rv.custom$history, 'nomProcess2', 'Step1', ##nom du parametre##, rv.widgets$Step1_Type)


      # Add filtered dataset
      #  Ici, on appelle la fonction generique pour addDatasets() qui a été
      #  specifiée dans le fichier config.txt du pipeline
      # Cette fonction peut être personnalisee suivant la classe de dataset sur 
      #  lequel on travaille
      #
      # On stocke le nouveau dataset (avec le resultat de la premier etape) dans
      # la variable de travail  de l'étape 1 qui est rv.custom$dataIn1
      # Dans le aprametre nam, le suffixe "_Process1" servira à la fin, à repérer les
      # SE à supprimer du dataset final
      rv.custom$dataIn1 <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)), 
        list(object = rv.custom$dataIn1, 
          dataset = datatmp,
          name = paste0(names(rv.custom$dataIn1)[length(rv.custom$dataIn1)], '_Process2')
        )
      )
      
      # Transfer the new dataset to the second sub-step
      # On met à jour la variable de travail de l'étape 2 car c'est sur elle qu'on travaillera
      # à l'étape 2 et non plus sur rv.custom$dataIn1
      rv.custom$dataIn2 <- rv.custom$dataIn1
     
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Step1'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #----------------------------Step 2----------------------------------
    #
    ###########################################################################-
    output$Step2 <- renderUI({
      shinyjs::useShinyjs()
      
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(
          uiOutput(ns("Step2_widgets_UI"))
        ),
        content = tagList(
          
        )
      )
    })
    
    # Define widgets for the step
    output$Step2_widgets_UI <- renderUI({
      widget <- ## A PERSONNALISER ##
      
      MagellanNTK::toggleWidget(widget, rv$steps.enabled["Step2"])
    })
    
    #
    #
    # Ajouter le code pour le contenu de la fenetre princiaple de l'étape 2.
    # Attention, ici on travaille sur la variable rv.custom$dataIn2
    #
    #
    
    
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Step2', btnEvents()))
      
      # Create temporary duplicate of dataset to perform Step2
      datatmp <- rv.custom$dataIn2[[length(rv.custom$dataIn2)]]
      # Proceed with Step2
      # On met le resultat dans le SE datatmp
      datatmp <- ## Resultat du traitement ##
        
        
        
        
      # Adding to history
      rv.custom$history <- Add2History(rv.custom$history, 'nomProcess2', 'Step2', XXX, XXX)

      # Add normalized dataset
      rv.custom$dataIn2 <- do.call(
        eval(parse(text = session$userData$funcs$addDatasets)),
        list(object = rv.custom$dataIn2,
          dataset = datatmp,
          name = paste0(names(rv.custom$dataIn2)[length(rv.custom$dataIn2)], '_Process2')
        )
      )
      
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- NULL
      rv$steps.status['Step2'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    ###########################################################################-
    #
    #---------------------------------SAVE--------------------------------------
    #
    ###########################################################################-
    output$Save <- renderUI({
      # Function for layout and display of widgets and plots for the step
      MagellanNTK::process_layout(session,
        ns = NS(id),
        sidebar = tagList(),
        content = tagList()
      )
    })
    
    
    
    # Dans cette partie, on va travailler sur la variable rv.custom$dataIn2
    # qui contient forcément le resultat du traitement, que l'utilistaeur ait
    # fait:
    # * que la premier etapte
    # * les deux étapes
    # * uniquement la deuxième etape
    # 
    # oberveEvent runs when one of the "Run" buttons is clicked
    observeEvent(req(btnEvents()), ignoreInit = TRUE, ignoreNULL = TRUE,{
      req(grepl('Save', btnEvents()))
      
      # As there is two sub-step, if both are performed there is two new dataset instead of one
      # Removing the first created out of the two if that is the case
      len_start <- length(rv$dataIn)
      len_end <- length(rv.custom$dataIn2)
      len_diff <- len_end - len_start
      
      req(len_diff > 0)
      
      
      # on supprime tous les datasets intermediaires qui ont été crées pendant
      # ce process
      if (len_diff == 2)
        rv.custom$dataIn2 <- keepDatasets(rv.custom$dataIn2, -(len_end - 1))
      
      # Rename the new dataset with the name of the process
      names(rv.custom$dataIn2)[length(rv.custom$dataIn2)] <- 'nomProcess2'
      

      # Add step history to the dataset history
      len <- length(rv.custom$dataIn2)
      rv.custom$dataIn2[[len]] <- SetHistory(rv.custom$dataIn2[[len]], rv.custom$history)
      
      
      # Ici, on va instancier la variable dataOut$value. La conséquence est que 
      # le core engine du process va détecter un changement dans ce process
      # et mettre à jour les interfaces ainsi que le dataset à l'entrée de tous
      # les process suivants dans le pipeline
      # DO NOT MODIFY THE THREE FOLLOWING LINES
      dataOut$trigger <- MagellanNTK::Timestamp()
      dataOut$value <- rv.custom$dataIn2
      rv$steps.status['Save'] <- MagellanNTK::stepStatus$VALIDATED
    })
    
    # Insert necessary code which is hosted by MagellanNTK
    # DO NOT MODIFY THIS LINE
    eval(parse(text = MagellanNTK::Module_Return_Func()))
  }
  )
}
