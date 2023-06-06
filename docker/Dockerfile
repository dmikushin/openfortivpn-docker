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
    supervisor

# Create an SSH key for SSH login
RUN sudo ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N "" && \
    mv /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# We use supervisor instead of systemd to start multiple applications.
COPY ./docker/supervisord.conf /etc/
COPY ./docker/supervisor-log-prefix.sh /

RUN apt-get -y --no-install-recommends install \
     git && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*

# Start supervisord
EXPOSE 8081
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

