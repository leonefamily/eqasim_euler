#!/bin/bash
# @leonefamily

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

trim_text () {
  # remove all whitespaces from start and end using regular expressions
  local text="$1"
  local trimmed=$(echo "$text" | sed 's/^[   ]*//;s/[    ]*$//')
  echo "$trimmed"
}

echo "Ensuring Euler's new environment usage"
env2lmod

echo "Enabling GCC and Python modules"
"module load gcc/$GCC_VERSION"
"module load python/$PYTHON_VERSION"

venv_name=$(trim_text $VENV_NAME)
venv_path="$HOME/$venv_name"
echo "Attempting to create a new Python virtual environment at path: $venv_path"

if [ -d "$venv_path" ]; then
  echo "$venv_path directory already exists. Would you like to delete it and create a new Python virtual environment from scratch?"
  read -r "Enter Y/N: " answer

    if [ "$answer" = 'Y' ]
    then
      # rm is a scary function, but here it will ask about deletion
      rm -r -d "$venv_path"
      python -m venv "$venv_path"
    else
      echo "Did not get positive (Y) answer, exiting"
      exit 1
    fi

  else
     python -m venv "$venv_path"
fi

ch_folder=$(trim_text $CH_FOLDER)
ch_path="$HOME/$ch_folder"

if [ -d "$ch_path" ]; then
  echo "$ch_path directory already exists. Would you like to update its contents from git?"
  read -r "Enter Y/N: " answer
    if [ "$answer" = 'Y' ]
    then
      # -C is for executing command without changing the working directory
      git -C "$ch_path" pull $REPO_URL
    else
      echo "Did not get positive (Y) answer, exiting"
      exit 1
    fi

  else
     git -C "$ch_path" pull $REPO_URL
fi

