[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
![GitHub repo size](https://img.shields.io/github/repo-size/sceccode/bbp_docker)

## The SCEC Broadband Platform (BBP) Docker Images

<a href="http://www.scec.org/research"><img src="https://github.com/sceccode/bbp_docker/wiki/images/SRL_Cover_v8.png"></a>

## Description: 
The Southern California Earthquake Center (SCEC) Broadband Platform (BBP) is a software system that can generate 0-20+ Hz seismograms for historical and scenario earthquakes in California, Eastern North America, and Japan using several alternative computational methods.

This repo contains tools to create a dockerized version of the SCEC Broadband Platform. The scripts, codes, configuration files in this repo create and run a dockerized version of the BBP software that is posted in SCEC github repo: [https://github.com/sceccode/bbp]

## Table of Contents:
1. [Software Documentation](https://github.com/SCECcode/bbp_docker/wiki)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Contributing](#contributing)
5. [Credits](#credit)
6. [License](#license)

## BBP Installation Options:
BBP was developed to support seismic simulations run on high-performance computing systems, so it is designed to compile and run on Linux-based computers. Before installing BBP from source code, they should be aware that there are other ways to get access to BBP without installing the software on your own Linux computer. Below we outline several of the options:
1. [BBP Docker Images](https://github.com/sceccode/bbp_docker) Users can run BBP in Docker on their local computers including laptops. Users can install free Docker software on most computers (e.g. Linux, MacOS, Windows) then run an BBP Docker image in a terminal window on their computer. 
2. [Installation Instructions for Linux Systems:](https://github.com/sceccode/ucvm/wiki) User can install BBP on Linux system. Advanced users that want to install many of the BBP simulation regions and validation events, or that want to run many simultaneous simulations. 

### Running an Existing BBP Docker Image:
BBP Docker images contains BBP software which can be run without a significant installation process. Users install the Docker client on their Laptops, and then use the Docker client software to run BBP Docker images. Docker client software is available as a free software download for several operating systems including MacOS, Windows, and Linux.

1. Install Docker Client on User Computer and Start Docker Client
- Docker Client download from [Dockerhub](https://hub.docker.com)
- Increase Docker configuration to 2 CPUs and 50GB memory

2. Open a terminal window on your local computer, and create a directory where you will run BBP
- mkdir /Users/maechlin/bbp_docker
- cd /Users/maechlin/bbp_docker

3. Create a "target" directory where BBP files are input/output
- cd /Users/maechlin/bbp_docker
- mkdir target
- ls /Users/maechlin/bbp_docker/target

4. Open a terminal window and start the BBP Docker image using the docker run command below. The BBP image will be downloaded from Dockerhub. The image is about 80GB so download time may be minutes or longer.
- docker run --rm -it --mount type=bind,source="$(pwd)"/target,destination=/app/target  sceccode/bbp_19_8_0:211210

5. The images starts and users sees a Linux bash shell command line prompt as user "bbp" in directory: /app/target
 
7. Run a the bbp text-based interface:
- $run_bbpy.py

8. The files generated by the default validation simulation will be saved to the target directory on the users host computer. Inside the container, the BBP output files are written to /app/target

9. The files written to the /app/target directory are available after the container exits.

### Building a BBP Docker Image:
A description of the steps needed to build a new BBP Docker image are provided in the bbp_docker wiki.

## Support:
Support for BBP docker images is provided by that Southern California Earthquake Center (SCEC) Research Computing Group. This group supports several research software distributions including UCVM. Users can report issues and feature requests using UCVM's github-based issue tracking link below. Developers will also respond to emails sent to the SCEC software contact listed below.
1. [BBP Docker Github Issue Tracker:](https://github.com/SCECcode/bbp_docker/issues)
2. Email Contact: software@scec.usc.edu

## Contributing
We welcome contributions to the BBP software framework. An overview of the process for contributing seismic models or software updates to the BBP Project is provided in the [BBP contribution](CONTRIBUTING.md) guidelines. BBP contributors agree to abide by the code of conduct found in our [Code of Conduct](CODE_OF_CONDUCT.md) guidelines.

## Credits
Development of BBP is a group effort. Developers that have contributed to the BBP docker software are listed in the [CREDITS.md](CREDITS.md) file in this repository.

## License
The BBP software is distributed under the BSD 3-Clause open-source license. Please see the [LICENSE.txt](LICENSE.txt) file for more information.
