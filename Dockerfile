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

LABEL "maintainer"="Philip Maechling <maechlin@usc.edu>" "appname"="bbp"

#
# the groupinstall includes autoconf automake, gcc gcc-c++ make libtool
RUN yum -y update &&\
 yum -y groupinstall "Development Tools" &&\
 yum -y install yum-utils gcc-gfortran fftw-devel which

# Setup owners
# Documents say this groupadd is needed build on linux, but not on mac
RUN groupadd --non-unique --gid $APP_GID $APP_GRPNAME
RUN useradd -ms /bin/bash -G $APP_GRPNAME --uid $APP_UID $APP_UNAME
USER $APP_UNAME
WORKDIR /home/bbp
COPY --chown=$APP_UNAME:$APP_GRPNAME Anaconda3-2021.05-Linux-x86_64.sh ./Anaconda3-2021.05-Linux-x86_64.sh
COPY --chown=$APP_UNAME:$APP_GRPNAME anaconda_inputs.txt ./anaconda_inputs.txt
RUN bash Anaconda3-2021.05-Linux-x86_64.sh < anaconda_inputs.txt
RUN rm /home/bbp/Anaconda3-2021.05-Linux-x86_64.sh
RUN /home/bbp/anaconda3/condabin/conda install -y pyproj

#
# Setup path for installation of bbp into /app/bbp
# Assume the data directory is a external bind mount, so that the results are saved
# Also assume the user treats the /app/target directory as their working directory
#
ENV BBP_DIR=/app/bbp/bbp BBP_GF_DIR=/app/bbp/bbp_gf BBP_VAL_DIR=/app/bbp/bbp_val BBP_DATA_DIR=/app/target BASEBBP=/app/bbp/bbp BBPDIR=/app/bbp SRCDIR=/app/bbp/bbp/src MD5FILE=/app//bbp/bbp/setup/bbp-19.4.0-md5.txt
ENV PYTHONPATH=/app/bbp/bbp/comps:/app/bbp/bbp/comps/PySeismoSoil:${PYTHONPATH}
ENV PATH="/home/bbp/anaconda3/bin:/app/bbp/bbp/comps:/app/bbp/bbp/utils/batch:${PATH}"
#

#
WORKDIR /app
COPY --chown=$APP_UNAME:$APP_GRPNAME bbp/ ./bbp
# Run the bbp install script
# The setup_inputs is a list of command line prompts for region
# This setup is configured and saved in the git repo.
# To start, the config says yes to install all regions, but could be minimized later
WORKDIR /app/bbp/bbp_gf
COPY --chown=$APP_UNAME:$APP_GRPNAME labasin500-velocity-model-19.4.0.tar.gz ./labasin500-velocity-model-19.4.0.tar.gz
RUN tar xf ./labasin500-velocity-model-19.4.0.tar.gz
RUN rm ./labasin500-velocity-model-19.4.0.tar.gz
WORKDIR /app/bbp/bbp_val
COPY --chown=$APP_UNAME:$APP_GRPNAME nr-validation-19.4.0.tar.gz ./nr-validation-19.4.0.tar.gz
RUN tar xf ./nr-validation-19.4.0.tar.gz
RUN rm ./nr-validation-19.4.0.tar.gz
COPY --chown=$APP_UNAME:$APP_GRPNAME whittier-validation-19.4.0.tar.gz ./whittier-validation-19.4.0.tar.gz
RUN tar xf ./whittier-validation-19.4.0.tar.gz
RUN rm ./whittier-validation-19.4.0.tar.gz
COPY --chown=$APP_UNAME:$APP_GRPNAME chino-hills-validation-19.4.0.tar.gz ./chino-hills-validation-19.4.0.tar.gz
RUN tar xf ./chino-hills-validation-19.4.0.tar.gz
RUN rm ./chino-hills-validation-19.4.0.tar.gz
#
# Run BBP Install script
# This version was modified to use binary files in bbp_gf and bbp_val rather
# than download those files from hypocenter.usc.edu
#
WORKDIR /app/bbp/setup
COPY --chown=$APP_UNAME:$APP_GRPNAME setup_inputs.txt ./setup_inputs.txt
RUN /bin/bash /app/bbp/setup/easy_install_bbp_19.4.0.sh < setup_inputs.txt
#
#
WORKDIR /home/bbp
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
