#!/bin/bash
set -e

# Generar claves de host si no existen
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    ssh-keygen -A
fi

# Arrancar rsyslog
rsyslogd

# Arrancar SSH en primer plano (para que el contenedor no muera)
exec /usr/sbin/sshd -D -e
