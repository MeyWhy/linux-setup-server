#!/bin/bash
set -e 

#to run it  sudo bash setup.sh
USERNAME="emy"
HOSTNAME="debian-prod"
TIMEZONE="Africa/Algiers"

echo "======================================"
echo "Setting up the linux server"
echo "======================================"

echo "[1/9] Updating system..."
#ssh into the server
#ssh root@your_server_ip

#updating it
apt update
apt full-upgrade -y
apt autoremove -y

echo "[2/9] Creating user..."
#add new user
if ! id "$USERNAME" &>/dev/null; then
  adduser --gecos "" "$USERNAME"
  usermod -aG sudo "$USERNAME"
else
  echo "User already exists"
fi

echo "[3/9] Installing packages..."
apt install -y \
    sudo \
    ufw \
    fail2ban \
    unattended-upgrades \
    apt-listchanges

echo "[4/9] Hardening SSH..."
SSHD_CONFIG="/etc/ssh/sshd_config"
#config ssh 
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"

grep -q "^ChallengeResponseAuthentication" "$SSHD_CONFIG" \
&& sed -i 's/^ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' "$SSHD_CONFIG" \
|| echo "ChallengeResponseAuthentication no">> "$SSHD_CONFIG"

systemctl restart ssh


echo "[5/9] Configuring firewall..."
#config the firewall
ufw default deny incoming
ufw default allow outgoing

ufw allow OpenSSH

ufw --force enable

echo "[6/9] Configuring unattended upgrades..."
#automate secu updates
dpkg-reconfigure -f noninteractive unattended-upgrades

systemctl status unattended-upgrades

echo "[7/9] Configuring Fail2Ban..."
#install fail2ban
if [ ! -f /etc/fail2ban/jail.local ]; then
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
fi

systemctl enable fail2ban
systemctl restart fail2ban

echo "[8/9] Setting hostname and timezone..."
#config hostnames
hostnamectl set-hostname "$HOSTNAME"

#config timezones
timedatectl set-timezone "$TIMEZONE"


echo
echo "======================================"
echo " Verification"
echo "======================================"

echo
echo "User:"
id "$USERNAME"

echo
echo "SSH:"
grep "^PermitRootLogin" "$SSHD_CONFIG"
grep "^PasswordAuthentication" "$SSHD_CONFIG"

echo
echo "Firewall:"
ufw status

echo
echo "Fail2Ban:"
fail2ban-client status

echo
echo "Automatic Updates:"
systemctl status unattended-upgrades --no-pager

echo
echo "Hostname:"
hostnamectl --static

echo
echo "Timezone:"
timedatectl | grep "Time zone"

echo
echo "SSH Service:"
systemctl status ssh --no-pager

echo
echo "======================================"
echo "Setup complete."
echo
echo "IMPORTANT:"
echo "1. Generate an SSH key on your LOCAL machine:"
echo "      ssh-keygen -t ed25519"
echo
echo "2. Copy it to the server:"
echo "      ssh-copy-id $USERNAME@SERVER_IP"
echo
echo "3. Verify you can log in with the key."
echo
echo "4. Only then disconnect your root session."
echo "======================================"