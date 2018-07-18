########### 安装nvidia驱动 #################################
# 添加nvidia驱动的PPA，该PPA的[详细信息](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa)
sudo add-apt-repository ppa:graphics-drivers
sudo apt-get update

## 清除旧的安装
sudo apt-get purge nvidia*

# 查看是否已用了nouveau （不应该有输出）
lsmod | grep nouveau

# 把 nouveau 驱动加入黑名单
sudo cat >> /etc/modprobe.d/blacklist-nouveau.conf << EOF
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF

sudo update-initramfs -u
#!!!!!!!!!!! 重启 !!!!!!!!!
sudo reboot

# 关闭lightdm服务
sudo service lightdm stop
# 安装驱动
sudo apt-get install nvidia-396
# 更新模块
sudo update-initramfs -u
sudo reboot
#!!!!!!!!!!! 重启 !!!!!!!!!

sudo modprobe nvidia

# 查看nvidia驱动是否正常
lsmod | grep nvidia
# 显示显卡一些信息
nvidia-smi

############安装CUDA#########################

# 下载cuda9.0的包和patch
# 注意在此时询问安装samples的位置的时候，将samples目录设置为`/usr/local/cuda_samples`
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

# 设置全局环境变量
sudo cat >> /etc/profile <<EOF
CUDA_HOME="/usr/local/CUDA-9.0"
PATH="$CUDA_HOME/bin:$PATH"
LD_LIBRARY_PATH="$CUDA_HOME/lib64"
EOF
source /etc/profile 

# 检查cuda是否安装好
# 查看cuda版本
# sudo apt-get install  nvidia-cuda-toolkit # 这个包比较大 1G左右，可以不安装
# nvcc --version
# Sample测试
cd /usr/local/cuda_samples/NVIDIA_CUDA-9.0_Samples/1_Utilities/deviceQuery
sudo make
./deviceQuery


################ 安装cuDNN #######################
tar -xf cudnn*.tgz
sudo cp -R cuda/include/* /usr/local/cuda-9.0/include
sudo cp -R cuda/lib64/* /usr/local/cuda-9.0/lib64

# 动态链接库设置
sudo cat >> /etc/ld.so.conf.d/cuda.conf <<EOF
/usr/local/cuda-9.0/lib64
EOF
sudo ldconfig -v

############# 一些有用的命令 ###########
# 显卡设置
# nvidia-settings
