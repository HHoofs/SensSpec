library(shiny)
shinyUI(
  pageWithSidebar(
    
    # Application title
    headerPanel(htmlOutput("selectTitle"),windowTitle="GettingThingsR"),
    
    # Sidebar panel --------------------------------------------------------------
    sidebarPanel(
      # HTML opmaak e.d.
      tags$head(
        HTML('<body style="background-color: white;">'),
        tags$style(type="text/css",
                   ".shiny-output-error { visibility: hidden; }",
                   ".shiny-output-error:before { visibility: hidden; }",
                   ".jslider { max-width: 100%; min-width: 100%; color: #001C3D; }",
                   ".jslider .jslider-label{ color: #001C3D ; font-size: 12px; }",
                   ".jslider .jslider-value{ color: #001C3D ; font-weight:bold; font-size: 16px; }",
                   ".span4 { color: #001C3D;  max-width: 310px; }",
                   ".span4 .well { background-color: white; border-color: #00A2DB; }",
                   "select { color: #001C3D; max-width: 200px; }",
                   ".well { max-width: 340px; }",
                   "textarea { max-width: 315px; color: #001C3D; }",
                   ".span12 { color: #001C3D; }",
                   "label.radio { display: inline-block; }",  
                   ".radio input[type=\"radio\"] { float: none }")      
      ),
      
      uiOutput("selectUIQual"),
      # Opties voor figuur
      wellPanel(htmlOutput("selectHeaderFigur"),
                checkboxInput("PF_cel","Cell",   value = FALSE),
                uiOutput("selectUIClass")
      ),
      # Opties voor tabel
      wellPanel(htmlOutput("selectHeaderTable"), 
                uiOutput("selectUIFil"),
                uiOutput("selectUIComp")
      ),
      # Language
      HTML('<div id="lang" class="control-group shiny-input-radiogroup">
              <label class="control-label" for="lang"></label>
              <label class="radio">
                <input type="radio" name="lang" id="dist1" value="dutch" checked="checked"/>
                <span><img src="http://i.imgur.com/JeuV7EU.png" height="42" width="42"></span>
              </label>
              <label class="radio">
                <input type="radio" name="lang" id="dist2" value="eng"/>
                <span><img src="http://i.imgur.com/dZVAGZ6.png" height="52" width="42"></a></span>
              </label>
            </div> '),
      checkboxInput("uitleg",htmlOutput("selectExplainHeader"),value=FALSE),
      conditionalPanel(condition = paste("input.uitleg == true"),
                       htmlOutput("selectExplain")),
      
      # Uitleg in condional panel
      
      HTML('<a href="http://www.maastrichtuniversity.nl/" target="_blank"><img src="logo.jpg" alt="Maastricht University"  border="0" style="border: #00A2DB solid 1px; border-radius: 5px;"/></a>'),
      checkboxInput("copy",strong("Copyright"),value=FALSE),
      conditionalPanel(condition = paste("input.copy == true"),
                       "The MIT License (MIT)",
                       br(),br(),
                       "Copyright (c) 2014 Huub",
                       br(),br(),
                       "Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.",
                       br(),br(),
                       "THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.",       
                       br(),br(),
                       "Source code:",
                       HTML('<a href="https://github.com/HHoofs/SensSpec" target="_blank"><img src="http://www.wakanda.org/sites/default/files/blog/blog-github.png" alt="Github Directory" border="0"/></a>'))
      
      
    ),
    
    mainPanel(
      # Opmaakt html
      tags$head(
        tags$style(type="text/css", "li a{color: white;  background-color:#001C3D;}")
      ),
      sliderInput("afkap", "",min=0, max=105, value=50, step=5,animate=TRUE),
      plotOutput("basefig",height = "250px"),
      fluidRow(
        column(4,plotOutput("tabfig",height = "250px")),
        column(4,plotOutput("sens_form",height = "250px")),
        column(4,plotOutput("ROC",height = "250px"))
      )
    )
  )
)

# # The MIT License (MIT)
# # 
# # Copyright (c) 2014 Huub
# # 
# # Permission is hereby granted, free of charge, to any person obtaining a copy of
# # this software and associated documentation files (the "Software"), to deal in
# # the Software without restriction, including without limitation the rights to
# # use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# # the Software, and to permit persons to whom the Software is furnished to do so,
# # subject to the following conditions:
# # 
# # The above copyright notice and this permission notice shall be included in all
# # copies or substantial portions of the Software.
# # 
# # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# # FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# # COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# # IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# # CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 