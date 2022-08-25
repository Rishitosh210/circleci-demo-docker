ARG BASE_CONTAINER=python:3.7.6-slim
FROM $BASE_CONTAINER

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Configurable via the docker build command line with -p
ARG TYCHO_BRANCH=develop
# Least privilege: Run as a non-root user.
ENV USER appstore
ENV APP_HOME /usr/src/inst-mgmt
ENV HOME /home/$USER
ENV UID 1000
ENV DJANGO_SETTINGS braini
ENV TYCHO_URL http://docker.for.mac.localhost:5000

RUN adduser --disabled-login --home $HOME --shell /bin/bash --uid $UID $USER && \
   chown -R $UID:$UID $HOME
#Switch the working directory

WORKDIR $APP_HOME

RUN set -x && apt-get update && \
	chown -R $UID:$UID $APP_HOME && \
	apt-get install -y postgresql-server-dev-all \
	postgresql-client git build-essential \
	xmlsec1


# Install Virtual Environment
RUN pip install --upgrade pip

COPY . .

RUN pip install -r req.txt