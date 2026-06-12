#!/bin/bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive 
if [ "$(whoami)" == "root" ]; then
    apt="apt"
else
    apt="sudo DEBIAN_FRONTEND=noninteractive apt"
fi

${apt} update -y
${apt} install -y libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build build-essential curl python3-venv linux-headers-generic
if [ ! -d ./qemu-11.0.1 ]; then
    curl -sSL -o qemu.tar.gz https://github.com/qemu/qemu/archive/refs/tags/v11.0.1.tar.gz
    tar xvzf qemu.tar.gz
    rm qemu.tar.gz
fi
cd qemu-11.0.1
rm -rf release
mkdir release
cd release
../configure --target-list=arm-softmmu,aarch64-softmmu --prefix=/opt/qemu
make -j4
make install
