FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get -y --no-install-recommends install \
    openfortivpn \
    ppp \
    ca-certificates \
    openssh-server \
    sudo \
    vim

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd && \
    bash -c 'install -m755 <(printf "#!/bin/sh\nexit 0") /usr/sbin/policy-rc.d' && \
    ex +'%s/^#\zeHostKey .*ssh_host_.*_key/\1/g' -scwq /etc/ssh/sshd_config && \
    echo "MaxSessions 2147483647" >> /etc/ssh/sshd_config && \
    RUNLEVEL=1 dpkg-reconfigure openssh-server && \
    ssh-keygen -A -v && \
    update-rc.d ssh defaults

RUN apt-get -y --no-install-recommends install \
    supervisor && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create an SSH key for SSH login
# TODO Remove in favor of dante-server
RUN sudo ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N "" && \
    mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Add a regular user for SSH proxying
RUN groupadd -g 1000 user && useradd -rm -s /bin/false -u 1000 -g 1000 user && \
    mkdir -p /home/user/.ssh

# Adjust permissions for the SSH keys
COPY ./authorize_keys.sh /

# We use supervisor instead of systemd to start multiple applications.
COPY ./supervisord.conf /etc/
COPY ./supervisor-log-prefix.sh /

# SSH proxy
EXPOSE 22

# SOCKS5 proxy
EXPOSE 8081

# Start supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

