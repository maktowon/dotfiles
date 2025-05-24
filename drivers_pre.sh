sudo dnf upgrade -y
sudo dnf install kmodtool akmods mokutil openssl -y
sudo kmodgenca -a
sudo mokutil --import /etc/pki/akmods/certs/public_key.der
sudo systemctl reboot
