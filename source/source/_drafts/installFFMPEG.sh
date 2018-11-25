# 安装依赖
sudo apt-get -y install autoconf automake build-essential cmake git-core libass-dev libfreetype6-dev libsdl2-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev libxcb-xfixes0-dev pkg-config texinfo wget zlib1g-dev  aptitude
# 安装汇编器yasm
sudo apt-get install yasm
# 安装解码器
sudo apt-get install libx264-dev libx265-dev libnuma-dev libvpx-dev libfdk-aac-dev  libmp3lame-dev libopus-dev 

# 下载ffmpeg源码
wget https://ffmpeg.org/releases/ffmpeg-4.0.tar.bz2
tar -jxvf   ffmpeg-4.0.tar.bz2
cd ffmpeg-4.0

# 下载安装ffnvcodec.pc 使用cuda时需要，不使用时不需要
# https://superuser.com/questions/1299064/error-cuvid-requested-but-not-all-dependencies-are-satisfied-cuda-ffnvcodec
git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git
cd nv-codec-headers
make
sudo make install
cd ..

# ffmpeg编译设置
./configure   --enable-shared --disable-static --disable-yasm --enable-gpl --enable-version3 --enable-postproc --enable-libx265 --enable-libxvid --enable-libvorbis --enable-pthreads --disable-w32threads --disable-os2threads --enable-debug  --enable-nvenc --enable-cuda --enable-cuvid --extra-cflags="-Invidia_sdk -I/usr/local/cuda-9.0/include"  --extra-ldflags="-Lnvidia_sdk -L/usr/local/cuda-9.0/lib64"  --enable-nonfree  --enable-libfreetype --enable-libfontconfig --enable-libnpp --enable-gpl --prefix=/usr/local/ffmpeg  --enable-libx264   --enable-libmp3lame
# 哪个没有装哪个，一般是
sudo aptitude install xxx-dev
# 开始编译安装
make -j
sudo make install

# 添加动态链接库
sudo cat >> /etc/ld.so.conf.d/ffmpg.conf << EOF
/usr/local/ffmpeg/lib
EOF
sudo ldconfig -v

# 建立软连接
ln -s /usr/bin/ffmpeg /usr/local/ffmpeg/bin/ffmpeg
ln -s /usr/bin/ffplay /usr/local/ffmpeg/bin/ffplay
ln -s /usr/bin/ffprobe /usr/local/ffmpeg/bin/ffprobe

# 辅助工具
# 以1秒钟为间隔来查看GPU资源占用情况
watch -n 1 nvidia-smi 
# 查看ffmpeg支持的编码器
ffmpeg -codecs | grep H.264
# 使用nvenc H.264编码器
ffmpeg -i xxx -c:v nvenc xx.mp4
