FROM  debian:buster-slim

LABEL maintainer="Thomas Jensen <tsjensen@users.noreply.github.com>"

ARG   bridgeVersion=1.2.3-1
ARG   smtpPort=25
ARG   imapPort=143

ENV   USER=proton \
      DEBIAN_FRONTEND=noninteractive \
      SMTP_PORT=${smtpPort} \
      IMAP_PORT=${imapPort}

RUN   apt-get update -y && \
      apt-get install -y apt-utils net-tools man pass boxes socat libcap2-bin ca-certificates curl && \
      apt-get install -y --no-install-recommends --no-install-suggests debsig-verify debian-keyring && \
      setcap 'cap_net_bind_service=+ep' /usr/bin/socat && \
      useradd --create-home --shell /bin/bash --no-user-group ${USER} && \
      chgrp -R users /home/${USER}/

COPY  protonmail/bridge.pol protonmail/bridge_pubkey.gpg protonmail/protonmail-bridge_${bridgeVersion}_amd64.deb /tmp/
COPY  --chown=${USER}:users gpgparams entrypoint.sh credentials.txt /home/${USER}/

RUN   chmod 755 /home/${USER}/entrypoint.sh && \
      chmod 644 /home/${USER}/gpgparams && \
      chmod 600 /home/${USER}/credentials.txt

USER  ${USER}

RUN   gpg --generate-key --batch /home/${USER}/gpgparams && \
      pass init pass-key

USER  root

RUN   gpg --dearmor --output /tmp/debsig.gpg /tmp/bridge_pubkey.gpg && \
      mkdir -p /usr/share/debsig/keyrings/E2C75D68E6234B07 && \
      mv /tmp/debsig.gpg /usr/share/debsig/keyrings/E2C75D68E6234B07 && \
      mkdir -p /etc/debsig/policies/E2C75D68E6234B07 && \
      mv /tmp/bridge.pol /etc/debsig/policies/E2C75D68E6234B07 && \
      debsig-verify /tmp/protonmail-bridge_${bridgeVersion}_amd64.deb && \
      \
      apt-get install -y --no-install-recommends --no-install-suggests /tmp/protonmail-bridge_${bridgeVersion}_amd64.deb && \
      apt-get clean && \
      ls -la /home/${USER} && \
      rm /tmp/bridge_pubkey.gpg /tmp/protonmail-bridge_${bridgeVersion}_amd64.deb

EXPOSE ${SMTP_PORT}
EXPOSE ${IMAP_PORT}

USER  ${USER}
WORKDIR /home/${USER}

ENTRYPOINT ./entrypoint.sh
