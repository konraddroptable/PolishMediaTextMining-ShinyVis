library(stringr)
library(dplyr)

##################### PCA results
# frm <- read.table("data/pca_output.csv", header = TRUE, sep = ",", stringsAsFactors = FALSE)
# txtSplit <- str_split(frm$names, "__")
# 
# txtSource <- str_replace_all(sapply(txtSplit, function(x) x[[1]]), "_", " ")
# events <- str_split(str_replace_all(sapply(txtSplit, function(x) x[[2]]), c("_end" = " end", "_start" = " start")), " ")
# 
# eventName <- sapply(events, function(x) x[[1]])
# eventTime <- ifelse(sapply(events, function(x) x[[2]]) == "start", "przed", "po")
# 
# df <- data.frame(source = txtSource, eventName = eventName, eventTime = eventTime, x = frm$x, y = frm$y, stringsAsFactors = FALSE)
# 
# rm(frm); rm(eventName); rm(events); rm(eventTime); rm(txtSource); rm(txtSplit);
# gc()
# 
# 
# df$eventName <- str_replace_all(string = df$eventName,
#                 c("afera_podsl"="afera podsluchowa",
#                   "janukowycz"="odwolanie Janukowycza",
#                   "jp2_swiety"="kanonizacja JP2",
#                   "wybory_pe"="wybory do PE",
#                   "obama_pol"="Obama w Polsce",
#                   "papiez_fran"="wybor papieza Franciszka",
#                   "samolot_ukr"="zestrzelenie samolotu na Ukrainie",
#                   "kopacz"="poczatek rzadow Kopacz",
#                   "krym_ref"="referendum na Krymie",
#                   "tusk_ue"="Tusk przewodniczacym Rady Europejskiej",
#                   "wybory_parl"="wybory parlamentarne",
#                   "wybory_prez1"="I-tura wyborow prezydenckich",
#                   "wybory_prez2"="II-tura wyborow prezydenckich",
#                   "wybory_samorz"="wybory samorzadowe",
#                   "zamach_bruks"="zamachy w Brukseli",
#                   "zamach_hebdo"="zamachy w Charlie Hebdo",
#                   "zamach_paryz"="zamachy w Paryzu"))
# 
# 
# saveRDS(df, "data/pca_result_parsed.rds")


pca.frm <- readRDS("data/pca_result_parsed.rds")


######################## Wordcloud
x = c("afera_podsl"="afera podsluchowa",
      "janukowycz"="odwolanie Janukowycza",
      "jp2_swiety"="kanonizacja JP2",
      "wybory_pe"="wybory do PE",
      "obama_pol"="Obama w Polsce",
      "papiez_fran"="wybor papieza Franciszka",
      "samolot_ukr"="zestrzelenie samolotu na Ukrainie",
      "kopacz"="poczatek rzadow Kopacz",
      "krym_ref"="referendum na Krymie",
      "tusk_ue"="Tusk przewodniczacym Rady Europejskiej",
      "wybory_parl"="wybory parlamentarne",
      "wybory_prez1"="I-tura wyborow prezydenckich",
      "wybory_prez2"="II-tura wyborow prezydenckich",
      "wybory_samorz"="wybory samorzadowe",
      "zamach_bruks"="zamachy w Brukseli",
      "zamach_hebdo"="zamachy w Charlie Hebdo",
      "zamach_paryz"="zamachy w Paryzu")

events_mapping = data.frame(key = names(x), value = as.character(x), stringsAsFactors = FALSE)

# wc.frm <- read.csv("data/events_wordcount.csv", stringsAsFactors=FALSE)
# wc.frm$source <- str_replace_all(wc.frm$source, "_", " ")
# wc.frm$key <- str_replace_all(wc.frm$event, "_end|_start", "")
# wc.frm$time <- sapply(str_match_all(wc.frm$event, "end|start"), function(x) x[1])
# 
# 
# wc <- inner_join(wc.frm, events_mapping, by = "key")
# 
# saveRDS(wc, "data/wc.rds")


wc <- readRDS("data/wc.rds")


# lda <- read.csv("data/lda.csv", stringsAsFactors=FALSE)
# lda$source <- str_replace(lda$source, "_", " ")
# 
# saveRDS(lda, "data/lda.rds")


lda <- readRDS("data/lda.rds")
lda$topicId <- lda$topicId + 1


w2v <- read.csv("data/word2vec.csv", stringsAsFactors=FALSE)

countries <- read.csv("data/countries.csv", stringsAsFactors=FALSE)

people <- read.csv("data/People.csv", stringsAsFactors=FALSE)
