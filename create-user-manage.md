# Tạo user với quyền Root

```
root@OpenWrt:~# useradd -m khanhnt
```

```
root@OpenWrt:~# cd /home/khanhnt/
root@OpenWrt:/home/khanhnt# 
```

```
root@OpenWrt:~# passwd khanhnt
Changing password for khanhnt
New password: 
Bad password: too weak
Retype password: 
passwd: password for khanhnt changed by root
```
- File `/etc/passwd`
![](https://i.ibb.co/P1ryL4Q/Screenshot-from-2021-04-08-10-49-48.png)

- File `/etc/sudoers`
```
root ALL=(ALL) ALL
khanhnt ALL=(ALL) NOPASSWD: ALL
sapd ALL=(ALL) NOPASSWD: ALL
```

- Test login by Password
```
root@khanhnt:~# ssh khanhnt@192.168.1.1
khanhnt@192.168.1.1's password: 


BusyBox v1.28.3 () built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 18.06.1, r7258-5eb055306f
 -----------------------------------------------------
khanhnt@OpenWrt:~$ 
```

- Change user khanhnt
```
root@OpenWrt:~# su khanhnt


BusyBox v1.28.3 () built-in shell (ash)

khanhnt@OpenWrt:/root$ 
```

- Add public key

```
khanhnt@OpenWrt:~$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/khanhnt/.ssh/id_rsa): 
Created directory '/home/khanhnt/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/khanhnt/.ssh/id_rsa.
Your public key has been saved in /home/khanhnt/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:51f30E02WazrU52d2a9Khzq/qDl0tHJB3B29RXpfXcw khanhnt@OpenWrt
The key's randomart image is:
+---[RSA 2048]----+
|         . . ..B+|
|          o . ..E|
|         .    .+O|
|          o   .*=|
|        S..o  o.%|
|        oo+  o.**|
|       . +. +...o|
|        ...= .o .|
|        oooo+o.o |
+----[SHA256]-----+
```

- Trong file `.ssh/authorized_keys`
  + `sudo vim .ssh/authorized_keys`
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCs5dzQQZi3M68kxV+Gf3mPlFZ75AFjYqF/b9V/IYLIqg3GJbTHbjUGn5Qw/bsbgTr/NhE2VRX+Pg+                           HEoj4zBHC3vAXDQXQoWFW7Eyk5etwf4HnnAUyNd6dYi71KME6+rBZlAhyYYH/ZuGggl65L0xwQaG5ecDtChsO8RUsGgn90R16Ayshv7PKRZCp3b8r/                            OO6FdL1jie198aKWgS7xEXJ5668HAoxZNioOgQHRxNFH6iegv7zAg/C3URPN2MqqTySVzMZFljdO6252BlUvh6zHPU6n9Ni6W60fbTtprGDgI1F0+                             ADNx4MUEsnePVnTuYWtKQDYIU6jjFH8MHxkx9J
```
`(add public key máy của khanhnt)`

- SSH public Key
```
root@khanhnt:~# ssh khanhnt@192.168.1.1


BusyBox v1.28.3 () built-in shell (ash)

  _______                     ________        __
 |       |.-----.-----.-----.|  |  |  |.----.|  |_
 |   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
 |_______||   __|_____|__|__||________||__|  |____|
          |__| W I R E L E S S   F R E E D O M
 -----------------------------------------------------
 OpenWrt 18.06.1, r7258-5eb055306f
 -----------------------------------------------------
khanhnt@OpenWrt:~$ 
```

```
khanhnt@OpenWrt:~$ mwan3 status
Interface status:
 interface wan10 is unknown and tracking is active
 interface wan20 is unknown and tracking is active
 interface wan30 is unknown and tracking is active

Current ipv4 policies:
Fatal: can't open lock file /var/run/xtables.lock: Permission denied

Current ipv6 policies:
Fatal: can't open lock file /var/run/xtables.lock: Permission denied

Directly connected ipv4 networks:

Directly connected ipv6 networks:

Active ipv4 user rules:

Active ipv6 user rules:

khanhnt@OpenWrt:~$ sudo mwan3 status
Interface status:
 interface wan10 is online and tracking is active
 interface wan20 is online and tracking is active
 interface wan30 is online and tracking is active

Current ipv4 policies:
balanced:
 wan30 (50%)
 wan10 (50%)

quang_trang:
 wan20 (100%)


Current ipv6 policies:
balanced:
 default

quang_trang:
 default


Directly connected ipv4 networks:
 10.0.20.0/24
 127.0.0.0
 203.0.1.0
 10.0.20.255
 192.168.1.255
 203.0.0.255
 203.0.0.1
 192.168.1.0/24
 203.0.2.255
 203.0.2.0
 10.0.10.255
 203.0.1.1
 203.0.0.0
 127.0.0.1
 203.0.1.255
 192.168.1.1
 10.0.10.1
 203.0.2.0/24
 127.255.255.255
 192.168.10.255
 10.0.10.0/24
 192.168.10.0
 192.168.10.1
 10.0.10.0
 127.0.0.0/8
 203.0.1.0/24
 192.168.10.0/24
 203.0.2.1
 10.0.20.1
 10.0.20.0
 192.168.1.0
 203.0.0.0/24
 224.0.0.0/3

Directly connected ipv6 networks:
 fe80::/64
 fdab:2811:c102::/64

Active ipv4 user rules:
    0     0 S https  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            multiport sports 0:65535 multiport dports 443 
   33  2492 - balanced  all  --  *      *       0.0.0.0/0            0.0.0.0/0            
    0     0 - quang_trang  all  --  *      *       10.0.10.4            0.0.0.0/0            

Active ipv6 user rules:
    0     0 S https  tcp      *      *       ::/0                 ::/0                 multiport sports 0:65535 multiport dports 443 
```