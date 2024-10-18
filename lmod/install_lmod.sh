#!/bin/bash

dnf install -y lua lua-posix lua-term tcl

ln -s /opt/software/lmod/lmod/init/cshrc /etc/profile.d/z00_lmod.csh
ln -s /opt/software/lmod/lmod/init/profile /etc/profile.d/z00_lmod.sh
ln -s /opt/creic-server-scripts/lmod/z01_lmod_modules_path.csh /etc/profile.d/z01_lmod_modules_path.csh
ln -s /opt/creic-server-scripts/lmod/z01_lmod_modules_path.sh /etc/profile.d/z01_lmod_modules_path.sh
