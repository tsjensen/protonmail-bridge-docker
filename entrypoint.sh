#!/bin/bash

set -eo pipefail

declare -r bridge="protonmail-bridge --cli"

if ! [ -f ~/.cache/protonmail/bridge ] ; then
    declare loginInput
    eval `cat credentials.txt`
    loginInput="login\n${EMAIL}\n${PASSWORD}"
    if [[ ! -z ${MFACODE} ]]; then
        loginInput="${loginInput}\n${MFACODE}"
    fi
    echo -e "${loginInput}" | ${bridge}
fi

# socat will make the connection appear to come from 127.0.0.1, because ProtonMail Bridge expects that
socat TCP-LISTEN:${SMTP_PORT},fork TCP:127.0.0.1:1025 &
socat TCP-LISTEN:${IMAP_PORT},fork TCP:127.0.0.1:1143 &

# display account information, then keep stdin open
[ -e faketty ] || mkfifo faketty
{ echo info ; cat faketty ; } | ${bridge}
