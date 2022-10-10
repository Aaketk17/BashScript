#!/bin/bash

while getopts c:n:m:e:s:h: flag
do
    case "$flag" in
        c) clustername=${OPTARG};;
        n) networkIP=${OPTARG};;
        m) masterIP=${OPTARG};;
        e) masterIPE=${OPTARG};;
        s) nodeName=${OPTARG};;
        h) masterName=${OPTARG};;    
    esac
done

echo "Cluster: $clustername";
echo "networkIP: $networkIP";
echo "masterIP: $masterIP";
echo "masterIP Two: $masterIPE";
echo "nodeName: $nodeName";
echo "masterName: $masterName";

master=cluster.initial_master_nodes;
host=discovery.seed_hosts;
cluster=cluster.name;
network=network.host;
node=node.name;

sudo sed -i "/^#$cluster:/ c$cluster: ${clustername}" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^#$host:/ c$host: [\"${masterIP}\",\"${masterIPE}\"]" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^#$network:/ c$network: ${networkIP}" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^#$node: / c$node: ${nodeName}" /etc/elasticsearch/elasticsearch.yml

sudo sed -i "/^$network:/ c$network: ${networkIP}" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^$master:/ c$master: [\"${masterName}\"]" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^$host:/ c$host: [\"${masterIP}\",\"${masterIPE}\"]" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^$node: / c$node: ${nodeName}" /etc/elasticsearch/elasticsearch.yml
sudo sed -i "/^$cluster:/ c$cluster: ${clustername}" /etc/elasticsearch/elasticsearch.yml

sudo sed -i "/xpack.security.enabled: true/s/true/false/" /etc/elasticsearch/elasticsearch.yml

sudo cat /etc/elasticsearch/elasticsearch.yml

