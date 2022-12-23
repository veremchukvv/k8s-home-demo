export KEY="${tls_private_key}"
echo -e "$KEY" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
apt-get -y update
apt-get -y install python3-pip
cd /root
git clone https://github.com/veremchukvv/k8s-home-demo.git
cd k8s-home-demo/kubespray
sudo pip install -r requirements.txt