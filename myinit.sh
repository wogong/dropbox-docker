#!/bin/bash

DROPBOX_USER=${DROPBOX_USER:-nobody}
DROPBOX_USERID=${DROPBOX_USERID:-99}
DROPBOX_GROUP=${DROPBOX_GROUP:-users}
DROPBOX_GROUPID=${DROPBOX_GROUPID:-100}

getent group ${DROPBOX_GROUP} 2>&1 > /dev/null || groupadd -g ${DROPBOX_GROUPID} ${DROPBOX_GROUP}
getent passwd ${DROPBOX_USER} 2>&1 > /dev/null && usermod -d /dropbox 
getent passwd ${DROPBOX_USER} 2>&1 > /dev/null || useradd -d /dropbox -g${DROPBOX_GROUP} -G users -u ${DROPBOX_USERID} ${DROPBOX_USER}

[ ! -f $HOME/.dropbox-dist/dropboxd ] && cp -rp /usr/local/.dropbox-dist $HOME/.
[ ! -d $HOME/.dropbox/instance1 ] && su - ${DROPBOX_USER} -c "exec $HOME/.dropbox-dist/dropboxd"
su - ${DROPBOX_USER} -c "/usr/local/bin/dropbox.py start"

