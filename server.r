library(shiny)
library(png)
library(grid)
library(ggplot2)
library(pROC)
library(RCurl)

# # Empty table
figure_table <- function(...){
  pushViewport(viewport(layout = grid.layout(nrow=5, ncol=5, 
                                             widths  = unit(c( 1, 1, 2, 2, 2), "null"),
                                             heights = unit(c( 1, 1, 2, 2, 2), "null"))))
  
  grid.text("Waarheid", vp = viewport(layout.pos.row = 1, layout.pos.col = 3:4))
  grid.text("Test", vp = viewport(layout.pos.row = 3:4, layout.pos.col = 1), rot=90)
  grid.text("+",      vp = viewport(layout.pos.row = 3, layout.pos.col = 2), rot=90)
  grid.text("-",      vp = viewport(layout.pos.row = 4, layout.pos.col = 2), rot=90)
  grid.text("Totaal", vp = viewport(layout.pos.row = 5, layout.pos.col = 2), rot=90)
  grid.text("+",      vp = viewport(layout.pos.row = 2, layout.pos.col = 3))
  grid.text("-",      vp = viewport(layout.pos.row = 2, layout.pos.col = 4))
  grid.text("Totaal", vp = viewport(layout.pos.row = 2, layout.pos.col = 5))
  grid.text("A", vp = viewport(layout.pos.row = 3, layout.pos.col = 3),gp = gpar(alpha=.15,fontsize=70))
  grid.text("B", vp = viewport(layout.pos.row = 3, layout.pos.col = 4),gp = gpar(alpha=.15,fontsize=70))
  grid.text("C", vp = viewport(layout.pos.row = 4, layout.pos.col = 3),gp = gpar(alpha=.15,fontsize=70))
  grid.text("D", vp = viewport(layout.pos.row = 4, layout.pos.col = 4),gp = gpar(alpha=.15,fontsize=70))
  
  grid.lines(x = unit(c(1/8, 1), "npc"), y = unit(c(.5, .5), "npc"))
  grid.lines(x = unit(c(0, 1), "npc"),   y = unit(c(.75, .75), "npc"))
  grid.lines(x = unit(c(0, 1), "npc"),   y = unit(c(.25, .25), "npc"))
  grid.lines(x = unit(c(.25, .25), "npc"), y = unit(c(1, 0), "npc"))
  grid.lines(x = unit(c(.5, .5), "npc"),   y = unit(c(7/8, 0), "npc"))
  grid.lines(x = unit(c(.75, .75), "npc"), y = unit(c(1, 0), "npc"))
}

figure_table_eng <- function(...){
  pushViewport(viewport(layout = grid.layout(nrow=5, ncol=5, 
                                             widths  = unit(c( 1, 1, 2, 2, 2), "null"),
                                             heights = unit(c( 1, 1, 2, 2, 2), "null"))))
  
  grid.text("Truth", vp = viewport(layout.pos.row = 1, layout.pos.col = 3:4))
  grid.text("Test", vp = viewport(layout.pos.row = 3:4, layout.pos.col = 1), rot=90)
  grid.text("+",      vp = viewport(layout.pos.row = 3, layout.pos.col = 2), rot=90)
  grid.text("-",      vp = viewport(layout.pos.row = 4, layout.pos.col = 2), rot=90)
  grid.text("Total", vp = viewport(layout.pos.row = 5, layout.pos.col = 2), rot=90)
  grid.text("+",      vp = viewport(layout.pos.row = 2, layout.pos.col = 3))
  grid.text("-",      vp = viewport(layout.pos.row = 2, layout.pos.col = 4))
  grid.text("Total", vp = viewport(layout.pos.row = 2, layout.pos.col = 5))
  grid.text("A", vp = viewport(layout.pos.row = 3, layout.pos.col = 3),gp = gpar(alpha=.15,fontsize=70))
  grid.text("B", vp = viewport(layout.pos.row = 3, layout.pos.col = 4),gp = gpar(alpha=.15,fontsize=70))
  grid.text("C", vp = viewport(layout.pos.row = 4, layout.pos.col = 3),gp = gpar(alpha=.15,fontsize=70))
  grid.text("D", vp = viewport(layout.pos.row = 4, layout.pos.col = 4),gp = gpar(alpha=.15,fontsize=70))
  
  grid.lines(x = unit(c(1/8, 1), "npc"), y = unit(c(.5, .5), "npc"))
  grid.lines(x = unit(c(0, 1), "npc"),   y = unit(c(.75, .75), "npc"))
  grid.lines(x = unit(c(0, 1), "npc"),   y = unit(c(.25, .25), "npc"))
  grid.lines(x = unit(c(.25, .25), "npc"), y = unit(c(1, 0), "npc"))
  grid.lines(x = unit(c(.5, .5), "npc"),   y = unit(c(7/8, 0), "npc"))
  grid.lines(x = unit(c(.75, .75), "npc"), y = unit(c(1, 0), "npc"))
}

