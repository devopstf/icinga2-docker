FROM centos:7.3.1611

ADD http://packages.icinga.org/epel/ICINGA-release.repo /etc/yum.repos.d/   


RUN groupadd icingacmd -g 994 && \
    groupadd icinga -g 995 && \
    useradd icinga -u 997 -g icinga -G icingacmd && \
    rpm --import http://packages.icinga.org/icinga.key && \
    yum -y install epel-release && \
    yum -y install icingacli httpd php-ZendFramework-Db-Adapter-Pdo-Mysql && \
    yum -y install --setopt=tsflags='' icingaweb2 \
    yum clean all && \
    icingacli setup config webserver apache \
      --document-root /usr/share/icingaweb2/public > \
      /etc/httpd/conf.d/icingaweb2.conf && \
    sed -i s/"^;\(date.timezone =\)"/"\1 UTC"/ /etc/php.ini # TODO: move this to a startup-script, so we can set this via environment-variable

RUN yum install -y icinga2-ido-mysql;

RUN yum install -y mysql
	
#RUN \
#	ln -sf /proc/1/fd/1 /var/log/icingaweb2/icingaweb2.log 


EXPOSE 80

ADD scripts /usr/local/
RUN chmod +x /usr/local/sbin/entrypoint.sh
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
