keepalived install tool
==

Useage:
--

**master** 
```
upload keepalived_stuff.tar.gz to /

tar zxvf keepalived_stuff.tar.gz
cd /keepalived_stuff
chmod +x ./setup.sh && ./setup.sh

./install_keepalived.sh -lp [local_real_ip] -rp [remote_real_ip] -vp [virtaul_ip] --master
```


**backup**
```
upload keepalived_stuff.tar.gz to /

tar zxvf keepalived_stuff.tar.gz
cd /keepalived_stuff
chmod +x ./setup.sh && ./setup.sh

./install_keepalived.sh -lp [local_real_ip] -rp [remote_real_ip] -vp [virtaul_ip] --backup

```
