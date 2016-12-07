FROM centos:6.7
RUN yum update -y glibc-common
RUN (yum install -y sudo passwd openssh-server openssh-clients tar screen crontabs strace telnet perl libpcap bc patch ntp dnsmasq unzip pax; \
     yum clean all)
RUN (rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm; \
     rpm -Uvh https://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm; \
     yum install -y puppet puppet-server puppetserver facter hiera lsyncd sshpass rng-tools)
RUN (service sshd start; \
     sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config; \
     sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config; \
     sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config; \
     sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/CentOS-Base.repo)
RUN (mkdir -p /root/.ssh/; \
     echo "StrictHostKeyChecking=no" > /root/.ssh/config; \
     echo "UserKnownHostsFile=/dev/null" >> /root/.ssh/config)
RUN echo "root:toor" | chpasswd
ADD /resilio-sync.repo /etc/yum.repos.d/
ADD /transmission/settings.json /root/.config/transmission-daemon/
RUN (rpm --import https://linux-packages.resilio.com/resilio-sync/key.asc; \
     yum install -y resilio-sync transmission transmission-daemon; \
     mkdir -p /root/.sync/; \
	 mkdir -p /root/Downloads/; \
     chmod -R 755 /root/.sync/)
ADD /sync.conf /usr/bin/
ADD /sync/ /root/.sync/
ADD /.sync/ /root/Downloads/.sync/
EXPOSE 22 9091 31003
CMD service crond start;/usr/bin/rslsync --config /usr/bin/sync.conf;transmission-daemon;/usr/sbin/sshd -D
