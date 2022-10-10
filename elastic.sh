#!/bin/bash

while getopts c:n:m:e:d:s:p:q:f: flag
do
    case "$flag" in
        c) clustername=${OPTARG};;
        n) networkIP=${OPTARG};;
        m) masterIP=${OPTARG};;
        e) extraNode1=${OPTARG};;
        d) extraNode2=${OPTARG};;
	f) extraNode3=${OPTARG};;
        s) nodeName=${OPTARG};;
    esac
done

echo "Cluster: $clustername";
echo "networkIP: $networkIP";
echo "masterIP: $masterIP";
echo "extraNode1: $extraNode1";
echo "extraNode2: $extraNode2";
echo "extraNode3: $extraNode3";
echo "nodeName: $nodeName";

master=cluster.initial_master_nodes;
host=discovery.seed_hosts;
cluster=cluster.name;
network=network.host;
node=node.name;

arrayOfIP=("$extraNode1","$extraNode2"."$extraNode3")

if [[ ${arrayOfIP[*]} =~ $masterIP  &&  ${arrayOfIP[*]} =~ $masterIP ]]
then
	echo "Master IP and Network IP Present"

	sudo sed -i "/^#$cluster:/ c$cluster: ${clustername}" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^#$host:/ c$host: [\"${extraNode1}\",\"${extraNode2}\",\"${extraNode3}\"]" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^#$network:/ c$network: ${networkIP}" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^#$node: / c$node: ${nodeName}" /etc/elasticsearch/elasticsearch.yml

	sudo sed -i "/^$network:/ c$network: ${networkIP}" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^$master:/ c$master: [\"${masterIP}\"]" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^$host:/ c$host: [\"${extraNode1}\",\"${extraNode2}\",\"${extraNode3}\"]" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^$node: / c$node: ${nodeName}" /etc/elasticsearch/elasticsearch.yml
	sudo sed -i "/^$cluster:/ c$cluster: ${clustername}" /etc/elasticsearch/elasticsearch.yml

	sudo sed -i "/xpack.security.enabled: true/s/true/false/" /etc/elasticsearch/elasticsearch.yml

	sudo cat /etc/elasticsearch/elasticsearch.yml
else
	echo "Master IP and Network IP not present"
	sudo cat /etc/elasticsearch/elasticsearch.yml
fi