# # Load Figures
myurl <- "http://i.imgur.com/HWmtyFd.png"
normal_png <- readPNG(getURLContent(myurl))
normal_fig <- rasterGrob(normal_png, interpolate=TRUE)

myurl <- "http://i.imgur.com/fr7SKOG.png"
priorl_png <- readPNG(getURLContent(myurl))
priorl_fig <- rasterGrob(priorl_png, interpolate=TRUE)

myurl <- "http://i.imgur.com/6zvepnI.png"
priorh_png <- readPNG(getURLContent(myurl))
priorh_fig <- rasterGrob(priorh_png, interpolate=TRUE)

myurl <- "http://i.imgur.com/2IXFWZq.png"
perfect_png <- readPNG(getURLContent(myurl))
perfect_fig <- rasterGrob(perfect_png, interpolate=TRUE)

myurl <- "http://i.imgur.com/UeLHhxX.png"
worse_png <- readPNG(getURLContent(myurl))
worse_fig <- rasterGrob(worse_png, interpolate=TRUE)

# # Data Frames 
# Normal
Normal <- data.frame(Score = seq(from = 0, to = 100, by = 5) + 0.01,
                     Sick  = c(0,1,0,0,0,1,0,0,1,0,0,1,0,1,0,1,1,1,0,1,1))
Normal_roc <- roc(response = Normal$Sick, predictor = Normal$Score)
Normal_rocT<- data.frame(sens=Normal_roc$sensitivities*100,
                         spec=(1-Normal_roc$specificities)*100,
                         score=Normal_roc$thresholds)

# Prior Laag
PriorL <- data.frame(Score = seq(from = 0, to = 100, by = 5) + 0.01,
                     Sick  = c(0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,1,0,1,1))
PriorL_roc <- roc(response = PriorL$Sick, predictor = PriorL$Score)
PriorL_rocT<- data.frame(sens=PriorL_roc$sensitivities*100,
                         spec=(1-PriorL_roc$specificities)*100,
                         score=PriorL_roc$thresholds)

# Prior Hoog
PriorH <- data.frame(Score = seq(from = 0, to = 100, by = 5) + 0.01,
                     Sick  = c(0,1,1,0,0,1,1,1,1,0,1,1,1,1,0,1,1,1,1,1,1))
PriorH_roc <- roc(response = PriorH$Sick, predictor = PriorH$Score)
PriorH_rocT<- data.frame(sens=PriorH_roc$sensitivities*100,
                         spec=(1-PriorH_roc$specificities)*100,
                         score=PriorH_roc$thresholds)

# Perfect
Perfect <- data.frame(Score = seq(from = 0, to = 100, by = 5) + 0.01,
                      Sick  = c(0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1))
Perfect_rocT <- data.frame(sens = c(0,100,100),
                           spec = c(0,0,100)
)

# Worse
Worse <- data.frame(Score = seq(from = 0, to = 100, by = 5) + 0.01,
                    Sick  = c(1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0))
Worse_rocT <- data.frame(sens = c(0,0,100),
                         spec = c(0,100,100)
)

# # Empty Plot
plot <- 
  ggplot(Normal, aes(x=Score, y=Sick), geom="blank") +
  theme_bw() +
  #   geom_line() + 
  scale_y_continuous(limits=c(0,1), breaks= NULL, 
                     labels=NULL, name="") +
  scale_x_continuous(limits=c(0,105),breaks=(seq(0,100,25)),expand=c(0,0),name="") +
  theme(axis.text= element_text(size=16, colour="black"),
        panel.background = element_rect(fill = "transparent",colour = NA), # or theme_blank()
        panel.grid.minor = element_blank(), 
        panel.grid.major = element_blank(),
        plot.background = element_rect(fill = "transparent",colour = NA),
        plot.margin = unit(c(0,0,0,-1), "cm")
  )

# # Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  output$selectTitle <- renderPrint({
    selOut <- "CAT: Sensitiviteit en Specificiteit"
    if(input$lang == "eng") selOut <- "CAT: Sensitivity and Specificity"
    cat(selOut)
  })
  
  output$selectUIQual <- renderUI({ 
    choices_qual <- c("Normaal" = "nor", "Prior Laag" = "priL", "Prior Hoog" = "priH", "Perfect" = "per", "Slecht" = "wor")
    if(input$lang == "eng") choices_qual <- c("Normal" = "nor", "Prior Low" = "priL", "Prior High" = "priH", "Perfect" = "per", "Worse" = "wor")
    selOut <- "Conditie"
    if(input$lang == "eng") selOut <- "Condition"
    selectInput("selfr", strong(selOut), choices = choices_qual)
  })
  
  output$selectUIClass <- renderUI({ 
    selOut <- "Classificatie"
    if(input$lang == "eng")   selOut <- "Classification"
    checkboxInput("PF_cor",selOut,value = FALSE)
  })
  
  output$selectUIFil <- renderUI({ 
    selOut <- "Invullen"
    if(input$lang == "eng")   selOut <- "Fill"
    checkboxInput("TA_inv",selOut,value=FALSE)
  })
  
  output$selectUIComp <- renderUI({ 
    selOut <- "Uitrekenen"
    if(input$lang == "eng")   selOut <- "Compute"
    checkboxInput("TA_uit",selOut,value=FALSE)
  })
  
  output$selectHeaderTable <- renderPrint({
    selOut <- "Tabel"
    if(input$lang == "eng")   selOut <- "Table"
    cat(paste("<b>",selOut,"</b>",sep=""))
  })
  
  output$selectHeaderFigur <- renderPrint({
    selOut <- "Figuur"
    if(input$lang == "eng")   selOut <- "Figure"
    cat(paste("<b>",selOut,"</b>",sep=""))
  })
  
  output$selectExplainHeader <- renderPrint({
    selOut <- "Uitleg"
    if(input$lang == "eng") selOut <- "Explanation"
    cat(paste("<b>",selOut,"</b>",sep=""))
  })
  
  output$selectExplain <- renderPrint({
    selOut <- "Voor een bepaalde ziekte zijn 21 personen gescreend met een nieuw instrument. De scores lopen van 0 t/m 105, waarbij een hogere score staat voor een grotere kans op de ziekte. In werkelijkheid hebben de groene personen de ziekte niet, en de rode personen wel. Het afkappunt kan (boven de figuur) worden verschoven om zodoende te kijken welke gevolgen dit heeft voor de sensitiviteit, specificiteit, NPV, en PPV. De optie Cell onder Figuur geeft de locatie van ieder persoon in de 2x2 tabel aan. De optie Classificatie toont aan of met het desbetreffende afkappunt een persoon juist of onjuist is geclassificeerd (X = Fout; V = Goed). De opties Invullen en Uitrekenen onder Tabel, tonen, respectievelijk, de aantallen in de 2x2 tabel en de bijbehorende sensitiviteit, specificiteit, NPV, en PPV waardes. De figuur rechtsonder geeft de ROC curve weer, waarbij de sensitiviteit en specificiteit van het gekozen afkappunt zijn omcirkeld. Bij condities kunnen verschillende situaties worden gekozen m.b.t. de prior kans van de ziekte en de kwaliteit van het instrument."
    if(input$lang == "eng") selOut <- "For a particular disease 21 individuals are screened with a new instrument. The scores range from 0 to 105, where a higher score indicates a higher risk for the disease. In reality, the green people do not have the disease while the red people do The cut-off point may (above figure) be shifted in order to see what effect this has on the sensitivity, specificity, NPV and PPV. The Cell option under Figure shows the location of each person in the 2x2 table. The option Classification shows for the current cut-off point a person is classified correct or incorrect (X = Wrong; V = Good). The options Fill and Compute under the Table options, show, respectively, the numbers in the 2x2 table and the corresponding sensitivity, specificity, NPV and PPV values. The lower right figure shows the ROC curve, in which the sensitivity and specificity of the selected cutoff are circled. At conditions different situations can be selected with regard to the prior probability of the disease and the quality of the instrument."
    cat(selOut)
  })
  
  # # ACTUAL SHIZZLLE
  
  # # Data Frame Select
  selFrame <- reactive({
    selectFrame <- switch(input$selfr, "nor" = Normal, "priL" = PriorL, "priH" = PriorH, "per" = Perfect, "wor" = Worse)
    selectFrame
  })
  
  # # ROC frame select
  rocFrame <- reactive({
    rocselFrame <- switch(input$selfr, "nor" = Normal_rocT, "priL" = PriorL_rocT, "priH" = PriorH_rocT, "per" = Perfect_rocT, "wor" = Worse_rocT)
    rocselFrame
  })
  
  # # Cell placement of each person
  cell <-  reactive({
    cell_tab <- selFrame()
    cell_tab$Score <- cell_tab$Score + 2.5
    cell_tab$Letter <- NA
    cell_tab[cell_tab$Score < input$afkap & cell_tab$Sick == 0 ,"Letter"] <- "D"
    cell_tab[cell_tab$Score > input$afkap & cell_tab$Sick == 0 ,"Letter"] <- "B"
    cell_tab[cell_tab$Score < input$afkap & cell_tab$Sick == 1 ,"Letter"] <- "C"
    cell_tab[cell_tab$Score > input$afkap & cell_tab$Sick == 1 ,"Letter"] <- "A"
    # # Correct or not (simplification of letters)
    cell_tab$Correct <- "X"
    cell_tab[cell_tab$Letter == "A" |  cell_tab$Letter == "D","Correct"] <- "V"
    cell_tab
  })
  
  # # 2x2 table
  basictable <- reactive({
    tabl_tab <- selFrame()
    postest <- sum(tabl_tab$Score > input$afkap)
    negtest <- sum(tabl_tab$Score < input$afkap)
    tabel <- matrix(NA,3,3)
    tabel[1,] <- c(sum(tabl_tab[tabl_tab$Score > input$afkap,"Sick"] == 1), 
                   sum(tabl_tab[tabl_tab$Score > input$afkap,"Sick"] == 0),
                   postest)
    tabel[2,] <- c(sum(tabl_tab[tabl_tab$Score < input$afkap,"Sick"] == 1), 
                   sum(tabl_tab[tabl_tab$Score < input$afkap,"Sick"] == 0),
                   negtest)
    tabel[3,] <- c(sum(tabel[1:2,1]),sum(tabel[1:2,2]),nrow(tabl_tab))
    tabel
  })  
  
  # # Top figure
  output$basefig <- renderPlot({
    # # Select figure 
    selectFigure <- switch(input$selfr, "nor" = normal_fig, "priL" = priorl_fig, "priH" = priorh_fig, "per" = perfect_fig, "wor" = worse_fig)
    # # Dataframe
    bfig_tab <- selFrame()
    # # LEtters
    letters <- cell()
    # # vertical line
    plot <- plot + geom_vline(xintercept=input$afkap, lwd = 1.5)
    # # Insert letters if requested
    if(input$PF_cel) plot <- plot + geom_text(data = letters, aes(x=Score,label=Letter), y =.8)
    # # Insert good/false if requested
    if(input$PF_cor) plot <- plot + geom_text(data = letters, aes(x=Score,label=Correct), y =.2)
    # # Add +/- of test
    plot <- plot + annotate("text", label="- ", x=input$afkap,y=1,hjust=1, fontface=2)
    plot <- plot + annotate("text", label=" +", x=input$afkap,y=1,hjust=0, fontface=2)
    # # Add Rectangle for +/- of test
    plot <- plot + geom_rect(xmin=input$afkap,xmax=Inf, ymin=-Inf,ymax=Inf,alpha=.005,fill="red",colour=NA) 
    plot <- plot + geom_rect(xmin=-Inf,xmax=input$afkap,ymin=-Inf,ymax=Inf,alpha=.005,fill="green",colour=NA)
    # # No legend
    plot <- plot + theme(legend.position="none")
    # # Add figure
    plot <- plot + annotation_custom(selectFigure, xmin=0, xmax=105, ymin=0, ymax=1) 
    # # Print plot
    print(plot)
  })
  
  # # 2x2 table figure
  output$tabfig <- renderPlot({
    # # Load empty grid 
    if(input$lang == "dutch") figure_table()
    if(input$lang == "eng")   figure_table_eng()
    # # Add numbers for each grid position
    if(input$TA_inv){
      grid.text(basictable()[1,1], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 3, layout.pos.col = 3))
      grid.text(basictable()[1,2], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 3, layout.pos.col = 4))
      grid.text(basictable()[2,1], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 4, layout.pos.col = 3))
      grid.text(basictable()[2,2], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 4, layout.pos.col = 4))
      
      grid.text(basictable()[3,1], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 5, layout.pos.col = 3))
      grid.text(basictable()[3,2], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 5, layout.pos.col = 4))
      grid.text(basictable()[1,3], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 3, layout.pos.col = 5))
      grid.text(basictable()[2,3], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 4, layout.pos.col = 5))
      
      grid.text(basictable()[3,3], gp = gpar(fontface = "bold", fontsize = 20), vp = viewport(layout.pos.row = 5, layout.pos.col = 5))
    }
  })
  
  # # Compute sensitivity
  sens <- reactive({
    basictable()[1,1]/basictable()[3,1]
  })
  
  # # Compute specificity
  spec <- reactive({
    basictable()[2,2]/basictable()[3,2]
  })
  
  # # Compute ppv
  ppv <- reactive({
    basictable()[1,1]/basictable()[1,3]
  })
  
  # # Compute npv
  npv <- reactive({
    basictable()[2,2]/basictable()[2,3]
  })
  
  # # Print formulas with solution if requested
  output$sens_form <- renderPlot({
    # # Grid layout
    gl <- grid.layout(nrow=4, ncol=1)
    vp.1 <- viewport(layout.pos.col=1, layout.pos.row=1) 
    vp.2 <- viewport(layout.pos.col=1, layout.pos.row=2) 
    vp.3 <- viewport(layout.pos.col=1, layout.pos.row=3) 
    vp.4 <- viewport(layout.pos.col=1, layout.pos.row=4) 
    
    # # init layout
    pushViewport(viewport(layout=gl))
    
    Sensitiviteit <- "Sensitiviteit"
    Specificiteit <- "Specificiteit"
    
    if(input$lang == "eng") Sensitiviteit <- "Sensitivity"
    if(input$lang == "eng") Specificiteit <- "Specificity"
    
    # # Only formulas
    if(!input$TA_uit){
      pushViewport(vp.1)
      grid.text(bquote({plain(.(Sensitiviteit)) == frac(A,A+C)}),x = 0, just = 0)
      popViewport()
      pushViewport(vp.2)
      grid.text(bquote({plain(.(Specificiteit)) == frac(D,B+D)}),x = 0, just = 0)
      popViewport()  
      pushViewport(vp.3)
      grid.text(bquote({plain(PPV) == frac(A,A+B)}),x = 0, just = 0)
      popViewport()  
      pushViewport(vp.4)
      grid.text(bquote({plain(NPV) == frac(D,C+D)}),x = 0, just = 0)
      popViewport()        
    } else {
      # # Add solutions 
      pushViewport(vp.1)
      grid.text(bquote({{plain(.(Sensitiviteit)) == frac(A,A+C)}=={frac(.(basictable()[1,1]),.(basictable()[3,1]))}} == .(round(sens(),2))),x = 0, just = 0)
      popViewport()
      pushViewport(vp.2)
      grid.text(bquote({{plain(.(Specificiteit)) == frac(D,B+D)}=={frac(.(basictable()[2,2]),.(basictable()[3,2]))}} == .(round(spec(),2))),x = 0, just = 0)
      popViewport()  
      pushViewport(vp.3)
      grid.text(bquote({{plain(PPV) == frac(A,A+B)}=={frac(.(basictable()[1,1]),.(basictable()[1,3]))}} == .(round(ppv(),2))),x = 0, just = 0)
      popViewport()  
      pushViewport(vp.4)
      grid.text(bquote({{plain(NPV) == frac(D,C+D)}=={frac(.(basictable()[2,2]),.(basictable()[2,3]))}} == .(round(npv(),2))),x = 0, just = 0)
      popViewport()   
    }
  })
  
  # # ROC figure
  output$ROC <- renderPlot({
    Specificiteit_lab <- "Specificiteit (%)"
    Sensitiviteit_lab <- "Sensitiviteit (%)"
    
    if(input$lang == "eng") Specificiteit_lab <- "Sensitivity (%)"
    if(input$lang == "eng") Sensitiviteit_lab <- "Specificity (%)"
    
    roc_tab <- rocFrame()
    pplot <- ggplot(roc_tab[order(roc_tab$spec,roc_tab$sens),], aes(x=spec,y=sens)) + 
      geom_line() +
      geom_abline(intercept =0, slope =1,lty=2) +
      geom_point(x=(1-spec())*100, y=sens()*100) +
      geom_text(label = input$afkap, x=(1-spec())*100, y=sens()*100,vjust=1, hjust=0) +
      scale_x_continuous(breaks=c(0,25,50,75,100), labels = c(100,75,50,25,0), name= Specificiteit_lab) +
      scale_y_continuous(limits=c(-10,110),breaks=c(0,25,50,75,100), name= Sensitiviteit_lab)
    print(pplot)
  })

})

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