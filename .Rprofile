local({
  options(repos = c(CRAN = "https://mirror.las.iastate.edu/CRAN",
                    BioCsoft = "https://bioconductor.org/packages/3.10/bioc", 
                    BioCann = "https://bioconductor.org/packages/3.10/data/annotation",
                    BioCexp = "https://bioconductor.org/packages/3.10/data/experiment",
                    CRANextra = "https://www.stats.ox.ac.uk/pub/RWin", 
                    Omegahat = "http://www.omegahat.net/R",
                    `R-Forge` = "https://R-Forge.R-project.org", 
                    rforge.net = "https://www.rforge.net"))})

options(stringsAsFactors=FALSE) # matches R 4.0
options(max.print=100)
options(scipen=10)
options(editor="nvim")
options(width = 120)
utils::rc.settings(ipck=TRUE)

suppressLoadMessage <- function(pkgname) {
  suppressWarnings(suppressPackageStartupMessages(library(pkgname, character.only=TRUE)))
}

auto.loads <-c("dplyr", "ggplot2")
 
if(Sys.getenv("TERM") == "xterm-256color") {
  library("colorout")
}

if(interactive()){
  invisible(sapply(auto.loads, suppressLoadMessage))
}
 
.env <- new.env()
attach(.env)
 
.env$unrowname <- function(x) {
  rownames(x) <- NULL
  x
}
 
.env$unfactor <- function(df){
  id <- sapply(df, is.factor)
  df[id] <- lapply(df[id], as.character)
  df
}

message("*** Successfully loaded .Rpofile ***")
