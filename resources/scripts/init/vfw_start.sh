#!/bin/bash

#update root ca (wr lab only)
#apt-get update

# echo 'Updte CA Cert'
# mkdir -p /usr/local/share/ca-certificates/extra
# cp /opt/rootCA.crt /usr/local/share/ca-certificates/extra/
# update-ca-certificates
# apt install -y libnss3-tools
# cp /opt/ImportScript /root
# chmod a+x /root/ImportScript
# /root/ImportScript

apt-get update
apt-get install -y sudo curl net-tools iproute2 inetutils-ping vim
#curl -s https://packagecloud.io/install/repositories/fdio/release/script.deb.sh | sudo bash
#curl -k -s https://packagecloud.io/install/repositories/fdio/1901/script.deb.sh | sudo bash

apt-get install -y gnupg
curl -k -L https://packagecloud.io/fdio/1901/gpgkey | sudo apt-key add -

cat <<EOF > /etc/apt/sources.list.d/fdio_1901.list
deb https://packagecloud.io/fdio/1901/ubuntu/ bionic main
deb-src https://packagecloud.io/fdio/1901/ubuntu/ bionic main
EOF

apt-get update

#export VPP_VER=19.01.2-release
export VPP_VER=19.01.3-rc0~9-gbef25c30a~b79
apt-get install -y vpp=$VPP_VER vpp-lib=$VPP_VER
apt-get install -y vpp-plugins=$VPP_VER

if [ -e /run/vpp/cli-vpp2.sock ]; then
    rm /run/vpp/cli-vpp2.sock
fi

apt-get install -y python3

python3 /opt/vfwstarter.py

# # extract core list
# #	root@vpktgen:/# taskset -p --cpu-list 1
# #	pid 1's current affinity list: 1,2,29

# corelist=`taskset -p -c 1 |cut -d : -f 2 | sed 's/^ *//' | sed 's/ *$//'`
# # #extract master core
# # mastercoreidx=`echo $corelist | cut -d , -f 1`
# # #extract worker cores
# # workercorelist=`echo $corelist | sed -E 's/^[0-9]*,//'`
# # delimiter=,
# # delimiter2=-
# # s=$corelist$delimiter 
# # list1=();
# # while [[ $s ]]; do
# #     element1=( "${s%%"$delimiter"*}" );
# #     s=${s#*"$delimiter"};
# #     s2=$element1$delimiter2
# #     while [[ $s2 ]]; do
# #         list1+=( "${s2%%"$delimiter2"*}" );
# #         s2=${s2#*"$delimiter2"};
# #     done;
# # done;

# delimiter=,
# s=$corelist$delimiter 
# list1=();
# while [[ $s ]]; do
#     element1=( "${s%%"$delimiter"*}" );
#     s=${s#*"$delimiter"};
#     s2=`echo $element1 | sed -E 's/-/\.\./'`
#     echo $(echo "{"$s2"}")
#     for i in $(echo "{"$s2"}"); do
#         list1+=$i;
#     done;
# done;
# declare -p list1

# echo 'start... vpp'
# vpp unix {cli-listen /run/vpp/cli-vpp2.sock} api-segment { prefix vpp2 } \
#     cpu { main-core $mastercoreidx  corelist-workers $workercorelist }

# echo 'wait vpp be up ...'
# while [ ! -e /run/vpp/cli-vpp2.sock ]; do
#     sleep 1;
# done

# echo 'configure vpp ...'

# ifconfig veth12 0.0.0.0
# ifconfig veth12 down
# ifconfig veth21 0.0.0.0
# ifconfig veth21 down

# HWADDR1=$(ifconfig veth12 |grep ether | tr -s ' ' | cut -d' ' -f 3)
# HWADDR2=$(ifconfig veth21 |grep ether | tr -s ' ' | cut -d' ' -f 3)

# vppctl -s /run/vpp/cli-vpp2.sock show ver
# vppctl -s /run/vpp/cli-vpp2.sock show threads

# vppctl -s /run/vpp/cli-vpp2.sock create host-interface name veth12 hw-addr $HWADDR1

# vppctl -s /run/vpp/cli-vpp2.sock set int state host-veth12 up

# vppctl -s /run/vpp/cli-vpp2.sock set int ip address host-veth12 10.10.1.1/24

# vppctl -s /run/vpp/cli-vpp2.sock create host-interface name veth21 hw-addr $HWADDR2

# vppctl -s /run/vpp/cli-vpp2.sock set int state host-veth21 up

# vppctl -s /run/vpp/cli-vpp2.sock set int ip address host-veth21 10.10.2.1/24

# vppctl -s /run/vpp/cli-vpp2.sock show hardware
# vppctl -s /run/vpp/cli-vpp2.sock show int
# vppctl -s /run/vpp/cli-vpp2.sock show int addr

# vppctl -s /run/vpp/cli-vpp2.sock show ip fib

# #vppctl -s /run/vpp/cli-vpp2.sock trace add af-packet-input 10

# #vppctl -s /run/vpp/cli-vpp2.sock ping 10.10.1.2

# #vppctl -s /run/vpp/cli-vpp2.sock show trace
# #vppctl -s /run/vpp/cli-vpp2.sock show ip arp

echo "done"
sleep infinity
