FROM ubuntu:18.04
ENV container docker

# Actualiza los paquetes
RUN apt-get update && apt-get -y upgrade

# Instala utilidades
RUN apt-get -y install procps htop grep iputils-ping iproute2 gpg

# Instala y configura SSH para poder usar 'vagrant ssh'
RUN apt-get -y install openssh-server sudo
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' -q -y
RUN useradd --create-home -s /bin/bash vagrant
RUN echo 'vagrant:vagrant' | chpasswd
RUN echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant
RUN chmod 440 /etc/sudoers.d/vagrant
RUN mkdir -p /home/vagrant/.ssh
RUN chmod 700 /home/vagrant/.ssh
ADD https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub /home/vagrant/.ssh/authorized_keys
RUN chmod 600 /home/vagrant/.ssh/authorized_keys
RUN chown -R vagrant:vagrant /home/vagrant/.ssh
RUN sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/i' /etc/ssh/sshd_config

# Instala nginx y habilitarlo
RUN apt-get -y install nginx
RUN systemctl enable nginx

CMD ["/usr/sbin/sshd", "-D"]
