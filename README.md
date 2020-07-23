# Newstack_demo Repository

This repo has scripts to spin up Newstack Demo in an Ubuntu 20.04 lab

It currently includes Anisible, Kubernetes, PSO and PSO explorer.

Many thanks are due to Brian Kuebler , Chris Crow for the original test drive idea, as well as all the ansible yaml files.

### Requirements
You will need a Ubuntu 20.04 install.  The prereqs for this eviornment are as follows
Server VM has to have at least 1 Nic connected to the Lan/Wan and 1 NIC connected to your iSCSI network
Access to at least 1 Pure FA running Purity 5.3 or higher (can be physical or VM)
update/upgrade the enviornment using apt get
make sure ssh is installed and running
install git


### Installing the demo
clone the repo with:
```
git clone https://pureschilab/newstack_demo
```

Run the install_ubuntu.sh script

Note that this will also install all of the ansible bits as well as the Pure PSO drivers and the new PSO explore bits

### Adding Flash Array to enviornment
open newstack_demo/kubernetes_yaml/pso_values.yaml with nano or vi
edit management end points and api with values from your Flasharay
control-x to save

### Demos

The demo PSO demo scripts are located in the kubernetes_yaml directory. They are designed to be run in order as there may be dependancies.

There is also a MySQL demo that is located in the kubernetes_yaml/mysql_demo folder
open the kubernetes_yaml/mysql_demo/example_commands.txt file for step by step in structions to follow for the mySQl demo

### PSO demo

#### Create the PVC. Check that it is created on the Pure
```
kubectl apply -f 1_createPVC.yaml
```

#### Creates Minio Deployment
```
kubectl apply -f 2_minio.yaml

kubectl apply -f 3_service.yaml
```

You can now log in to minio using the service port. Find the port with the kubectl get svc (should always be 9000) command. http://<linuxIP>:<port> Username/password: minio:minio123

Continuing with the rest of the commands, which will take a snap and clone a new PVC from that snapshot
You can then continue with spinning up a new minio instance (default will be port 9001)

**Don't forget that adding the snapshot spec adds the below object type**
```
kubectl get VolumeSnapshots
```

For a snap restore demo, you can scale to 0 replicas, restore the snap, and scale replicas to 1. The command to scale replicas is:
kubectl scale deploy minio-deployment --replicas=0


## Ansible Demo



### Running the Demo

This demo allows the driver to run playbooks in the ansible_playbooks directory. They are numbered to run through a progression.

You can run each playbook with 'ansible-playbook <yaml file>'
  
The Active cluster demo requires access to two arrays (PSO Yaml file will need the info on both arrays)  

More notes to come...



# Additional customizations
initial requirments

- SSH server Running
- GIT installed
- Update/upgrade
Script will add the following
- installed multipath-tools
- installed python3-pip
- installed open-iscsi
