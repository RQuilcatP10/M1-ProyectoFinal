
library(shiny)
library(shinythemes)
library(markdown)
library(tm)
library(caret)
source("www/Introduccion.R")
source("www/Recoleccion.R")
source("www/datos/Modelos/Kmeans.R", local = T)


run_CART <- function() {
  print("Resultados de la matriz de confusion CART")
  source("www/datos/Modelos/CART.R", local = T)
  print(CART2total)
}
run_SVM <- function() {
  print("Resultados de la matriz de confusion SVM")
  source("www/datos/Modelos/SVM.R", local = T)
  print(SVMout)
}
run_Bayes <- function() {
  print("Resultados de la matriz de confusion de Naive Bayes")
  source("www/datos/Modelos/NaiveBayes.R", local = T)
  print(Bayesout)
}


ui <- fluidPage(theme = shinytheme("flatly"),
                titlePanel("An\u00E1lisis de Sentimientos en Twitter con R"),
                tabsetPanel(
                    tabPanel("Introducci\u00F3n",
                             introduccion,
                             includeMarkdown("www/datos/Markdown/introduccion.md")
                    ),
                    tabPanel("Recolecci\u00F3n",
                             recoleccion
                    ),
                    tabPanel("Modelado",
                             includeMarkdown("www/datos/Markdown/modelado.md"),
                             div(
                                 column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1ModeloEstructurado1.PNG",width="100%",height="50%"))
                             ),
                    ),
                    tabPanel("Preprocesamiento",
                             includeMarkdown("www/datos/Markdown/Preprocesamiento.md")
                    ),
                    tabPanel("Exploraci\u00F3n",
                             includeMarkdown("www/datos/Markdown/exploracion.md")
                    ),
                    tabPanel("Modelo",
                             tabsetPanel(
                               
                               tabPanel("K-Means",
                                        fluidRow(
                                          includeMarkdown("www/datos/Markdown/kmeans_1.md"),
                                          div(
                                            column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1KMeans.png",width="70%",height="50%"))
                                          ),
                                          includeMarkdown("www/datos/Markdown/kmeans_2.md"),
                                          headerPanel("Cluster por K-means"),
                                          sidebarPanel(
                                            numericInput(inputId = "idK", label = "Escoja K grupos",value = 2, min=2)
                                          ),
                                          mainPanel(verbatimTextOutput("KMeansout"))
                                        )
                               ),
                               tabPanel("CART",
                                        fluidRow(
                                          includeMarkdown("www/datos/Markdown/CART_1.md"),
                                          div(
                                            column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1Cart.png",width="70%",height="50%"))
                                          ),
                                          includeMarkdown("www/datos/Markdown/CART_2.md"),
                                          h3("CART matriz confusion "),
                                          verbatimTextOutput("CARTout")
                                        )
                               ),
                               tabPanel("Niave-Bayes",
                                        fluidRow(
                                          includeMarkdown("www/datos/Markdown/bayes_1.md"),
                                          div(
                                            column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1NaiveBayes1.jpeg",width="70%",height="50%"))
                                          ),
                                          includeMarkdown("www/datos/Markdown/bayes_2.md"),
                                          h3("Naive-Bayes matriz confusion "),
                                          verbatimTextOutput("Bayesoutput")
                                        )
                               ),
                               tabPanel("SVM",
                                        fluidRow(
                                          includeMarkdown("www/datos/Markdown/SVM_1.md"),
                                          div(
                                            column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1SVM.png",width="70%",height="50%"))
                                          ),
                                          includeMarkdown("www/datos/Markdown/SVM_2.md"),
                                          h3("SVM matriz confusion "),
                                          verbatimTextOutput("SVMoutput")
                                        )
                               )
                             ) #Close inner tabsetPanel
                    ),
                    tabPanel("Visualizaci\u00F3n",
                             div(
                               column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/grafo1.png",width="100%",height="50%")),
                               column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/grafo2.png",width="100%",height="50%")),
                               column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/grafo3.png",width="100%",height="50%")),
                               column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/grafo4.PNG",width="100%",height="50%"))
                             ),
                    ),
                    tabPanel("Comunicaci\u00F3n",
                             includeMarkdown("www/datos/Markdown/autores.md"),
                             downloadButton("downloadReport", "Generar Reporte HTML")
                    )
                )
   
)

server <- function(input, output) {
    #########################RECOLECCION##############################
    output$table.output <- renderTable({
        inFile <- input$idDSSelec
        if (is.null(inFile))
            return(NULL)
        linksito <- paste("www/datos/Csv/",input$idDSSelec, sep = "")
        tbl <- read.csv(linksito, header=TRUE)
    })
    ##################################################################
    ###########################MODELOS################################
    output$CARTout <- renderPrint(run_CART())
    output$Bayesoutput <- renderPrint(run_Bayes())
    output$KMeansout <- renderPrint({
      k <- input$idK
      kc <- kmeans(Kmeans_m1_out, k)
      print(kc)
    })
    output$SVMoutput <- renderPrint(run_SVM())
    ##################################################################
    output$dowloadReport <- downloadHandler(
      filename = function() {
        paste('ReporteSentimientos', sep = '.','html')
      },
      
      content = function(file) {
        src <- normalizePath('report.Rmd')
        
        # temporarily switch to the temp dir, in case you do not have write
        # permission to the current working directory
        owd <- setwd(tempdir())
        on.exit(setwd(owd))
        file.copy(src, 'report.Rmd', overwrite = TRUE)
        
        library(rmarkdown)
        out <- render('report.Rmd', html_document())
        file.rename(out, file)
      }
    )
    
}


shinyApp(ui = ui, server = server)
