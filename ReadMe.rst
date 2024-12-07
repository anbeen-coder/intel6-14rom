intel 6-14代pve虚拟机核显直通使用rom 使用说明

本项目fork edk2 2024年12月5日版本



一、关于源码：
在fork edk2 源码基础上，增加或者修改部分文件而来，详细见commit文件和代码差异


二、代数说明：

1、12-14代：完美了， bios画面，安装系统，安装显卡驱动都可以，出hdmi声音。完美突破了gzgang（https://github.com/gangqizai/igd）的不开源，可以不用gzgang的闭源二进制文件了。

2、11代： bios画面，安装系统，安装显卡驱动都可以。就是hdmi声卡出不来，解决办法就是要刷机器bios，把bios里面的两个参数改了或者弄成能设置选择 bios刷进去就好了。大概就是iDisplay Audio Link Frequency改为48mhz，iDisplay Audio Link T-Mode改为4T，如果不行再降低。详见：https://www.bilibili.com/video/BV1Mc41147dA 或者搜b站其他up主他们的教程 。刷bios有风险。

3、6-10代：如果你的机器可以bios开csm并把核显设置为Legacy模式。那你就虚拟机seabios+i440fx或者q35直接用就是，都不需要加载什么rom，即使要加载也是从机器里面提取的而已（具体请参考网上一大堆成功案例。也不需要我这里提供的什么6-14.rom这货）。

我这里是主要针对6-10代小主机或者笔记本等bios没有开csm选项或者没法核显设置为Legacy模式使用，虚拟机只能用ovmf+i440fx加载6-14.rom使用，但是呢有些机器他还是有小bug的，会和这个项目 https://github.com/my33love/gk41-pve-ovmf 中的描述症状一样：WIN10 直通安装没有任何问题，可以正常直通到物理显示器，但是一旦装了UHD驱动就黑屏了，只能RDP远程进去，暂时没找到解决办法！ubuntu测试完美，直通安装与安装完显示器都能在4K 60HZ下工作。我在j4105机器上遇见一样的问题，不管是用最新的6-10代核显驱动还是2019年及以前发布的6-10代核显驱动，只要一驱动了必黑屏。这是前人源代码埋下来的坑，快4年了无人解决，我也解决不了，找我没用。有网友反馈驱动黑屏问题是因为硬盘分区表问题，用mbr就可以了，我估计4-10代如果安装核显后驱动黑屏，大家可以试下安装的时候硬盘用mbr，实在不会就选择ide硬盘给win10虚拟机试试，如果能解决记得反馈。



三、关于虚拟机机型设置：

intel核显直通6-14代统一使用ovmf+i440fx机型（i440fx至少7.0以上到最新都可以），当然也支持ovmf+q35（这个说下是可以的，大家就别去折腾找虐了，i440fx足够稳定了，我都是劝人放弃q35这个想法，q35看看这两个视频就是了 https://www.bilibili.com/video/BV1gu4m1K7CX 和 https://www.bilibili.com/video/BV1VS411w7ko ，别去浪费时间折腾，直接玩独显q35直通没烦恼）



四、关于编译源码

如果你不想编译直接使用，请在Build文件夹中直接使用6-14.rom就是

4.1 编译准备工作：

①、首先下载本项目

git clone https://github.com/lixiaoliu666/intel6-14rom 可能会断掉，请多试几次。你可以使用代理加速（如何切换git clone后的版本自行百度）。
因为只使用编译后的efi以及生成的rom

②、进入intel6-14rom目录运行一下 bash build_efi_rom.sh 成功

③、到Build目录进行操作，合并出来具体型号的rom或者88合一rom 参考build_efi_rom.sh 最后一行命令

    或者你在windows上直接双击运行 cmd运行自动生成88合一rom.bat 就是
  Build目录下的是生成rom必备的各种efi文件及efirom（efirom.exe）

4.2 如何使用

①、nano /etc/default/grub 文件中增加内容
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"

②、nano /etc/modprobe.d/pve-blacklist.conf 文件中增加内容

blacklist i915

blacklist snd_hda_intel

options vfio_iommu_type1 allow_unsafe_interrupts=1

③、执行下面三个命令

update-grub

update-initramfs -u -k all

reboot

④、新建win虚拟机并修改虚拟机参数（nano /etc/pve/qemu-server/100.conf ）为类似下面：

args: -set device.hostpci0.addr=02.0 -set device.hostpci0.x-igd-gms=0x2 -set device.hostpci0.x-igd-opregion=on

bios:ovmf

cpu: host

hostpci0: 0000:00:02.0,legacy-igd=1,romfile=6-14.rom

hostpci1: 0000:00:1f.3

vga: none

machine: pc-i440fx-8.0


选择 ovmf+机型i440fx 7.0以上就是
0000:00:02.0是核显的pci编号

0000:00:1f.3是声卡的pci编号，11-14代基本是这个，6-10代不一定是这个有些是1e.0之类的

