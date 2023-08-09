#!/bin/bash
/bin/echo "Script Start Time: "$(/usr/bin/date) > /tmp/first-boot.log
/bin/echo "*****UPDATE*****" >> /tmp/first-boot.log
/usr/bin/apt update -y >> /tmp/first-boot.log 2>&1
/bin/echo "*****UPGRADE*****" >> /tmp/first-boot.log
DEBIAN_FRONTEND=noninteractive /usr/bin/apt upgrade -y >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL MATE 1 *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y --no-install-recommends ubuntu-mate-core >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL MATE 2 *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y --no-install-recommends ubuntu-mate-desktop >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL MATE 3 *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y mate-core >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL MATE 4 *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y mate-desktop-environment >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL MATE 5 *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y mate-notification-daemon >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL xrdp *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y xrdp >> /tmp/first-boot.log 2>&1
/usr/bin/systemctl enable xrdp >> /tmp/first-boot.log 2>&1
/bin/echo "***** Fix Broken Packages *****" >> /tmp/first-boot.log
/usr/bin/apt --fix-broken install -y >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL Firefox *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y firefox >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL chrome *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y gdebi-core >> /tmp/first-boot.log 2>&1
/usr/bin/wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb >> /tmp/first-boot.log 2>&1
/usr/bin/gdebi --n --q google-chrome-stable_current_amd64.deb >> /tmp/first-boot.log 2>&1
/bin/echo "***** INSTALL Python *****" >> /tmp/first-boot.log
/usr/bin/apt-get install -y python >> /tmp/first-boot.log 2>&1
/usr/bin/apt-get install -y python3-pip >> /tmp/first-boot.log 2>&1
/bin/echo "***** Create New User *****" >> /tmp/first-boot.log
/usr/sbin/useradd -m shokz >> /tmp/first-boot.log 2>&1
/usr/sbin/usermod -aG sudo shokz
/usr/bin/mkdir /home/shokz/Desktop >> /tmp/first-boot.log 2>&1
/usr/bin/chown shokz:shokz /home/shokz/Desktop >> /tmp/first-boot.log 2>&1
/usr/bin/ls -als /home/shokz/Desktop >> /tmp/first-boot.log 2>&1
/bin/echo 'shokz:Changemenow' | /usr/sbin/chpasswd
/bin/echo "***** Create Firefox Launcher *****" >> /tmp/first-boot.log
/usr/bin/cat << EOF > /home/shokz/Desktop/Firefox.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon=firefox
Icon[C]=firefox
Name[C]=Firefox
Exec=firefox
Name=Firefox
EOF
/usr/bin/cat /home/shokz/Desktop/Firefox.desktop >> /tmp/first-boot.log
/usr/bin/chown shokz:shokz /home/shokz/Desktop/Firefox.desktop >> /tmp/first-boot.log 2>&1
/usr/bin/chmod 775 /home/shokz/Desktop/Firefox.desktop >> /tmp/first-boot.log 2>&1
/bin/echo "***** Create Firefox Launcher *****" >> /tmp/first-boot.log
/usr/bin/cat << EOF > /home/shokz/Desktop/Chrome.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Icon=google-chrome
Icon[C]=google-chrome
Name[C]=Chrome
Exec=google-chrome
Name=Chrome
EOF
/usr/bin/cat /home/shokz/Desktop/Chrome.desktop >> /tmp/first-boot.log
/usr/bin/chown shokz:shokz /home/shokz/Desktop/Chrome.desktop >> /tmp/first-boot.log 2>&1
/usr/bin/chmod 775 /home/shokz/Desktop/Chrome.desktop >> /tmp/first-boot.log 2>&1
/bin/echo "***** Create Terminal Launcher *****" >> /tmp/first-boot.log
/usr/bin/cat << EOF > /home/shokz/Desktop/Terminal.desktop
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Icon=mate-panel-launcher
Icon[C]=mate-panel-launcher
Name[C]=Terminal
Exec=bash
Name=Terminal
EOF
/usr/bin/cat /home/shokz/Desktop/Terminal.desktop >> /tmp/first-boot.log
/usr/bin/chown shokz:shokz /home/shokz/Desktop/Terminal.desktop >> /tmp/first-boot.log 2>&1
/usr/bin/chmod 775 /home/shokz/Desktop/Terminal.desktop >> /tmp/first-boot.log 2>&1
/bin/echo "*****DONE*****" >> /tmp/first-boot.log
/bin/echo "Script Stop  Time: "$(/usr/bin/date) >> /tmp/first-boot.log
/usr/bin/wall "NOTICE: First Boot Setup Has Completed"

