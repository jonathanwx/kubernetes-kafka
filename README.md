# kubernetes-kafka
kafka cluster for kubernetes

kubernete下kafka，支持集群或者单机模式 -> [docker hub地址](https://hub.docker.com/r/jonathanwx/kubernetes-kafka)

依赖zookeeper，地址  [zookeeper](https://github.com/jonathanwx/kubernetes-zookeeper)


`kafka.yaml`

``` yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: kafka
spec:
  serviceName: kafka
  replicas: 3 # 集群数量
  selector:
    matchLabels:
      app: kafka
  template:
    metadata:
      labels:
        app: kafka
    spec:
      containers:
      - name: kafka
        imagePullPolicy: IfNotPresent
        image: jonathanwx/kubernetes-kafka:2.12-2.4.1
        ports:
          - containerPort: 9092
        env:
        - name: ZK_SERVERS
          value: "zookeeper-0.zookeeper:2181,zookeeper-1.zookeeper:2181,zookeeper-2.zookeeper:2181"
---
apiVersion: v1
kind: Service
metadata:
  name: kafka
  labels:
    app: kafka
spec:
  ports:
  - port: 9092
  clusterIP: None
  selector:
    app: kafka
```

`kubectl apply -f kafka.yaml`

创建话题
`/kafka/bin/kafka-topics.sh --create --zookeeper ${ZK_SERVERS} --replication-factor 3 --partitions 3 --topic your_topic_name`

查看话题
`./kafka-topics.sh --list --zookeeper ${ZK_SERVERS}`

`${ZK_SERVERS}`通过pod中的env暴露给容器，可以直接使用。使用`echo ${ZK_SERVERS}`在容器中查看