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
# Java Development Kit version, URL and hash sum
JDK_VERSION="11.0.7"
JDK_URL="https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.7%2B10/OpenJDK11U-jdk_x64_linux_hotspot_11.0.7_10.tar.gz"
JDK_SHA256="ee60304d782c9d5654bf1a6b3f38c683921c1711045e1db94525a51b7024a2ca"
# Maven package manager version, URL and hash sum
MAVEN_VERSION="3.9.6"
MAVEN_URL="https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"
MAVEN_SHA512="c35a1803a6e70a126e80b2b3ae33eed961f83ed74d18fcd16909b2d44d7dada3203f1ffe726c17ef8dcca2dcaa9fca676987befeadc9b9f759967a8cb77181c0"
