config_opts['description'] += " + IPA"

# Install packages for IPA enrollment
config_opts['chroot_additional_packages'] += ' ipa-client'
