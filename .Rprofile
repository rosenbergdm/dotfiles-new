local({
  options(repos = c(CRAN       = "https://mirror.las.iastate.edu/CRAN",
                    BioCsoft   = "https://bioconductor.org/packages/3.11/bioc",
                    BioCann    = "https://bioconductor.org/packages/3.11/data/annotation",
                    BioCexp    = "https://bioconductor.org/packages/3.11/data/experiment",
                    CRANextra  = "https://www.stats.ox.ac.uk/pub/RWin",
                    Omegahat   = "http://www.omegahat.net/R",
                    `R-Forge`  = "https://R-Forge.R-project.org",
                    rforge.net = "https://www.rforge.net"))})

options(stringsAsFactors = FALSE) # matches R 4.0
options(max.print = 100)
options(scipen = 10)
options(editor = "nvim")
options(width = 120)
utils::rc.settings(ipck = TRUE)

suppress_load_message <- function(pkgname) {
  suppressWarnings(suppressPackageStartupMessages(library(pkgname, character.only = TRUE)))
}

auto_loads <- c("plyr", "dplyr", "ggplot2", "devtools")
if (interactive()) {
  invisible(sapply(auto_loads, suppress_load_message))
}

if (Sys.getenv("TERM") == "xterm-256color") {
  suppress_load_message("colorout")
}

.rprofile_env <- new.env()
attach(.rprofile_env)
.rprofile_env$auto_loads <- auto_loads
.rprofile_env$suppress_load_message <- suppress_load_message
.rprofile_env$unrowname <- function(x) {
  rownames(x) <- NULL
  x
}
.rprofile_env$unfactor <- function(df) {
  id <- sapply(df, is.factor)
  df[id] <- lapply(df[id], as.character)
  df
}
rm(list = c("auto_loads", "suppress_load_message"))

if (interactive()) {
  package_string <- paste("`", paste(.rprofile_env$auto_loads, collapse = "`, `"), "`", sep="")
  message(paste("*** Successfully loaded .Rprofile including packages ", package_string, " ***", sep=""))
  rm(package_string)
}
# TEST
