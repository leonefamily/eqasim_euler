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
# Get the location of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Name of folder with data for simulation
DATA_FOLDER="switzerland_data"

# extract repository name from the last part independently on the fact whether it ends with .git or not
repo_name=$(basename $REPO_URL | sed 's/\.git$//')
if [ -z "$repo_name" ]; then
  echo "Repository name couldn't be extracted. Invalid repository URL?"
  exit 1
fi

trim_text () {
  # remove all whitespaces from start and end using regular expressions
  local text="$1"
  local trimmed
  trimmed=$(echo "$text" | sed 's/^[   ]*//;s/[    ]*$//')
  echo "$trimmed"
}

echo "Ensuring Euler's new environment usage"
# this command is an alias and couldn't be executed as is, so real path is needed
env2lmod="/cluster/apps/local/env2lmod.sh"
$env2lmod

echo "Enabling GCC and Python modules"
module load "gcc/$GCC_VERSION"
module load "python/$PYTHON_VERSION"

venv_name=$(trim_text $VENV_NAME)
venv_path="$HOME/$venv_name"
echo "Attempting to create a new Python virtual environment at path: $venv_path"

if [ -d "$venv_path" ]; then
  echo "$venv_path directory already exists. Would you like to delete it and create a new Python virtual environment from scratch? Enter Y to continue"
  read -r answer

    if [ "$answer" = 'Y' ]; then
      # rm is a scary function
      rm -rf "$venv_path"
      python -m venv "$venv_path"
    else
      echo "Did not get positive (Y) answer, exiting"
      exit 1
    fi

  else
     python -m venv "$venv_path"
fi
echo "Python virtual environment is in order"

ch_folder=$(trim_text $CH_FOLDER)
ch_path="$HOME/$ch_folder"

if [ -d "$ch_path" ]; then
  echo "$ch_path directory already exists. Would you like to remove its contents and clone git?  Enter Y to continue: "
  read -r answer
    if [ "$answer" = 'Y' ]; then
      # git -C is for executing command without changing the working directory
      rm -rf "$ch_path"
      mkdir "$ch_path"
      git -C "$ch_path" clone $REPO_URL -b develop --single-branch
    else
      echo "Did not get positive (Y) answer, exiting"
      exit 1
    fi

  else
    echo "Creating directory $ch_path"
    mkdir "$ch_path"
    git init "$ch_path"
    git -C "$ch_path" clone $REPO_URL -b develop --single-branch
fi

echo "Activating Python environment"
source "$venv_path/bin/activate"
pip install -r "$ch_path/$repo_name/euler_requirements.txt"

# install this script's requirements for Python; they shouldn't interfere
pip install -r "$SCRIPT_DIR/requirements.txt"

data_folder=$(trim_text $DATA_FOLDER)
yaml_cfg="$ch_path/$repo_name/config.yml"
yaml_w="$SCRATCH/$ch_folder/$repo_name/cache"
yaml_d="$HOME/$data_folder"
yaml_f="$SCRATCH/$ch_folder/$repo_name/flowchart.json"

echo "Working directory for simulations is $yaml_w"
echo "Data for synthesis should be located at $yaml_d"
echo "Flowchart will be created at $yaml_f"
python -m "$SCRIPT_DIR/edit_config.py" -i "$yaml_cfg" -o "$yaml_cfg" -w "$yaml_w" -d "$yaml_d" -f "$yaml_f"
echo "Configuration is edited and is placed to $yaml_cfg"