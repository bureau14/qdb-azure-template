# Install a QuasarDB cluster on Ubuntu Virtual Machines using Custom Script Linux Extension

This template deploys a QuasarDB cluster on Ubuntu virtual machines. 

This template provisions the QuasarDB cluster as follows:

* an Ubuntu virtual machine for each node (3 to 5, depending on the selected size)
* a storage account (5 for the "Large" size)
* a virtual network
* an availability set
* a network interface for each node.

Optionally, it can also provision a "jumpbox", with the following resources: 

* an Ubuntu virtual machine
* a public IP addresses
* a dedicated storage account

The template supports the following parameters:

| Name   | Description    |
|:--- |:---|
| adminUsername  | Admin user name for the Virtual Machines  |
| adminPassword  | Admin password for the Virtual Machines  |
| storageAccountPrefix  | Unique DNS Name for the Storage Account where the Virtual Machine's disks will be placed (multiple storage accounts are created with this template using this value as a prefix for the storage account name) |
| region | Region name where the corresponding Azure artifacts will be created |
| virtualNetworkName | Name of the Virtual Network that is created and that resources will be deployed in to |
| clusterName | The name of the new cluster that is provisioned with the deployment |
| tshirtSize | Higher level definition of a cluster size. It can take Small, Medium and Large values. This value causes cluster sizes with following characteristics. Small: 3xStandard_A2, Medium: 4xStandard_A6, Large: 5xStandard_D14  |
| vmNamePrefix | The prefix for the names of the VMs that will be provisioned |
| jumpbox | Deploys an additional Ubuntu VM to access the cluster from the Internet |

## Topology

This template deploys a configurable number of cluster nodes of a configurable size. 
The cluster nodes are internal and only accessible on the virtual network. 
The assumption for the deployment is, the cluster is going to be provisioned as the back end of a service, and never be exposed to internet directly. 

The cluster can be accessed through an Ubuntu VM ("jumpbox") accessible via SSH (port 22) on a public IP, for test purposes only.
The jumbox has a web monitoring console on port 8080.

The cluster is deployed to one single availability set to ensure the distribution of VMs accros different update domains (UD) and fault domains (FD).

## Known Issues and Limitations

