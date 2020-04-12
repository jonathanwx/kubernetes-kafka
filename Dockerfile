FROM openjdk:8u232-jdk

LABEL maintainer="jonathanlichi@gmail.com"
ARG KAFKA_VERSION=2.4.1
ARG SCALA_VERSION=2.12
WORKDIR /tmp

# change apt source
# uncomment if needed
# RUN mv /etc/apt/sources.list /etc/apt/sources.list.bak && \
#   echo "deb http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian/ stretch-backports main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list && \
#   echo "deb-src http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib">>/etc/apt/sources.list 

RUN apt-get update && apt-get install -y wget iputils-ping lsof

# alternative mirror site replace if needed
# https://mirrors.tuna.tsinghua.edu.cn/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
RUN wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

RUN tar -xzvf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C / && mv /kafka_${SCALA_VERSION}-${KAFKA_VERSION} /kafka

COPY scripts/start-kafka.sh /
RUN chmod +x /start-kafka.sh

# change time zone
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
EXPOSE 9092

RUN rm -rf /tmp
WORKDIR /
ENTRYPOINT ["/start-kafka.sh"]