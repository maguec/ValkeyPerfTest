echo "# Lab specific ENV vars" >> /etc/bash.bashrc
echo "export GOOGLE_CLOUD_PROJECT=${projectid}"  >> /etc/bash.bashrc
echo "export GOOGLE_CLOUD_LOCATION=${region}" >> /etc/bash.bashrc
echo "export GOOGLE_VALKEY_IP=${memorystore_ip}" >> /etc/bash.bashrc
echo "export PATH=$${PATH}:/tmp/google-cloud-sdk/bin" >> /etc/bash.bashrc

# Run this after as it takes time
apt-get update
apt-get install -y make valkey-tools
