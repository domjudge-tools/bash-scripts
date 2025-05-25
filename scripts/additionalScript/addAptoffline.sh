# #!/usr/bin/bash

wget http://bcpc.birjand.ac.ir:80/apt-offline.deb

dpkg -i apt-offline.deb

sudo apt-offline get update.sig --bundle update.zip
