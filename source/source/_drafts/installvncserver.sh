#!/bin/sh
sudo apt-get update 
sudo apt-get install  ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal --no-install-recommends -y
sudo apt-get install vnc4server -y
vncserver :1
vncserver -kill :1
cat > ~/.vnc/xstartup << EOF
#!/bin/sh

# Uncomment the following two lines for normal desktop:
# unset SESSION_MANAGER
# exec /etc/X11/xinit/xinitrc

[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
xsetroot -solid grey
vncconfig -iconic &
x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
x-window-manager &

gnome-panel &
gnome-settings-daemon &
metacity &
nautilus &
EOF
vncserver :1

