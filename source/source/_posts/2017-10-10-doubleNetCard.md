---
layout: post
title: ubuntu双网卡（内网+外网）
description: 
date: 2017-10-10
categories: 
  - [Linux]
  - [软件安装和使用]
tags:
  - Linux
  - 软件安装和使用
  - 折腾笔记
---

## 缘起

实验室的台式机有公网ip，而平时主要使用笔记本，平时拷文件使用`scp`有些慢，并且也不想每次钻桌子底插usb，所以就想加快笔记本和台式机的网络速度。

## 分析

1. 连接公网的有线不支持dhcp，意味着没法直接买一个交换机来插上。同时我的笔记本也没有rj45接口，需要一个usb的网卡适配器，每次拔插usb也不爽，所以该方案放弃。
2. 有线连接路由器，然后路由器接台式机和笔记本，笔记本用无线。但该方案不知道怎么保留公网ip，不知道路由器外ip能不能设置成公网ip然后配置一个路由表项？
3. 实验室还有一个无线路由，平时我笔记本用这个来上网，所以有一个看起来可行的方法，即买一个无线网卡插在台式机上，然后外网访问用有线网卡，和笔记本之间的通信无线，由于两个无线网卡接在同一个AP上，少绕了几个圈子，应该快一点。看起来不错的样子，遂行动。
4. 还是使用台式机装一个有线网卡一个无线网卡的方式，不过使用无线网卡作为AP，开一个无线网，然后将台式机配置好路由，这个方法肯定是可行的，但ubuntu的网络配置我不会，而且买的小米随身wifi在ubuntu上也不原生支持AP模式，配置有点麻烦，遂放弃。后来发现方案3不行简单看了一下，但没有弄，参考[这个](http://www.cnblogs.com/fenggangwu/archive/2011/06/20/linux_gateway.html)。
5. 之后又有了一种新的方案，就是在台式机上再装一块有线网卡，然后买一个千兆的USB网卡，网线连接surface和台式机，这样他们交换数据就是千兆的了，已经基本上达到机械硬盘的上限了。同时，把台式机配置成路由器，笔记本把台式机作为网关，实现对外网的访问。最终采用了这种方案。

## ubuntu双网卡（内网+外网）的配置

配置还是比较简单的。可以直接参考[这篇文章](https://github.com/ttop5/ttop5.github.io/issues/11)，下面做一下备份，放置遗失。

### 环境

ubuntu 14.04 server
拥有两块网卡的服务器
外网IP:210.44.185.75 外网网关:210.44.185.10
内网IP:10.6.0.248 内网网关:10.6.0.254

### 需求

服务器能通过网卡1来连接外网的某台主机；
同时要求局域网内网段为 10.6.1.* , 10.6.4.* , 10.6.15.* 的三个网段要能通过网卡2连接服务器。

### 明确

一台双网卡电脑拥有两个网关是不可能的，因为默认网关（default gateway）只能是一个！

### 解决方案：

#### 1.配置网络

```bash
sudo vim /etc/network/interfaces
```

配置如下：

```bash
auto eth0
iface eth0 inet static
address 210.44.185.75
netmask 255.255.255.0
gateway 210.44.185.10
dns-nameservers 115.27.254.2 114.114.114.114

auto eth1
iface eth1 inet static
address 10.6.0.248
netmask 255.255.255.0
```
只设置外网IP的网关，不要设置内网IP的网关。

#### 2. 重启网络

```bash
sudo /etc/init.d/networking restart
```

#### 3.设置路由

这时我们的第一条需求已经实现了，但是由于没有设置内网网关，第二条需求还实现不了，我们需要分别给这三个网段设置路由。注意：一块网卡只能设置一个网关，多个网关会发生冲突而无法成功配置。
操作如下：

```bash 
sudo route add -net 10.6.0.0/24 gw 10.6.0.254 dev eth1
sudo route add -net 10.6.1.0/24 dev eth1
sudo route add -net 10.6.4.0/24 dev eth1
sudo route add -net 10.6.15.0/24 dev eth1
```
最后使用 `ip route`或者`route` 查看路由设置情况：

```bash
ttop5@ubuntu:~$ ip route
default via 210.44.185.10 dev eth0  metric 100
10.6.0.0/24 dev eth1  proto kernel  scope link  src 10.6.0.248
10.6.1.0/24 dev eth1  scope link
10.6.4.0/24 dev eth1  scope link
10.6.15.0/24 dev eth1  scope link
210.44.185.0/24 dev eth0  proto kernel  scope link  src 210.44.185.75
```

如有多余的配置，可使用下面的命令进行删除，祝你好运！😀

```bash
sudo route del -net *.*.*.*/* dev eth*
```
到此为止，我们就设置完毕了，内外网应该都可以访问了,不过由于路由是手动添加进去的，所以系统重启之后路由就丢失了．不过我可以将设置的命令保存为一个脚本，然后在 `/etc/rc.local`中调用执行或者直接添加到该文件中。

## 悲剧

原文中没有添加dns信息，`ping`的时候会出现无法解析的情况。添加dns，解决这个问题之后发现可以`ping`通外网，但台式机和笔记本直接互相无法`ping`通，笔记本也无法`ping`通台式机的公网ip，遂怀疑是不是无线网里面不让通信。使用手机实验，连接同一个AP时，和笔记本也无法互相`ping`通，也无法`ping`通台式机的局域网ip和公网ip。但使用流量可以`ping`通台式机的公网ip。
画一下图发现只要经过了无线网里面的通信都无法进行，使用笔记本`ping`公网ip时，由有线网卡收到，但根据上面配置的路由表项，全部转发给内网的无线网卡，遂挂。
所以确实是因为无线局域网里的设备无法通信，但还不知道为什么。求助HC之后，他说是不是配置了`AP隔离`，恍然大悟。

## 有线方案

### 双网卡配置

主要可以参考这篇[blog](http://www.cnblogs.com/feiling/archive/2012/06/22/2558931.html)。
主要分为三个步骤：
1. 配置双网卡一个内网一个外网，和上面的无线方案完全相同。
2. 打开IP转发。
修改`/etc/sysctl.conf`，取消这一行的注释： 
```net.ipv4.ip_forward= 1```
然后使之立即生效
```sudo sysctl -p```
3. 在iptables添加一条NAT规则，一般都是这样配置，然后将其加入的`rc.local`中，使之开机启动。
```bash
iptables -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.121.0/24  ! -d 192.168.121.0/24 -o eth1 -j SNAT MASQUERADE
```
不过我配置了，然后也加入到`rc.local`了，但还是不行。可能是`iptables`没有激活，然后我用`Webmin`进行了配置，然后就可以了。然后查看`iptables`的规则可以使用```iptables -n -vv -L```。详细的iptables的使用，可以参考这篇[iptables详解](http://blog.csdn.net/u012174021/article/details/45390239)

整个过程，这篇[blog](http://blog.csdn.net/u012174021/article/details/45369457)说的很详细，他的网络拓扑图也画得很好，直接盗用下。
![](/images/doublenetcard1.jpg) 

## 收获

对路由器和交换机的认识加深了一点。其他的还是ubuntu上的网络操作还是迷迷糊糊，有点不值得。

## 教训

1. 少折腾，能用就行
2. 如果按照网上说的配置了但有了问题，立马去查看文档，详细的系统的学习一下，不要再头疼医头脚疼医脚，随时记笔记，保持头脑清醒。