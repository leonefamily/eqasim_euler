#!/bin/bash
# @author : leonefamily

# immediately exit on error instead of continuing
set -e

# jump to script's actual location
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# import
source variables.sh
source utils.sh

echo "Enabling GCC and Python modules"
module load "gcc/$GCC_VERSION"
module load "python/$PYTHON_VERSION"

ch_folder=$(trim_text "$CH_FOLDER")
ch_path="$HOME/$ch_folder"
venv_name=$(trim_text "$VENV_NAME")
venv_path="$HOME/$venv_name"
repo_name=$(get_stem "$REPO_URL")
yaml_cfg="$ch_path/$repo_name/config.yml"

echo "Activating Python environment"
source "$venv_path/bin/activate"
cd "$ch_path/$repo_name"
echo "Starting slurm job..."
sbatch -n 1 --cpus-per-task=12 --time=20:00:00 --mem-per-cpu=4096 --wrap="python3 -m synpp $yaml_cfg"
