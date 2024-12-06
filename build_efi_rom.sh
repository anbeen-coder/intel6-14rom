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
cd Build
./EfiRom -e pc-4-5-IntelGopDriver.efi pc-6-7-8-9-IntelGopDriver.efi j4125.efi pc-10-IntelGopDriver.efi pc-11-IntelGopDriver.efi pc-12-13-14-IntelGopDriver.efi 11-J6412.efi 11-n5095.efi 12-1240p.efi 12-n100.efi N2930.efi N3350.efi nb-11-11700h.efi nb-11-1185G7E.efi nb-12-12700h.efi nb-13-13700h.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 6-14.rom

/EfiRom -e pc-4-5-IntelGopDriver.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o pc-4-5.rom

./EfiRom -e pc-6-7-8-9-IntelGopDriver.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o pc-6-7-8-9.rom

./EfiRom -e j4125.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o j4125.rom

./EfiRom -e pc-10-IntelGopDriver.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o pc-10.rom

./EfiRom -e pc-11-IntelGopDriver.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o pc-11.rom

./EfiRom -e pc-12-13-14-IntelGopDriver.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o pc-12-13-14.rom

./EfiRom -e 11-J6412.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 11-J6412.rom

./EfiRom -e 11-n5095.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 11-n5095.rom

./EfiRom -e 12-1240p.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 12-1240p.rom

./EfiRom -e 12-n100.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 12-n100.rom

./EfiRom -e N2930.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o N2930rom

./EfiRom -e N3350.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o N3350.rom

./EfiRom -e nb-11-11700h.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o nb-11-11700h.rom

./EfiRom -e nb-11-1185G7E.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o nb-11-1185G7E.rom

./EfiRom -e nb-12-12700h.efi nb-13-13700h.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o nb-12-12700h.rom

./EfiRom -e nb-13-13700h.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o nb-13-13700h.rom
