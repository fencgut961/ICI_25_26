FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instalar SSH y rsyslog
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        rsyslog \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Crear usuario de demo (cámbialo si quieres otras credenciales para la práctica)
RUN useradd -m -s /bin/bash student && \
    echo "student:Password123" | chpasswd

# Configuración básica de SSH
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config || true && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#UsePAM yes/UsePAM yes/' /etc/ssh/sshd_config

# Configuración de rsyslog para enviar logs a Logstash (host "logstash", puerto 1514)
RUN echo '*.* @logstash:1514' > /etc/rsyslog.d/60-logstash.conf

# Copiar entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
