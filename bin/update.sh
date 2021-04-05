#! /usr/bin/env bash
# update.sh
# Copyright (C) 2021 David Rosenberg <dmr@davidrosenberg.me>
# Distributed under terms of the GPLv3 license.
#
# Usage: update.sh
#

brew update
brew upgrade
brew cleanup

nvim --headless +CocUpdate +'call dein#install()' +qa
Rscript <( ( echo 'devtools::update_packages(upgrade="always", build_opts = c("--with-keep.source", "--with-keep.parse.data", "--example", "--html", "--build-vignettes"), build_vignettes=TRUE)' ) )