6-14.rom这个文件请用winscp等软件传输到/usr/share/kvm/ 目录下

当然unraid也可以使用

4.3 虚拟机开机点不亮bios画面

①、检查下你虚拟机配置如上类似

②、可能我的rom里面没有增加你机器的IntelGopDriver.efi，你使用4.6步骤 获取到你机器的bios，然后使用4.5提取出来IntelGopDriver.efi文件。然后放到\Build目录下，你照着 cmd运行自动生成88合一rom.bat 这个程序增加IntelGopDriver.efi改出来命令行，自己合成88合一rom就是。

③、合并了新的6-14.rom你直接用就是

4.4 如何稳定使用

解决6-14代pve核显直通win10 win11闪屏黑屏花屏不出bios启动画面各种不稳定问题（包括虚拟机内部错误）

①、设置物理机bios核显建议为64m,最大只能512M（配合x-igd-gms=0x10参数使用）

②、设置虚拟机类型为linux，这个很重要！

③、参数x-igd-gms=0x2改为0x8 或者 0x10，最大只能0x10，超过就要报错 Unsupported IGD GMS value 0x11

④、6-14.rom出现点不亮核显直通后bios画面黑屏问题或者1 2 3步骤都弄了都还有花屏闪屏问题的解决办法:

6-14.rom是一个通用的大杂烩rom(吹牛的88合一rom),里面集成了太多的gop.efi文件（这些gop.efi不一定是最新的），这些gop文件在同代cpu不同架构之间（比如12代的n100和12代12700这两种不同架构或者类别cpu）核显直通的时候可能互相干扰，导致核显直通可能只有hdmi接口能点亮bios画面或者只有dp接口能点亮bios画面，或者只有typec接口能点亮bios画面，以及两种接口一起插入都点不亮bios画面等等情况，会让你造成显示接口优先输出的假象，解决办法就是，自己生成单独的rom，只添加一个gop.efi来生成rom（屏蔽掉多个gop.efi加进去出现互相干扰）

比如
EfiRom.exe -e 12-n100.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 6-14.rom

EfiRom.exe -e IntelGopDriver.efi IgdAssignmentDxe.efi PlatformGOPPolicy.efi -f 0x8086 -i 0xffff -o 6-14.rom
这样生成你自己处理器的单独rom后你进行测试 IntelGopDriver.efi你通过提取你物理机bios或者下载的官网bios然后用ubu软件或者mmtool软件进行提取而来。， 0xffff改不改成对应的id无所谓。详见4.5 IntelGopDriver.efi如何得来以及怎么提取出来的。

4.5、IntelGopDriver.efi如何得来

①、用ubu提取物理bios的IntelGopDriver.efi 

UBU 1.79.17下载地址：https://pan.baidu.com/s/1pD7NqJoOThQawJw59NyTHQ 提取码: ivwk

②、物理bios可以到华擎官网下载 https://www.asrockind.com/zh-cn/single-board-computer

里面各个类目都点开试试，?SBC?UTX?NUC等等，intel和amd型号都有哦

③、使用mmtool也可以提取

4.6 物理机的bios如何得来

①、到你机器的官网去下载

②、用AMI bios（ami固件）提取工具 直接提取 类似教程详见 https://www.bilibili.com/read/cv25423474/ 提取物理机bios 部分

4.7、源码来源

https://eci.intel.com/docs/3.0.2/components/kvm-hypervisor.html?highlight=igd

Build OVMF.fd for KVM 中的0001-0004.....patch这4个补丁，这4个补丁和https://bugzilla.tianocore.org/show_bug.cgi?id=935 没有本质区别。

4.8、源码更新了什么

相比较于源码来源更新了什么 请见b站视频源码讲解 https://www.bilibili.com/video/BV1aN411g7sf

Intel 4-14代核显直通源码讲解视频，从此再也没有闭源折腾人了，再也没有秘密可言了，希望后来人继续折腾继续贡献源码

4.9、如果你觉得以上操作都麻烦，可以直接fork本项目，然后直接actions进行云编译,或者直接下载本项目云编译releases里面的6-14.rom和分别的rom https://github.com/lixiaoliu666/intel6-14rom/releases

感谢佛西和蜗牛网友写的actions能够实现本项目自动云编译和云发布releases

也可以使用cmd2001小伙伴的项目地址，直接自动化编译
https://github.com/cmd2001/build-edk2-gvtd
此项目和我这个源码是类似的，实质也是一样的，可以在这个项目里面 提issue，提想法，一起贡献代码。





后记，关于6-10代开bios csm和设置核显为legacy直通如何提取vbios

代码如下：

cd /sys/bus/pci/devices/0000:02:00.0

echo 1 > rom

cat rom > /tmp/vbios.bin

echo 0 > rom

你检查下 /tmp/vbios.bin大小是不是0,0就是失败，不是0就是成功

可以参考这个教程

https://foxi.buduanwang.vip/virtualization/pve/1602.html/
