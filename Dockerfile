#
# Build an Ubuntu installation of bbp
#
# ubuntu:focal is 20.04 which should give us compatible compilers
#
from ubuntu:focal
MAINTAINER Philip Maechling maechlin@usc.edu

# Define Build and runtime arguments
# These accept userid and groupid from the command line
#ARG APP_UNAME
#ARG APP_GRPNAME
#ARG APP_UID
#ARG APP_GID
#ARG BDATE

ENV APP_UNAME=scecuser \
APP_GRPNAME=scec \
APP_UID=1000 \
APP_GID=20 \
BDATE=20230428

# Retrieve the userid and groupid from the args so 
# Define these parameters to support building and deploying on EC2 so user is not root
# and for building the model and adding the correct date into the label
RUN echo $APP_UNAME $APP_GRPNAME $APP_UID $APP_GID $BDATE

#
RUN apt-get -y update
RUN apt-get -y upgrade
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt-get install -y build-essential git vim nano python3 python3-pip curl

# Install latest gcc, gfortran, and fftw
RUN apt-get install -y libfftw3-dev libfftw3-mpi-dev libopenmpi-dev gfortran
RUN pip3 install matplotlib pyproj numpy scipy numba

RUN ln -s /usr/bin/python3 /usr/bin/python

# Setup Owners
# Group add duplicates "staff" so just continue if it doesn't work
RUN groupadd -f --non-unique --gid $APP_GID $APP_GRPNAME
RUN useradd -ms /bin/bash -G $APP_GRPNAME --uid $APP_UID $APP_UNAME

#Define interactive user
USER $APP_UNAME

# Get a copy of the bbp repo
WORKDIR /home/$APP_UNAME

#COPY --chown=$APP_UNAME:$APP_GRPNAME Anaconda3-2023.03-1-Linux-x86_64.sh ./anaconda.sh
#RUN /bin/bash anaconda.sh -b && \
#/bin/rm /home/$APP_UNAME/anaconda.sh
# && \
#/home/$APP_UNAME/anaconda3/condabin/conda install -c anaconda -y pyproj

#COPY --chown=$APP_UNAME:$APP_GRPNAME Anaconda3-2023.03-1-Linux-x86_64.sh ./Anaconda3-2023.03-1-Linux-x86_64.sh
#COPY --chown=$APP_UNAME:$APP_GRPNAME anaconda_inputs.txt ./anaconda_inputs.txt
#RUN bash Anaconda3-2023.03-1-Linux-x86_64.sh < anaconda_inputs.txt
#RUN rm /home/$APP_UNAME/Anaconda3-2023.03-1-Linux-x86_64.sh
#RUN /home/$APP_UNAME/anaconda3/condabin/conda install -y pyproj

#
# Setup path for installation of bbp into /app/bbp
# Assume the data directory is a external bind mount, so that the results are saved
# Also assume the user treats the /app/target directory as their working directory
#
ENV BBP_DIR=/home/$APP_UNAME/bbp/bbp BBP_GF_DIR=/home/$APP_UNAME/bbp_gf BBP_VAL_DIR=/home/$APP_UNAME/bbp_val BBP_DATA_DIR=/app/target MD5FILE=/home/$APP_UNAME/bbp/bbp/setup/bbp-22.4.0-md5.txt
ENV PYTHONPATH=/home/$APP_UNAME/bbp/bbp/comps:/home/$APP_UNAME/bbp/bbp/comps/PySeismoSoil:${PYTHONPATH}
ENV PATH="/home/$APP_UNAME/bbp/bbp/comps:/home/$APP_UNAME/bbp/bbp/utils/batch:${PATH}"
#ENV PATH="/home/$APP_UNAME/anaconda3/bin:/home/$APP_UNAME/bbp/bbp/comps:/home/$APP_UNAME/bbp/bbp/utils/batch:${PATH}"

RUN git clone https://github.com/pjm-usc/bbp
RUN chown -R $APP_UNAME:$APP_GRPNAME ./bbp

#
# Run BBP Install script
# The setup_inputs.txt input files specifies
# responses to questions printed on terminal screen.
# The responses in this default set selects only one region
# and three validation events for installation
#
WORKDIR /home/$APP_UNAME/bbp/setup
COPY --chown=$APP_UNAME:$APP_GRPNAME setup_inputs.txt ./setup_inputs.txt
RUN  bash easy_install_bbp_22.4.0.sh < setup_inputs.txt

# After the bbp install move the data files into place
# The setup_inputs is a list of command line prompts for region
# This setup is configured and saved in the git repo.
# To start, the config says yes to install all regions, but could be minimized later
WORKDIR /home/$APP_UNAME/bbp_gf
COPY --chown=$APP_UNAME:$APP_GRPNAME LABasin500/ ./LABasin500
#RUN tar xf ./bbp/bbp_gf/labasin500-velocity-model-19.4.0.tar.gz
#RUN rm ./bbp/bbp_gf/labasin500-velocity-model-19.4.0.tar.gz
WORKDIR /home/$APP_UNAME/bbp_val
COPY --chown=$APP_UNAME:$APP_GRPNAME NR/ ./NR
#RUN tar xf ./bbp/bbp_val/nr-validation-19.4.0.tar.gz
#RUN rm ./bbp/bbp_val/nr-validation-19.4.0.tar.gz
COPY --chown=$APP_UNAME:$APP_GRPNAME Whittier/ ./Whittier
#RUN tar xf ./bbp/bbp_val/whittier-validation-19.4.0.tar.gz
#RUN rm ./bbp/bbp_val/whittier-validation-19.4.0.tar.gz
COPY --chown=$APP_UNAME:$APP_GRPNAME ChinoHills/ ./ChinoHills
#RUN tar xf ./bbp/bbp_val/chino-hills-validation-19.4.0.tar.gz
#RUN rm ./bbp/bbp_val/chino-hills-validation-19.4.0.tar.gz
#
#
WORKDIR /home/$APP_UNAME
COPY --chown=$APP_UNAME:$APP_GRPNAME .bashrc  ./.bashrc
COPY --chown=$APP_UNAME:$APP_GRPNAME .bash_profile  ./.bash_profile

# Define file input/output mounted disk
#
VOLUME /app/target
WORKDIR /app/target
#
# The .bashrc and .bash_profile will Define ENV variables
#
#
# Add metadata to dockerfile using labels
LABEL "org.scec.project"="SCEC Broadband Platform (BBP)"
LABEL org.scec.responsible_person="Philip Maechling"
LABEL org.scec.primary_contact="maechlin@usc.edu"
LABEL version="bbp_v22_4"
# start as command line terminal
#
CMD ["/bin/bash"]
