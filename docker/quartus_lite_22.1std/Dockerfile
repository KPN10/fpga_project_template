FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ARG QUARTUS=QuartusLiteSetup-22.1std.2.922-linux.run
ARG CYCLONE=cyclonev-22.1std.2.922.qdz

COPY $QUARTUS /$QUARTUS
COPY $CYCLONE /$CYCLONE

RUN apt-get update && \
    apt-get -y -qq install apt-utils sudo && \
    apt-get -y -qq install locales && locale-gen en_US.UTF-8 && \
    apt-get -y -qq install  software-properties-common \
                            git \
                            libglib2.0-0:amd64 \
                            libfreetype6:amd64 \
                            libsm6:amd64 \
                            libxrender1:amd64 \
                            libfontconfig1:amd64 \
                            libxext6:amd64 \
                            libpng12-0:amd64 \
                            xterm:amd64 && \
    chmod 755 /$QUARTUS

# create a normal user so we're not running as root
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

# switch to user so it installs from the user's context
USER developer
ENV HOME /home/developer
# install quartus as the user (not root)
RUN    /$QUARTUS --mode unattended --unattendedmodeui none --installdir /home/developer/quartus_lite --accept_eula 1 && \
    sudo rm -f /$QUARTUS && \
    sudo rm -f /$CYCLONE

# run from xterm to capture any stdio logging (not sure there is any, but can't hurt)
CMD xterm -e "/home/developer/quartus_lite/quartus/bin/quartus --64bit"
