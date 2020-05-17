# .Rprofile
#  Local R settings
local({
  options(repos = c(
    CRAN = "https://mirror.las.iastate.edu/CRAN",
    BioCsoft = "https://bioconductor.org/packages/3.11/bioc",
    BioCann = "https://bioconductor.org/packages/3.11/data/annotation",
    BioCexp = "https://bioconductor.org/packages/3.11/data/experiment",
    CRANextra = "https://www.stats.ox.ac.uk/pub/RWin",
    Omegahat = "http://www.omegahat.net/R",
    `R-Forge` = "https://R-Forge.R-project.org",
    rforge.net = "https://www.rforge.net"
  ))
})

options(stringsAsFactors = FALSE) # matches R 4.0
options(max.print = 500)
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
  invisible(setOutputColors(
    normal = "\x1b[38;2;0;200;0m", # red = 0; green = 200; blue = 0
    negnum = "\x1b[38;2;255;200;0m",
    zero = "\x1b[38;2;255;255;0m",
    number = "\x1b[38;2;200;255;75m",
    date = "\x1b[38;2;155;155;255m",
    string = "\x1b[38;2;0;255;175m",
    const = "\x1b[38;2;0;255;255m",
    false = "\x1b[38;2;255;125;125m",
    true = "\x1b[38;2;125;255;125m",
    infinite = "\x1b[38;2;75;75;255m",
    index = "\x1b[38;2;00;150;80m",
    stderror = "\x1b[38;2;255;0;255m",
    warn = "\x1b[38;2;255;0;0m",
    error = "\x1b[38;2;255;255;255;48;2;255;0;0m",
    zero.limit = 0.01, verbose = FALSE
  ))
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
  package_string <- paste("`", paste(.rprofile_env$auto_loads, collapse = "`, `"), "`", sep = "")
  message(paste("*** Successfully loaded .Rprofile including packages ", package_string, " ***", sep = ""))
  rm(package_string)
}

style_in_place <- function(fname, backup = FALSE) {
  if (backup) {
    bkfile <- tempfile(pattern = "styler")
    file.copy(fname, bkfile, overwrite = TRUE)
  }
  styler::style_file(fname)
}

setHook(
  packageEvent("languageserver", "onLoad"),
  function(...) {
    options(languageserver.default_linters = lintr::with_defaults(line_length_linter(120), object_usage_linter = NULL))
  }
)
