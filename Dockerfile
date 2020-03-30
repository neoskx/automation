FROM ubuntu:18.04

LABEL maintainer="Neo Xu <neoskx15@gmail.com>"
ENV REFRESHED_AT 2020-03-26
ARG DEBIAN_FRONTEND=noninteractive

## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=welcome
ENV HOME=/home/neo \
    INSTALL_SCRIPTS=/docker/scripts \
    STARTUPDIR=/docker/startup \
    NO_VNC_HOME=/home/neo/noVNC \
    DISPLAY=:1 \
    VNC_PORT=5901 \
    NO_VNC_PORT=6901 \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x800 \
    VNC_PW=welcome \
    VNC_VIEW_ONLY=true \
    WORKHOME=/app
EXPOSE $VNC_PORT $NO_VNC_PORT
WORKDIR $WORKHOME

## Copy all install scripts for further steps
COPY ./src/scripts $INSTALL_SCRIPTS/
RUN find $INSTALL_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INSTALL_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INSTALL_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INSTALL_SCRIPTS/tigervnc.sh
RUN $INSTALL_SCRIPTS/no_vnc.sh

### Install xfce UI
RUN $INSTALL_SCRIPTS/xfce_ui.sh
COPY ./src/xfce/ $HOME/

### Install NodeJS
RUN $INSTALL_SCRIPTS/install_nodejs.sh

### configure startup
RUN $INSTALL_SCRIPTS/libnss_wrapper.sh
COPY ./src/startup $STARTUPDIR
RUN $INSTALL_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME $WORKHOME

# USER 1000

ENTRYPOINT ["/docker/startup/vnc_startup.sh"]
CMD ["--wait"]


# Metadata
LABEL neoskx.image.vendor="Neo" \
    neoskx.image.url="https://github.com/neoskx/automation" \
    neoskx.image.title="Automation" \
    neoskx.image.description="A docker image that used for automation job, like puppeeter. It contains NodeJS and VNC server." \
    neoskx.image.version="v0.1.1" \
    neoskx.image.documentation="https://github.com/neoskx/automation/blob/master/README.md"