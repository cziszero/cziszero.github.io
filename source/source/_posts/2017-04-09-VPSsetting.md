---
layout: post
title:  VPS初始化设置
description: 
date: 2017-04-09
categories: 
  - [Linux]
  - [软件安装和使用]
  - [初始设置]
tags:
  - Linux
  - 软件安装和使用
---

# 安装常用软件

```bash
# 更换apt-get源为清华大学的源
wget https://tuna.moe/oh-my-tuna/oh-my-tuna.py
sudo python oh-my-tuna.py -y -g

# 安装必备软件
sudo apt-get update
for i in 'openssh-server' 'git' 'vim' 'tree' 'htop' 'iotop' 'slurm'
do
sudo apt-get install -y $i
done

# 安装常用软件
for i in 'gparted' 'sox'
do
sudo apt-get install -y $i
done

# 配置ipv6
wget https://raw.githubusercontent.com/lennylxx/ipv6-hosts/master/hosts
sudo cat hosts >> /etc/hosts
wget https://raw.githubusercontent.com/cziszero/cziszero.github.io/master/uploads/netinterface_en
sudo openssl aes-128-cbc -d -in netinterface_en  >> /etc/network/interfaces
sudo /etc/init.d/networking restart

# 安装chrome
wget -q -O - https://raw.githubusercontent.com/longhr/ubuntu1604hub/master/linux_signing_key.pub | sudo apt-key add
sudo sh -c 'echo "deb [ arch=amd64 ] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable
#sudo apt-get install google-chrome-beta #安装Google Chrome unstable 版本
#sudo apt-get install google-chrome-unstable # 安装Google Chrome beta 版本

# 安装x11vnc 运行完5秒内会重启，放在最后
wget https://raw.githubusercontent.com/cziszero/cziszero.github.io/master/uploads/ubuntu1604VNC.sh
chmod +x ubuntu1604VNC.sh
sudo ./ubuntu1604VNC.sh

# 剩余未完成，以后有时间再写
```

