# babun-docker

## Description

Workaround / fix to allow using [Docker Toolbox](https://www.docker.com/toolbox) from [Babun](http://babun.github.io/).

It could work for Cygwin with some little modifications, but if you are using Cygwin, you should be using Babun. It's an improved Cygwin.

This program installs [winpty](https://github.com/rprichard/winpty), sets the environment variables and creates a function to embed ```docker```, and to allow non-tty connections.

It also checks if the default docker-machine is running, if not, it tries to start it and set the environment to use it.

And it also sets up shared folders in VirtualBox for each drive in your Windows and mounts them inside the virtual machine (docker-machine), to allow using volumes with Docker (from any drive in your Windows, which is even more than what comes by default with the Docker Toolbox) to allow using commands like:

```
docker run -d -v $(pwd):/var/www ubuntu ping google.com
```

**Note**: After installing **babun-docker** (this program), you don't have to "use" another program. You can keep using the ```docker``` commands as normal.

## Installation

* Install [Babun](http://babun.github.io/) and start a terminal.
* Run the following command:

```
curl -s https://raw.githubusercontent.com/tiangolo/babun-docker/master/setup.sh | source /dev/stdin
```

**Note**: the previous command will get a script from this repository and run it immediately, performing all the needed
steps to install everything (the same steps described in "Manual installation").
If you don't want to run it, you can do a manual installation.

## Updating

* To update **babun-docker**, after following the installation instructions, run the command:

```
babun-docker-update
```

----

## What's new

#### 2016-03-16: 
* Support for Docker v1.10 (see PR #9 by @mrkschan ).

#### 2015-11-12:
* **babun-docker** automatically sets up shared folders in your VirtualBox virtual machine (docker-machine) for each of your Windows drives and mounts them inside the virtual machine, to allow using volumes (from any drive in your Windows, which is even more than what comes by default with the Docker Toolbox) with commands like:

```
docker run -it -v $(pwd):/var/www debian bash
```

* You can configure if you want **babun-docker** to automatically set up VirtualBox shared folders and volumes with the environment variable ```babun_docker_setup_volumes```. Set it to "0" if you want to disable that.

* You can now specify the name of the docker-machine to use with the environment variable ```babun_docker_machine_name```, which is set by default to the "default" machine (named "default"). (No pun / tongue twister intended). Set that environment variable to the name of the machine that you want to use (e.g. ```babun_docker_machine_name='dev'```).

#### 2015-10-21:
* The installation of **babun-docker** clones the repository and sets up the environment to use the scripts inside it instead of writing it all to the ```~/.zshrc``` file.

* Running ```babun-docker-update``` will update that repository (will update **babun-docker**) and set up the environment again.



----

## Docker Volumes with Babun

Here is an explanation of how volumes work in Docker and how they work in the Toolbox Virtual Machine: [Docker Volumes with Babun](https://github.com/tiangolo/babun-docker/wiki/Docker-Volumes-with-Babun).

That's what allows using commands like:
```
docker run -it -v $(pwd):/var/www debian bash
```

But all that is implemented automatically in the newest version of **babun-docker**.

-----

## Manual installation

* Go to your home directory:

```
cd
```

* clone this repo in the specific directory, like:

```
git clone https://github.com/tiangolo/babun-docker.git ./.babun-docker
```

* Enter that directory:

```
cd ./.babun-docker
```

* Source the setup:

```
source ./setup.sh
```

The setup will:

* Download and install Winpty to allow using Docker commands that enter a container
* Create a command (function) to update **babun-docker**, with ```babun-docker-update```
* Add itself to the ```~/.zshrc``` file to run at startup
* Run (```source```) the script to fix Docker, wrapping it

The wrapper script (function) will try to call docker, if it fails, it will check what was the failure, try to fix it and run again.

The wrapper / fix will:

* auto-start the default docker machine
* set the environment variables for that default docker-machine
* use winpty (console) to connect to a tty session to avoid errors, as in:

```
docker exec -it my_container bash
```

----

## Configurations

After installing **babun-docker**, you can configure things with environment variables.

* If you want to disable the setup of VirtualBox shared folders and volumes inside your docker-machine virtual machine set the environment variable ```babun_docker_setup_volumes``` to "0". For example:

```
echo babun_docker_setup_volumes=0 >> ~/.zshrc
source ~/.zshrc
```

* If you want to change the virtual machine to use (if you have configured another virtual machine with ```docker-machine```) you can set the environment variable ```babun_docker_machine_name``` to the name of your new virtual machine. For example:

```
echo babun_docker_machine_name='dev' >> ~/.zshrc
source ~/.zshrc
```
