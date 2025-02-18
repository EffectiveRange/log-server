ARG ARCH=$ARCH
ARG IMAGE_REPO=${ARCH}/debian
ARG IMAGE_VER=bullseye-slim

FROM ${IMAGE_REPO}:${IMAGE_VER}

RUN apt update && apt upgrade -y && apt install -y openjdk-11-jdk wget gnupg apt-transport-https

# Install Elasticsearch
RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
RUN apt-get update
RUN apt-get install elasticsearch -y 2>&1 | tee /tmp/elasticsearch.log

# Install Logstash
RUN apt-get install logstash -y

# Install Kibana
RUN apt-get install kibana -y

COPY . /etc/log-server

# Set up configuration
RUN cp /etc/log-server/elasticsearch/config/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml
RUN cp /etc/log-server/logstash/config/logstash.yml /usr/share/logstash/config/logstash.yml
RUN cp /etc/log-server/logstash/pipeline/logstash.conf /usr/share/logstash/pipeline/logstash.conf
RUN cp /etc/log-server/kibana/config/kibana.yml /usr/share/kibana/config/kibana.yml

CMD ["/bin/bash"]
