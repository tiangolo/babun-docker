#! /bin/bash

# Fix for Docker and Docker Toolbox in Babun
if [[ -z "$docker_bin" ]] ; then
  docker_bin=$(which docker) ;
fi
function docker {
  if [[ -z ${babun_docker_old_IFS+x} ]] ; then
    babun_docker_old_IFS=$IFS
  fi
 IFS=''
 babun_docker_use_winpty=0
 babun_docker_run_again=0
 "$docker_bin" $@ 2>&1 | while read -r line; do
   echo $line
    if [[ $line == "cannot enable tty mode on non tty input" ]] ; then
      babun_docker_use_winpty=1
    elif [[ $line == *"ConnectEx tcp"* ]] ; then
      echo "babun-docker: Trying to start docker-machine default"
      docker-machine start default
      echo "babun-docker: Setting up docker-machine environment"
      eval "$(docker-machine env default --shell zsh)"
      babun_docker_run_again=1
    fi;
 done
 if [[ $babun_docker_use_winpty == 1 ]] ; then
   echo "babun-docker: Using winpty"
   console $docker_bin $@

 elif [[ $babun_docker_run_again == 1 ]] ; then
   echo "babun-docker: Running command again"
   docker $@
 fi
 IFS=$babun_docker_old_IFS
}
