#!/bin/bash
source nfv-mainrc

#For SRIOV
#Configure flavour
openstack flavor create m1.tiny --ram 1024 --disk 10 --vcpus 1 
openstack flavor create m1.small --ram 2048 --disk 20 --vcpus 1 
openstack flavor create m1.medium --ram 4096 --disk 160 --vcpus 2 
openstack flavor create m1.large --ram 8192 --disk 160 --vcpus 4 
openstack flavor create m1.xmlarge --ram 16384 --disk 160 --vcpus 4 
openstack flavor create m1.xlarge --ram 16384 --disk 160 --vcpus 8
openstack flavor create m1.LTM-1SLOT --ram 4096 --disk 40 --vcpus 2
openstack flavor create m1.1SLOT --ram 4096 --disk 100 --vcpus 2
openstack flavor create m1.F5-ALL --ram 8192 --disk 160 --vcpus 4
openstack flavor create m1.pinnedxlarge --ram 16384 --disk 160 --vcpus 8 --property hw:cpu_policy=dedicated --property hw:mem_page_size=1GB
openstack flavor create m1.pinnedxmassive --ram 32768 --disk 160 --vcpus 16 --property hw:cpu_policy=dedicated --property hw:mem_page_size=1GB
openstack flavor create m1.pinnedxmorecpu --ram 24576 --disk 160 --vcpus 16 --property hw:cpu_policy=dedicated --property hw:mem_page_size=1GB
openstack flavor create m1.pinnedxnomempage --ram 32768 --disk 160 --vcpus 16 --property hw:cpu_policy=dedicated
openstack flavor create m1.xmassive --ram 32768 --disk 160 --vcpus 16


#Create images
openstack image create bigip-13.1.1 --disk-format qcow2 --file ./images/BIGIP-13.1.1-0.0.4.qcow2 --public 
openstack image create rhel7.5 --disk-format qcow2 --file ./images/rhel-server-7.5-update-1-x86_64-kvm.qcow2 --public
openstack image create centos --disk-format qcow2 --file ./images/CentOS-7-x86_64-GenericCloud.qcow2 --public
openstack image create bigip-15.0.1 --disk-format qcow2 --file ./images/BIGIP-15.0.1-0.0.11.qcow2 --public
openstack image create bigip-14.1.2 --disk-format qcow2 --file ./images/BIGIP-14.1.2.1-0.0.4.qcow2 --public
#openstack image create vnfm --disk-format qcow2 --file ./images/F5-VNF-Manager_1.0.0.qcow2 --public 
#openstack image create vnfm1.0.0.1 --disk-format qcow2 --file ./images/F5-VNF-Manager_1.0.0.1.qcow2 -- public
#openstack image create bigip-13.1.1-1slot --disk-format qcow2 --file ./images/BIGIP-13.1.3-0.0.6.ALL_1SLOT.qcow2 --public
#openstack image create bigip-13.1.1-1slot-ltm --disk-format qcow2 --file ./images/BIGIP-13.1.3-0.0.6.LTM.qcow2 --public
#openstack image create vnfm1.0.1.0 --disk-format qcow2 --file ./images/F5-VNF-Manager_v1.0.1.0.qcow2 --public
#openstack image create vnfm1.2.1.0 --disk-format qcow2 --file ./images/F5-VNF-Manager_v1.2.1.0.qcow2 --public
#openstack image create bigiq6.0.1 --disk-format qcow2 --file ./images/BIG-IQ-6.0.1.0.0.813.qcow2 --public 

#Configure a number of internal vxlan interfaces for use
openstack network create internal1 --provider-network-type vxlan
openstack network create internal2 --provider-network-type vxlan
openstack network create internal3 --provider-network-type vxlan

#Configure external lans
#openstack network create external3206p1p1 --external --provider-network-type vlan --provider-physical-network sriov1 --share --provider-segment 3206
#openstack network create external3206p1p2 --external --provider-network-type vlan --provider-physical-network sriov2 --share --provider-segment 3206
#openstack network create external3205p1p1 --external --provider-network-type vlan --provider-physical-network sriov1 --share --provider-segment 3205
#openstack network create external3205p1p2 --external --provider-network-type vlan --provider-physical-network sriov2 --share --provider-segment 3205
openstack network create external3208p1p1 --external --provider-network-type vlan --provider-physical-network sriov1 --share --provider-segment 3208
openstack network create external3208p1p2 --external --provider-network-type vlan --provider-physical-network sriov2 --share --provider-segment 3208
#openstack network create external3208 --external --provider-network-type vlan --provider-physical-network dplane --share --provider-segment 3208
openstack network create externaldefault --default --external --provider-network-type vlan --provider-physical-network dplane --provider-segment 130
openstack network create internalapi --external --provider-network-type vlan --provider-physical-network dplane --share --provider-segment 3198

