#!/bin/sh

##################################
# Core CAPI workspace installation
#
# The current goals listed in README.md are stale. This script aims
# to represent the most minimal, objective representation of what it
# means to develop on CAPI projects.
#
# Ultimately, this means stripping away a lot of excess configuration
# and utilities.
##################################

: "${FULL_CAPI_INSTALL:=false}"

# install brew and its packages
source ./setup/brew.sh
source ./setup/xcode.sh
source ./brew-bundle.sh

# ruby setup
source ./setup/ruby.sh
source ./setup/bundler.sh

# core git setup
source ./setup/git-hooks.sh

# update cred-alert-cli
source ./setup/update-cred-alert.sh

# daemons to launch databases at startup
source ./setup/mysql.sh
source ./setup/postgres.sh

# Golang setup
source ./setup/go.sh

# Depends on existence of GOPATH, created earlier on
source ./clone-repos.sh

# Concourse "fly"
source ./setup/fly.sh