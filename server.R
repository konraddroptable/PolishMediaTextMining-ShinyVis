library(shiny)
library(plotly)
library(formattable)
library(htmlwidgets)
library(dplyr)

shinyServer(function(input, output) {
  isBefore <- reactive({input$isBefore})
  isAfter <- reactive({input$isAfter})
  events <- reactive({input$eventName})
  topicSource <- reactive({input$topicsSource})
  topicNumber <- reactive({input$topicsNumber})
  
  output$scatterPlot <- renderPlotly({
    eventPeriod <- c("przed", "po")
    ep <- eventPeriod[c(isBefore(), isAfter())]
    scatter.frm <- pca.frm[pca.frm$eventName %in% events() & pca.frm$eventTime %in% ep, ]
    
    plot_ly(data = scatter.frm, x = x, y = y, 
            text = paste(eventTime, eventName), 
            type = "scatter",
            mode = "markers", 
            color = source, 
            colors = "Set1",
            marker = list(size = 14, opacity = 0.67))
  })
  
  output$wcPlot <- renderPlot({
    eventPeriod <- c("start", "end")
    ep <- eventPeriod[c(isBefore(), isAfter())]
    events = c("zamachy w Charlie Hebdo", "zamachy w Paryzu")
    
    wc[wc$source == topicSource() & wc$value %in% events() & wc$time %in% ep, c("word", "count")] %>%
      group_by(word) %>%
      summarise(cnt = sum(count)) -> wc.plt
    
    pal <- brewer.pal(9,"YlGnBu")
    pal <- pal[-(1:4)]
    
    wordcloud(wc.plt$word, wc.plt$cnt, colors = pal, max.words = 100)
  })
  
})
