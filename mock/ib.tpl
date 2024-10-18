config_opts['description'] += " + IB"

# Install packages for Infiniband
config_opts['chroot_additional_packages'] += """
    ibacm infiniband-diags iwpmd kmod-mlx4 libibumad libibverbs 
    libibverbs-utils librdmacm librdmacm-utils libvma mstflint 
    opensm perftest rdma-core srp_daemon
"""

config_opts['dnf.conf'] += """

[elrepo]
name=ELRepo.org Community Enterprise Linux Repository - el9
baseurl=http://elrepo.org/linux/elrepo/el9/$basearch/
    http://mirrors.coreix.net/elrepo/elrepo/el9/$basearch/
    http://mirror.rackspace.com/elrepo/elrepo/el9/$basearch/
    http://linux-mirrors.fnal.gov/linux/elrepo/elrepo/el9/$basearch/
mirrorlist=http://mirrors.elrepo.org/mirrors-elrepo.el9
enabled=1
countme=1
gpgcheck=1
gpgkey=https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

[elrepo-testing]
name=ELRepo.org Community Enterprise Linux Testing Repository - el9
baseurl=http://elrepo.org/linux/testing/el9/$basearch/
    http://mirrors.coreix.net/elrepo/testing/el9/$basearch/
    http://mirror.rackspace.com/elrepo/testing/el9/$basearch/
    http://linux-mirrors.fnal.gov/linux/elrepo/testing/el9/$basearch/
mirrorlist=http://mirrors.elrepo.org/mirrors-elrepo-testing.el9
enabled=0
countme=1
gpgcheck=1
gpgkey=https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

[elrepo-kernel]
name=ELRepo.org Community Enterprise Linux Kernel Repository - el9
baseurl=http://elrepo.org/linux/kernel/el9/$basearch/
    http://mirrors.coreix.net/elrepo/kernel/el9/$basearch/
    http://mirror.rackspace.com/elrepo/kernel/el9/$basearch/
    http://linux-mirrors.fnal.gov/linux/elrepo/kernel/el9/$basearch/
mirrorlist=http://mirrors.elrepo.org/mirrors-elrepo-kernel.el9
enabled=0
countme=1
gpgcheck=1
gpgkey=https://www.elrepo.org/RPM-GPG-KEY-elrepo.org

[elrepo-extras]
name=ELRepo.org Community Enterprise Linux Extras Repository - el9
baseurl=http://elrepo.org/linux/extras/el9/$basearch/
   http://mirrors.coreix.net/elrepo/extras/el9/$basearch/
   http://mirror.rackspace.com/elrepo/extras/el9/$basearch/
   http://linux-mirrors.fnal.gov/linux/elrepo/extras/el9/$basearch/
mirrorlist=http://mirrors.elrepo.org/mirrors-elrepo-extras.el9
enabled=0
countme=1
gpgcheck=1
gpgkey=https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
"""
