#! /bin/bash

# winpty base URL
babun_docker_WINPTY_BASE_URL="https://github.com/downloads/rprichard/winpty/"
# Specific file name, separated to allow unzipping it later
babun_docker_WINPTY_FILENAME="winpty-0.1.1-cygwin.zip"

# babun-docker repo
babun_docker_repo='https://github.com/tiangolo/babun-docker.git'

# feedback format string
babun_docker_feedback='-- babun-docker:'

# VirtualBox path
babun_docker_virtualbox_path="C:\\Program Files\\Oracle\\VirtualBox\\VBoxManage"

babun_docker_OLD_PWD=$(pwd)
# Set up winpty
# Where to download winpty from
babun_docker_WINPTY_URL="$babun_docker_WINPTY_BASE_URL$babun_docker_WINPTY_FILENAME"
# Directory in where to put Winpty
babun_docker_WINPTY_DIR="$HOME/.winpty"
# Create a local .winpty directory under your home
if [[ ! -d $babun_docker_WINPTY_DIR ]] ; then
   mkdir -p $babun_docker_WINPTY_DIR ;
fi
# Enter the .winpty directory to download winpty
cd $babun_docker_WINPTY_DIR
if [[ ! -f $babun_docker_WINPTY_FILENAME ]] ; then
   # Download winpty
   wget $babun_docker_WINPTY_URL
   # Unzip the downloaded file
   unzip $babun_docker_WINPTY_FILENAME
   # Make console executable
   chmod 777 $babun_docker_WINPTY_DIR/*
fi
export PATH=$PATH:$babun_docker_WINPTY_DIR


# Set up babun-docker
# Directory in where to put babun-docker
babun_docker_repo_dir="$HOME/.babun-docker"
if [[ ! -d $babun_docker_repo_dir ]] ; then
   git clone $babun_docker_repo $babun_docker_repo_dir
fi
cd $babun_docker_repo_dir
source ./*config.sh
source 'bin/babun-docker.sh'


# Set up setup on start
babun_docker_setup_str="source '$babun_docker_repo_dir/setup.sh'"
if [[ -z $(grep "$babun_docker_setup_str" $HOME/.zshrc) ]] ; then
  echo $babun_docker_setup_str >> $HOME/.zshrc ;
fi

# Setup update
function babun-docker-update {
  babun_docker_update_old_pwd=$(pwd)
  echo "$babun_docker_feedback Updating babun-docker"
  cd $babun_docker_repo_dir
  git pull
  source ./setup.sh
  cd $babun_docker_update_old_pwd
}

cd $babun_docker_OLD_PWD
