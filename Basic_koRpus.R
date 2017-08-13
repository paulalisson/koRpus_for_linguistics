
#### Using the koRpus package for lexical diversity and readability: an easy guide, step by step ####
#### Paula Lissón, 2017. All the code from the script has been adapted from
#### the vignette and the manual of the {koRpus} package (Meik Michalke, 2017): 
#### - https://cran.r-project.org/web/packages/koRpus/vignettes/koRpus_vignette.pdf
#### - https://cran.r-project.org/web/packages/koRpus/koRpus.pdf
#### development website: http://reaktanz.de/?c=hacking&s=koRpus
#### This script has didactical purposes, it complements a poster to be presented at the conference HDH2017, Málaga, Spain.
### koRpus Version 0.10-2 #####################################################


########### 0. First things first: setting libraries and loading data----###############

# downloading and loading the libraries (koRpus and tm.plugin.koRpus, tm may also be required)
install.packages("koRpus"); install.packages("tm")
install.packages("tm.plugin.koRpus", repo="https://reaktanz.de/R")
library(koRpus); library(tm.plugin.koRpus)

# I prefer to use TreeTagger for the POS-tagging of the corpus. You need to download TreeTagger http://www.cis.uni-muenchen.de/~schmid/tools/TreeTagger/ (+ the parameters for the languages you wish) and find the path in your own computer. Once you get the path, you need to replace mine with yours: 

set.kRp.env(TT.cmd="/Users/paulalisson/corpus/programs/tree-tagger/cmd/tree-tagger-english", lang="en",TT.options=list(path="/Users/paulalisson/corpus/programs/tree-tagger/", preset="en"))

# notice that in the preivous command I set the path for the English parameters, you do need to change that depending on the language you wish to work (and remember you need to download the parameters for that language). An example for French: 

set.kRp.env(TT.cmd="/Users/paulalisson/corpus/programs/tree-tagger/cmd/tree-tagger-french", lang="fr",TT.options=list(path="/Users/paulalisson/corpus/programs/tree-tagger/", preset="fr"))

# importing files from a corpus individually and POS-tagging them, all within a same complex object 
corpus <- simpleCorpus(dir=file.path("~/","Desktop","mycorpus"),lang="en",TT.options=list(path="/Users/paulalisson/corpus/programs/tree-tagger/", preset="en"))

# now we already have our corpus loaded in R, POS-tagged, and we can start with lexical diversity metrics and readability. 


########### 1. Lexical Diversity metrics----

# computing the lex.div metrics
corpus_lexdiv <- lex.div(corpus, char=FALSE, quiet=TRUE) 
# getting the scores of the metrics in a data frame
corpus_lexdiv.df <- corpusSummary(corpus_lexdiv)
# exporting the data frame with the scores in .csv format 
write.table(corpus_lexdiv.df, file = "corpus_lexdiv.csv", sep = ",", col.names = NA, qmethod = "double")


########### 2. Readability metrics-----
# notice that some of the metrics require wordlists that need to be downloaded online and 
# are not inlcuded in the package for copyright reasons. If you don't have the wordlist, you can compute the rest of the metrics that do not require it.

corpus_readability <- readability(corpus, hyphen = NULL,
  index = c("ARI", "Bormuth", "Coleman", "Coleman.Liau", "Dale.Chall",
    "Danielson.Bryan", "Dickes.Steiwer", "DRP", "ELF", "Farr.Jenkins.Paterson",
    "Flesch", "Flesch.Kincaid", "FOG", "FORCAST", "Fucks", "Harris.Jacobson",
    "Linsear.Write", "LIX", "nWS", "RIX", "SMOG", "Spache", "Strain",
    "Traenkle.Bailer", "TRI", "Tuldava", "Wheeler.Smith"), parameters = list(),
  word.lists = list(Bormuth = dalechalleasylist, Dale.Chall = dalechalleasylist, Harris.Jacobson = NULL,Spache = spachelist), fileEncoding = "UTF-8", tagger = "kRp.env",
  force.lang = NULL, sentc.tag = "sentc", nonword.class = "nonpunct",
  nonword.tag = c(), quiet = FALSE)

# have a look at the results
corpusSummary(corpus_readability)
# getting the scores in a data frame
corpus_readability.df <- corpusSummary(corpus_readability) 
# exporting the scores in .csv format 
write.table(corpus_readability.df, file = "corpus_readability.csv", sep = ",", col.names = NA, qmethod = "double") 

######## End of the script------
######## What to do next? The format of the scores (dataframe in R or easily exported in .csv) allows for the treatment of the scores with many other packages. Common practices are correlations of the metrics, dimensionality reduction techniques to reduce the number of metrics, ANOVAS between groups if you are to compare different subgroups of your corpus... 
