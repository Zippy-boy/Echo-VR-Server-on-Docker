FROM debian:bullseye-slim as build

ENV DEBIAN_FRONTEND="noninteractive"

# Install some needed packages
RUN apt-get update \
 && apt-get install -y wget software-properties-common gnupg2 cabextract procps bc htop nano curl

WORKDIR /root

# Clean up APT-Caches
RUN apt-get -y autoremove \
 && apt-get clean autoclean \
 && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists

# Install wine and winetricks
COPY ./files/install-wine.sh /
RUN bash /install-wine.sh \
 && rm /install-wine.sh

# Set the Echo Folder
VOLUME /ready-at-dawn-echo-arena
WORKDIR /ready-at-dawn-echo-arena/bin/win10
RUN wine wineboot

# COPY demo profile
ARG src="./files/demoprofile.json"
ARG target="/root/.wine/drive_c/users/root/Local Settings/Application Data/rad/echovr/users/dmo/demoprofile.json"
COPY ${src} ${target}

# SET Debug-Level and Term
ENV WINEDEBUG=-all
ENV TERM=xterm

# Remove ENTRYPOINT
# ENTRYPOINT ["bash", "/scripts/dummy.sh"]
ENTRYPOINT ["tail", "-f", "/dev/null"]
