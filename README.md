# PVE

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2FspiritLHLS%2Fpve&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

感谢 Proxmox VE 的免费订阅支持

如果有未适配的商家或机器欢迎联系[@spiritlhl_bot](https://t.me/spiritlhl_bot)，有空会尝试支持一下

待开发内容：

- KVM/LXC模板加载部分自定义的限制，避免机器用于滥用发包
- LXC模板构建自定义的模板提前初始化好部分内容，避免原始模板过于干净导致初始化时间过长

## 更新

2023.11.26

- 重新计算IPV6子网的前缀，适配宿主机虽然给了子网但默认的IPV6地址是随机给的，非```::1```或```::a```结尾的情况
- 重新设计虚拟机/容器的IPV6网关配置逻辑，适配宿主机的IPV6的gateway可能恰好是该子网第一个IPV6的情况

[更新日志](CHANGELOG.md)

## 说明文档

国内(China)：

[virt.spiritlhl.net](https://virt.spiritlhl.net/)

国际(Global)：

[www.spiritlhl.net](https://www.spiritlhl.net/)

说明文档中 Proxmox VE 分区内容

[https://github.com/oneclickvirt/kvm_images](https://github.com/oneclickvirt/kvm_images) 为对应虚拟机镜像仓库

## Stargazers over time

[![Stargazers over time](https://starchart.cc/spiritLHLS/pve.svg)](https://starchart.cc/spiritLHLS/pve)

## 友链

VPS融合怪测评脚本

https://github.com/spiritLHLS/ecs
