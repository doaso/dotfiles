#!/bin/bash
PARTITION="nvme0n1"
PARTITION_SEPERATOR="p"
parted /dev/${PARTITION} << EOF
mklabel gpt
mkpart primary fat32 1MiB 513MiB
set 1 esp on
name 1 EFI
mkpart primary linux-swap 513MiB 16GiB
name 2 swap
mkpart primary ext4 16GiB 100%
name 3 root
quit
EOF
mkfs.vfat -F 32 /dev/${PARTITION}${PARTITION_SEPERATOR}1
mkswap /dev/${PARTITION}${PARTITION_SEPERATOR}2
swapon /dev/${PARTITION}${PARTITION_SEPERATOR}2
mkfs.ext4 /dev/${PARTITION}${PARTITION_SEPERATOR}3
mkdir --parents /mnt/gentoo
mount /dev/${PARTITION}${PARTITION_SEPERATOR}3 /mnt/gentoo
mkdir --parents /mnt/gentoo/efi
mount /dev/${PARTITION}${PARTITION_SEPERATOR}1 /mnt/gentoo/efi
MIRROR="https://distfiles.gentoo.org"
ARCHITECTURE="amd64"
LATEST_STAGE=$(curl --silent ${MIRROR}/releases/${ARCHITECTURE}/autobuilds/current-stage3-${ARCHITECTURE}-musl-llvm/latest-stage3-${ARCHITECTURE}-musl-llvm.txt | grep --only-matching .*.tar.xz)
wget --directory-prefix=/mnt/gentoo ${MIRROR}/releases/${ARCHITECTURE}/autobuilds/current-stage3-${ARCHITECTURE}-musl-llvm/${LATEST_STAGE}
tar xpvf /mnt/gentoo/*.tar.xz --xattrs-include='*.*' --numeric-owner --directory=/mnt/gentoo
rm --force /mnt/gentoo/*.tar.xz
cp --recursive ./root/* /mnt/gentoo/
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
ROOT_PASSWD="passwd"
USER="doaso"
USER_PASSWD="passwd"
arch-chroot /mnt/gentoo /bin/bash << EOF
emerge --sync
emerge sys-devel/gcc
emerge sys-apps/musl-locales
emerge sys-libs/timezone-data
emerge sys-kernel/linux-firmware
emerge sys-kernel/installkernel
emerge sys-kernel/gentoo-kernel
emerge sys-fs/genfstab
emerge sys-boot/grub
emerge app-admin/sysklogd
emerge net-misc/chrony
emerge net-misc/dhcpcd
emerge net-wireless/iwd
emerge media-video/pipewire
emerge media-video/wireplumber
emerge app-admin/doas
emerge app-misc/neofetch
emerge dev-vcs/git
emerge app-editors/neovim
emerge dev-util/tree-sitter-cli
emerge gui-apps/wl-clipboard
emerge dev-libs/wayland
emerge gui-wm/sway
emerge sys-auth/seatd
emerge gui-apps/swaybg
emerge gui-apps/waybar
emerge gui-apps/grim
emerge gui-apps/foot
emerge dev-lang/rust
emerge www-client/firefox
emerge --verbose --update --deep --newuse @world
emerge --deepclen
echo "root:${ROOT_PASSWD}" | chpasswd
useradd --create-home --groups users,wheel,pipewire --shell /bin/bash ${USER}
echo "root:${USER_PASSWD}" | chpasswd
rc-update add iwd default
rc-update add dhcpcd default
rc-update add sysklogd default
rc-update add chronyd default
rc-update add elogind boot
emerge sys-fs/genfstab
genfstab -U / >> /etc/fstab
emerge sys-boot/grub
grub-install --efi-directory=/efi
grub-mkconfig --output=/boot/grub/grub.cfg
EOF
