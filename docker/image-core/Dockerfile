FROM centos:7.3.1611

ADD http://packages.icinga.org/epel/ICINGA-release.repo /etc/yum.repos.d/
RUN groupadd icingacmd -g 994 && \
    groupadd icinga -g 995 && \
    useradd icinga -u 997 -g icinga -G icingacmd 
    

RUN rpm --import http://packages.icinga.org/icinga.key && \
    yum -y install epel-release && \
    yum -y install icinga2 icinga2-ido-mysql mariadb nagios-plugins-all && \
    yum clean all && \
    ln -sr /etc/icinga2/features-available/command.conf /etc/icinga2/features-enabled/ && \
    /usr/lib/icinga2/prepare-dirs /etc/sysconfig/icinga2 && \
    cp -a /etc/icinga2 /etc/icinga2.orig
    
# set icinga2 NodeName and create proper certificates required for the API
RUN sed -i -e 's/^.* NodeName = .*/const NodeName = "docker-icinga2"/gi' /etc/icinga2/constants.conf; 

RUN  yum -y install wget gcc openssl openssl-devel && \
    cd /tmp && \
    wget http://sourceforge.net/projects/nagios/files/nrpe-2.x/nrpe-2.15/nrpe-2.15.tar.gz -O nrpe.tgz && \
    tar xzf nrpe.tgz && \
    cd nrpe-2.15 && \
    ./configure && \
    make all && \
    make install-plugin && \
    cp /usr/local/nagios/libexec/check_nrpe /usr/lib64/nagios/plugins/

RUN  yum -y install mailx && \
    ln -s /bin/mailx /bin/email && \
    echo "#set smtp=smtp://smtp.server.tld:port_numberecho" >> /etc/mail.rc && \
    echo "set smtp=smtp://Ip servidor de correos:25" >> /etc/mail.rc 
    


RUN \
	chown -R 997:995 /etc/icinga2 && \
	chmod -R g+rwx /etc/icinga2 

#
ADD scripts /usr/local/
RUN chmod +x /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["/usr/sbin/icinga2", "daemon"]


