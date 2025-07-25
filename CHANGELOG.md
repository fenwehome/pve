# 更新日志

2025.07.04

- 添加物理机器pve8添加无线网络所需的安装包集合和一键设置脚本

2025.06.10

- 修复nameserves在开设双栈的虚拟机的时候设置格式有误的问题
- 修复上游带非全IPV6地址的(典型例子virtfusion开设的)宿主机导致无法分配IPV6独立地址的问题
- 实验性添加ip6tables全端口映射的方法确保在极其受限的情况下依然可以给虚拟机配置独立的IPV6地址
- 优化MACOS系统在开设过程中对镜像的挂载路径的识别，添加对-lvm名字尾缀的二次尝试
- 在仅使用NAT进行IPV6地址映射时，配置对每个可能的IPV6地址进行链接保活

2025.06.03

- 修复部分函数在信息传递时使用的是echo传递，导致意外的函数输出，修改为使用全局变量进行信息传递

2025.06.02

- 适配NetworkManager迁移场景，自动添加所需的网络接口配置
- 检测到 NetworkManager 的时候自动进行切换，通过 networking 接管网络
- 更新部分说明减少本项目使用歧义

2025.05.18

- 修复CDN抽风情况下，重复尝试获取镜像列表和下载

2025.05.17

- 修复CDN抽风情况下，重复尝试ndp配置文件下载，重复尝试默认的设置文件下载
- 虚拟机开设的时候，强制指定OS Type
- 针对CPU的Type，采取更细化的分类设置，兼容额外的默认设置
- 修复ARM架构下老的上游配置的使用
- ndp的配置设置修改适配至少/112大小的IPV6子网

2025.05.10

- 对ARM架构上PVE安装的上游更新适配
- 放宽PVE安装过程中的主IP识别逻辑，尝试支持物理机
- PVE主体安装流程模块化函数化，方便后续维护

2025.05.09

- 修复ARM架构上开设虚拟机的BUG，添加额外的固件检测和安装
- 优化虚拟机系统模糊匹配机制，优先使用版本较新的镜像
- 添加ARM架构虚拟机系统可用的参数提示，添加Debian系列的ARM镜像，添加模糊匹配
- 增强VMID/CTID检测避免同ID实体创建报错
- 模块化容器CT的创建流程，提取公共函数，方便后续维护

2025.05.08

- 添加MACOS虚拟机开设文件

2025.05.07

- 添加MACOS镜像预下载shell文件
- 删除无效文件

2025.04.21

- 修复ndpresponder.service在前置条件不完全正确时依然启动的问题

2025.04.20

- 修复环境检测的提示和自加载KVM的逻辑，当嵌套虚拟化不可用时，提示可使用QEMU的TCG开设虚拟机
- 修复虚拟机自动开设的所有脚本，支持自动检测自动判断使用host类型还是qemu类型的CPU开设虚拟机
- 调整CDN轮询顺序为随机顺序，避免单个CDN节点压力过大
- 提取公共代码，减少重复逻辑，模块化代码方便维护

2025.04.12

- 修复DigitalOcean的debian12存在不同的debian系统发行版本存在默认命令路径不同的问题

2025.03.29

- 修复Hits徽章访问量统计，使用 https://github.com/oneclickvirt/hitscounter

2025.02.23

- 去除对 cip.cc 的依赖

2025.01.23

- 增加ndpresponder的自动编译，及时更新上游更新。

2024.12.31

- 去除无效的源替换，增加PVE国内镜像源的尝试列表不仅限于清华源

2024.12.14

- 进一步限制ctid和vmid在100到256范围内，避免使用错误的id导致开始失败

2024.12.06

- 增加对web端口映射的检测，如果对应参数设置为0，则不进行公网端口映射

2024.12.01

- 修复可能输入无效的VMID/CTID的问题，开设之前检测有效性

2024.11.16

- 修复自动识别导入后image所在盘路径的位置，避免指定非local盘时路径失效

2024.11.15

- 支持自定义hostname，留空回车时默认为PVE

2024.10.27

- 完全重构删除VM和CT的脚本，考虑更多可能导致删除错误的情况，增加错误排查机制和日志记录

2024.10.20

- 修复在开设NAT的KVM/LXC时，未显式指定bridge的问题，导致的潜在的端口访问问题

2024.10.04

- 修复在ARM的宿主机上进行容器创建时引导检测失败的问题

2024.08.11

- 修复自动修复apt源的代码

2024.06.05

- 更新SSH设置规则，适配Ubuntu24

2024.05.19

