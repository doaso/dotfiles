#!/bin/bash
parted /dev/nvme0n1 << EOF
mklabel gpt
mkpart primary fat32 1MiB 201MiB
set 1 esp on
mkpart primary ext4 201MiB 100%
EOF
mkfs.vfat -F 32 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mkdir --parents /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
wget --directory-prefix=/mnt "https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-musl-llvm/$(curl curl https://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-musl-llvm/latest-stage3-amd64-musl-llvm.txt | grep '.tar.xz' | awk '{print $1}')"
tar xpvf /mnt/*.tar.xz --xattrs-include='*.*' --numeric-owner --directory=/mnt
rm --force /mnt/*.tar.xz
cp /etc/resolv.conf /mnt/etc/resolv.conf
cp --recursive ./root/* /mnt/
arch-chroot /mnt << EOF
emerge-webrsync
emerge --sync
emerge --quiet --update --newuse @world
rc-update add elogind boot
emerge --quiet sys-devel/gcc
emerge --quiet dev-lang/rust-bin
emerge --quiet sys-kernel/linux-firmware
emerge --quiet sys-kernel/gentoo-kernel-bin
emerge --quiet sys-fs/genfstab
genfstab -U / >> /etc/fstab
grub-install
grub-mkconfig --output=/boot/grub/grub.cfg
emerge --quiet sys-apps/musl-locales
emerge --quiet sys-libs/timezone-data
env-update && source /etc/profile
emerge --quiet app-admin/sysklogd
rc-update add sysklogd default
emerge --quiet net-wireless/iwd
rc-update add iwd default
emerge --quiet net-misc/dhcpcd
rc-update add dhcpcd default
emerge --quiet app-admin/doas
emerge --quiet media-video/pipewire
useradd --create-home --groups users,wheel,pipewire --shell /bin/bash doaso
echo 'doaso:password' | chpasswd
echo 'root:password' | chpasswd
emerge --quiet media-video/wireplumber
emerge --quiet app-misc/neofetch
emerge --quiet emerge dev-vcs/git
emerge --quiet app-editors/neovim
emerge --quiet dev-util/tree-sitter-cli
emerge --quiet gui-apps/wl-clipboard
emerge --quiet dev-libs/wayland
emerge --quiet gui-wm/sway
emerge --quiet gui-apps/swaybg
emerge --quiet gui-apps/waybar
emerge --quiet gui-apps/foot
emerge --quiet gui-apps/grim
emerge --quiet www-client/firefox
EOF
