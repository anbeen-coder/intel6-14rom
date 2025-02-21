Intel 6th-14th Gen PVE Virtual Machine iGPU Passthrough with Custom ROM Usage Guide
(Note: Not supported for Ultra 1st/2nd Gen desktops/laptops. Untested due to lack of hardware.)

Project Forked from EDK2 (2024-12-05 Version)

I. Source Code
This project is based on the EDK2 source code with modifications and additions. For details, refer to the commit history and code diffs.

II. Generation-Specific Notes
1. 12th-14th Gen
Status: Fully functional.
Features:
BIOS display output during boot
OS installation compatibility
GPU driver installation support
HDMI audio output
Breakthrough: Eliminates dependency on closed-source binaries from gzgang/igd.
2. 11th Gen
Status: Partial functionality.
Working Features:
BIOS display output
OS installation
GPU driver installation
Known Issue: No HDMI audio output.
Workaround:
Modify BIOS settings (requires BIOS flashing):
Set iDisplay Audio Link Frequency to 48MHz
Set iDisplay Audio Link T-Mode to 4T (adjust downward if unstable)
Warning: BIOS flashing carries risks. For guidance, refer to Bilibili Tutorial or similar resources.
3. 6th-10th Gen
Requirements:
Enable CSM in BIOS
Set iGPU to Legacy Mode
Configuration:
Use SeaBIOS + i440fx/Q35 in VMs
No custom ROM required (standard ROMs extracted from hardware work).
Refer to existing community guides for implementation details.
This translation preserves technical terminology while adapting to English technical documentation standards. Critical warnings (e.g., BIOS flashing risks) and key configuration parameters are emphasized for clarity.

Here, it mainly addresses the situation where the BIOS of 6th - 10th generation small form - factor PCs or laptops doesn't have the CSM option enabled, or the integrated graphics can't be set to the Legacy mode. For virtual machines, you can only use OVMF + i440fx to load the 6 - 14.rom. However, there are still some minor bugs on some machines, with symptoms similar to those described in this project: https://github.com/my33love/gk41-pve-ovmf  When directly installing Windows 10, there are no issues, and it can be directly connected to a physical monitor. But once the UHD driver is installed, the screen goes black, and you can only access it via RDP remotely. So far, no solution has been found! Ubuntu has been tested to work perfectly. Both during the direct installation and after the installation, the monitor can operate at 4K 60HZ. I encountered the same problem on a J4105 machine. Whether using the latest 6th - 10th generation integrated graphics drivers or those released in 2019 or earlier, the screen will definitely go black once the drivers are installed. This is a bug left in the previous source code, and it has remained unsolved for nearly four years. I can't solve it either, so don't come to me. Some netizens have reported that the black - screen issue after driver installation is due to the hard - disk partition table problem. Using MBR can solve it. I guess that if the screen goes black after installing the integrated graphics drivers on 4th - 10th generation devices, you can try using MBR for the hard - disk during installation. If you really don't know how, try using an IDE hard - disk for the Windows 10 virtual machine. If it solves the problem, please give feedback.

III. Regarding virtual machine model settings
For Intel integrated graphics direct passthrough on 6th - 14th generation devices, uniformly use the OVMF + i440fx model (i440fx versions from at least 7.0 to the latest are all acceptable). Of course, OVMF + q35 is also supported (it's mentioned here just to let you know it's possible. Don't waste your time struggling with it. i440fx is stable enough. I always advise people to abandon the idea of using q35. Just watch these two videos: https://www.bilibili.com/video/BV1gu4m1K7CX and https://www.bilibili.com/video/BV1VS411w7ko. Don't waste time on it. You'll have no troubles with direct - passthrough of discrete graphics using q35).

IV. Regarding source code compilation
If you don't want to compile and just want to use it directly, you can directly use the 6 - 14.rom in the Build folder.
