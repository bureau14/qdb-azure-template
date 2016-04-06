# quasardb cluster deployment template

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fbureau14%2Fqdb-azure-template%2Fmaster%2FmainTemplate.json) 

This template deploys a quasardb cluster on Azure. 

It provision the following resources:

* a storage account
* a virtual network
* an availability set
* several nodes, each composed of:
 * a virtual machine running quasardb server on Ubuntu
 * a network interface
* a testbox, composed of:
 * a virtual machine with quasardb client tools on Ubuntu
 * a network interface
 * a public IP address

#### Warning about storage

There is no network storage attached to the node!
For performance reasons, the cluster's data is stored on the machine local drive.
This means that the data will be lost if you deprovision the all the VMs.
However, since data is replicated between the nodes (3 times by default), the data will not be lost if some nodes are removed.

# Parameters

The template supports the following parameters:

| Name               | Description                                              |
|:------------------ |:-------------------------------------------------------- |
| nodeCount          | Number of nodes (ie number of VM) in the cluster         |
| nodeSize           | Size of Virtual Machines (nodes and testbox)              |
| adminUsername      | Admin username used when provisioning virtual machines   |
| adminPassword      | Admin password used when provisioning virtual machines   |
| storageAccountName | Name of the storage account to be used for all resources |
| namePrefix         | The prefix for the names of all resources                |

## Topology

This template deploys a configurable number of cluster nodes of a configurable size. 
The cluster nodes are internal and only accessible on the virtual network. 
The assumption for the deployment is, the cluster is going to be provisioned as the back end of a service, and never be exposed to internet directly. 
The cluster is deployed to one single availability set to ensure the distribution of VMs accros different update domains (UD) and fault domains (FD).

The cluster can be accessed through a "testbox" accessible via SSH (port 22) on a public IP.
It contains the followings:

1. `qdb_httpd`, a web monitoring console, listening on public port 8080
2. `qdbsh`, the quasardb shell utility
3. `qdb-benchmark`, the quasardb performance testing tool
4. quasardb APIs for: C, PHP and Python
