#!/bin/bash
# ==============================================================================
# Install External Storage CCTV ONLINE
# ==============================================================================

# 1. Dapatkan user asli meskipun diinstall menggunakan sudo
CURRENT_USER=${SUDO_USER:-$(whoami)}
NODE_BIN=$(which node || echo /usr/bin/node)

# 2. Buat direktori base untuk mount external storage
sudo mkdir -p /mnt/cctv-storage
sudo chown -R "$CURRENT_USER":"$CURRENT_USER" /mnt/cctv-storage || true
sudo chmod 775 /mnt/cctv-storage
echo "Mount base directory /mnt/cctv-storage siap."

echo "Configuring sudoers for service restart and storage mount..."
SYSTEMCTL_BIN=$(command -v systemctl || echo /bin/systemctl)
MOUNT_BIN=$(command -v mount || echo /bin/mount)
UMOUNT_BIN=$(command -v umount || echo /bin/umount)
MKDIR_BIN=$(command -v mkdir || echo /bin/mkdir)
CHOWN_BIN=$(command -v chown || echo /bin/chown)
CHMOD_BIN=$(command -v chmod || echo /bin/chmod)
SED_BIN=$(command -v sed || echo /bin/sed)
BASH_BIN=$(command -v bash || echo /bin/bash)
TEE_BIN=$(command -v tee || echo /usr/bin/tee)

sudo bash -c "cat > /etc/sudoers.d/cctv-monitoring << SUDOEOF
$CURRENT_USER ALL=NOPASSWD: $SYSTEMCTL_BIN restart mediamtx, $SYSTEMCTL_BIN restart cctv-web, $SYSTEMCTL_BIN restart mediamtx cctv-web
$CURRENT_USER ALL=NOPASSWD: $MOUNT_BIN
$CURRENT_USER ALL=NOPASSWD: $UMOUNT_BIN
$CURRENT_USER ALL=NOPASSWD: $MKDIR_BIN -p /mnt/cctv-storage/*
$CURRENT_USER ALL=NOPASSWD: $CHOWN_BIN -R * /mnt/cctv-storage/*
$CURRENT_USER ALL=NOPASSWD: $CHMOD_BIN 775 /mnt/cctv-storage/*
$CURRENT_USER ALL=NOPASSWD: $SED_BIN -i * /etc/fstab
$CURRENT_USER ALL=NOPASSWD: $BASH_BIN -c echo * >> /etc/fstab
$CURRENT_USER ALL=NOPASSWD: $TEE_BIN -a /etc/fstab
SUDOEOF"
sudo chmod 440 /etc/sudoers.d/cctv-monitoring
if sudo visudo -cf /etc/sudoers.d/cctv-monitoring; then
    echo "Sudoers OK."
else
    echo "Invalid sudoers file. Removing /etc/sudoers.d/cctv-monitoring"
    sudo rm -f /etc/sudoers.d/cctv-monitoring
fi
