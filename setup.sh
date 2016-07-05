#! /bin/bash

# winpty base URL
babun_docker_winpty_base_url="https://github.com/rprichard/winpty/releases/download/0.4.0/"


# Specific file name, separated to allow unzipping it later
babun_docker_winpty_only_name="winpty-0.4.0-cygwin-2.5.2-ia32"

# Specific file extension
babun_docker_winpty_ext=".tar.gz"

# Complete filename
babun_docker_winpty_filename="$babun_docker_winpty_only_name$babun_docker_winpty_ext"

# babun-docker repo
babun_docker_repo='https://github.com/tiangolo/babun-docker.git'

# feedback format string
babun_docker_feedback='-- babun-docker:'

babun_docker_OLD_PWD=$(pwd)
# Set up winpty
# Where to download winpty from
babun_docker_winpty_url="$babun_docker_winpty_base_url$babun_docker_winpty_filename"
# Directory in where to put Winpty
babun_docker_winpty_dir="$HOME/.winpty"
# Create a local .winpty directory under your home
if [[ ! -d $babun_docker_winpty_dir ]] ; then
   mkdir -p $babun_docker_winpty_dir ;
fi
# Enter the .winpty directory to download winpty
cd $babun_docker_winpty_dir
if [[ ! -f $babun_docker_winpty_filename ]] ; then
   # Remove old files
   cd ..
   rm -rf $babun_docker_winpty_dir
   mkdir -p $babun_docker_winpty_dir
   cd $babun_docker_winpty_dir
   # Download winpty
   wget $babun_docker_winpty_url   -O $babun_docker_winpty_filename
   # Untar the downloaded file
   tar xf $babun_docker_winpty_filename
   # Move the tar contents to the current directory
   mv $babun_docker_winpty_only_name/bin/* ./
   # Remove untar-ed directory
   rm -rf $babun_docker_winpty_only_name
   # Make winpty executable
   chmod 777 $babun_docker_winpty_dir/*
   # Ask for update
   echo "$babun_docker_feedback to finish the installation please run: babun-docker-update"
fi
export PATH="$PATH:$babun_docker_winpty_dir"


# Set up babun-docker
# Directory in where to put babun-docker
babun_docker_repo_dir="$HOME/.babun-docker"
if [[ ! -d $babun_docker_repo_dir ]] ; then
   git clone $babun_docker_repo $babun_docker_repo_dir
   echo "$babun_docker_feedback to finish the installation please run: babun-docker-update"
fi
cd $babun_docker_repo_dir
source ./*config.sh
source 'bin/babun-docker.sh'


# Set up setup on start for Bash
babun_docker_setup_str="source '$babun_docker_repo_dir/setup.sh'"
if [[ -z $(grep "$babun_docker_setup_str" $HOME/.bashrc) ]] ; then
  echo $babun_docker_setup_str >> $HOME/.bashrc ;
fi

# Set up setup on start for Zsh
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
