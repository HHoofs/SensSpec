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
  grid.text("Test", vp = viewport(layout.pos.row = 3:4, layout.pos.col = 1), rot=90)
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
    figure_table()
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
    
    # # Only formulas
    if(!input$TA_uit){
      pushViewport(vp.1)
      grid.text(bquote({plain(Sensitiviteit) == frac(A,A+C)}),x = 0, just = 0)
      popViewport()
      pushViewport(vp.2)
      grid.text(bquote({plain(Specificiteit) == frac(D,B+D)}),x = 0, just = 0)
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
      grid.text(bquote({{plain(Sensitiviteit) == frac(A,A+C)}=={frac(.(basictable()[1,1]),.(basictable()[3,1]))}} == .(round(sens(),2))),x = 0, just = 0)
      popViewport()
      pushViewport(vp.2)
      grid.text(bquote({{plain(Specificiteit) == frac(D,B+D)}=={frac(.(basictable()[2,2]),.(basictable()[3,2]))}} == .(round(spec(),2))),x = 0, just = 0)
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
    roc_tab <- rocFrame()
    pplot <- ggplot(roc_tab[order(roc_tab$spec,roc_tab$sens),], aes(x=spec,y=sens)) + 
      geom_line() +
      geom_abline(intercept =0, slope =1,lty=2) +
      geom_point(x=(1-spec())*100, y=sens()*100) +
      geom_text(label = input$afkap, x=(1-spec())*100, y=sens()*100,vjust=1, hjust=0) +
      scale_x_continuous(breaks=c(0,25,50,75,100), labels = c(100,75,50,25,0), name="Specificiteit (%)") +
      scale_y_continuous(limits=c(-10,110),breaks=c(0,25,50,75,100), name="Sensitiviteit (%)")
    print(pplot)
  })
})