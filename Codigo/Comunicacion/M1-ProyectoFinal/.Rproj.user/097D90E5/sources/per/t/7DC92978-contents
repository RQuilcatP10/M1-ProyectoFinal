recoleccion <- {
  fluidRow(
    h3("Para la fase de recolecci\u00F3n de datos, usaremos la red social Twitter, la cual nos permitir\u00E1 extraer la informaci\u00F3n con respecto a los tweets que realizan los usuarios. Esto ser\u00E1 posible con la afiliaci\u00F3n del usuario al programa Developers de Twitter",align="center"),
    hr(),
    h4("Dentro de ello, crearemos un proyecto, el cual nos servir\u00E1 para crear keys, y con ello acceder y usar la API de Twitter para la extracci\u00F3n de los datos"),
    div(
      column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1Imagen3.PNG",width="100%",height="50%"))
    ),
    br(),
    br(),
    h3("Una vez con esto creado y validado, procedemos realizar la extracci\u00F3n de la data conveniente, para ello, presentaremos dos formas para hacerlo", align="center"),
    tags$style(".topimg {padding-left:5px;padding-right:5px;}"),
    tags$b(h4("\u2022 PRIMER M\u00C9TODO DE RECOLECCI\u00D3N: SCRIPT EN PYTHON - GOOGLE COLAB")),
    div(class="topimg",
      includeMarkdown("www/datos/Markdown/collab.md"),
      column(12,align="center",tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1Recoleccion1.PNG",width="100%",height="50%")),
      br()
    ),
    tags$b(h4("\u2022 SEGUNDO M\u00C9TODO DE RECOLECCI\u00D3N: USO DE GOOGLE SHEETS ADD ONS")),
    div(class="topimg",align="justify",
        h5("El primer m\u00E9todo de recolecci\u00F3n al ser un script se tendr\u00EDa que ejecutar cada vez que el notebook sea abierto, por lo que la recolecci\u00F3n se har \u00E1 mas corta en cuanto a items, por los periodos de tiempo. Una alternativa a esto, es el uso de GOOGLE SHEET y TWITTER ARCHIVER, que es un complemento que nos agiliza la recolecci\u00F3n de datos, organizandolos automaticamente en forma de tabla, listo para exportar como archivo .csv, y a dem \u00E1s de eso se va llenando de forma autom \u00E1tica cada 1 hora, llenando de 100 registros dicho archivo. Esto agiliza mas la recolecci\u00F3n, ya que a mas datos, mejor ser \u00E1n los modelos a implementar mas adelante."),
        tags$img(src="https://raw.githubusercontent.com/RQuilcatP10/M1-ProyectoFinal/master/Otros/M1Recoleccion4.PNG",width="100%",height="50%")
    ),
    hr(),
    h3("Al final, obtenemos los siguientes archivos:"),
    selectInput(inputId = "idDSSelec", label = "Seleccione un dataset", choices = dir("www/datos/Csv", pattern=NULL, all.files=FALSE,
                                                                                             full.names=FALSE)),
    tableOutput(outputId = 'table.output')
  )
}
