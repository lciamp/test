FROM centos

RUN yum update -y \
    && yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
    && yum install -y python36u python36u-libs python36u-devel python36u-pip \
    && yum install -y which gcc \
    && yum install -y openssh-server \
    && yum install -y mysql 

# make pip3 point to pip3.6
RUN ln -s /usr/bin/pip3.6 /bin/pip3
# pipenv installation

RUN pip3 install --upgrade pip \
    && pip3 install pipenv

# make python point to python3.6
RUN ln -s /usr/bin/python3.6 /usr/bin/python3
# install aws cli
RUN pip3 install awscli --upgrade 

#add remote_user and ssh key
RUN useradd remote_user && \
    echo "1234" | passwd remote_user --stdin && \
    mkdir /home/remote_user/.ssh && \
    chmod 700 /home/remote_user/.ssh


COPY remote-key.pub /home/remote_user/.ssh/authorized_keys

RUN chown remote_user:remote_user -R /home/remote_user/.ssh/ && \
    chmod 600 /home/remote_user/.ssh/authorized_keys

RUN /usr/sbin/sshd-keygen

CMD /usr/sbin/sshd -D 
