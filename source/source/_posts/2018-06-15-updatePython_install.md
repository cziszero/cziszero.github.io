---
layout: post
title:  python升级和常用包的安装脚本
description: 
date: 2018-06-15
categories: 
  - [Linux]
  - [软件安装和使用]
tags:
  - Linux
  - 软件安装和使用
---

# 升级python3.5并设置python3.6为默认

注意：如果使用python3.6替换掉python3.5，并将软链指向python3.6会有很多软件出问题
比如`nvidia-setting`等，所以不建议更换，如果需要不同的环境可以使用pyenv，挺好用的。

## 添加python的PPA

```bash
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
```

## 安装python3.6

```bash
sudo apg-get install -y python3.6
```

## 将python3.6置为python3的默认选项

```bash
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.6 5
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.5 1
```
数字越大优先级越高，使用`sudo update-alternatives --config python3`可以切换。

# 安装常用python包

## 安装pip和pip3并升级

```bash
sudo apt-get install -y python3-pip python-pip 
sudo python3 -m pip install pip --upgrade
sudo python -m pip install pip --upgrade
```

## 更换pypi源为清华的源

```bash
mkdir ~/.config/pip
cat >> ~/.config/pip/pip.conf  << EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF
```

## 安装python3的各种常用包

```bash
for i in 'xgboost' 'bs4' 'coursera-dl' 'jupyter' 'jupyterlab' 'ipython' 'keras' 'matplotlib' 'seaborn' 'pandas' 'pep8' 'pylint' 'pysc2' 'sklearn' 
do
sudo pip3 install $i
sudo pip2 install $i
done 
```

## 依赖于CUDA9.0和cuDNN7.0的包
### 安装tensorflow-gpu

```bash
sudo pip3 install tensorflow-gpu
sudo pip2 install tensorflow-gpu
```

### 安装pytorch

安装pytorch0.4 cuda9.0 python3.5 版本，安装前需要去[官网](https://pytorch.org)看下，进行相应的修改。

```bash
sudo pip3 install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl 
sudo pip3 install torchvision
```

### 安装mxnet
安装mxnet cuda9.0版本，运行前请去更新mxnet[安装指导](https://mxnet.apache.org/install/index.html?device=Linux&language=Python&processor=GPU)更新本段代码。

```bash
sudo pip3 install mxnet-cu90
sudo apt-get install graphviz
sudo pip install graphviz
```

# 总结
整个的脚本可以从[这里](/docs/updatePython_install.sh)下载。