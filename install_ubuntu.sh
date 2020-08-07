#!/bin/bash
# This is only to be used as a prep for a non Pure Test Drive Environment
# Brian Kuebler 4/17/20
# Bruce Modell 7/22/20
# Chris Crow 7/22/20

# Install necessary packages, only python2 installed

echo "#####################################"

#remove password requirement for sudo
echo '%sudo ALL=(ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers

#makesure all packages are updated
sudo apt-get update
sudo apt-get upgrade
#install PIP3
sudo apt install python3-pip --assume-yes

# Install necessary packages, only python2 installed

echo "#####################################"

# Install SDK

echo "####  Installing the Pure Storage SDK  ####"
pip3 install purestorage
pip3 install jmespath
pip3 install ansible
# Install the Pure Storage collection

# Ansible is being installed with PIP3, so we need to update the path for the users
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
export PATH=$PATH:$HOME/.local/bin
source ~/.bashrc -i

echo "#### Installing the Purestorage Ansible Collection  ####"

ansible-galaxy collection install purestorage.flasharray


#install Iscsi-tools
sudo apt install open-iscsi --assume-yes

#Install Multipath tools
sudo apt install multipath-tools --assume-yes

#install scsi tools
sudo apt install -y scsitools --assume-yes

# Save a second and create a mount point in /mnt - Actually, Ansible will create the mount point.
# mkdir /mnt/ansible-src

# Typing "ansible-playbook" everytime is a hassle...
echo "" >> ~/.bashrc
echo "alias ap='ansible-playbook'" >> ~/.bashrc
echo "alias P='cd ~/newstack_demo/ansible_playbooks'" >> ~/.bashrc


#generate an ssh key for local login:
echo "#### Generate SSH keys on local install ####"
ssh-keygen -t rsa -N '' -q -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#clone required repositories
echo "#### Clone kubespray repo and copy inventory in to repo ####"
git clone https://github.com/kubernetes-sigs/kubespray ~/kubespray
cp -rfv ~/newstack_demo/inventory/testdrive ~/kubespray/inventory/
cd ~/kubespray

# Install prereqs as we now have pip3
echo "#### Install kubespray prereqs ####"
pip3 install -r requirements.txt

# Install kubernetes
echo "#### Install kubernetes ####"
ansible-playbook -i inventory/testdrive/inventory.ini cluster.yml -b

# configure kubectl. needs to be updated as it only works

mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/config -rf
sudo chown $(id -u):$(id -g) ~/.kube/config
cat << 'EOF' >> ~/.bashrc
export KUBECONFIG=$HOME/.kube/config
source <(kubectl completion bash)
complete -F __start_kubectl k
alias kgp='kubectl get pods --all-namespaces'
alias kgv="kubectl get VolumeSnapShots"
EOF


#Install PSO
echo "#### Update helm repos and install PSO ####"
helm repo add pure https://purestorage.github.io/helm-charts
helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm repo update
helm install pure-storage-driver pure/pure-csi --namespace default -f ~/newstack_demo/kubernetes_yaml/pso_values.yaml


#Install PSO EXPLORER
# Add Helm repo for PSO Explorer
echo "#### Add, update helm repos and install PSO Explorer####"
helm repo add pso-explorer 'https://raw.githubusercontent.com/PureStorage-OpenConnect/pso-explorer/master/'
helm repo update
helm search repo pso-explorer -l

# Create namespace
kubectl create namespace psoexpl

# Install with default settings
helm install pso-explorer pso-explorer/pso-explorer --namespace psoexpl

#INSTALL PIP AT ROOT
sudo pip3 install purestorage

echo "#### For kubectl to work, you may need to run 'source ~/.bashrc' ####"

