### 电源管理
> 参考 [电源管理](https://wiki.archlinux.org/index.php/Power_management_(简体中文))

术语
1. suspend: 挂起到内存, 类似与 windows 的睡眠.
2. hibernate: 休眠, 将内存中的数据dump到disk, 断电后仍可以恢复.
3. hybrid-sleep: 混合睡眠, 同时执行睡眠和休眠: 断电时从disk回复, 未断电从内存恢复. 其他还有延迟休眠等.

#### 休眠支持
> 参考: [Suspend and hibernate](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate_(简体中文))

术语介绍
1. `/sys/power/image_size`: image_size 用于控制将内存 dump 到硬盘时所占空间的大小, 在dump内存时, 系统尽量保证所占用的硬盘空间不会超过image_size设置的大小(dump内存到disk时会压缩数据). 默认是内存的2/5, 增大该值将提升休眠速度, 减小该值将减少空间占用
    - 参考 [swap_partition](https://wiki.archlinux.org/index.php/Power_management/Suspend_and_hibernate#About_swap_partition.2Ffile_size)

启用休眠支持
1. 创建 swap 分区: 休眠需要将内存中的内容写入swap分区, 建议大小与内存大小相同, 或与所使用的内存大小相同. (swap分区创建参照 arch安装文档)
2. (可选)修改 `/sys/power/image_size` 为swap大小. (这里我设置的是32G)
    - `sudo tee /etc/tmpfiles.d/modify_power_image_size.conf <<< "w /sys/power/image_size - - - - 34359734272"`
3. 在bootloader中添加resume参数: 参考 _Suspend and hibernate_
    ```Bash
    vim /etc/default/grub
    # 示例, 注意更换 /dev/sda3 为自己电脑上 交换分区 的位置
    GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable"  ==> GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_pstate=enable resume=/dev/sda3"
    # 更新 grub 配置
    grub-mkconfig -o /boot/grub/grub.cfg
    
    vim /etc/mkinitcpio.conf
    # 示例, 添加了 resume
    HOOKS="base udev autodetect modconf block filesystems keyboard fsck" ==> HOOKS="base udev resume autodetect modconf block filesystems keyboard fsck"
    # 重新生成 initramfs 镜像
    mkinitcpio -p linux
    ```

其他参考
- [Archlinux休眠设置](https://www.cnblogs.com/xiaozhang9/p/6443478.html)

#### DPMS
> 参考 [Display_Power_Management_Signaling](https://wiki.archlinux.org/index.php/Display_Power_Management_Signaling_(简体中文))

DPMS 可以在计算机一定时间无操作时, 锁定/休眠计算机 或 将显示器置于节电模式. 配置文件为 `/etc/systemd/logind.conf`, 可通过 `man logind.conf` 查看具体信息.
- 使配置生效: `systemctl restart systemd-logind`