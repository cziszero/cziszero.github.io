# 安装samba
sudo apt-get install samba -y
# 设置密码，需要注意的是没有任何提示，并且是明文输入
sudo smbpasswd -a -s zczhang
# 创建配置文件
sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
sudo cat > /etc/samba/smb.conf << EOF
[global]
	unix charset = utf8
	dos charset = cp936
	log file = /var/log/samba/%m.log

	security = user
	passdb backend = tdbsam
	smb passwd file = /etc/samba/smbpasswd
	encrypt passwords = yes

	read raw = no
	deny hosts = 1.1.1.1
	load printers = no
	max log size = 500
	log level = 3
	write raw = no
	socket options = TCP_NODELAY
	debug level = 3
    browseable = yes
	os level = 20
    available = yes

	# winbind trusted domains only = yes
	# dns proxy = no
	# name resolve order = lmhosts bcast host
	# winbind use default domain = yes
    # winbind use default domain = yes
	# netbios name  = vbirdserver
	# template shell = /bin/false
    # display charset = utf8
	# wins support = true
	# server string = my samba server
	# winbind trusted domains only = yes
	# socket options = TCP_NODELAY SO_RCVBUF=8192 SO_SNDBUF=8192
	# NetBIOS name 名称解析有关的设


[zczhanghome]
	user = zczhang,@zczhang
	path = /home/zczhang
	write list = zczhang,@zczhang
	valid users = zczhang,@zczhang
	directory mode = 771
	deny hosts = 1.1.1.1
	create mode = 771
	writeable = yes
	available = yes
	browseable = yes
EOF
# 重启samba服务
sudo /etc/init.d/samba restart