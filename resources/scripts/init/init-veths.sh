#!/bin/bash

apt-get update
apt-get install -y sudo curl net-tools iproute2

sudo ip link add name veth11 type veth peer name veth12
sudo ip link add name veth21 type veth peer name veth22

echo "done"
sleep infinity
