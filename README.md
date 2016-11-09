# babun-docker

## Description

Program / fix to allow using [Docker Toolbox](https://www.docker.com/toolbox) from [Babun](http://babun.github.io/) or Cygwin in Windows.

If you are using Cygwin, you should be using Babun. It's an improved Cygwin. Nevertheless, the latest versions of **babun-docker** work in Cygwin too.

This program installs [winpty](https://github.com/rprichard/winpty), sets the environment variables and creates a function to embed ```docker```, and to allow non-tty connections.

This allows running commands that "enter" in the container, as for example those that use `-it` and end in `bash`:

```bash
docker run -it -v $(pwd):/var/www debian bash
```

It also checks if the default docker-machine (the Virtual Machine) is running, if not, it tries to start it and set the environment to use it.

And it also sets up shared folders in VirtualBox for each drive in your Windows (although you can configure which drives to use if you want) and mounts them inside the virtual machine (docker-machine), to allow using volumes with Docker (from any drive in your Windows, which is even more than what comes by default with the Docker Toolbox) to allow using commands like:

```bash
docker run -d -v $(pwd):/var/www ubuntu ping google.com
```

The shared folders (drives) inside the docker-machine (VirtualBox virtual machine) are mounted in two different directories to make it compatible with `docker` and `docker-compose`, so you can use normal relative volumes with `docker-compose`. You only have to make sure you run a normal `docker` command first to start and set up everything. For example:

```bash
docker ps
```

**Note**: After installing **babun-docker** (this program), you don't have to "use" another program. You can keep using the ```docker``` commands as normal. And after running a first `docker` command, you can use `docker-compose` as you would normally too.

## Installation

* Install [Docker Toolbox](https://www.docker.com/products/docker-toolbox).
* Run the bundled Docker Quickstart Terminal that comes with Docker Toolbox to make sure everything is working.
* Turn off the Docker Toolbox Virtual Machine: run `docker-machine stop default` (or turn off the Virtual Machine `default` in VirtualBox) so that **babun-docker** can do all the needed automatic configurations with the VM turned off.
* Install [Babun](http://babun.github.io/) and start a terminal.
* Run the following command:

```
curl -s https://raw.githubusercontent.com/tiangolo/babun-docker/master/setup.sh | source /dev/stdin
```

* To be able to use **babun-docker** right away without having to close and open Babun run the update:
```
babun-docker-update
```

* From Babun, use Docker as you would normally, for example: `docker ps`.

It will take care of configuring the virtual machine, turning it on, sharing volumes, allowing non-tty commands, etc. Whenever it does something for you (automatically) you will see an output like: `-- babun-docker: doing something`.

**Note**: the installation command will get a script from this repository and run it immediately, performing all the needed
steps to install everything (the same steps described in "Manual installation").
If you don't want to run it, you can do a manual installation.

### Installing **docker-babun** in Cygwin

If you definitively don't want to use **Babun**, you can install **docker-babun** in **Cygwin** (nevertheless, I highly recommend you **Babun**).

First you will need to have installed the following packages (installed by default in **Babun**):

* curl
* wget
* git

Then you can run the same command as above.



## Updating

* To update **babun-docker**, after following the installation instructions, run the command:

```
babun-docker-update
```

Note: if you want to receive email notifications when **babun-docker** is updated you can "star" this repository (the star button above) and login with GitHub to [Sibbell](https://sibbell.com), it will send you notifications automatically with new releases.

## Turning off
* As Docker Toolbox runs in a virtual machine, it uses `docker-machine` to comunicate and configure it. If you want to turn the virtual machine off, run:

```
docker-machine stop $babun_docker_machine_name
```

----

## What's new

#### 2016-11-09:
Now the shared folders are mounted in two directories inside the VirtualBox virtual machine to make it compatible with `docker-compose`.

You can start and set up **babun-docker** and all the shared folders with any `docker` command, as:

```bash
docker ps
```

And have a `docker-compose.yml` file with:

```yml
version: '2'
services:
  server:
    build: ./server
    volumes:
      - ./server/app:/app
    ports:
      - 8081:80
```

...note the relative mounted volume in `./server/app:/app`.

And then bring up your stack with:

```bash
docker-compose up -d
```

and it will work (because the shared folder paths that `docker-compose` uses are also mounted in the virtual machine).

#### 2016-08-17:
* Fix for the command `docker login`, see PR [24](https://github.com/tiangolo/babun-docker/pull/24) by [jpraet](https://github.com/jpraet).

#### 2016-07-05:
* Make `winpty` download file explicit, see PR [23](https://github.com/tiangolo/babun-docker/pull/23) by [murrayju](https://github.com/murrayju).
* Use the latest version of Winpty (0.4.0).

#### 2016-06-22:
* Fix for Docker Beta for Windows, see PR [#21](https://github.com/tiangolo/babun-docker/pull/21) by [@ronnypolley](https://github.com/ronnypolley).

#### 2016-04-21:
* Now you can run **babun-docker** in **Cygwin** (but I still recommend **Babun**).

#### 2016-04-20:
* Update winpty to latest version (and make old winpty installs to auto-update).
* Now you can use Bash instead of Zsh.

#### 2016-04-19:
* You can configure the VirtualBox installation path with the variable `babun_docker_virtualbox_bin`. Read more in the **Configurations** section below.

#### 2016-04-14:
* You can define which specific Windows drives to mount with the variable `babun_docker_volumes` (by default **babun-docker** tries to mounth them all). Read more in the **Configurations** section below.

* You can use a separate file in `~/.babun-docker/custom-config.sh` for custom configurations. Read more in the **Configurations** section below.

* Improved mounted volumes and ownership (with hints by [@olegweb](https://github.com/olegweb) ).

#### 2016-03-16:
* Support for Docker v1.10 (see PR [#9](https://github.com/tiangolo/babun-docker/pull/9) by [@mrkschan](https://github.com/mrkschan) ).

#### 2015-11-12:
* **babun-docker** automatically sets up shared folders in your VirtualBox virtual machine (docker-machine) for each of your Windows drives and mounts them inside the virtual machine, to allow using volumes (from any drive in your Windows, which is even more than what comes by default with the Docker Toolbox) with commands like:

```
docker run -it -v $(pwd):/var/www debian bash
```

* You can configure if you want **babun-docker** to automatically set up VirtualBox shared folders and volumes with the environment variable ```babun_docker_setup_volumes```. Set it to "0" if you want to disable that. Read more in the **Configurations** section below.

* You can now specify the name of the docker-machine to use with the environment variable ```babun_docker_machine_name```, which is set by default to the "default" machine (named "default"). (No pun / tongue twister intended). Set that environment variable to the name of the machine that you want to use (e.g. ```babun_docker_machine_name='dev'```). Read more in the **Configurations** section below.

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

After installing **babun-docker**, you can configure things with environment variables in the file `~/.babun-docker/custom-config.sh`.

* If you want to specify which drives should be used for the setup of VirtualBox shared folders and volumes inside your docker-machine virtual machine set the environment variable ```babun_docker_volumes``` to a list of the drive names separated by spaces, as in "c d". For example:

```
echo 'babun_docker_volumes="c d"' >> ~/.babun-docker/custom-config.sh
source ~/.babun-docker/*config.sh
```

* If you want to disable the setup of VirtualBox shared folders and volumes inside your docker-machine virtual machine set the environment variable ```babun_docker_setup_volumes``` to "0". For example:

```
echo babun_docker_setup_volumes=0 >> ~/.babun-docker/custom-config.sh
source ~/.babun-docker/*config.sh
```

* If you want to change the virtual machine to use (if you have configured another virtual machine with ```docker-machine```) you can set the environment variable ```babun_docker_machine_name``` to the name of your new virtual machine. For example:

```
echo babun_docker_machine_name='dev' >> ~/.babun-docker/custom-config.sh
source ~/.babun-docker/*config.sh
```

* If you have VirtualBox installed in a different location (it would be uncommon) you could set the path with the variable ```babun_docker_virtualbox_bin```, you would have to use Cygwin (Babun) paths, you can use cygpath to convert between Windows and Cygwin paths. It should point to the program "VBoxManage". For example:

```
echo "babun_docker_virtualbox_bin='$(cygpath -u 'C:\Program Files\Oracle\VirtualBox\VBoxManage')'" >> ~/.babun-docker/custom-config.sh
source ~/.babun-docker/*config.sh
```
