# Arch Linux 安装

- [Arch Linux 手册](https://wiki.archlinux.org/index.php/Main_page_(简体中文))
- [Arch Linux的原则](https://wiki.archlinux.org/index.php/Arch_Linux_(简体中文))

## 安装
- [Arch Linux安装教程](https://wiki.archlinux.org/index.php/Installation_guide_(简体中文))

###  准备
1. 刻录U盘安装
    - Linux环境: `dd bs=4M if=/path/to/archlinux.iso of=/dev/sdx status=progress && sync`. (注意替换iso路径和U盘路径)
2. 重启电脑, 选择U盘启动
    - Thinkpad: 开机回车, 然后f12进入挂载启动页, 选择刻录的U盘即可.

注意查看是否报错.

### 预配置系统
1. 链接wifi: `wifi-menu`
    - 因为 arch 默认网络安装, 所以要保证在有网的情况下进行.
2. 使用parted格式化硬盘为GPT分区 (GRUB/UEFI引导需要分区格式为GPT)
    - [GURB引导](https://wiki.archlinux.org/index.php/GRUB_(简体中文)#UEFI_.E7.B3.BB.E7.BB.9F)
    - [Parted工具](https://wiki.archlinux.org/index.php/GNU_Parted_(简体中文) ): parted比fdisk功能更多, 这里主要用来设置硬盘为gpt格式.
    ```Bash
    fdisl -l                // 查看分区类型
    // parted
    parted>> mklabel gpt    // 格式化为 gpt 分区
    ```
3. 分区方案: `fdisk /dev/sda`
    - efi 分区: `512M`
    - swqp 分区: 实际内存 `小于2G: 2G;   2G~8G: 内存同大小;    大于8G: 8G`.
    - 推荐 `/home, /usr/local/` 单独分区, 一个存放个人资料, 一个存放个人程式
    - `/tmp, /var` 根据需要决定是否单独分区(某些服务器需要单独设置, 避免临时文件填充满整个系统)
    - 剩下的所有可用空间给 `/`
4. 格式化:
    - `mkfs.fat /dev/sda1`: efi分区
    - `mkswap /dev/sda2`: 格式化swap分区;  `swapon/off /dev/sda2`: 挂载/卸载 swap 分区
    - `mkfs.ext4 /dev/sda3`: 格式化其他分区
5. 挂载分区
    - `mount /mnt /dev/sda3`: 挂载 `/` 目录
    - `mkdir /mnt/boot && mount /dev/sda1`: 创建boot目录并挂载 `efi` 分区
    - `mkdir /mnt/home && mount /dev/sda4`: 创建home目录并挂载 `home` 分区
6. 更改默认源: 修改 '/etc/pacman.d/mirror', 将China的源复制到最前面即可.(建议163或者阿里的源)
6. 安装基本系统: `pacstrap /mnt base base-devel`
    - `base-devel`: 开发基本工具包
7. 生成并检查 fstab 文件: `genfstab -U /mnt >> /mnt/etc/fstab`
8. 切换到新系统: `arch-chroot /mnt`

部分比较麻烦的设置待系统装完后在设置.

### 配置系统
1. 设置时区并更新时间: `ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && hwclock --systohc`
2. 修改主机名: `echo "x1" >> /etc/hostname`
3. **无线网络配置**: 
    - 安装必备软工具: `pacman -S dialog wpa_supplicant`
    - 拷贝无线网配置文件: `mv etc/netctl/xx /mnt/etc/netctl/`. (注意, 这一步在 `exit` 退出arch后完成拷贝)
4. 设置密码: `passwd`
5. 设置grub引导: `pacman -S grub efibootmgr && grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub && grub-mkconfig -o /boot/grub/grub.cfg`
    - [GURB引导](https://wiki.archlinux.org/index.php/GRUB_(简体中文)#UEFI_.E7.B3.BB.E7.BB.9F)
    - [Parted工具](https://wiki.archlinux.org/index.php/GNU_Parted_(简体中文))
    - 流程解释:
        - 安装工具包:`pacman -S grub efibootmgr`
        - 设置启动目录, 引导程序, 挂载分区:`grub-install --target=x86_64-efi --efi-directory=esp_mount --bootloader-id=grub`. (注意替换必要参数)
        - 生成配置文件: `grub-mkconfig -o /boot/grub/grub.cfg`
6. Intel/AMD CPU启用微码更新
    - Intel: `pacman -S intel-ucode`
7. 退出并系统: `exit`
8. 拷贝第二步的无线配置, 然后重启系统

