# Overview of bbp_docker Repo
This repo contains tools to create a dockerized version of the SCEC Broadband Platform. The scripts, codes, configuration files in this repo create and run a dockerized version of the BBP software that is posted in SCEC github repo: [https://github.com/sceccode/bbp]

# Overview of Building a new Docker image from the BBP
## Select Working Directory on Development Computer
On a mac start at:
/Users/maechlin

## Retrieve this repo. This repo contains bbp docker tools
git clone https://github.com/sceccode/bbp_docker.git

This creates a directory call bbp_docker. On my Mac as:
/Users/maechlin/bbp_docker

## Retrieve the desired version of the bbp platform
<pre>
Move into the bbp_docker directory on the development computer.
cd /Users/maechlin/bbp_docker

The git retrieval command for the starting branch of BBP:
$git clone --single-branch --branch dev https://github.com/sceccode/bbp.git
</pre>

## BBP Command Line Installation Inputs
This repo contains a file setup_inputs.txt. This is a list of inputs to the bbp install script. Currently, during the installation process, this file is redirected as standard input to the bbp installation script.

See the wiki page to see list of inputs to bbp install, and to interpret the settings in this setup_inputs.txt file.
https://github.com/pjmaechling/bbp_docker/wiki

## build.sh script
This script contains the "docker build" command. When this script is run, the docker file is converted to a docker image. For larger installations, the docker build process may take multiple hours.

## Usage Model for BBP Docker Installations.
The User starts docker on their computer. The docker daemon must be running. Then, the User moves to a directory on their computer where they want to run the bbp. Let's say this directory is /Users/maechlin/bbp_docker

The user will cd to this directory, and create a subdirectory call /target. As an example:
/Users/maechlin/bbp_docker/target

The bbp platform will read input files and write results to this ./target directory. File in this directory will be preserved after the Container exits or terminates.

## run_bbp.sh script
Once the bbp image has been built, it can be run with this script:
$ run_bbp.sh

This script mounts the ./target subdirectory in the container. It will pull the bbp image specified in this file from a local Docker repo, or from Dockerhub if not found locally. The images are 50GB+, so if they are downloaded from Dockerhub, it may take more than an hour to start up the container. Once the image is cached locally, the container will start up rapidly.

## Once BBP Containers starts up
The user runs the run_bbp.sh script in terminal window at the command line on their host computer. When they run this script, the command line changes in their terminal window, and the user is presented with a Linux command line prompt. The users should cd into the /app/target directory. The files from their host computer (e.g. the files in /Users/maechlin/bbp_docker/target) will found in this directory. When the users runs the bbp platform from here, the results will be written to subdirectories of /app/target.
$cd /app/target

## Interaactive BBP Command Line Interface
Users can invoke the BBP command line interface, and the bbp will ask users a series of questions about the simulation they wish to run. 
$run_bbp.py

## Run Cmd:
docker run --rm -it --mount type=bind,source="$(pwd)"/target,destination=/app/target  sceccode/bbp_docker:MMDDHHMM

This is a coding and configuration test for creating a UCVM docker image that can be run on AWS.

## .dockerignore file
There is a .dockerignore file that defines which files not to include in the image. The Dockerfile and this README.md are excluded.

## Build Docker images for Nine SCEC CVMs
The top level script is: build_all.sh which invokes docker build 1 time.

## Dockerfile
This lists the steps needed to build the container. It starts with a amazonlinux base image, add compilers and python.

It copies the ucvm git repo from the build computer into the image, and then invokes the build process. The build process runs, installs results in a directory: /app/bbp

## Mount data input output directories
On host system, user invokes docker run. Expectation is that there is a subdirectory call ./target
./target is mounted as /app/bbp_data.
Input files can be stored there.
Output results will be written there

## Potential Benefits and Limitations

Potential Benefits 

This BBP docker image requires no installation, other than the docker run command. Also, the docker images are now portable to other computers. Potentially, large BBP calculations could be distributed among multiple instances running simultaneously.

Potential Limitations

Users must be comfortable running ucvm from a command line interface. This over means they are creating output files, and extracting selected information for plotting. Users must work within limits of images and local computers. There are some size ucvm problems that won't run on their laptops, so we need to warn people what the limits are.

# Related Docker git repos
1. [UCVM Docker Wiki](https://github.com/sceccode/ucvm_docker/wiki)
2. [UCVM Docker README.md](https://github.com/sceccode/ucvm_docker)
3. [BBP Docker Wiki](https://github.com/sceccode/bbp_docker/wiki)
4. [BBP Docker README.md](https://github.com/sceccode/bbp_docker)
