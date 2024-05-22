FROM --platform=amd64 debian:bookworm-slim AS ansible-tower

MAINTAINER Julien Blanc <jbla@tuta.io>

ENV ANSIBLE_TOWER_VER 3.2.8
EXPOSE 80 443

RUN apt-get update -y \
    && apt-get install -y software-properties-common \
    && apt-add-repository -y ppa:ansible/ansible \
    && apt-get update -y \
    && apt-get install -y ansible wget libpython2.7 
    
RUN yes | apt-get install -y ssh \
    && mkdir ~/.ssh \
    && service ssh start \
    && ssh-keyscan -H 127.0.0.1 > ~/.ssh/known_hosts \
    && service ssh stop

WORKDIR /opt

RUN wget https://releases.ansible.com/ansible-tower/setup/ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz
RUN tar xvzf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && rm -rf ansible-tower-setup-${ANSIBLE_TOWER_VER}.tar.gz \
    && mv ansible-tower-setup-${ANSIBLE_TOWER_VER} /opt/ansible-tower

ADD start.sh start.sh
ADD custom.sh /opt/ansible-tower/custom.sh

RUN chmod +x start.sh
RUN chmod +x /opt/ansible-tower/custom.sh
RUN /opt/ansible-tower/custom.sh
RUN /opt/ansible-tower/setup.sh \
    && rm -rf /opt/ansible-tower

RUN pip install pyvmomi pysphere

ENTRYPOINT exec /opt/start.sh
