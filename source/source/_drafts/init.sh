# 挂载磁盘
/etc/fstab
mount -a
http://blog.sina.com.cn/s/blog_142e95b170102vx2a.html 
1. 查看uuid
sudo blkid
ls -l /dev/disk/by-uuid
ntfs分区的uuid和ext4的长度不一样
# 4T volume
UUID=0D2909BF0D2909BF /home/chao/b ntfs defaults,umask=013,uid=1000,gid=1000        0 0

# 500G volume
UUID=68347b69-cd57-4e3b-9b03-b5cd29c7a31a /home/chao/h ext4 defaults        0 0


2. ntfs设置默认属性
<file system> <mount point>   <type>  <options>       <dump>  <pass>

<file system> ：分区定位，可以给磁盘号，UUID或LABEL，例如：/dev/sda2，UUID=6E9ADAC29ADA85CD或LABEL=software

<mount point> : 具体挂载点的位置，例如：/media/C

<type> : 挂载磁盘类型，linux分区一般为ext4，windows分区一般为ntfs

<options> : 挂载参数，一般为defaults

<dump> : 磁盘备份，默认为0，不备份

<pass> : 磁盘检查，默认为0，不检查

# 开机启动
rc.local

# 查看uid，gid
cat /etc/passwd

3. 文件权限含义
evernote

4 设置密钥登陆
http://blog.csdn.net/leexide/article/details/17252369
https://www.jianshu.com/p/51bd2b82ff35

cat > ~/.ssh/authorized_keys << EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC4vLQK62esK6XZUicf+wuUulKi/tdlpfQ7wJ7qtcJ9y2aelpdHirPB0vztOTosS8EAFuuwnvdsISuZfYFwIsGZKqzjKCXDxl4+hEPsHTxovTPyGJglcRa5pQzJLCpTnLlLCoWpxXfdJ7N9nDys6K+ojpyVkuO5Xbq9HF6Vu8vJkZl8zlzGuS+3z8sOr03LWI9rO8DA+0wJRk4qVH1E89itj07BL/GhLoJLUR5Gqo+zca4EzUzSXx1/VS7jc17nuUCJddfNTBLLZ+IsKEcjWIQ+YFvQyji7Dmg7rLDqI5aWLJfxWosKc7BOhNKOpWplgYrGx05vMA/UsZtb7/a6m7sb
EOF
chmod 600  ~/.ssh/authorized_keys

5. 更新pip源
mkdir /root/.pip
cat > /root/.pip/pip.conf << EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

mkdir ~/.pip
cat >> ~/.pip/pip.conf << EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF

6. 安装pip
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
sudo pip3 install you-get bs4 requests
sudo pip3 install numpy matplotlib sklearn tensorflow seaborn  
sudo pip3 install ipython jupyter scipy

7.
# cat > /etc/resolv.conf << EOF
# nameserver 162.105.129.26



