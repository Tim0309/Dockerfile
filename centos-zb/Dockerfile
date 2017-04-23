FROM hub:5000/centos-base

ENV zabbix_agents=3.0.0 \
    zb_USER=zabbix \
    zb_UID=10050 
# http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm
# http://repo.zabbix.com/zabbix/3.2/rhel/7/x86_64/zabbix-release-3.2-1.el7.noarch.rpm

RUN set -ex \
    && useradd -u ${zb_UID} -d /var/zabbix  ${zb_USER} \
    \
    && zb_REPO='http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm' \
    \
    && yum install -y ${zb_REPO} \
    && yum makecache \
    && yum install -y zabbix-agent zabbix-sender \
    \
    && rm -f /etc/yum.repos.d/zabbix.repo \
    && yum clean all

ENV zb_Hostname=Zabbix \
    zb_Server=zabbix3.0 \
    zb_AgentPort=10050 \
    zb_SerActive=zabbix3.0 \
    zb_AgentConfDir='/etc/zabbix/zabbix_agentd.conf'

COPY zabbix_agentd.conf /etc/zabbix/
COPY docker-entrypoint.sh /

ENTRYPOINT [ "/docker-entrypoint.sh" ]
