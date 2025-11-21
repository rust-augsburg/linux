set shell := ["bash", "-cu"]

# Setup just shell completions for bash
setup-self:
  just --completions bash | sudo tee /etc/bash_completion.d/just > /dev/null
  exec bash

# Install all build dependencies for the kernel
kernel-deps-deb:
  sudo apt install build-essential flex bison libncurses-dev libssl-dev debhelper libelf-dev libdw-dev gawk distcc -y

# Create a decent default config for building the kernel
create-kernel-config:
  -mv .config .initial-config
  cat /boot/config-$(uname -r) > .config
  LLVM=1 make olddefconfig
  LLVM=1 make menuconfig
  sed -i -e 's/CONFIG_SYSTEM_TRUSTED_KEYS=.*/CONFIG_SYSTEM_TRUSTED_KEYS=""/' .config
  sed -i -e 's/CONFIG_SYSTEM_REVOCATION_KEYS=.*/CONFIG_SYSTEM_REVOCATION_KEYS=""/' .config
  cp .config .config.bk

# Build kernel
build-kernel $BUILD_START_DATE=`date +%T` $BUILD_START=`date +%s`:
  LLVM=1 ARCH=x86_64 nice -n19 make -j $(nproc)
  @echo "start:   $BUILD_START_DATE"
  @echo "done:    $(date +%T)"
  @DURATION=$(($(date +%s) - BUILD_START)); echo "elapsed: $((DURATION / 60)):$((DURATION % 60))"

# Build kernel
install-kernel-full:
  LLVM=1 ARCH=x86_64 sudo make -j $(nproc) modules_install
  LLVM=1 ARCH=x86_64 sudo make -j $(nproc) headers_install
  LLVM=1 ARCH=x86_64 sudo make -j $(nproc) install

# Build kernel .deb
build-kernel-deb $BUILD_START_DATE=`date +%T` $BUILD_START=`date +%s`:
  LLVM=1 ARCH=x86_64 KDEB_COMPRESS=none nice -n19 make -j $(nproc) bindeb-pkg
  @echo "start:   $BUILD_START_DATE"
  @echo "done:    $(date +%T)"
  @DURATION=$(($(date +%s) - BUILD_START)); echo "elapsed: $((DURATION / 60)):$((DURATION % 60))"

# Install the latest .deb package of the kernel image
install-latest-kernel-deb-image:
  cd .. && sudo apt install "./$(ls -t | grep 'image.*\.deb' | grep -v 'dbg' | head -n 1)" -y --allow-downgrades

# Install the latest .deb package of the kernel headers
install-latest-kernel-deb-headers:
  cd .. && sudo apt install "./$(ls -t | grep 'headers.*\.deb' | grep -v 'dbg' | head -n 1)" -y --allow-downgrades

install-latest-kernel-deb-full:  install-latest-kernel-image  install-latest-kernel-headers
