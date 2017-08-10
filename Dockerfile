FROM registry.access.redhat.com/rhel7

# add software
RUN ["yum","-y","install","man","hostname","iputils","bind-utils","git","vim","sudo"]

# create user
ENV NEWUSER sean
RUN useradd $NEWUSER

# add wheel
RUN usermod -a -G wheel $NEWUSER

# change password
RUN echo "${NEWUSER}:howdy" | chpasswd

# run containers as NEWUSER
USER $NEWUSER

# add alias
RUN echo "alias ll='ls -lha'" >> ~/.profile

# run sh but read profile
CMD /bin/sh --login
