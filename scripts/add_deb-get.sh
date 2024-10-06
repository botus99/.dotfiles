#!/usr/bin/env bash

#=============================================================================#
#                      GitHub Personal Access Token (PAT)                     #
#     You must provide deb-get with a GitHub Personal Access Token (PAT).     #
#    Once created, insert it into the DEBGET_TOKEN environment variable for   #
#          for deb-get to use for authorization with the GitHub API.          #
#                                                                             #
# For example:                                                                #
#                                                                             #
#  export DEBGET_TOKEN=github-personal-access-token                           #
#  deb-get update                                                             #
#  deb-get upgrade                                                            #
#                                                                             #
#                   Skipping this step will lead to failures                  #
#              during the update, upgrade, and install commands.              #
#=============================================================================#

sudo apt-get install curl lsb-release wget glab
curl -sL https://raw.githubusercontent.com/wimpysworld/deb-get/main/deb-get | sudo -E bash -s install deb-get
