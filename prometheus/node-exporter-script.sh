#!/bin/bash
# run script in the same directory as the node exporter tar file

# Creates Node Exporter user
sudo groupadd -f node_exporter
sudo useradd -g node_exporter --no-create-home --shell /bin/false node_exporter
sudo mkdir /etc/node_exporter
sudo chown node_exporter:node_exporter /etc/node_exporter

# Unpacks Node Exporter Binary
# sudo tar -xvf node_exporter-1.8.2.linux-amd64.tar.gz
# mv node_exporter-1.8.2.linux-amd64.tar.gz node_exporter-files

# Installs Node Exporter service
sudo cp node_exporter-files/node_exporter /usr/bin/
sudo chown node_exporter:node_exporter /usr/bin/node_exporter

# Sets up Node Exporter to activate on startup
echo '[Unit]
Description=Node Exporter
Documentation=https://prometheus.io/docs/guides/node-exporter/
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
Restart=on-failure
ExecStart=/usr/bin/node_exporter \
  --web.listen-address=:9100

[Install]
WantedBy=multi-user.target
' > /usr/lib/systemd/system/node_exporter.service

sudo chmod 664 /usr/lib/systemd/system/node_exporter.service

# Starts service
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter.service

