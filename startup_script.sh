echo "# Lab specific ENV vars" >> /etc/bash.bashrc
echo "export GOOGLE_CLOUD_PROJECT=${projectid}"  >> /etc/bash.bashrc
echo "export GOOGLE_CLOUD_LOCATION=${region}" >> /etc/bash.bashrc
echo "export GOOGLE_VALKEY_IP=${memorystore_ip}" >> /etc/bash.bashrc
echo "export GOOGLE_REDIS_IP=${redis_ip}" >> /etc/bash.bashrc
echo "export PATH=$${PATH}:/tmp/google-cloud-sdk/bin" >> /etc/bash.bashrc

echo "# Increase open files for running memtier_benchmark" >> /etc/security/limits.conf
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "* hard nofile 65535" >> /etc/security/limits.conf

# Run this after as it takes time
apt-get update
apt-get install -y make valkey-tools libevent-openssl-2.1-7t64 libevent-2.1-7t64 btop

# install memtier_benchmark
cd /tmp
wget https://github.com/redis/memtier_benchmark/releases/download/2.2.1/memtier-benchmark_2.2.1.noble_amd64.deb
dpkg -i memtier-benchmark_2.2.1.noble_amd64.deb
