#!/bin/bash
# @author : leonefamily

# exit on any error
set -e

# Get the location of this script and jump to its location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# importing variables and functions
source variables.sh
source utils.sh

# extract repository name from the last part independently on the fact whether it ends with .git or not
repo_name=$(get_stem "$REPO_URL")

echo "Ensuring Euler's new environment usage"
# this command is an alias and couldn't be executed as is, so real path is needed
env2lmod="/cluster/apps/local/env2lmod.sh"
$env2lmod

echo "Enabling GCC and Python modules"
module load "gcc/$GCC_VERSION"
module load "python/$PYTHON_VERSION"

venv_name=$(trim_text "$VENV_NAME")
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

ch_folder=$(trim_text "$CH_FOLDER")
ch_path="$HOME/$ch_folder"

if [ -d "$ch_path" ]; then
  echo "$ch_path directory already exists. Would you like to remove its contents and clone git?  Enter Y to continue: "
  read -r answer
    if [ "$answer" = 'Y' ]; then
      # git -C is for executing command without changing the working directory
      rm -rf "$ch_path"
      mkdir "$ch_path"
      git -C "$ch_path" clone "$REPO_URL" -b develop --single-branch
    else
      echo "Did not get positive (Y) answer, exiting"
      exit 1
    fi

  else
    echo "Creating directory $ch_path"
    mkdir "$ch_path"
    git init "$ch_path"
    git -C "$ch_path" clone "$REPO_URL" -b develop --single-branch
fi

echo "Activating Python environment"
source "$venv_path/bin/activate"
pip install -r "$ch_path/$repo_name/euler_requirements.txt"

echo "Installed Euler requirements"
# account for synpp dependency if missing
# Run pip freeze and store the output in a temporary file
pip freeze > "$SCRIPT_DIR/temp_file"

# otherwise grep just silently crashes, as this is an alias
grep_cmd="/usr/bin/grep"
synpp_string=$($grep_cmd synpp "$SCRIPT_DIR/temp_file")

echo "Got synpp_string: $synpp_string"

if [ -n "$synpp_string" ]; then
    echo "synpp is installed"
  else
    echo "synpp is still not installed, fixing"
    pip install "synpp"
fi

rm "$SCRIPT_DIR/temp_file"

echo "Installing this script's requirements"
# install this script's requirements for Python; they shouldn't interfere
pip install -r "$SCRIPT_DIR/requirements.txt"

data_folder=$(trim_text "$DATA_FOLDER")
yaml_cfg="$ch_path/$repo_name/config.yml"
yaml_w="$SCRATCH/$ch_folder/$repo_name/cache"
yaml_d="$HOME/$data_folder"
yaml_f="$SCRATCH/$ch_folder/$repo_name/flowchart.json"

echo "Working directory for simulations is $yaml_w"
echo "Data for synthesis should be located at $yaml_d"
echo "Flowchart will be created at $yaml_f"
python "$SCRIPT_DIR/edit_config.py" -i "$yaml_cfg" -o "$yaml_cfg" -w "$yaml_w" -d "$yaml_d" -f "$yaml_f"
echo "Configuration is edited and is placed to $yaml_cfg"

echo "Creating run's folders"
mkdir -p "$SCRATCH/$ch_folder/$repo_name/cache"

printf "\n--------- Preparations done! ---------\n"
