#!/bin/bash
# ==============================================================================
# Install NodeJS V20
# ==============================================================================

# Step 1 : Membuat Key Repository NodeJS V20
echo -e "Membuat Repository NodeJS V20"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Step 2 : Create Nodesource Repository NodeJS (NODE_MAJOR sesuaikan dengan versi linux)
echo -e "Create Nodesource Repository NodeJS (NODE_MAJOR sesuaikan dengan versi linux)"
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

# Step 3 : Mulai Proses install NodeJS
echo -e "Mulai Proses install NodeJS"
sudo apt update
sudo apt install nodejs
