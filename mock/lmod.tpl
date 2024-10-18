config_opts['description'] += " + Lmod"

# Install packages for Lmod
config_opts['chroot_additional_packages'] += ' lua lua-posix lua-term tcl'
