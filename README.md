# babun-docker

## Description

Workaround and quick fix to allow using [Docker Tooblox](https://www.docker.com/toolbox) from [Babun](http://babun.github.io/).

It could work for Cygwin with some little modifications, but if you are using Cygwin, you should be using Babun. It's an improved Cygwin.

This quick fix installs [winpty](https://github.com/rprichard/winpty), sets the environment variables and creates a function to embed ```docker```, and to allow non-tty connections.

It also checks if the default docker-machine is running, if not, it tries to start it and set the environment to use it.

After using this, you don't have to "use" another program. You can keep using the ```docker``` commands as normal.

## Installation

* Install [Babun](http://babun.github.io/) and start a terminal.
* Run the following command:

```
curl -s https://raw.githubusercontent.com/tiangolo/babun-docker/master/setup.sh | source /dev/stdin
```

Note: the previous command will get a script from this repository and run it immediately, performing all the needed
steps to install everything (the same steps described in "Manual installation").
If you don't want to run it, you can do a manual installation.

-----

## Manual installation

* Go to your home directory:

```
cd
```

* Create a directory to store winpty:

```
mkdir ~/.winpty
```

* Enter that directory:

```
cd ~/.winpty
```

* Download winpty for Cygwin:

```
wget https://github.com/downloads/rprichard/winpty/winpty-0.1.1-cygwin.zip
```

* Unzip it there:

```
unzip winpty-0.1.1-cygwin.zip
```

* Add execution permissions:

```
chmod 777 ~/.winpty
```

* Add winpty to the PATH variable:

```
echo 'PATH=$PATH:'$WINPTY_DIR >> ~/.zshrc
```

* Add the workaround function to your .zshrc:

```
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
elif [[ $result == *"ConnectEx tcp"* ]] ; then
 echo "babun-docker: Trying to start docker-machine default"
 docker-machine start default
 echo "babun-docker: Setting up docker-machine environment"
 eval "$(docker-machine env default --shell zsh)"
 docker $@
else
 echo $result ;
fi
}
BABUN_DOCKER_SETUP=1
' >> ~/.zshrc
```

The function will try to call docker, if it fails, it will check what was the failure, try to fix it and run again.

It will:

* auto-start the default docker machine
* set the environment variables for that default docker-machine
* use winpty (console) to connect to a tty session to avoid errors, as in:

```
docker exec -it my_container bash
```
