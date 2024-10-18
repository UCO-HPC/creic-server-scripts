config_opts['description'] += " + Slurm"

# Install packages for Slurm
config_opts['chroot_additional_packages'] += ' munge slurm slurm-slurmd slurm-perlapi'
