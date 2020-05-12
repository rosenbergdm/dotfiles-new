#! /usr/bin/env R
library(readr)
library(styler)
target_file <- commandArgs(trailingOnly = TRUE)
style_text(read_file(target_file))



# vim: ft=R
