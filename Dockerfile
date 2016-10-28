FROM centos:6.7
RUN yum update -y glibc-common
RUN (yum install -y sudo passwd openssh-server openssh-clients tar screen crontabs strace telnet perl libpcap bc patch ntp dnsmasq unzip pax; \
     yum clean all)
RUN rpm -Uvh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN (rpm -Uvh https://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm; \
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
RUN (echo "[btsync]" > /etc/yum.repos.d/resilio-sync.repo; \
     echo "name=Resilio Sync \$basearch" >> /etc/yum.repos.d/resilio-sync.repo; \
     echo "baseurl=http://linux-packages.resilio.com/resilio-sync/rpm/\$basearch" >> /etc/yum.repos.d/resilio-sync.repo; \
     echo "enabled=1" >> /etc/yum.repos.d/resilio-sync.repo; \  
     echo "gpgcheck=1" >> /etc/yum.repos.d/resilio-sync.repo; \
     mkdir -p /root/.config/transmission-daemon/; \
     echo "{" > /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-down\": 50," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-time-begin\": 540," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-time-day\": 127," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-time-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-time-end\": 1020," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"alt-speed-up\": 50," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"bind-address-ipv4\": \"0.0.0.0\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"bind-address-ipv6\": \"::\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"blocklist-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"blocklist-url\": \"http://www.example.com/blocklist\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"cache-size-mb\": 2," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"dht-enabled\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"download-dir\": \"/root/Downloads\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"encryption\": 1," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"idle-seeding-limit\": 30," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"idle-seeding-limit-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"incomplete-dir\": \"/root/Downloads\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"incomplete-dir-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"lazy-bitfield-enabled\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"lpd-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"message-level\": 2," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"open-file-limit\": 32," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-limit-global\": 240," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-limit-per-torrent\": 60," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-port\": 51413," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-port-random-high\": 65535," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-port-random-low\": 49152," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-port-random-on-start\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"peer-socket-tos\": 0," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"pex-enabled\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"port-forwarding-enabled\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"preallocation\": 1," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"ratio-limit\": 2," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"ratio-limit-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rename-partial-files\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-authentication-required\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-bind-address\": \"0.0.0.0\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-enabled\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-password\": \"{25e7c2c09b1d0f61bfd356c0924693443e28efbbSViTnp0M\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-port\": 9091," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-username\": \"\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-whitelist\": \"127.0.0.1\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"script-torrent-done-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"rpc-whitelist-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "	  \"script-torrent-done-filename\": \"\"," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"speed-limit-down\": 100," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"speed-limit-down-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"speed-limit-up\": 100," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"speed-limit-up-enabled\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"start-added-torrents\": true," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"trash-original-torrent-files\": false," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"umask\": 18," >> /root/.config/transmission-daemon/settings.json; \
     echo "    \"upload-slots-per-torrent\": 14" >> /root/.config/transmission-daemon/settings.json; \
     echo "}" >> /root/.config/transmission-daemon/settings.json; \
     rpm --import https://linux-packages.resilio.com/resilio-sync/key.asc; \
     yum install -y resilio-sync transmission transmission-daemon; \
     echo "{" > /usr/bin/sync.conf; \
     echo "  \"device_name\": \"My Sync Device\"," >> /usr/bin/sync.conf; \
     echo "  \"storage_path\" : \"/root/.sync\"," >> /usr/bin/sync.conf; \
     echo "  \"use_upnp\" : true," >> /usr/bin/sync.conf; \
     echo "  \"download_limit\" : 0," >> /usr/bin/sync.conf; \
     echo "  \"upload_limit\" : 0," >> /usr/bin/sync.conf; \
     echo "  \"directory_root\" : \"/root/\"," >> /usr/bin/sync.conf; \
     echo "  \"webui\" :" >> /usr/bin/sync.conf; \
     echo "  {" >> /usr/bin/sync.conf; \
     echo "    \"listen\" : \"0.0.0.0:31003\"" >> /usr/bin/sync.conf; \
     echo "    ,\"login\" : \"q\"" >> /usr/bin/sync.conf; \
     echo "    ,\"password\" : \"q\"" >> /usr/bin/sync.conf; \
     echo "  }" >> /usr/bin/sync.conf; \
     echo "}" >> /usr/bin/sync.conf; \
     /usr/bin/rslsync --config /usr/bin/sync.conf)
EXPOSE 22 9091 31003
CMD service crond start;/usr/sbin/sshd -D;service transmission-daemon start;service resilio-sync start 
