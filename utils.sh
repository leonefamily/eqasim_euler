#!/bin/bash
# @author : leonefamily

trim_text () {
  # remove all whitespaces from start and end using regular expressions
  local trimmed
  trimmed=$(echo "$1" | sed 's/^[   ]*//;s/[    ]*$//')
  if [ -z "$trimmed" ]; then
    echo "Trimming resulted in an empty string, aborting"
    exit 1
  fi
  echo "$trimmed"
}

get_stem () {
  # extract filename without suffix / last directory name / last URL page
  stem=$(basename "$1" | cut -d. -f1)
  if [ -z "$stem" ]; then
    echo "Stem couldn't be extracted. Invalid path or URL?"
    exit 1
  fi
  echo "$stem"
}