#Configure subnets
openstack subnet create internal1 --network internal1 --gateway 10.103.10.254 --subnet-range 10.103.10.0/24 --dhcp --dns-nameserver 172.30.104.10 --allocation-pool start=10.103.10.20,end=10.103.10.49
openstack subnet create internal2 --network internal2 --gateway 10.103.12.254 --subnet-range 10.103.12.0/24 --dhcp --dns-nameserver 172.30.104.10 --allocation-pool start=10.103.12.20,end=10.103.12.49
openstack subnet create internal3 --network internal3 --gateway 10.103.14.254 --subnet-range 10.103.14.0/24 --dhcp --dns-nameserver 172.30.104.10 --allocation-pool start=10.103.14.20,end=10.103.14.49
#openstack subnet create external3206p1p1 --network external3206p1p1 --gateway 10.130.206.18 --subnet-range 10.130.206.0/24 --no-dhcp --allocation-pool start=10.130.206.35,end=10.130.206.45
#openstack subnet create external3206p1p2 --network external3206p1p2 --gateway 10.130.206.18 --subnet-range 10.130.206.0/24 --no-dhcp --allocation-pool start=10.130.206.35,end=10.130.206.45
#openstack subnet create external3205p1p1 --network external3205p1p1 --gateway 10.130.205.18 --subnet-range 10.130.205.0/24 --no-dhcp --allocation-pool start=10.130.205.35,end=10.130.205.45
#openstack subnet create external3205p1p2 --network external3205p1p2 --gateway 10.130.205.18 --subnet-range 10.130.205.0/24 --no-dhcp --allocation-pool start=10.130.205.35,end=10.130.205.45
openstack subnet create external3208p1p1 --network external3208p1p1 --gateway 10.130.208.18 --subnet-range 10.130.208.0/24 --no-dhcp --allocation-pool start=10.130.208.35,end=10.130.208.45
openstack subnet create external3208p1p2 --network external3208p1p2 --gateway 10.130.208.18 --subnet-range 10.130.208.0/24 --no-dhcp --allocation-pool start=10.130.208.35,end=10.130.208.45
openstack subnet create externalmgt --network externaldefault --gateway 172.30.110.10 --subnet-range 172.30.110.0/26 --dhcp --dns-nameserver 172.30.104.10 --allocation-pool start=172.30.110.30,end=172.30.110.60
#openstack subnet create public --network externaldefault --dhcp --allocation-pool start=10.130.199.51,end=10.130.199.100 --gateway 10.130.199.254 --subnet-range 10.130.199.0/24 

#openstack port create --network external3205p1p1 --vnic-type direct sriov3205p1
#openstack port create --network external3206p1p1 --vnic-type direct sriov3206p1
#openstack port create --network external3205p1p2 --vnic-type direct sriov3205p2
#openstack port create --network external3206p1p2 --vnic-type direct sriov3206p2
openstack port create --network external3208p1p1 --vnic-type direct sriov3208p1
openstack port create --network external3208p1p2 --vnic-type direct sriov3208p2

#Create a security group - who needs security when you have big-ip
openstack security group create allow-all
openstack security group rule create --remote-ip 0.0.0.0/0 --dst-port 1:65535 --protocol tcp allow-all
openstack security group rule create --remote-ip 0.0.0.0/0 --dst-port 1:65535 --protocol udp allow-all 
openstack security group rule create --protocol icmp allow-all
#Create key
#ssh-keygen -q -N "" -f /home/stack/.ssh/openstack_rsa
openstack keypair create --public-key /home/stack/.ssh/openstack_rsa.pub oskey

#Do not need to configure aggregate groups since there is only one compute node and its running SRIOV. Otherwise you would need to group SRIOV capable compute nodes

#openstack server create --flavor m1.pinnedxlarge --image bigip-15.0.1 --nic net-id=externaldefault --port sriov3205p1 --port sriov3206p1 --security-group allow-all --key-name oskey bigip1

#openstack server create --flavor m1.pinnedxlarge --image bigip-15.0.1 --nic net-id=externaldefault --port sriov3205p1 --port sriov3205p2 --port sriov3206p2 --port sriov3206p1 --port sriov3208p1 --port sriov3208p2 --security-group allow-all --key-name oskey bigip1

openstack server create --flavor m1.pinnedxlarge --image bigip-14.1.2 --nic net-id=externaldefault --port sriov3208p1 --port sriov3208p2 --security-group allow-all --key-name oskey bigip1

#openstack server create --flavor m1.pinnedxmassive --image bigip-15.0.1 --nic net-id=externaldefault --port sriov3208p1 --port sriov3208p2 --security-group allow-all --key-name oskey bigip1

#openstack server create --flavor m1.pinnedxlarge --image bigip-15.0.1 --nic net-id=externaldefault --port sriov3205p2 --port sriov3206p2 --security-group allow-all --key-name oskey bigip2
#openstack server create --flavor m1.pinnedxlarge --image bigip-15.0.1 --nic net-id=externaldefault --nic net-id=external3205 --nic net-id=external3206 --security-group allow-all --key-name oskey bigip2

#openstack server create --flavor m1.pinnedxmorecpu --image bigip-15.0.1 --nic net-id=externaldefault --port sriov3205p1 --port sriov3205p2 --port sriov3206p2 --port sriov3206p1 --security-group allow-all --key-name oskey bigip2



#BIGIP
#create net trunk Trunk3208 interfaces add { 1.1 1.2}
#create net vlan vlan3208 interfaces add { Trunk3208 { untagged }} cmp-hash ipport
#create net self v3208-self address 10.130.208.35/24 vlan vlan3208 allow-service all
#create ltm pool HTTP_Pool monitor http members add {10.130.208.60:80}
#create ltm virtual HTTP_VIP destination 10.130.208.160:80 profiles add { http} vlans-enabled vlans add { vlan3208 } pool HTTP_Pool

