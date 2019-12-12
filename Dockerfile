FROM ubuntu:14.04

ARG username="aosp"
ARG password="password"

RUN echo "dash dash/sh boolean false" | debconf-set-selections \
	&& dpkg-reconfigure -p critical dash

ARG DEBIAN_FRONTEND=noninteractive

RUN \
	apt-get update \
	&& apt-get -y upgrade

RUN \
	apt-get install -y  \
		bison \
		build-essential \
		curl \
		flex \
		g++-multilib \
		gcc-multilib \
		git-core \
		gnupg \
		gperf \
		lib32ncurses5-dev \
		lib32z-dev \
		libc6-dev-i386 \
		libgl1-mesa-dev \
		libx11-dev \
		libxml2-utils \
		unzip \
		x11proto-core-dev \
		xsltproc \
		zlib1g-dev \
		zip \
	&& apt-get clean \
	&& rm -rf \
		/var/lib/apt/lists/* \
		/tmp/* \
		/var/tmp/*

ADD \
	https://commondatastorage.googleapis.com/git-repo-downloads/repo \
	/usr/local/bin/
RUN \
	chmod 755 /usr/local/bin/repo

RUN \
	useradd \
		--create-home \
		--groups \
			sudo \
		"${username}" && \
	echo "${username}:${password}" | chpasswd

VOLUME \
	[ \
		"/home/${username}/.ccache", \
		"/home/${username}/workspace" \
	]

ENV USE_CCACHE 1
ENV CCACHE_DIR /home/${username}/.ccache

USER ${username}
WORKDIR /home/${username}/workspace
