# syntax = docker/dockerfile:1.2
##################################################################################
##	INIT/AUTHOR																	##
##	 - Uses the latest GCC image to use in the docker container 				## 
##	 - Sets version number, author and github link								##
##################################################################################
FROM gcc:latest
LABEL version="1.0"
LABEL author="livingsavage"

##################################################################################
##	BASICS																		##
##	-	Updates the packages included with the gcc image 						##
##	-	Installs git, vim and dependencies required for: 						##
##		-	norminette 	(python3, python3-pip)									##
##		-	42 header	(.bashrc, stdheader.vim)								##
##################################################################################
RUN apt-get update && apt-get install -y \
	git \
	vim \
	python3 \
	python3-pip 

#	Install norminette into the container
RUN python3 -m pip install --upgrade pip setuptools
RUN python3 -m pip install norminette

##################################################################################
##	USERENV (https://vsupalov.com/docker-env-vars/)								##
##	-	Set default username and password (via ARG) if it hasn't been defined.	##
##		-	ENV can be defined in docker compose, command line (-e) or .env file##
##	-	Set UserID and GroupID													##
##################################################################################
#	If environment variables have been set they will be substituted here.
ENV INTRA=${INTRA}
ENV PW=42docker

ARG UID=1000
ARG GID=1000

#	Change password of the assigned user and password to the assigned UID
RUN useradd -m ${INTRA} --uid=${UID} && echo "${INTRA}:${PW}" | \
		chpasswd

#	Set working directory for 42git
USER ${UID}:${GID}
WORKDIR /home/${INTRA}

RUN mkdir 42git
COPY 42git {$HOME}/42git

#	Setup 42header - WIP
# COPY stdheader.vim ${HOME}/.vim/pack/vendor/start/stdheader.vim
# RUN mkdir ${HOME}/bin
# COPY set_header.sh ${HOME}/bin/set_header.sh
