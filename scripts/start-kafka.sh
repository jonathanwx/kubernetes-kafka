#!/usr/bin/env bash

HOST=$(hostname -s)
DOMAIN=$(hostname -d)

if [[ $HOST =~ (.*)-([0-9]+)$ ]]; then
  NAME=${BASH_REMATCH[1]}
  ORD=${BASH_REMATCH[2]}
else
  echo "Fialed to parse name and ordinal of Pod"
  exit 1
fi

function create_config() {
  sed -i "s/^broker.id=.*$/broker.id=${ORD}/g" /kafka/config/server.properties
  sed -i "s/^listeners=.*$/listeners=PLAINTEXT:\/\/${HOST}.${DOMAIN}:9092/g" /kafka/config/server.properties
  sed -i "s/^log.dirs=.*$/log.dirs=\/kafka\/log\/${HOST}/g" /kafka/config/server.properties
  if [ "${ZK_SERVERS}" != "" ]; then
    sed -i "s/^zookeeper.connect=.*$/zookeeper.connect=${ZK_SERVERS}/g" /kafka/config/server.properties
  else
    /kafka/bin/zookeeper-server-start.sh
  fi
}

create_config && /kafka/bin/kafka-server-start.sh /kafka/config/server.properties
