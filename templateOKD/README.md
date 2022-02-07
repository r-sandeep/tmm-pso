## Template Spec:

This template create an Azure ResourceGroup within the subscription __ISGS_System__.
The ResourceGroup will contain a complete Origin cluster, with a group of Master VMs, a group of Infra Vms and a group of Node VMs.

Here a example of the cluster

>   * Resource group
>        * Application security group
>            * Master NSG
>              1. Master
>                 * Master Network Interface
>                 * Master VM
>                 * Master OS Disk
>                 * Master Data Disk (create by the vm Image)    
>            * Infra NSG
>              1. Infra
>                 * Infra Network Interface
>                 * Infra VM
>                 * Infra OS Disk
>                 * Infra Data Disk (create by the vm Image)    
>            * Node NSG
>              1. Node
>                 * Node Network Interface
>                 * Node VM
>                 * Node OS Disk
>                 * Node Data Disk (create by the vm Image)
>              2. Node
>                 * Node Network Interface
>                 * Node VM
>                 * Node OS Disk
>                 * Node Data Disk (create by the vm Image)
>        * Storage Account
>          * Blob Storage Container (name: `ocp-registry`) 


## Naming Conventions

* Cluster name : `ORIGINPOC<SEQUENTIAL NUMBER>`
* Resource Group name: `RSG<CLUSTER NAME>`
* Virtual Machine types:
  * `MASTER`
  * `INFRA`
  * `BASTION`
  * `NODE`
* Virtual Machine name: `VM<VM TYPE><VM SEQUENTIAL NUMBER><CLUSTER NAME>`
* Network Interface name: `NIC<VM NAME>`
* Application Security Group name: `ASG<CLUSTER NAME>`
* Network Security Group name: `NSG<VM TYPE><CLUSTER NAME>`
* OS Disk name: `<VM NAME>_OS_DISK`
* Availability Set name: `AST<VM TYPE><CLUSTER NAME>`
* Storage Account name: `sas<cluster name>`

### Bastion Machine IP: `10.244.253.111`

### Machine sizes:

* master: Standard_D4_v3
* node/infra : Standard_D2_v3