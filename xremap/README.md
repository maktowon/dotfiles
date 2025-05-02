```
sudo gpasswd -a maktowon input
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' | sudo tee /etc/udev/rules.d/input.rules
echo 'uinput' | sudo tee /etc/modules-load.d/uinput.conf
```
