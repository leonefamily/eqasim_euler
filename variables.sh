#!/bin/bash
# @author : leonefamily

# * * * * * * * * * * * * * * * * * * * * * * *
# * !! AVOID EMPTY VARIABLES AT ALL COSTS !!  *
# *  You may accidentally nuke your home di-  *
# * !!        rectory into oblivion       !!  *
# * * * * * * * * * * * * * * * * * * * * * * *

# exit on any error
set -e

# C compiler version
GCC_VERSION="8.2.0"
# Python interpreter version
PYTHON_VERSION="3.10.4"
# Name of the folder, where Python virtual environment will reside
VENV_NAME="venv"
# Name of the folder, that will contain the Equasim pipeline code
CH_FOLDER="ch"
# Remote Eqasim's repository URL
REPO_URL="https://gitlab.ethz.ch/ivt-vpl/populations/ch-zh-synpop.git"
# Name of folder with data for simulation
DATA_FOLDER="switzerland_data"