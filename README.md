# Needtobebanned 需要封禁的IP列表+自动封禁脚本


这个库用来实时记录对我公有云主机不友好的IP地址


This repositories is used to real-time record IP addresses that are not friendly to my public cloud servers.


如果你有IP封禁的需求，这个IP列表可以作为参考。


If you have IP blocking requirements, this IP list can be used as a reference.


此项目所有代码由ChatGPT 3.5生成。本人不懂代码也不懂英语，没有维护此项目的能力。


All code is generated by ChatGPT 3.5.I don't understand code and I don't understand English, so I don't have the ability to maintain this project.

原理：监测到有IP连我VPS未开放的端口 -> 封禁IP -> 每5分钟提交到Github

Principle: Detecting an IP attempting to connect to a closed port on my VPS -> Block the IP -> Submit to Github every 5 minutes.

程序不会判断请求内容是否是恶意的，但是如果你向我的VPS未开放端口发送SYN数据包超过3次，就会被程序记录。

The program does not determine whether the request content is malicious, but if you send SYN packets to the closed ports of my VPS, the system will record it.

[点击下载IP黑名单Click to download IP blacklist.](https://narizgnaw.github.io/needtobebanned/iplist.txt)

# 一键使用脚本 One-Click Command

功能：使用crontab定期下载IP黑名单，并使用IPSET封禁，请确认你的主机已接入互联网

Function: Use crontab to periodically download IP blacklist and use IPSET for banning. Please make sure your host is connected to the Internet.

```shell
bash <(wget -qO- -o- https://narizgnaw.github.io/needtobebanned/install.sh)
```

脚本测试过的环境：腾讯云-CentOS7