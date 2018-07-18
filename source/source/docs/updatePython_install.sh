#############安装python3.6并设置为默认############
# 注意：如果使用python3.6替换掉python3.5，并将软链指向python3.6会有很多软件出问题
# 比如nvidia-setting等，所以不建议更换，如果需要不同的环境可以使用pyenv，挺好用的。

# 添加python的PPA
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update

# 安装python3.6
sudo apg-get install -y python3.6
# 将python3.6置为python3的默认选项
# 数字越大优先级越高，使用 sudo update-alternatives --config python3 可以切换
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.6 5
sudo update-alternatives --install /usr/bin/python3 python /usr/bin/python3.5 1

# 安装pip和pip3并升级
sudo apt-get install -y python3-pip python-pip 
sudo python3 -m pip install pip --upgrade
sudo python -m pip install pip --upgrade

# 更换pypi源为清华的源
mkdir ~/.config/pip
cat >> ~/.config/pip/pip.conf  << EOF
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
EOF

# 安装python3的各种常用包
sudo pip3 install --upgrade pip
for i in 'xgboost' 'bs4' 'coursera-dl' 'jupyter' 'jupyterlab' 'ipython' 'keras' 'matplotlib' 'seaborn' 'pandas' 'pep8' 'pylint' 'pysc2' 'sklearn' 
do
sudo pip3 install $i
sudo pip2 install $i
done 

################ 安装tensorflow-gpu ##############
sudo pip3 install tensorflow-gpu
sudo pip2 install tensorflow-gpu

################ 安装pytorch ##############
# 安装pytorch0.4 cuda9.0 python3.5 版本
# 安装前需要去[官网](https://pytorch.org)相应的修改该段
sudo pip3 install http://download.pytorch.org/whl/cu90/torch-0.4.0-cp35-cp35m-linux_x86_64.whl 
sudo pip3 install torchvision

################ 安装mxnet ################
# 安装pytorch cuda9.0 python3.5 版本
# 运行前请去更新mxnet[安装指导](https://mxnet.apache.org/install/index.html?device=Linux&language=Python&processor=GPU)更新本段代码
sudo pip3 install mxnet-cu90
sudo apt-get install graphviz
sudo pip install graphviz
