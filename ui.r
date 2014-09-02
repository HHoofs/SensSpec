library(shiny)
shinyUI(
  pageWithSidebar(
    
    # Application title
    headerPanel(" ~CAT",windowTitle="GettingThingsR"),
    
    # Sidebar panel --------------------------------------------------------------
    sidebarPanel(
      # HTML opmaak e.d.
      tags$head(
        HTML('<body style="background-color: white;">'),
        tags$style(type="text/css", "select { color: #001C3D }"),
        tags$style(type="text/css", "textarea { max-width: 315px; color: #001C3D}"),
        tags$style(type="text/css", ".jslider { max-width: 100%; }"),
        tags$style(type="text/css", ".jslider { min-width: 100%; color: #001C3D}"),
        tags$style(type="text/css", ".jslider .jslider-label{color: #001C3D ; font-size: 12px;}"),
        tags$style(type="text/css", ".jslider .jslider-value{color: #001C3D ; font-weight:bold; font-size: 16px;}"),      
        tags$style(type='text/css', ".well { max-width: 340px; }"),
        tags$style(type='text/css', ".span4 .well { background-color: white; border-color: #00A2DB}"),
        tags$style(type='text/css', ".span12  { color: #001C3D; }"),
        tags$style(type='text/css', ".span4  { color: #001C3D; }") ,   
        tags$style(type="text/css", "select { max-width: 200px; }"),
        tags$style(type="text/css", "textarea { max-width: 185px; }"),
        tags$style(type='text/css', ".well { max-width: 310px; }"),
        tags$style(type='text/css', ".span4 { max-width: 310px; }")
      ),
      # Conditie
      selectInput("selfr", strong("Conditie"), 
                  choices = c("Normaal" = "nor", "Prior Laag" = "priL", "Prior Hoog" = "priH", "Perfect" = "per", "Slecht" = "wor")),
      # Opties voor figuur
      wellPanel(strong("Populatie Figuur"),
                checkboxInput("PF_cel","Cell",   value = FALSE),
                checkboxInput("PF_cor","Classificatie (X = Fout; V = Goed)",value = FALSE)
      ),
      # Opties voor tabel
      wellPanel(strong("Tabel"),
                checkboxInput("TA_inv","Invullen",value=FALSE),
                checkboxInput("TA_uit","Uitrekenen"),value=FALSE),
      # Plaatje UM
      HTML('<a href="http://www.maastrichtuniversity.nl/" target="_blank"><img src="logo.jpg" alt="Maastricht University"  border="0" style="border: #00A2DB solid 1px; border-radius: 5px;"/></a>'),
      br(), 
      br(),
      # Uitleg in condional panel
      checkboxInput("uitleg",strong("Uitleg"),value=FALSE),
                conditionalPanel(condition = paste("input.uitleg == true"),
                                 "Voor een bepaalde ziekte zijn 21 personen gescreend met een nieuw instrument. De scores lopen van 0 t/m 105, waarbij een hogere score staat voor een grotere kans op de ziekte. In werkelijkheid hebben de groene personen de ziekte niet, en de rode personen wel. Het afkappunt kan (boven de figuur) worden verschoven om zodoende te kijken welke gevolgen dit heeft voor de sensitiviteit, specificiteit, NPV, en PPV. De optie Cell onder Populatie Figuur geeft de locatie van ieder persoon in de 2x2 tabel aan. De optie Classificatie toont aan of met het desbetreffende afkappunt een persoon juist of onjuist is geclassificeerd. De opties Invullen en Uitrekenen onder Tabel, tonen, respectievelijk, de aantallen in de 2x2 tabel en de bijbehorende sensitiviteit, specificiteit, NPV, en PPV waardes. De figuur rechtsonder geeft de ROC curve weer, waarbij de sensitiviteit en specificiteit van het gekozen afkappunt zijn omcirkeld. Bij condities kunnen verschillende situaties worden gekozen m.b.t. de prior kans van de ziekte en de kwaliteit van het instrument")
      
      
      
    ),
    
    mainPanel(
      # Opmaakt html
      tags$head(
        tags$style(type="text/css", "li a{color: white;  background-color:#001C3D;}")
        #         tags$style(type="text/css", ".active li a{color: black; font-weight:bold; background-color:black;}")
        
      ),
      sliderInput("afkap", "",min=0, max=105, value=50, step=5,animate=TRUE),
      plotOutput("basefig",height = "250px"),
      fluidRow(
        column(4,plotOutput("tabfig",height = "250px")),
        column(4,plotOutput("sens_form",height = "250px")),
        column(4,plotOutput("ROC",height = "250px"))
      )
      #       column(12,textOutput("test"))
    )
  )
)

