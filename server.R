library(shiny)
library(plotly)
library(dplyr)
library(ggplot2)
library(wordcloud)
library(DT)



shinyServer(function(input, output) {
  ##### Reactive elements
  #
  #
  isBefore <- reactive({input$isBefore})
  isAfter <- reactive({input$isAfter})
  events <- reactive({input$eventName})
  topicSource <- reactive({input$topicsSource})
  topicNumber <- reactive({input$topicsNumber})
  wordSelect <- reactive({input$wordSelect})
  
  ###### Functions
  #
  #
  ldaPlot <- function(frm, articleSource){
    frm$pos <- factor(frm$pos, order(frm$pos, decreasing = TRUE))
    
    p <- ggplot(frm, aes(x = as.factor(topicId), y = pos, label = word_u, fill = count_all)) + 
      geom_tile(alpha = 0.9) + 
      geom_text(colour = "white") + 
      theme_minimal() +
      ylab(articleSource) +
      theme(axis.ticks.y = element_blank(),
            line = element_blank(),
            axis.title.x = element_blank(),
            axis.text.y = element_blank(),
            axis.text.x = element_blank())
    
    p$labels$fill <- "Czestosc"
    
    return(p)
  }
  
  ldaFrame <- function(lda, articleSource, topicsNumber){
    lda[lda$source == articleSource & lda$topicId <= topicsNumber, ] %>%
      group_by(topicId) %>%
      mutate(pos = row_number()) -> frm
    
    return(frm)
  }
  
  ####### Outputs
  #
  #
  #DKL_GW	DKL_ND	DKL_SE
  #105.194979399	122.453115248	32.8691035484
  
  output$dklValue <- renderText({
    return(paste("DKL(P='naszdziennik.pl' | Q='gazeta.pl') = 180.00"))
  })
  
  output$dklTable <- renderTable({
    return(data.frame(`Gazeta Wyborcza`=105.19, `Nasz Dziennik`=122.45, `Super Express`=32.87))
  })
  
  output$gwPlot <- renderPlot({
    src <- "Gazeta Wyborcza"
    frm <- ldaFrame(lda, src, topicNumber())
    plt <- ldaPlot(frm, src)
    
    return(print(plt))
  })
  
  output$ndPlot <- renderPlot({
    src <- "Nasz Dziennik"
    frm <- ldaFrame(lda, src, topicNumber())
    plt <- ldaPlot(frm, src)
    
    return(print(plt))
  })
  
  output$sePlot <- renderPlot({
    src <- "Super Express"
    frm <- ldaFrame(lda, src, topicNumber())
    plt <- ldaPlot(frm, src)
    
    return(print(plt))
  })
  
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
    
    set.seed(666)
    wordcloud(wc.plt$word, wc.plt$cnt, colors = pal, max.words = 100, scale = c(8, 0.3))
  })
  
  output$topicTable <- renderTable({
    tbl <- data.frame(
      Temat.1 = c("praca", "budżet/finanse", "wybory"),
      Temat.2 = c("katastrofa/wypadek", "kościół/papież", "papież/Wałęsa"),
      Temat.3 = c("nauka/matura", "praca/przetargi", "500+"),
      Temat.4 = c("Rosja/USA", "Smoleńsk/katastrofa", "Rosja/Ukraina"),
      Temat.5 = c("Trybunał Konst.", "obchody święta", "katastrofa/wypadek"),
      Temat.6 = c("prawo/sensacje", "Rosja/Ukraina", "wypadek/sensacje"),
      Temat.7 = c("wybory", "prawo/aborcja", "wypadek/sensacje"),
      Temat.8 = c("uchodźcy", "prawo", "lokalne"),
      row.names = c("Gazeta Wyborcza", "Nasz Dziennik", "Super Express"))
    
    return(tbl[, 1:topicNumber()])
  })
  
  output$introWordcount <- renderTable({
    return(data.frame(Gazeta.Wyborcza = c(5.975764,
                                          3.869931),
                      Nasz.Dziennik = c(6.051237,
                                        3.462286),
                      Super.Express = c(5.800287,
                                        3.291448),
                      row.names = c("Średnia", "Odch. Stand.")))
  })
  
  output$word2vecTable <- renderDataTable(datatable({
    w2v[w2v$Slowo == wordSelect(), c("Gazeta.Wyborcza", "Nasz.Dziennik", "Super.Express")]
  }))
  
  output$word2vecInfo <- renderText({
    if(wordSelect() == "papież"){return(HTML("W tabeli widać wyraźną różnicę w skojarzeniach dla słowa „papież”. W Naszym Dzienniku jest ono zdecydowanie powiązane z Janem Pawłem II. Obecny papież Franciszek nie występuje w pierwszych czterdziestu wynikach wcale, natomiast poprzedni papież Benedykt XVI pojawia się na 24 miejscu. Z kolei dla Gazety.pl to Franciszek znajduje się na pierwszym miejscu, na czwartym Benedykt XVI, natomiast Jan Paweł II dopiero na 14 miejscu. W Super Expressie również Franciszek pojawia się przed Janem Pawłem II, jednak wyniki są gorzej dopasowane niż dla pozostałych źródeł. Może to stanowić pewną wskazówkę do interpretacji kwestii religijnych poruszanych przez wybrane media."))}
    if(wordSelect() == "gender"){return(HTML("W tabeli zestawiono wyniki dla hasła „gender”. Zwraca uwagę ranking z Naszego Dziennika, w którym łączy się ono z takimi pojęciami jak pedofilia, satanizm, neomarksizm, aborcja, dewiacja czy homoseksualizm, które sugerują zdecydowanie negatywne konotacje w danym źródle. W pozostałych źródłach trudniej się doszukać tak wyraźnych powiązań między hasłami."))}
    if(wordSelect() == "niemcy"){return(HTML("W tabeli zawierającej wyniki dla hasła „niemcy” po raz kolejny widać bardzo wyraźne nacechowanie emocjonalne najbardziej powiązanych słów. Widać, że główny kontekst w jakim występuje to hasło dotyczy II wojny światowej i zbrodni wojennych, poza hasłami określającymi inne narodowości zaangażowane w konflikt pojawia się wiele określeń na czynności jakich mieli się oni dokonywać. Dla porównania w Gazecie.pl zestawienie zawiera w głównej mierze nazwy państw i narodowości, jako najbardziej powiązane znaczeniem z wyszukiwanym hasłem."))}
  })
  output$peopleFameRank <- renderTable(people)
  
  output$countriesFameRank <- renderTable(countries)
  
  output$lettersPerWord <- renderTable(lettersPerWord)
  
  output$wordsPerArticle <- renderTable(wordsPerArticle)
  
})
