#! /bin/bash

# Fix for Docker and Docker Toolbox in Babun
if [[ -z "$docker_bin" ]] ; then
  docker_bin=$(which docker) ;
fi
function docker {
  if [[ -z ${babun_docker_old_IFS+x} ]] ; then
    babun_docker_old_IFS=$IFS
  fi
  if [[ -z ${babun_docker_volumes+x} ]] ; then
    babun_docker_volumes=$(ls /cygdrive);
  fi
 IFS=''
 babun_docker_use_winpty=0
 babun_docker_run_again=0
 "$docker_bin" $@ 2>&1 | while read -r line; do
   echo $line
    if [[ $line == "cannot enable tty mode on non tty input" ]] ; then
      babun_docker_use_winpty=1
    elif [[ $line == *"ConnectEx tcp"* || $line == *"connectex"* ]] ; then
      # Set up shared folders in VirtualBox
      if [[ $babun_docker_setup_volumes == 1 ]] ; then
        IFS=$babun_docker_old_IFS
        if [[ -f $babun_docker_virtualbox_bin ]] ; then
          for drive in $(echo $babun_docker_volumes | tr '\n' ' ') ; do
            windows_drive=$(cygpath -d /cygdrive/$drive)
            if [[ -z $($babun_docker_virtualbox_bin showvminfo $babun_docker_machine_name | grep "Name: '$drive'") ]] ; then
              echo "$babun_docker_feedback Setting VirtualBox shared folder for drive $drive"
              $babun_docker_virtualbox_bin sharedfolder add $babun_docker_machine_name --name $drive --hostpath $windows_drive --automount
            else
              echo "$babun_docker_feedback VirtualBox shared folder for drive $drive was already set"
            fi
          done
        fi
        IFS=''
      fi;
      # Start docker-machine
      echo "$babun_docker_feedback Trying to start docker-machine $babun_docker_machine_name"
      docker-machine start $babun_docker_machine_name
      # Set up volumes
      if [[ $babun_docker_setup_volumes == 1 ]] ; then
        IFS=$babun_docker_old_IFS
        for drive in $(ls /cygdrive); do
          echo "$babun_docker_feedback Volumes, creating directory for drive: $drive"
          docker-machine ssh $babun_docker_machine_name "sudo mkdir -p /cygdrive/$drive/"
          echo "$babun_docker_feedback Volumes, mounting drive: $drive"
          #docker-machine ssh $babun_docker_machine_name "sudo mount -t vboxsf $drive /cygdrive/$drive/"
          docker-machine ssh $babun_docker_machine_name 'sudo mount -t vboxsf -o "defaults,uid=`id -u docker`,gid=`id -g docker`,iocharset=utf8,rw"' "$drive /cygdrive/$drive/"
        done
        IFS=''
      fi;
      # Set up environment
      echo "$babun_docker_feedback Setting up docker-machine environment"
      eval "$(docker-machine env $babun_docker_machine_name --shell zsh)"
      babun_docker_run_again=1
    fi;
 done
 if [[ $babun_docker_use_winpty == 1 ]] ; then
   # Run commands with winpty
   echo "$babun_docker_feedback Using winpty"
   console $docker_bin $@
 elif [[ $babun_docker_run_again == 1 ]] ; then
   # Run commands again after setup
   echo "$babun_docker_feedback Running command again"
   docker $@
 fi
 IFS=$babun_docker_old_IFS
}