## 安装JDK
参考[blog](http://blog.csdn.net/gatieme/article/details/52723931)
主要方法：下载甲骨文的JDK，解压，添加到PATH中即可。

## 使用samba，让ubuntu与windows实现文件共享
未完成，按照教程配置之后windows无法访问，说无法访问到445端口，可能是被防火墙干掉了。
[参考连接1](http://www.nenew.net/samba-ubuntu-share.html)
[鸟哥的系统介绍](http://cn.linux.vbird.org/linux_server/0370samba/0370samba-centos4.php)

## 安装chrome浏览器
这篇[博客](http://blog.csdn.net/longhr/article/details/51695123)写的很好了

## 配置ipv6
这篇[blog](http://blog.yuantops.com/tech/config-ipv6-to-bypass-gfw-in-bupt/)已经写的非常好了，精简如下：
1. 先去[ipv6-test](http://ipv6-test.com/)看是否支持ipv6
2. 更新hosts文件为[这个](https://raw.githubusercontent.com/lennylxx/ipv6-hosts/master/hosts)。windows上hosts的文件路径为`%SystemRoot%\system32\drivers\etc\hosts`，linux下为`/etc/hosts`。
3. 使用IPv6 DNS服务器  
  GoogleDNS服务器的IPv6地址是:
  * 2001:4860:4860::8888
  * 2001:4860:4860::8844
  windows上很容易配置，打开网络适配器找到ipv6的协议然后写上就可以了。
  ubuntu上，改`/etc/resolv.conf`文件重启服务会失效。[这篇博客](http://pythonman.blog.51cto.com/2842803/1194049)有改`/etc/network/interfaces`和改`/etc/resolvconf/rosolv.conf.d/base`两个文件两种方法，不过我试了一下，只有第一种方法可行。并且无法通过`sudo /etc/init.d/networking restart`重启服务，不过可以重启生效。

### VNC

* x11vnc 远程控制，client和server使用同一个桌面，安装可以依照这个[博客](http://blog.csdn.net/longhr/article/details/51657610),博主还提供了一个自动安装的[脚本](https://github.com/longhr/ubuntu1604hub/raw/master/ubuntu1604VNC.sh)，非常好用。
* vncserver 新建一个桌面给client用

### shell的使用
* Ctrl＋Shift＋C＝复制，Ctrl＋Shift＋V＝粘贴

### MATLAB

文件目录位于`/usr/local/MATLAB/R2017a/bin`，可以将其添加到`PATH`中，每次开机可以直接从终端打开，方式是在`~\.bashrc`文件最后加一句`export PATH=/usr/local/MATLAB/R2017a/bin:$PATH`，然后运行`source ~\.bashrc`使其生效。

### 查看SATA控制器的类别
```bash
    dmesg | grep SATA
```
[更多](https://superuser.com/questions/417857/how-to-find-sata-controller-version-on-ubuntu-laptop-do-i-have-sata-1-2-or-3)

### 添加Swap分区
首先输入`lsblk`查看连接的存储设备，然后假设为`/dev/xvdf`,则执行下面的操作。
```bash
    sudo mkswap -f /dev/xvdf
    sudo swapon /dev/xvdf
    free -h #查看当前内存和swap情况
```
设置成开机生效`sudo vi /etc/fstab`,添加一行`/dev/xvdf swap swap defaults 0 0`
　
### 挂载一个磁盘
首先输入`lsblk`查看连接的存储设备，然后假设为`/dev/xvdf`,则执行下面的操作。
然后使用`sudo file -s /dev/xvdf`查看`/dev/xvdf`这个设备的情况。如果没有格式化就执行格式化操作。
```bash
    sudo mkfs -t ext4 /dev/xvdf #格式化
    sudo mkdir ~/data #创建挂载点
    sudo mount /dev/xvdf ~/data #挂载
```
设置成开机生效`sudo vi /etc/fstab`，添加一行 `/dev/xvdf ~/data ext4 defaults,nofail 0 2`
,然后运行`mount -a`检查是否有误。如果没有输出则正确。

### 更改目录或文件所有者 
    sudo chown system_username /location_of_files_or_folders

### 更改目录或文件权限
`chmod abc file`  
其中a,b,c各为一个数字，分别表示User、Group、及Other的权限。  
或者
`chmod o+w file` 
用户身份主要有如下几类  
u：拥有文件的用户（所有者）； 
g：所有者所在的组群； 
o：其他人（不是所有者或所有者的组群）； 
a：每个人或全部（u、g、和o）。 
用户所具有的文件访问权限类型如下： 
r：读取权； 
w：写入权； 
x：执行权。 
文件权限配置行为有如下几类： 
+：添加权限； 
-：删除权限； 
=：使它成为惟一权限。 

### 安装grive进行数据同步
    sudo add-apt-repository ppa:nilarimogard/webupd8
    sudo apt-get update
    sudo apt-get install grive
注意，grive进行的是同步，而不能指定文件进行上传，要想达到这样的目的，需要新建一个文件夹，
把要上传的东西放进去然后使用`-u`命令，只上传不下载。如果固定使用一个文件夹作为中转的话，
需要在每次上传前删除`.grive_state`文件，否则会同步本地文件夹的删除操作。

## matplotlib

### matplotlib报QXcbConnection: Could not connect to display错误
    import matplotlib
    matplotlib.use('Agg')

使用use命令即可，必须放在调用pyplot前面，最好放在最前面，因为貌似numpy或者其他的什么包会设置。如果放在下面就会报`UserWarning: This call to matplotlib.use() has no effect because the backend has already been chosen.`
除此之外，设置环境变量`export QT_QPA_PLATFORM=offscreen`好像能不完美的解决这个问题，依旧报warning，
但可以生成图像。

## Tensorflow

### 安装NVIDIA Cuda Toolkit 和 cuDNN(未实践)
1. [Check NVIDIA Compute Capability of your GPU card](https://developer.nvidia.com/cuda-gpus)
2. [Download and install Cuda Toolkit](https://developer.nvidia.com/cuda-downloads)  
  Install version 7.5 if using our binary releases.
3. Install the toolkit into e.g. `/usr/local/cuda`  
  [Download and install cuDNN](https://developer.nvidia.com/cudnn)  
  Download cuDNN v5.
  Uncompress and copy the cuDNN files into the toolkit directory. Assuming the toolkit is installed in `/usr/local/cuda`, run the following commands (edited to reflect the cuDNN version you downloaded):
    tar xvzf cudnn-7.5-linux-x64-v5.1-ga.tgz
    sudo cp cuda/include/cudnn.h /usr/local/cuda/include
    sudo cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
    sudo chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*
[参考](https://www.tensorflow.org/versions/r0.10/get_started/os_setup#optional_linux_enable_gpu_support)

## python

### 在virtualenv中使用ipython
将`alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"`添加到`~\.bashrc`（ubuntu）中。
详情见[链接](http://www.rrifx.com/post/use-ipython-in-virtualenv/)

### python列出所有安装的模块

`pip list` 或者 `pip freeze`

### python列出已导入的模块
    import sys
    sys.modules

### 更新使用anaconda 安装的tensorflow时出现Cannot remove entries...的问题

更新tensorflow时出现`Cannot remove entries from nonexistent file c:\program files\anaconda3\lib\site-packages\easy-install.pth`错误。

原因：  
相应的清单文件叫做setuptools.pth，而非easy-install.pth

解决：  
把setuptools.pth复制一份改名成easy-install.pth就可以了。或者使用`pip install --upgrade --ignore-installed tensorflow`

## ssh 

### 安装
参考这个博客[ubuntu开启SSH服务](http://www.cnblogs.com/xiazh/archive/2010/08/13/1798844.html)

### ssh允许使用密钥登陆
这个博客[设置 SSH 通过密钥登录](https://hyjk2000.github.io/2012/03/16/how-to-set-up-ssh-keys/)写的很详细了。
不过如果已经生成了密钥对，那就在`~/.ssh/authorized_keys`中添加`id_rsa.pub`的内容即可。并且不要忘记设置其访问权限为600。
```bash
# 设置允许密钥登陆
mkdir ~/.ssh
cd ~/.ssh
cat > authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4vLQK62esK6XZUicf+wuUulKi/tdlpfQ7wJ7qtcJ9y2aelpdHirPB0vztOTosS8EAFuuwnvdsISuZfYFwIsGZKqzjKCXDxl4+hEPsHTxovTPyGJglcRa5pQzJLCpTnLlLCoWpxXfdJ7N9nDys6K+ojpyVkuO5Xbq9HF6Vu8vJkZl8zlzGuS+3z8sOr03LWI9rO8DA+0wJRk4qVH1E89itj07BL/GhLoJLUR5Gqo+zca4EzUzSXx1/VS7jc17nuUCJddfNTBLLZ+IsKEcjWIQ+YFvQyji7Dmg7rLDqI5aWLJfxWosKc7BOhNKOpWplgYrGx05vMA/UsZtb7/a6m7sb
EOF
chmod 600 authorized_keys
chmod 700 ~/.ssh

# 设置ssh一直保持连接
sudo cat >>  /etc/ssh/sshd_config <<EOF
ClientAliveInterval 30
ClientAliveCountMax 5
EOF

sudo cat >> /etc/ssh/ssh_config <<EOF
ServerAliveInterval 30 # 指定了客户端向服务器端请求消息的时间间隔
ServerAliveCountMax 5
ConnectTimeout 6000
EOF

service sshd restart
# 此时需要输入root的密码
```

### 使用密钥登陆服务器
把私钥文件文件放在`~/.ssh/`目录即可，不忘记设置的存取权限是400

### 设置ssh超时
`sudo vim /etc/ssh/sshd_config`  
添加如下两行  
    ClientAliveInterval 60  # 指定了服务器端向客户端请求消息的时间间隔, 默认是0, 不发送.而ClientAliveInterval 60表示每分钟发送一次, 然后客户端响应, 这样就保持长连接了.  
    ClientAliveCountMax 5   #允许超时的次数
   
`sudo vim /etc/ssh/ssh_config`  
添加下面一行  
    ServerAliveInterval 60  # 指定了客户端向服务器端请求消息的时间间隔  
    ServerAliveCountMax 5  
    ConnectTimeout 6000  
然后重启服务  
    `service sshd restart`
### 查看公钥指纹  
    ssh-keygen -l -E md5 -f ~\id_rsa.pub

## jupyter使用

### 命令行导出pdf文件
 `jupyter nbconvert --to pdf xxx.ipynb`
 在windows上需要预先安装pandoc和miktex，在生成的时候自动选择的remote package repository可能总是下载不下来，
 这时可以打开MiKTeX setting换一个。
 
 在ubuntu上先安装了Texlive，但是生成pdf的时候还是报错，就没有再搞了，想想可以安装包含texpdf组件的其他工具。

### 安装jupyter notebook及设置允许远程访问

1. 登陆远程服务器
2. 生成配置文件`jupyter notebook --generate-config`
3. 生成密码
 打开ipython，创建一个密文的密码：  
    from notebook.auth import passwd
    passwd()
    Enter password: 
    Verify password: 
 输出例如'sha1:4e1cfb362357:ac6688741c2750bfd2bafa2371f22efc827e68b2'
 把生成的密文‘sha1:ce…’复制下来

4. 配置SSL
生成证书和密钥
` openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem`
5. 修改默认配置文件
`$vim ~/.jupyter/jupyter_notebook_config.py`  
进行如下修改：  
```python
c.NotebookApp.certfile = u'/absolute/path/to/your/certificate/mycert.pem'
c.NotebookApp.keyfile = u'/absolute/path/to/your/certificate/mykey.key'
c.NotebookApp.ip='*'
c.NotebookApp.password = u'sha:ce...刚才复制的那个密文'
c.NotebookApp.open_browser = False
c.NotebookApp.port =8989 #随便指定一个端口
```

6. 启动jupyter notebook：  
`$jupyter notebook`
7. 远程访问  
 此时应该可以直接从本地浏览器直接访问http://address_of_remote:8888就可以看到jupyter的登陆界面。  
8. 建立ssh通道  
如果登陆失败，则有可能是服务器防火墙设置的问题，此时最简单的方法是在本地建立一个ssh通道： 
在本地终端中输入ssh username@address_of_remote -L127.0.0.1:1234:127.0.0.1:8989 
便可以在localhost:1234直接访问远程的jupyter了。

[参考1:Running a notebook server](http://jupyter-notebook.readthedocs.io/en/latest/public_server.html)
[参考2:远程访问jupyter notebook](http://blog.leanote.com/post/jevonswang/%E8%BF%9C%E7%A8%8B%E8%AE%BF%E9%97%AEjupyter-notebook)

### jupyter显示python终端实际打开是python3的解决办法
1. 首先使用`jupyter kernelspec list`查看kernel的配置文件 
2. 进入安装内核目录打开`kernel.json`文件，查看Python编译器的路径是否正确，一般出现的原因是都是`python`,而系统中的python即为python3，只要把python改为`python2`就可以了。
3.重启`jupyter notebook`即可

## AWS CLI使用

1. 使用前先配置  
 运行`aws configure `命令，需要配置`AWS Access Key ID`,`AWS Secret Access Key`,`Default region name`,`Default output format`四项内容，第一次配置后以后可以直接输回车确认。访问密钥（访问密钥 ID 和秘密访问密钥）的是什么参考[这里](http://docs.aws.amazon.com/zh_cn/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys),如何获取参考[这里](http://docs.aws.amazon.com/zh_cn/general/latest/gr/managing-aws-access-keys.html)
1. 获取当前区的实例
 运行`aws ec2 describe-instances`
2. 查看命令
随便输错一个子命令即会列出所有命令的名字，之后搭配help使用即可。
3. 关闭某个实例（stop）
 `aws ec2 stop-instances --instance-ids i-xxxxxx`
4. 启动某个实例（start）
 `aws ec2 start-instances --instance-ids i-xxxxxx`

## git

### 使用bitbucket的git lfs服务
1. 安装[Bitbucket LFS Media Adapter](https://confluence.atlassian.com/bitbucket/bitbucket-lfs-media-adapter-856699998.html)  
2. 安装git-lfs
3. 使用  
[教程](https://www.atlassian.com/git/tutorials/git-lfs)