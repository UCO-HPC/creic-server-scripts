config_opts['description'] += " + Base"

# Install Almalinux Minimal base packages
# https://git.almalinux.org/almalinux/pungi-almalinux/src/branch/a9.4/x86_64/comps.xml
# Search for <group variant="Minimal"> <id>base</id> <name>Base</name>
config_opts['chroot_additional_packages'] += """
    acl almalinux-release at attr bc cpio crontabs cyrus-sasl-plain 
    dbus ed file irqbalance kpatch kpatch-dnf logrotate lsof mcelog 
    microcode_ctl net-tools pciutils psacct quota sudo symlinks 
    systemd-udev tar tree tuned util-linux-user bash-completion 
    bluez bpftool bzip2 chrony cockpit cryptsetup dos2unix 
    dosfstools ethtool gnupg2 iprutils kmod-kvdo ledmon lvm2 
    mailcap man-pages mdadm mlocate mtr nano nvme-cli realmd rsync 
    smartmontools sos sssd strace teamd time unzip usbutils vdo 
    virt-what which words xfsdump zip cifs-utils cockpit-doc fwupd 
    ima-evm-utils nfs-utils nvmetcli traceroute vdo-support zsh
    glibc-all-langpacks
"""

# Install packages necessary for remote access
config_opts['chroot_additional_packages'] += """
    NetworkManager NetworkManager-tui device-mapper dnf kernel-core
    nfs-utils openssh openssh-clients openssh-server sudo less 
    dnf-plugins-core nano bat wget
"""	

# Install "Development Tools" group
config_opts['chroot_additional_packages'] += """
    autoconf automake binutils bison flex gcc gcc-c++ gdb
    glibc-devel libtool make pkgconf pkgconf-m4 pkgconf-pkg-config
    redhat-rpm-config rpm-build rpm-sign strace asciidoc byacc
    diffstat git intltool jna ltrace patchutils perl-Fedora-VSP
    perl-generators pesign source-highlight systemtap valgrind
    valgrind-devel
"""
