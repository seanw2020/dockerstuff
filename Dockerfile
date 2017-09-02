#Amy's contrib
#FROM registry.access.redhat.com/rhel7

# change password
RUN echo "root:howdy" | chpasswd

# set env 
ENV TERM xterm

# set permissions
RUN mkdir /data && chmod -R 0777 /data

# add software
#RUN yum -y install hostname iputils bind-utils git vim sudo openssh-server iproute initscripts wget deltarpm
RUN yum -y install hostname iputils bind-utils git vim sudo openssh-server iproute initscripts wget deltarpm expect httpd install ntp nc curl unzip tar wget openssl openssh install gcc-c++ ntp curl unzip tar wget openssl openssh nc nfs-utils libnfsidmap pam ntp libaio compat-libstdc++*i686 ksh pam.i686 libstdc++*i686 openssh numactl gcc-c++ kernel-devel sg3_utils ntp nc curl unzip tar wget openssl openssh java-1.8.0-openjdk-devel 
RUN yum -y install firewalld net-tools policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted libselinux-utils setroubleshoot-server setools setools-console mcstrans

# allow root ssh
RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

RUN yum -y install systemd; yum clean all; \
	(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
RUN chkconfig sshd on ; touch /etc/sysctl.conf

# systemd leaves this post-install
RUN rm -f /usr/lib/tmpfiles.d/systemd-nologin.conf
ADD aml-timezone.service /etc/systemd/system/
RUN systemctl enable aml-timezone
RUN systemctl enable firewalld

# only enable this dev:node
#ADD aml-kickoff.service /etc/systemd/system/
#RUN systemctl enable aml-kickoff

CMD [ "/usr/sbin/init" ]
