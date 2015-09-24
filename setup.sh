#! /bin/bash
if [[ -z $BABUN_DOCKER_SETUP ]] ; then
  # Set variables
    # winpty base URL
  WINPTY_BASE_URL="https://github.com/downloads/rprichard/winpty/"
    # Specific file name, separated to allow unzipping it later
  WINPTY_FILENAME="winpty-0.1.1-cygwin.zip"
    # Where to download winpty from
  WINPTY_URL="$WINPTY_BASE_URL$WINPTY_FILENAME"
    # Directory in where to put Winpty
  WINPTY_DIR="$HOME/.winpty"
    # Create a local .winpty directory under your home
  if [[ ! -d $WINPTY_DIR ]] ;
  then
    mkdir -p $WINPTY_DIR ;
  fi
  OLD_PWD=$(pwd)
  # Enter the .winpty directory to download winpty
  cd $WINPTY_DIR
  if [[ ! -f $WINPTY_FILENAME ]] ; then
    # Download winpty
    wget $WINPTY_URL
    # Unzip the downloaded file
    unzip $WINPTY_FILENAME
  fi
  # Make console executable
  chmod 777 $WINPTY_DIR/*
  # Add winpty to the PATH
  echo '# Add Winpty fix for Docker' >> ~/.zshrc
  echo 'PATH=$PATH:'$WINPTY_DIR >> ~/.zshrc
  echo '
# Fix for Docker and Docker Toolbox in Babun
if [[ -z "$docker_bin" ]] then ;
  docker_bin=$(which docker) ;
fi
function docker {
 result="$($docker_bin $@ 2>&1)"
 if [[ $result == "cannot enable tty mode on non tty input" ]] ; then
   echo "babun-docker: Using winpty"
   console $docker_bin $@
 elif [[ $result == *"ConnectEx tcp: No connection could be made"* ]] ; then
   echo "babun-docker: Setting up docker-machine environment"
   eval "$(docker-machine env default --shell zsh)"
   docker $@
 elif [[ $result == *"ConnectEx tcp: A connection attempt failed"* ]] ; then
   echo "babun-docker: Starting docker-machine default"
   docker-machine start default
   # eval "$(docker-machine env default --shell zsh)"
   docker $@
 else
   echo $result ;
 fi
}
BABUN_DOCKER_SETUP=1
  ' >> ~/.zshrc
  source ~/.zshrc
  cd $OLD_PWD
fi