- 修复开设PVE的ARM架构的LXC容器时指定系统版本检索错误的问题
- 优化手动指定IPV4地址时，自动识别是否在同子网内，若在同一子网时也进行开设，使用不同的网关配置
- 新增NAT全端口映射的KVM开设虚拟机的脚本

2024.05.15

- 指定额外子网的IPV4地址生成虚拟机时，强制指定虚拟机内的IPV4的子网掩码为/32

2024.05.13

- 较新的Ubuntu/Debian系统可能自带密码禁用验证策略，修复开放密码验证策略

2024.04.25

- 修复 hostname 可能设置失败的问题
- 修复面板地址可能绑定到IPV6上的问题，强制监听IPV4的端口
- 修复KVM开设独立IPV4的虚拟机时，可能遇到的查询宿主机IP区间和网关地址失败的问题
- 优化独立IPV4地址的虚拟机开设的脚本，强制要求手动附加地址的时候附加IP非同子网，而自动附加时需要附加IP同子网
- 优化手动附加地址的时候附加IPV4可指定MAC地址
- 上述脚本错选时增加更换脚本的提示

2024.03.12

- 迁移仓库至于组织仓库，方便协同维护

2024.02.21

- 增加LXC容器开设的自修补镜像源：https://github.com/oneclickvirt/lxc_amd64_images
- LXC容器开设的源优先级：自修补 > 手动修补 > 官方源

2024.02.20

- 优化环境检测脚本，IPV6不可用时不检测SLAAC配置

2024.02.19

- 优化CT创建的系统选择判断，支持宽泛的无指定具体版本的系统

2024.02.18

- 修复低版本PVE删除非企业订阅弹窗可能失效的问题
- 使用 https://github.com/oneclickvirt/lxc_arm_images 归档的ARM架构的LXC镜像以支持可开设更多不同系统的ARM容器镜像，不再局限于Ubuntu和Debian系统
- 修复ARM架构下纯IPV6的容器开设有问题

2024.02.17

- 修复X86架构下，debian9安装的PVE无法解压zst格式的LXC容器预制模板的问题
- 初步修复x86架构下批量重启容器会有内网IP错误重载的问题，在预制容器模板的过程中使用非平凡的net0名字以避免网络在后续使用过程中不自重设的问题

2024.02.16

- 修复IPV6配置后的可用性检测，增加提示信息
- 修复ARM的服务器安装PVE时遇到的部分镜像链接不可用的情况，使用ping和curl双重检测确保链接的可用性
- 修复ARM架构下无法安装PVE6.x以及更低版本的问题，切换使用另一个项目的源进行低版本的pve安装

2024.02.09

- 尝试适配 devuan opensuse 待适配 gentoo
- 修复使用GitHub的API的Release存在缓存延迟的问题，切换使用raw链接获取文件名字

2024.02.08

