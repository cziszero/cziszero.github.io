---
layout: post
title:  在ubuntu16.04上安装nvida显卡驱动，CUDA9.0 和 cuDNN7.0
description: 
date: 2018-06-15
categories: 
  - [Linux]
  - [软件安装和使用]
tags:
  - Linux
  - 软件安装和使用
---

# 使用PPA安装nvidia驱动

## 添加nvidia驱动的PPA

该PPA的[详细信息](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa)

```bash
sudo add-apt-repository ppa:graphics-drivers
sudo apt-get update
```
## 清除旧的安装

```bash
sudo apt-get purge nvidia*
```
## 禁用开源驱动nouveau
首先查看是否已用了`nouveau` （不应该有输出）

```bash
lsmod | grep nouveau
```
然后把 `nouveau` 驱动加入黑名单

```bash
sudo cat >> /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF

sudo update-initramfs -u
sudo reboot
```
此时电脑会重启一次

## 安装驱动

```bash
# 首先需要关闭lightdm服务
sudo service lightdm stop
# 安装最新版本驱动，可以去上面那个PPA的网站查一下支持的最新版本
sudo apt-get install nvidia-396
# 更新模块
sudo update-initramfs -u
sudo reboot
```
此时电脑会重启一次，重启后可以通过`lsmod | grep nvidia`来查看`nvidia`的模块有没有被正确载入，也可以通过`nvidia-smi`来显示显卡一些信息。

# 安装CUDA

## 下载CUDA9.0并安装

以下脚本会下载CUDA9.0的run文件和3个patch，并自动安装。注意在安装的时候询问是否要装驱动选no，有的资料说讯问是否要装`openGL`时选no，否则会循环登陆，不过我按的之后没有问我是否要装`openGL`。
另外询问安装samples的位置的时候，将samples目录设置为`/usr/local/cuda_samples`，后面才可以编译一个sample测试一下是否正确安装。

```bash
mkdir cuda9.0
cd cuda9.0
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/local_installers/cuda_9.0.176_384.81_linux-run
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/1/cuda_9.0.176.1_linux-run
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/2/cuda_9.0.176.2_linux-run
wget https://developer.nvidia.com/compute/cuda/9.0/Prod/patches/3/cuda_9.0.176.3_linux-run
chmod +x *
sudo ./cuda_9.0.176_384.81_linux-run
sudo ./cuda_9.0.176.1_linux-run
sudo ./cuda_9.0.176.2_linux-run
sudo ./cuda_9.0.176.3_linux-run
```

## 设置全局环境变量

```bash
sudo cat >> /etc/profile <<EOF
CUDA_HOME="/usr/local/CUDA-9.0"
PATH="$CUDA_HOME/bin:$PATH"
LD_LIBRARY_PATH="$CUDA_HOME/lib64"
EOF
source /etc/profile 
```
如果只想对当前用户生效，将上面的内容加入到`~/.bashrc`中即可。

## 检查cuda是否安装好
可以通过查看cuda版本`nvcc --version`来查看是否正确安装。不过需要先`sudo apt-get install nvidia-cuda-toolkit`安装这个包，不过这个包比较大 1G左右，可以不安装。更好的是编译一个sample来测试，还可以看到很详细的显卡的信息。

```bash
cd /usr/local/cuda_samples/NVIDIA_CUDA-9.0_Samples/1_Utilities/deviceQuery
sudo make
./deviceQuery
```

# 安装cuDNN 

## 下载安装

cuDNN的安装很简单，从官网下载下来之后复制到cuda的安装目录就可以了。不过cuDNN的下载需要先注册nvidia的会员，假设已下好并命名为本目录下`cudnn.tgz`。

```bash
tar -xf cudnn.tgz
sudo cp -R cuda/include/* /usr/local/cuda-9.0/include
sudo cp -R cuda/lib64/* /usr/local/cuda-9.0/lib64
```

## 更新动态链接库

```bash
sudo cat >> /etc/ld.so.conf.d/cuda.conf <<EOF
/usr/local/cuda-9.0/lib64
EOF
sudo ldconfig -v
```

到此处就大功告成了，可以正常安装`tensorflow-gpu`，`pytorch`，`maxnet`了。

# 一些有用的命令

* 显卡设置 `nvidia-settings`
* 安装驱动有问题时可以试试自动载入nvidia的模块 `sudo modprobe nvidia`

# 总结
最后，将整个代码放在[这个文件](/docs/installNvidiaCUDAcuDNN.sh)中。
