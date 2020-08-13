# Newstack_demo Repository

This repo has scripts to spin up Newstack Demo in an Ubuntu 20.04 lab

It currently includes Anisible, Kubernetes, PSO and PSO explorer.

Many thanks are due to Brian Kuebler , Chris Crow for the original test drive idea, as well as all the ansible yaml files.

### Requirements
You will need a Ubuntu 20.04 install.  

The prereqs for this eviornment are as follows

Server VM has to have at least 1 Nic connected to the Lan/Wan and 1 NIC connected to your iSCSI network

Access to at least 1 Pure FA running Purity 5.3 or higher (can be physical or VM) a 2nd Pure FA Running 5.3 or higher is required for the anisible playbook demo

Update/upgrade the enviornment using apt get
```
 sudo apt-get update
 sudo apt-get upgrade
 ```
Make sure ssh is installed and running

```
sudo service ssh status
```

If yes, skip to install git

if no

```
sudo apt-get install openssh-server
```

Enable the ssh service by typing 

```
sudo systemctl enable ssh
```

Start the ssh service by typing
```
sudo systemctl start ssh
```

Install git

```
sudo apt install git
```
(best practice is to take a snapshot of your VM at this time, this will allow for quick restarts if something goes wrong or if you want a golden image to run demo from each time)


Note that this will also install all of the Ansible bits as well as the Pure PSO drivers and the new PSO explore bits

This will take between 5-10 minutes depending on environment. Great time for you to explain whats going on during the install. Feel free to ``` cat install_ubuntu.sh```  to walk through whats being done in the background

### Post install
 ```
 source ~/.bashrc
 kubectl get pods
 kubectl get nodes
 kubectl get svc
 edit kubernetes_yaml/pso_values.yaml and ansible_playbooks/roles/var/main yaml and ansible_playbooks/testdrive_vbars.yaml with IP addresses and API's from your Flasharrays that will be used for this demo using NANO or VI

```
### Demos

The demo PSO demo scripts are located in the kubernetes_yaml directory. They are designed to be run in order as there may be dependancies.

The demo ansible script are located in ansible_playbooks (requires access to 2 x FA's)

There is also a MySQL demo that is located in the kubernetes_yaml/mysql_demo folder

Open the kubernetes_yaml/mysql_demo/example_commands.txt file for step by step instructions to follow for the mySQl demo

### PSO & EXPLORER Demos
Step by Step Instructions 
```
kubectl get svc --namespace psoexpl -w pso-explorer
```

Jot down 5 digit port number (80:xxxxx)

open browser window with VM IP:Port number from above

PSO EXPLORER  will open
Ctrl -c to exit get svc request above

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

after you take snap, go into Minio browser window and delete some file s you have uploaded

For a snap restore demo, you can scale to 0 replicas, restore the snap (step 6), and scale replicas to 1. The command to scale replicas is:

kubectl scale deploy minio-deployment --replicas=0
after steps 6 , 7 and 8 are run

You can then continue with spinning up a new minio instance (default will be port 9001)

kubectl scale deploy minio-deployment --replicas=1


## Ansible Demo

The Full Ansible Demo requires access to 2 x FlashArrays


### Running the Demo

This demo allows the driver to run playbooks in the ansible_playbooks directory. They are numbered to run through a progression.

You can run each playbook with 'ap -b <yaml file>'

The Active cluster demo requires access to two arrays (PSO Yaml file will need the info on both arrays as does Ansible_playbooks/roles/var/main yaml and ansible_playbooks/testdrive_vbars.yaml)  

More notes to come..


# Additional customizations
initial requirements

- SSH server Running
- GIT installed
- Update/upgrade
Script will add the following
- installed multipath-tools
- installed python3-pip
- installed open-iscsi
