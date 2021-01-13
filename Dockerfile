FROM debian:buster
# Original MAINTAINER Adrian Dvergsdal [atmoz.net]
# S.CAPS: Modifications regarding OpenShift compatibility and SecurityContext (scc=anyuid)

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd /var/run/sftp && \
    chgrp 0 /var/run/sshd /var/run/sftp /etc/ssh /etc/passwd /etc/shadow /etc/group && \
    chmod g+w /var/run/sshd /var/run/sftp /etc/ssh /etc/passwd /etc/shadow /etc/group && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
