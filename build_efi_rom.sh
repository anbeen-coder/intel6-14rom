#!/bin/bash
git submodule update --init
source edksetup.sh
sed -i 's:^ACTIVE_PLATFORM\s*=\s*\w*/\w*\.dsc*:ACTIVE_PLATFORM       = OvmfPkg/OvmfPkgX64.dsc:g' Conf/target.txt
sed -i 's:^TARGET_ARCH\s*=\s*\w*:TARGET_ARCH           = X64:g' Conf/target.txt
sed -i 's:^TOOL_CHAIN_TAG\s*=\s*\w*:TOOL_CHAIN_TAG        = GCC5:g' Conf/target.txt
make -C BaseTools
build -DFD_SIZE_4MB -DDEBUG_ON_SERIAL_PORT=TRUE
cp Build/OvmfX64/DEBUG_GCC5/X64/PlatformGOPPolicy.efi Build/
cp Build/OvmfX64/DEBUG_GCC5/X64/IgdAssignmentDxe.efi Build/
cp ./BaseTools/Source/C/bin/EfiRom Build/
Build/EfiRom -e Build/IgdAssignmentDxe.efi Build/PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o Build/6-14igd.rom
cd Build
./EfiRom -e pc-4-5-IntelGopDriver.efi pc-6-7-8-9-IntelGopDriver.efi j4125.efi pc-10-IntelGopDriver.efi pc-11-IntelGopDriver.efi pc-12-13-14-IntelGopDriver.efi 11-J6412.efi 11-n5095.efi 12-1240p.efi 12-n100.efi N2930.efi N3350.efi nb-11-11700h.efi nb-11-1185G7E.efi nb-12-12700h.efi nb-13-13700h.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 6-14.rom

