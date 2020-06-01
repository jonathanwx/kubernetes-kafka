FROM openjdk:8u232-jdk

LABEL maintainer="jonathanlichi@gmail.com"
ARG KAFKA_VERSION=2.2.0
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
# RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
RUN wget https://archive.apache.org/dist/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz

RUN tar -xzvf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C / && mv /kafka_${SCALA_VERSION}-${KAFKA_VERSION} /kafka

# fix bugs https://help.aliyun.com/noticelist/articleid/1060035134.html
RUN rm -rf /kafka/libs/jackson*
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-databind/2.9.10/jackson-databind-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-annotations/2.9.10/jackson-annotations-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/core/jackson-core/2.9.10/jackson-core-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.9.10/jackson-datatype-jdk8-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/jaxrs/jackson-jaxrs-base/2.9.10/jackson-jaxrs-base-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/jaxrs/jackson-jaxrs-json-provider/2.9.10/jackson-jaxrs-json-provider-2.9.10.jar
RUN wget -P /kafka/libs https://repo1.maven.org/maven2/com/fasterxml/jackson/module/jackson-module-jaxb-annotations/2.9.10/jackson-module-jaxb-annotations-2.9.10.jar

COPY scripts/start-kafka.sh /
RUN chmod +x /start-kafka.sh

# change time zone
RUN cp /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
EXPOSE 9092

RUN rm -rf /tmp
WORKDIR /
ENTRYPOINT ["/start-kafka.sh"]