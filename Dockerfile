# Create bbp docker image
FROM centos:8

# Define Build and runtime arguments
ARG APP_UNAME
ARG APP_GRPNAME
ARG APP_UID
ARG APP_GID
ENV APP_UNAME=$APP_UNAME \
APP_GRPNAME=$APP_GRPNAME \
APP_UID=$APP_UID \
APP_GID=$APP_GID
# Retrieve the userid and groupid from the args so 
# Define these parameters to support building and deploying on EC2 so user is not root
RUN echo $APP_UNAME
RUN echo $APP_GRPNAME
RUN echo $APP_UID
RUN echo $APP_GID

LABEL "maintainer"="Philip Maechling <maechlin@usc.edu>" "appname"="bbp"

#
# the groupinstall includes autoconf automake, gcc gcc-c++ make libtool
RUN yum -y update &&\
 yum -y groupinstall "Development Tools" &&\
 yum -y install yum-utils gcc-gfortran fftw-devel which

# Setup owners
# Documents say this groupadd is needed build on linux, but not on mac
RUN groupadd --non-unique --gid $APP_GID $APP_GRPNAME
RUN useradd -ms /bin/bash -g $APP_GRPNAME --uid $APP_UID $APP_UNAME
USER $APP_UNAME
WORKDIR /home/$APP_UNAME
COPY --chown=$APP_UNAME:$APP_GRPNAME Anaconda3-2021.05-Linux-x86_64.sh ./Anaconda3-2021.05-Linux-x86_64.sh
COPY --chown=$APP_UNAME:$APP_GRPNAME anaconda_inputs.txt ./anaconda_inputs.txt
RUN bash Anaconda3-2021.05-Linux-x86_64.sh < anaconda_inputs.txt
RUN rm /home/$APP_UNAME/Anaconda3-2021.05-Linux-x86_64.sh
RUN /home/$APP_UNAME/anaconda3/condabin/conda install -y pyproj

#
# Setup path for installation of bbp into /app/bbp
# Assume the data directory is a external bind mount, so that the results are saved
# Also assume the user treats the /app/target directory as their working directory
#
ENV BBP_DIR=/home/$APP_UNAME/bbp/bbp BBP_GF_DIR=/home/$APP_UNAME/bbp_gf BBP_VAL_DIR=/home/$APP_UNAME/bbp_val BBP_DATA_DIR=/app/target MD5FILE=/home/$APP_UNAME/bbp/bbp/setup/bbp-19.4.0-md5.txt
ENV PYTHONPATH=/home/$APP_UNAME/bbp/bbp/comps:/home/$APP_UNAME/bbp/bbp/comps/PySeismoSoil:${PYTHONPATH}
ENV PATH="/home/$APP_UNAME/anaconda3/bin:/home/$APP_UNAME/bbp/bbp/comps:/home/$APP_UNAME/bbp/bbp/utils/batch:${PATH}"
#

#
WORKDIR /home/$APP_UNAME
COPY --chown=$APP_UNAME:$APP_GRPNAME bbp/ ./bbp
#
# Run BBP Install script
# The setup_inputs.txt input files specifies
# responses to questions printed on terminal screen.
# The responses in this default set selects only one region
# and three validation events for installation
#
WORKDIR /home/$APP_UNAME/bbp/setup
COPY --chown=$APP_UNAME:$APP_GRPNAME setup_inputs.txt ./setup_inputs.txt
RUN  bash easy_install_bbp_19.4.0.sh < setup_inputs.txt

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
LABEL version="bbp_v19_8"
# start as command line terminal
#
CMD ["/bin/bash"]
