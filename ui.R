library(shiny)
library(plotly)

# formattable::as.htmlwidget()
# library(htmlwidgets)
# htmlwidgets::shinyRenderWidget()
# htmlwidgets::shinyWidgetOutput()



shinyUI(
  fluidPage(
    titlePanel("Analiza treści artykułów na portalach informacyjnych"),
    
    
    sidebarLayout(
      sidebarPanel(
        strong(paste("Treść na 7 dni przed/po zdarzeniu")),
        checkboxInput("isBefore", "Przed", value = FALSE),
        checkboxInput("isAfter", "Po", value = TRUE),
        selectizeInput("eventName", 
                       "Wybierz zdarzenie(a)", 
                       choices = unique(pca.frm$eventName), 
                       multiple = TRUE, 
                       selected = c("I-tura wyborow prezydenckich", "II-tura wyborow prezydenckich")),
        selectizeInput("topicsSource",
                       "Wybierz portal",
                       choices = c("Gazeta Wyborcza", "Nasz Dziennik", "Super Express"),
                       multiple = FALSE,
                       selected = "Nasz Dziennik"),
        sliderInput("topicsNumber",
                    label = "Wybierz liczbę tematów do wyodrębnienia",
                    min = 1,
                    max = 8,
                    value = 4,
                    step = 1)
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("readme", column(width = 12,
                                              p("Text mining artykułów na portalach internetowych"),
                                              br(),
                                              p("eloelo"))
                             ),
                    tabPanel("Wydarzenia", column(width = 12,
                                                  h4("Analiza głównych składowych"),
                                                  plotly::plotlyOutput("scatterPlot"))
                             ),
                    tabPanel("Tematy", column(width = 12,
                                              h4("Poszczególne tematy"))
                             ),
                    tabPanel("Słowa", column(width = 12,
                                             h4("Najczęściej występujące słowa dla danego portalu w podziale na wydarzenia"),
                                             plotOutput("wcPlot")))
                    )
        
      )
    )
  ))
