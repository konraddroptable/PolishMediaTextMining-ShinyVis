library(shiny)
library(DT)

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
                    step = 1),
        selectizeInput("wordSelect",
                       "Wybierz słowo",
                       choices = c("gender", "niemcy", "papież"),
                       multiple = FALSE,
                       selected = "gender")
      ),
      mainPanel(
        tabsetPanel(type = "tabs",
                    tabPanel("readme", column(width = 12,
                                              h4("Text mining artykułów na portalach internetowych"),
                                              HTML("<p>Celem projektu było przeanalizowanie treści polskiej prasy na przykładzie wybranej wąskiej próby gazet i ich treści udostępnianych w internecie. W powszechnej świadomości większość gazet jest zwykle kojarzona z pewnym środowiskiem i światopoglądem, które ono reprezentuje. Wpływa to na wybór wydarzeń, którym poświęcone są artykuły, aspekt w jakim są one przedstawiane i słownictwo jakie jest użyte w celu ich określenia. Istnienie takich wyraźnych podziałów na rynku prasy jest zapewne oczywiste dla osób zainteresowanych, jednak opiera się raczej na obiegowych opiniach i różnego rodzaju uprzedzeniach istniejących zarówno wśród autorów jak i czytelników polskiej prasy.<p>"),
                                              HTML("<p>W pracy podjęto próbę weryfikacji niektórych opinii dotyczących zarówno formy jak i treści znanych, ogólnopolskich gazet. Skupiono się na artykułach dostępnych w trzech serwisach internetowych związanych z polską prasą: Gazeta.pl, naszdziennik.pl, se.pl.</p>"),
                                              HTML("<ul>
<li>Gazeta.pl jest portalem należącym do grupy Agora i kojarzonym z Gazetą Wyborczą. Został wybrany ze względu na łatwiejszy dostęp do treści artykułów na potrzeby analizy. Chociaż jest znacznie bardziej nastawiony na dotarcie do masowego czytelnika niż Gazeta Wyborcza to przyjęto, że może zostać również uznany za przykład medium skierowanego do odbiorców ze środowisk liberalnych, zazębiających się z gronem czytelników GW.</li>
<li>Naszdziennik.pl jest portalem gazety Nasz Dziennik, jednego z najbardziej znanych pism o profilu katolicko-narodowym, którego artykuły są publikowane na portalu.</li>
<li>Se.pl to portal gazety Super Express, drugiego obok Faktu najbardziej znanego polskiego tabloidu.</li>
                                                   </ul>"),
                                              HTML("<p>Wybór powyższych mediów miał na celu uzyskanie możliwie szerokiego spektrum prasy pod kątem treści i formy artykułów oraz zwiększenie szansy na odnalezienie istotnych różnic z wykorzystaniem narzędzi statystycznych.</p><br>"),
                                              h4("Dane"),
                                              HTML("Pod względem klasyfikacji danych, artykuły z gazet i portali internetowych należą do danych tworzonych przez człowieka. Ze względu na dużą liczbę źródeł są bardzo różnorodne i wymagają starannej obróbki przed wykorzystaniem narzędzi analitycznych. Do wydobycia danych ze stron internetowych wykorzystano technikę scrapingu, dzięki której uzyskano surowy tekst artykułów. W zależności od rodzaju analizy, dane mogły być dodatkowo obrabiane aby uzyskać preferowany format wejściowy danych. Wykorzystano artykuły z kategorii „Polska”, „Polityka” i „Świat”."),
                                              HTML("Dla każdego medium dzięki scrapingowi uzyskano listę kilkunastu tysięcy (15-19 tys.) artykułów wraz z tytułem, datą publikacji oraz linkiem do źródła.<br>"),
                                              HTML("<br><h4>Technologie</h4>
                                                   <ul>
                                                   <li>Python - pobieranie danych ze stron (webscraping), machine learning w Sparku</li>
                                                   <li>R - wstępna obróbka danych</li>
                                                   <li>Apache Spark - zastosowanie algorytmów Machine Learningowych w Big Data</li>
                                                   <li>Shiny - pakiet do R, wizualizacja danych (wizualizacja, którą właśnie oglądasz :)</li>
                                                   <li>Google Compute Engine - serwer z Shiny (dzięki temu możesz to oglądać :)</li></ul>"),
                                              HTML("<br><h4>Kod źródłowy:</h4>
                                                   <ul>
                                                   <li><a href='https://github.com/pbylicki/media-crawl'>Pobieranie danych</a></li>
                                                   <li><a href='https://github.com/konraddroptable/PolishMediaTextMining-RClean'>Oczyszczanie danych</a></li>
                                                   <li><a href='https://github.com/konraddroptable/PolishMediaTextMining-Spark'>Analiza danych w Sparku</a></li>
                                                   <li><a href='https://github.com/konraddroptable/PolishMediaTextMining-ShinyVis'>Wizualizacja w Shiny</a></li></ul>")
                                              )
                             ),
                    tabPanel("Rozkłady", column(width = 12,
                                                h4("Analiza liczby słów w artykułach i liczby liter w słowach"),
                                                h4("Liczba słów w artykule"),
                                                tableOutput("wordsPerArticleStats"),
                                                h4("Histogram liczby słów w artykule"),
                                                img(src="words_distribution.png", align="center"),
                                                tableOutput("wordsPerArticle"),
                                                HTML("<p>W powyższych tabelach oraz na wykresie przedstawiono średnią liczbę słów w artykule oraz rozkład liczby słów w artykule. Można zaobserwować pewne różnice pomiędzy poszczególnymi mediami. Średnio najkrótsze teksty są umieszczane w Super Expressie. Zgadza się to ze specyfiką pism tabloidowych, które pierwotnie posiadały mniejszy format niż tradycyjne gazety i oferowały krótkie, proste teksty mające wzbudzać sensację, opatrzone dużą ilością ilustracji. Histogram dla tego źródła odbiega najbardziej od pozostałych – dominują teksty w zakresie 100-200 słów. Liczba artykułów zawierających powyżej 300 słów jest bardzo niska.</p><p>Widać również różnicę pomiędzy Naszym Dziennikiem a Gazetą.pl. W Gazecie jest znacznie więcej najkrótszych artykułów, co można tłumaczyć internetową specyfiką tego medium. Część treści jest udostępniana w formie materiałów wideo lub galerii zdjęć opatrzonych krótkim opisem. Poza odchyleniem dla najkrótszych artykułów, rozkład liczby słów w artykule jest zbliżony dla obu mediów.</p>"),
                                                h4("Liczba liter w słowie"),
                                                tableOutput("lettersPerWordStats"),
                                                h4("Histogram liczby liter w słowie"),
                                                img(src="letters_distribution.png", align="center"),
                                                tableOutput("lettersPerWord"),
                                                HTML("<p>W powyższych tabelach oraz na wykresie przedstawiono rozkład liczby liter w słowie w badanych źródłach. Najmniejszą średnią ilość liter oraz najniższe odchylenie standardowe ma Super Express, zaś najwyższą średnią ma Nasz Dziennik. Na histogramie widać, że w Super Expressie częściej niż w pozostałych źródłach występują słowa mające do 7 liter, natomiast w Naszym Dzienniku jest względnie najwięcej słów posiadających ponad 8 liter. Chociaż w tym przypadku różnice są znacznie bardziej subtelne niż dla liczby słów w artykule to mogą też świadczyć o różnicy w strukturze języka wykorzystywanego w artykułach Super Expressu.</p>")
                                                )),
                    tabPanel("Wydarzenia", column(width = 12,
                                                  h4("Analiza głównych składowych"),
                                                  HTML("<p>Zastosowanie 
                                                       <a href='https://en.wikipedia.org/wiki/Principal_component_analysis'>analizy głównych składowych</a> w celu skwantyfikowania treści artykułów
                                                       na portalach intertnetowych <b>w podziale na różne wydarzenia</b> z kraju i świata do (przyjaznej dla oka) postaci dwuwymiarowej.<br>
                                                       Niestety, cięzko jest znaleźć jakieś sensowne wytłumaczenie/historyjkę, dla której można opowiedzieć poniższe rozłożenie punktów na wykresie.<br>
                                                       </p>"),
                                                  plotly::plotlyOutput("scatterPlot"))
                             ),
                    tabPanel("Tematy", column(width = 12,
                                              h4("Automatyczne dopasowywanie słów do wyodrębnionej liczby tematów w podziale na portal informacyjny"),
                                              HTML("<p>W celu wyodrębnienia wykorzystany został model 
                                                   <a href='https://en.wikipedia.org/wiki/Latent_Dirichlet_allocation'>Latent Dirichlet Allocation</a>
                                                   (nie ma/nie chce mi się szukać tłumaczenia na polski :)).<br>
                                                    Co to takiego i o co w tym chodzi?<br>
                                                    Mając artykuły z danego portalu (które składają się z poszczególnych słów),
                                                   można spróbować wyodrębnić pewną ilość tematów, dla których <b>pasują odpowiednie słowa</b> z odpowiednią wagą
                                                   (która informuje o tym, jak bardzo istotne jest dane słowo w tym temacie).</p>
                                                   <p>Poniższe tabele przedstawiają poszczególne tematy (kolejność tematów nie ma znaczneia, a także
                                                   nie ma związku pomiędzy numerami tematów dla danych portali). Im wyżej słowo w tabeli, tym wyższa jego waga,
                                                   a więc i <b>większe znaczenie dla danego tematu ma to słowo</b>. Natomiast kolor komórki oznacza <b>częstość występowania
                                                   danego słowa na portalu</b> (im jaśniejszy kolor komórki, tym częściej dane słowo występuje).</p>"),
                                              HTML("<p>Poniżej moja (subiektywna) nazwa dla danego tematu na podstawie słów znajdujących się w tabeli:</p>"),
                                              tableOutput("topicTable"),
                                              plotOutput("gwPlot"),
                                              plotOutput("ndPlot"),
                                              plotOutput("sePlot")
                                              )
                             ),
                    tabPanel("Słowa", column(width = 12,
                                             HTML("<h4>Najczęściej występujące słowa dla <b>wybranego portalu</b> w podziale na <b>zaznaczone wydarzenia</b> w okresie przed lub po jego wystąpieniu.</h4>"),
                                             HTML("<p>Im większe i ciemniejsze słowo, tym częsciej ono występuje dla zaznaczonych po lewej stronie kryteriów.</p>"),
                                             plotOutput("wcPlot"))),
                    tabPanel("Podobienstwa", column(width = 12,
                                                    h4("Podobieństwa w treści artykułów między portalami"), 
                                                    br(),
                                                    HTML(paste("<p>Do porównania podobienstw miedzy artykulami zostala wykorzystana ", 
                                                          "<a href='https://en.wikipedia.org/wiki/Kullback%E2%80%93Leibler_divergence'>dywergencja Kullbacka-Leiblera (DKL)</a>.</p>")),
                                                    HTML(paste("<p>Miara ta informuje o różnicach między dwoma rozkładami (aproksymowanym i teoretycznym). 
                                                          W tym przypadku, rozkładem teoretycznym jest treść artykułów artykułów na wszystkich portalach (gazeta.pl, naszdziennik.pl, se.pl),
                                                          z kolei rozkładem aproksymowanym będzie treść artykułów, np. na portalu naszdziennik.pl</p>")),
                                                    HTML(paste("<p>DKL przyjmuje wartości większe od zera, gdzie wartości <i>bliskie zeru świadczą o małej zawartości informacyjnej</i> 
                                                          artykułów na danym portalu, ponieważ treść na danym portalu <b>nie wyróżnia się niczym od ogółu</b>. 
                                                          Analogicznie, <b>wysokie wartości</b> współczynnika informują o dużej zawartości informacyjnej artykułów),
                                                          ponieważ występują <b>spore różnice w treści</b> znajdującej się na danym portalu w porównaniu do pozostałych portali.</p>")),
                                                    tableOutput("dklTable"),
                                                    br(),
                                                    HTML(paste("<p>Powyższe wartości współczynników świadczą o małej zawartości informacyjnej na portalu se.pl. 
                                                               Z kolei o sporym zróżnicowaniu w treści artykułów na portalach gazeta.pl i naszdziennik.pl. 
                                                               </br>Oba portale (gazeta.pl i naszdziennik.pl) mają zbliżone wartości współczynników, co świadczy o sporych różnicach między treścią
                                                               na tych portalach w porównaniu do ogółu, ale nie wiadomo, czy występują takie różnice między portalem naszdziennik.pl, a gazeta.pl.
                                                               </br>O co chodzi?<br>
                                                               -Tak jak wyżej napisałem, w dywergencji Kullbacka-Leiblera porównuje się rozkład aproksymowany (teraz nim będzie treść artykułów na portalu naszdziennik.pl),
                                                               z rozkładem teoretycznym (tym razem będą to artykuły na protalu gazeta.pl), w celu ustalenia różnic w obu rozkładach 
                                                               - mówiąc inaczej, czy treść artykułów na naszdziennik.pl odbiega mocno od artykułów na stronie gazeta.pl.</p>")),
                                                    verbatimTextOutput("dklValue"),
                                                    HTML(paste("Co oznacza powyższy wynik?</br>
                                                               Występują <b>duże róznice</b> między treścią artykułów między portalami
                                                               naszdziennik.pl i gazeta.pl.</br></br>")),
                                                    h4("TL;DR;"),
                                                    HTML(paste("Jeśli chcesz poczytać artykuły, które swoją treścią (słownictwem) niczym się nie wyróżniają - se.pl to dobry wybór.
                                                               Natomiast, jeśli szukasz portali, których zawartość bardzo się różni nie tylko od ogółu, ale także między sobą,
                                                               wybierz naszdziennik.pl lub gazeta.pl."))
                                                    )),
                    tabPanel("Synonimy", column(width = 12,
                                        h4("Wyszukiwanie synonimów dla podanych słów na portalach internetowych"),
                                        HTML("<p><a href='https://en.wikipedia.org/wiki/Word2vec'>Algorytm Word2Vec</a> polega na zamianie  korpusu tekstu na przestrzeń wektorową, w której każde słowo z korpusu posiada swoją wektorową reprezentację i słowa występujące w podobnym kontekście w korpusie są położone w bliskiej odległości od siebie w przestrzeni wektorowej. Pozwala to m.in. na wyszukiwanie synonimów lub podobnych znaczeniowo słów dla słów zawartych w korpusie wykorzystanym do wytrenowania modelu. Na podstawie tekstu artykułów przygotowano model dla każdego ze źródeł, a następnie dla wybranych haseł analizowano wyniki najbardziej podobnych słów zwracanych przez każdy z modeli. Ze względu na specyfikę źródeł skupiono się na hasłach, które sugerowały istnienie różnic w poszczególnych modelach ze względu na światopoglądowy profil wybranych mediów. Najciekawsze wyniki przedstawiono poniżej.</p><br>"),
                                        textOutput("word2vecInfo"),
                                        HTML("<br><br>"),
                                        dataTableOutput("word2vecTable"),
                                        HTML("<br><br>
                                             <p>Zaprezentowane wyniki to zawierają subiektywny wybór haseł, dla których uzyskano interesujące różnice w wynikach. Dla wielu innych haseł (nazwisk osób zaangażowanych politycznie, wydarzeń) wyniki albo nie posiadają wyraźnych różnic albo trudno w nich odnaleźć warty odnotowania wzór. W przedstawionych wynikach można zauważyć znaczne różnice w jakości modelu. Korpus Super Expressu pomimo zbliżonej do innych źródeł ilości artykułów zawierał najmniejszą ilość tekstu co zapewne wpłynęło na słabą jakość modelu. Słabe wyniki Super Expressu potwierdzają również wyniki znajdujące się w zakładce 'Podobieństwa'.</p> <p>Największą ilość słów zawierał korpus Naszego Dziennika i z tego modelu uzyskano najciekawsze rezultaty, chociaż były to nie tylko słowa występujące w tym samym kontekście (pełniące podobną rolę w zdaniu), ale również słowa występujące w pobliżu szukanego słowa.</p>"))
                             ),
                    tabPanel("FameRank", column(width = 12,
                                                h4("Częstość występowania osób i państw w badanych mediach"),
                                                HTML("<p>Poniższą analizę przygotowano poprzez zliczenie wystąpień wszystkich haseł zidentyfikowanych jako związane z daną osobą w oczyszczonym i zlematyzowanym korpusie tekstu artykułów z każdego źródła. Ze względu na wybór kategorii artykułów wykorzystano przykładowe nazwiska ze świata polityki i religii.</p>"),
                                                h4("Osoby"),
                                                tableOutput("peopleFameRank"),
                                                HTML("<p>W przypadku nazwisk polityków, większość z nich najczęściej pojawia się w treści artykułów z Gazeta.pl. Wśród polityków względnie najczęściej wspominanych przez Nasz Dziennik są Donald Tusk oraz Wojciech Jaruzelski. Z kolei Super Express miał najwyższy odsetek artykułów wspominających Lecha Wałęsę, Czesława Kiszczaka oraz Pawła Kukiza. W przypadku postaci ze sfery religijnej to najczęściej pojawiają się one w Naszym Dzienniku, zaś najrzadziej w Super Expressie.<br><br>Wszyscy wybrani zagraniczni politycy występują najczęściej na łamach Gazety.pl.</p>"),
                                                h4("Państwa"),
                                                tableOutput("countriesFameRank"),
                                                HTML("<br><br><p>Większość wybranych państw występuje najczęściej w Gazeta.pl. Wyjątkami są Rosja i Ukraina, które były wzmiankowane częściej w Naszym Dzienniku. Patrząc na odsetek artykułów zawierających hasła to również Niemcy, Chiny oraz Wielka Brytania pojawiały się względnie częściej w Naszym Dzienniku.</p>")
                                                )),
                    tabPanel("Podsumowanie"), column(width = 12,
                                                     HTML("<p>Gdyby podjąć próbę nakreślenia profilu medium na podstawie występujących w nich haseł to Gazeta.pl jest bardziej nastawiona na sprawy międzynarodowe i bieżącą politykę, w Naszym Dzienniku ważną rolę odgrywa polityka, kwestie historyczne i religijne, Super Express najczęściej wspomina osoby kontrowersyjne, prawdopodobnie w celu wzbudzenia sensacji.</p>"))
                    )
        
      )
    )
  ))