- LXC模板构建自定义的模板提前初始化好部分内容，避免原始模板过于干净导致初始化时间过长，优先级：自修补镜像 > 官方镜像
- 已预先安装设置模板的容器仓库：[https://github.com/oneclickvirt/pve_lxc_images](https://github.com/oneclickvirt/pve_lxc_images)
- 修复镜像在下载后重复使用可能重复下载的问题
- 增加适配 alpine fedora archlinux 待适配 devuan opensuse gentoo
- 大幅缩短LXC容器开设时间(在使用自修补镜像时)
- 增加下载镜像失败时的错误处理

2024.02.04

- 增加IPV6的子网掩码识别的精确度
- 修复部分提示信息避免误导

2024.02.02

- 修复网关自动配置的时候，可能出现IPV6网络配置未加载的情况，增加预先的请求加载配置

2024.01.31

- 增添每日实时更新的KVM镜像源，实现自动修补原始镜像进行初始化
- 修改部分提示和描述

2024.01.09

- 增加初始的DNS配置备份
- 增加SLAAC处理逻辑，若存在SLAAC机制分配的IPV6地址，则需要用户选择是否使用最大IPV6子网范围

2023.12.31

- 增加一个删除对应容器/虚拟机的脚本，避免在删除过程中删除了非对应的映射规则
- 修复批量开设时最后一个循环后续没有要等待的内容还去等待的问题

2023.12.27

- 修复部分宿主机安装过程中可能存在```firmware-ath9k-htc```需要移除的情况

2023.12.21

- 修复部分宿主机和LXC容器不含定时任务机制的问题

2023.12.20

- 增加IPV6网络保活的定时任务，避免长期不使用导致V6的ndp广播缓存失效

2023.12.08

- 有的商家双重配置有别名的网卡，实际没有使用但会卡脚本，现自动删除无效网卡

2023.12.03

- 修复可能的hostname的自动修改导致网络不通的问题，尝试解决默认V4为内网V4的情况
- 修复限定仅在子网前缀识别出现问题时才重构ipv6地址匹配前缀
- 适配宿主机的IPV6子网可能是/48甚至更大的情况

2023.11.27

- 完善IPV6检测机制，尽量保证识别出准确的IPV6子网掩码和子网前缀，且尽量保证ndp可用

2023.11.26

- 重新计算IPV6子网的前缀，适配宿主机虽然给了子网但默认的IPV6地址是随机给的，非```::1```或```::a```结尾的情况
- 重新设计虚拟机/容器的IPV6网关配置逻辑，适配宿主机的IPV6的gateway可能恰好是该子网第一个IPV6的情况

2023.11.25

- 放松IPV6的gateway判断条件，部分宿主机的gateway直接通过```ip -6 route add default via```加上去的还行，此时虽然fe80地址不通，但不影响v6使用

2023.11.24

- 修复特殊的宿主机绑定了非IPV6子网内的额外的IPV6地址，且此额外的IPV6地址不能直接删除(会导致虚拟机网关不通)，需要接在vmbr0上，IPV6子网的IPV6需要接到vmbr2上，已修复

2023.11.22

- 修复可能检测私网IPV6失灵的情况，完善检测逻辑
- 修复宿主机内可能绑定不止一个IPV6地址的情况，只测试地址最长的公网IPV6地址
- 修复DNS可能在添加PVE的证书后被重置为空的问题

2023.11.18

- 修复适配宿主机本身IPV6环境可能fe80地址未加白的情况
- 修复部分宿主机本身绑定了两个IPV6地址，且二者的子网掩码大小不同的情况，使用其中范围更大的子网掩码
- 修复了部分宿主机网关抽风自动识别MAC地址错误，导致重启后丢失网络的情况，给物理网关绑定死了MAC地址

2023.11.05

- 修复创建CT时可能存在的IPV6的分配问题

2023.11.02

- 尝试在网关构建过程中支持IPV6隧道做为虚拟网关之一，失败了
- 尝试在网关构建过程中支持IPV6隧道做为被桥接的网关，测试已成功
- 去除至少/64子网大小的限制

2023.10.22

- 设置LXC容器开设后，重启不再覆写更改后的配置

2023.10.09

- 修复国内宿主机开设容器时，由于网络与官方的包管理源链接非常不通畅，使用第三方镜像地址加速

2023.10.03

- 修复开设带IPV6地址的虚拟机时，网关顺序错配的问题
- 更新开设出的虚拟机的nameserver和searchdomain设置，避免某些机器在解析域名时出错

2023.09.16

- 修复DNS修补过程中可能存在的判断漏洞
- 修复可能存在的ndp的sysctl设置问题
- 修复可能存在的网关的路由缓存问题，增加自动修复的守护进程

2023.09.15

- 迁移了KVM镜像中Centos8-Stream的所在地址

2023.09.07

- 修复默认的物理接口如果带altname时自动检测部分别名是否可附加，如果不可附加自动删除

2023.09.01

- 前置的环境检测增加是否是debian系统的检测，优化部分检测逻辑
- 主体安装的脚本前移二次环境检测，避免已修改了部分内容还去检测是否能安装，此时再判断已经迟了
- 优化IPV4地址检测，增加对 RFC 6598 地址的判断
- 前置的环境检测优化内存的检测，如果Swap不为0则包含Swap

2023.08.29

- 判断IPV6是否未dhcp类型，如果是则检测是否已分配IPV6地址，如果未分配则删除对应配置避免冲突

2023.08.27

- 将删除物理网关的操作移动到创建vmbr0之前，而不是原来的创建vmbr1之前

2023.08.26

- 修复开设NAT网关时，vmbr0如果不存在就去补全时的漏洞，尝试支持第一第二步安装PVE不使用本仓库脚本的PVE创建NAT网关
- 给IPV6的识别增加ping检测，如果ping不通当作IPV6不通，避免有的商家设置的IPV6本身就有问题根本用不了还配置，导致安装出问题

2023.08.23

- ndppd增加ARM架构的支持
- 修复了非独立IPV6的CT重启失败的问题，独立IPV6的CT可能还是会重启失败无法启动(目前测试ARM会重启出问题，X86的全部无问题)
- 选择开设带独立IPV6地址的服务前增加ndppd的检测，如果其状态异常则自动退出脚本

2023.08.22

- 使用ndppd进行独立IPV6映射解决MAC校验的问题，实测成功

2023.08.20

- iptables的映射存在重复的问题，已尝试修复
- 尝试在写入NAT网关的同时删除无用的原有网关配置，避免可能存在的问题

2023.08.15

- 尝试增加Docker安装PVE的方法以适配宿主机不是Debian的情况，实测支持Ubuntu了，其他支持Docker的宿主机系统应该也没问题

2023.08.11

- 修复部分上次更新导致的新BUG，测试无误了

2023.08.09

- 判断是否有IPV6网络，如果没有则宿主机就不添加对应的V6的DNS
- 判断是否有IPV6网络，如果没有则开设的虚拟机和容器就不添加对应的V6的DNS
- 修复带IPV6环境的容器设置ssh时，需要重启容器才能保证容器内网络联通的问题，自动判断是否需要自重启容器

2023.08.04

- 开设独立IPV4地址的虚拟机时，尝试增加自动附加IPV6地址的功能
- 增加一键开设纯IPV6虚拟机、纯IPV6容器的脚本
- 修复可能的dns-nameservers存在多行导致网络异常的问题
- 特殊处理没有ifupdown的宿主机

2023.08.03

- 尝试增加了IPV6的支持，暂时只是支持了IPV6网关的设置，暂时未适配一键开设，明日适配
- 简化IPV4和IPV6地址的查询，避免重复查询
- 修复可能的grub更新错误
- 网络配置文件备份修改顺序，避免重复备份
- 增加已修改过的文件的备份
- KVM虚拟机增加centos8-stream镜像源

2023.08.02

- 更新KVM虚拟机镜像源，支持更多系统
- 修复部分虚拟机开设时自定义硬盘大小失败的问题，增加设置间隔，避免硬盘IO爆炸

2023.07.31

- 修复部分机器重启机器后失联的情况(Hetzner、Azure)
- 增加自动时间校准功能
- 加速系统熵计算
- 修复创建虚拟机和容器的一键脚本分别适配ARM和X86_64的情况
- 重构物理接口检测函数，保证检测到的接口顺序与```ip addr show```一致
- 优化ssh.sh文件，如果开设debian的LXC容器时，遇到中国宿主机，对应自动替换apt源

2023.07.30

- 适配了ARM架构且已在hz的ARM机器上测试(Debian11及其更旧的系统)无问题，感谢[Proxmox-Arm64](https://github.com/jiangcuo/Proxmox-Arm64)提供的第三方补丁，本项目目前支持X86_64架构和ARM架构了
- 修改部分附加文件的存储位置至于```/usr/local/bin/```目录下
- CN的IP检测增加一个检测源，对CN的特殊处理增加对APT源的特殊处理
- 有些奇葩机器的apt源老有问题，增加自动修复的函数

2023.07.28

- 部分原生的厂商给的apt源有问题，不是官方源，比如Azure需要进行特殊处理，特转换archive为官方源以支持pve的安装，已修复该问题
- 整合网络修改部分的代码到同一个函数中，方便后续维护

2023.07.24

- 增强ssh.sh脚本开设ssh服务的能力，避免默认配置了cloudinit导致的问题

2023.07.06

- 增加公网私网IPV4地址的检测

2023.07.02

- 修复部分机器的网络配置重复行的部分空格数量不一致导致未识别出重复的问题
- 修复部分网络配置的子目录有写但不使用的情况，这种情况就不需要合并配置文件了，修复了之前强制合并的问题
- 修复适配部分机器默认防火墙是开启且屏蔽了部分端口的情况

2023.06.30

- 修复部分机器的网络配置是热加载，写在/run/network/interfaces.d/文件夹下的问题
- 修复安装proxmox-ve时grub-pc配置可能冲突的问题

2023.06.29

- 规整输出，所有输出修改为中英双语
- 修改部分脚本提示避免脚本被小白重复执行

2023.06.26

- 修复ipv6网络是SLAAC动态分配时vmbr0的设置导致宿主机没有V6网络的问题

2023.06.25

- 特化修复在Hetzner上安装需要DD系统再安装的问题，现在安装原生debian系统也支持了
- 修复部分机器使用浮动IP，没有/etc/network/interfaces文件的问题，自动生成对应文件
- 修复部分机器启动后，DNS检测失败的问题，确保在网关添加后必自动检测一次保证DNS无问题

2023.06.24

- 修复部分机器是IPV6子网前缀识别失效的问题
- 更新Debian12安装的PVE版本为stable
- 修复部分机器ifconfig命令不存在的问题
- 适配部分机器ipv6网络是SLAAC动态分配的情况
- 适配pve8.0的非订阅用户弹窗进行删除

2023.06.23

- 网关配置修改使用新结构，以便于适配大多数机器
- 调整安装的流程，升级软件包后需要重启一次系统，详见脚本的运行提示
- 解决了ifupdown2的安装问题，支持在更多商家的服务器上安装

2023.06.22

- PVE安装修复部分机器网络设置不立即重新加载的问题，增加网络设置备份
- 部分机器的IPV6物理接口使用auto类型，无法安装PVE，修改为static类型并重写配置
- 由于上面这条修复，已支持在Linode平台安装PVE了
- 修复低版本PVE还安装ifupdown2的问题，7.x以下版本使用ifupdown也足够了
- 由于上面这条修复，Hetzner的Debian10系统可以安装PVE了，但只可安装主体，不能自动设置网关

2023.06.21

- 增加手动指定IPV4地址的脚本
- PVE安装修复部分系统原生网络设置有问题的情况
- 修复NAT网关自动设置时部分机器的物理接口存在别名的情况，已自动识别替换别名

2023.06.14

- 修改ssh.sh文件以适配不同的系统启用SSH端口和服务
- 修改create_ct.sh文件及相关文件，增加适配支持开设centos系的系统的CT容器

2023.06.13

- 修改部分提示，避免错误的操作流程
- 增加对apparmor的依赖修复，避免安装apparmor在部分模板上卡死未成功安装
- 适配Debian12系统
- 重新整合组件安装部分的代码，优化代码结构
- 修改网关写入的文件，判断物理接口是否允许桥接，无配置的设置为允许

2023.06.06

- 修复检测过程中遇到系统盘以TB为单位的识别问题，适配系统盘以TB或GB单位计算
- 修复安装过程中部分奇葩模板可能出现的依赖问题，使用--fix-missing命令修复依赖

2023.06.05

- 创建IPV4的NAT网关时检测IPV4的方法改为使用ip addr show检测，不再使用ip route，这样可以带上IP区间不写死
- 自动检测IPV6子网是否存在，如果存在则绑定vmbr0，不存在则只绑定IPV4
- 更改部分说明的描述

2023.06.04

- 增加一键开设独立IPV4虚拟机的脚本，支持一键生成独立IPV4的KVM虚拟化的虚拟机
- 修改创建KVM虚拟机过程中预下载镜像前CDN检测的逻辑问题，如果已存在镜像则不再检测CDN有效性，因为无需通过CDN下载镜像文件
- 更新中文文档部分说明

2023.06.03

- 更新支持自动修复apt源缺失公钥的问题，不再需要手动修复
- 暂时移除静态动态地址转换，默认的是DHCP或静态的IP不再进行识别和转换，后续替换为别的方式解决
- NAT网络构建前检测lshw包是否存在是否需要下载，保证物理设备的识别能成功(部分奇葩的系统模板不自带该工具包)
- 更新中文文档部分说明

2023.05.30

- 更新支持批量开设的虚拟机或容器自定义系统，默认留空为debian11系统
- 更新修复使用批量开设前检测挂载盘系统盘的问题，暂时移除检测，后续修复检测
- 更新中文文档部分说明

2023.05.29 

- 增加自动写入NOTE的功能，开出的容器和虚拟机将自带对应的配置信息，不用再在命令行中使用cat查看了(但原有的配置信息文件还将存在，否则无法使用批量命令批量创建)

2023.05.20

- 增加支持开设的虚拟机和容器可自定义开设在挂载盘还是系统盘，默认留空使用系统盘local

2023.04.24 

- 更新支持国内腾讯云阿里云的Debian系安装PVE和开设LXC容器，由于国内机器非独服基本不开嵌套虚拟化支持，所以只能开LXC
- 更新支持创建vmbr0，母鸡允许addr和gateway为内网IP或外网IP，已自动识别替换

2023.04.23

- 支持一键生成LXC或KVM虚拟化的NAT服务器
- 支持批量开设，多次运行批量开设LXC或KVM虚拟化的NAT服务器，重复运行继承配置
- 开出的容器和虚拟机都自带IPV4内外网端口转发

2023.04.11 

- 更新支持一键生成单个KVM虚拟化的NAT服务器(自带内外网映射)
- 更新PVE自修改qcow2文件，已预开启安装cloudinit，开启SSH登陆，预设值SSH监听V4和V6的22端口，开启允许密码验证登陆，开启允许ROOT登陆

2023.04.04

- 开发了基于PVE的 [ConvoyPanel](https://github.com/ConvoyPanel/panel) 一键安装脚本
- PVE一键安装是ConvoyPanel一键安装的前提，创建NAT网关不是
- 修复PVE在VPS上一键安装可能遇到的各种BUG
