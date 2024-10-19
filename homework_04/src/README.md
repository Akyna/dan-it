### Створіть користувача з іменем "bob".
```bash
akyna@akyna-server:~$ sudo useradd -m bob -s /bin/bash
[sudo] password for akyna:
akyna@akyna-server:~$
```
### Додайте створеного користувача до групи sudo (щоб він міг виконувати команди як адміністратор).
```bash
akyna@akyna-server:~$ sudo usermod -aG sudo bob
akyna@akyna-server:~$ groups bob
bob : bob sudo
akyna@akyna-server:~$ id bob
uid=1005(bob) gid=1005(bob) groups=1005(bob),27(sudo)
akyna@akyna-server:~$
```
### Створіть сценарій у каталозі /home/bob/, який під час виконання змінить ім'я хоста для "ubuntu22". Атрибути виконання сценарію повинні бути встановлені виключно для користувача "bob".
```bash
bob@akyna-server:~$ cat change_host_name.sh
#!/bin/bash

hostnamectl set-hostname amb-server

bob@akyna-server:~$ ls -l
total 4
-rwxrw-r-- 1 bob bob 50 Jun 21 14:05 change_host_name.sh
bob@akyna-server:~$
```
### Запустіть сценарій. Перезавантажте систему. Увійти в систему як "bob" користувача.
```bash
bob@akyna-server:~$ ./change_host_name.sh
==== AUTHENTICATING FOR org.freedesktop.hostname1.set-hostname ====
Authentication is required to set the local hostname.
Multiple identities can be used for authentication:
 1.  akyna
 2.  bob
Choose identity to authenticate as (1-2): 2
Password:
==== AUTHENTICATION COMPLETE ====
bob@akyna-server:~$ sudo su
root@amb-server:/home/bob# echo "127.0.1.1 amb-server" >> /etc/hosts
root@amb-server:/home/bob# exit
exit
bob@akyna-server:~$ cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 akyna-server

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
127.0.1.1 amb-server
```

```bash
andriiboiko@AMB-MacBook-Pro-16 ~ % ssh bob@192.168.183.129
...
Last login: Fri Jun 21 14:14:51 2024 from 192.168.183.1
bob@amb-server:~$

```
### Встановіть "nginx". Перевірте, чи працює nginx, а також використовуйте netstat, щоб побачити, які порти є ВІДЧИНЕНО.
```bash
bob@amb-server:~$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Fri 2024-06-21 14:30:38 UTC; 1min 41s ago
       Docs: man:nginx(8)
    Process: 4216 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 4218 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 4219 (nginx)
      Tasks: 3 (limit: 4550)
     Memory: 2.3M (peak: 2.6M)
        CPU: 7ms
     CGroup: /system.slice/nginx.service
             ├─4219 "nginx: master process /usr/sbin/nginx -g daemon on; master_process on;"
             ├─4220 "nginx: worker process"
             └─4221 "nginx: worker process"
bob@amb-server:~$
```
```bash
bob@amb-server:/etc/nginx/sites-enabled$ netstat
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 192.168.183.129:http    192.168.183.1:51589     ESTABLISHED
tcp        0      0 192.168.183.129:http    192.168.183.1:51588     ESTABLISHED
tcp6       0    232 amb-server:ssh          192.168.183.1:51225     ESTABLISHED
udp        0      0 192.168.183.129:42692   192.168.183.2:domain    ESTABLISHED
```
```bash
bob@amb-server:/etc/nginx/sites-enabled$ sudo netstat -ntlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      4219/nginx: master
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN      633/systemd-resolve
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      633/systemd-resolve
tcp6       0      0 :::80                   :::*                    LISTEN      4219/nginx: master
tcp6       0      0 :::22                   :::*                    LISTEN      1/init
bob@amb-server:/etc/nginx/sites-enabled$
```
```bash
bob@amb-server:/etc/nginx/sites-enabled$ sudo ufw status verbose
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing), disabled (routed)
New profiles: skip

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW IN    Anywhere
80/tcp                     ALLOW IN    Anywhere
22/tcp (v6)                ALLOW IN    Anywhere (v6)
80/tcp (v6)                ALLOW IN    Anywhere (v6)

bob@amb-server:/etc/nginx/sites-enabled$
```
```bash
bob@amb-server:/etc/nginx/sites-enabled$ curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
bob@amb-server:/etc/nginx/sites-enabled$
```
