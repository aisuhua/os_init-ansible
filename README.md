# os init ansilbe

初始化操作系统的 Ansible 脚本，适用于 RHEL7/8、Kylin V10 SP1/SP2。

## 使用

```sh
git clone git@github.com:aisuhua/os_init-ansible.git

cd os_init-ansible

# 按需修改主机 IP、主机名、各模块参数等
vim hosts.ini
vim group_vars/all.yaml

ansible-playbook.yaml
```

## Roles 清单

```sh
roles:
  - init
  - hostname
  - timezone
  - dns
  - chrony
  - user
  - file
  - profile
  - repo
  - init_pkg
  - selinux
  - iptables
  - limit
  - ssh
  - safe
  - disable_services
  - cron
```

## 特点

- 适合在国内信创服务器上使用（如 Kylin V10 系列，也适用 RHEL7/8）
- 可方便自定义，没有太多复杂代码
- 尽可能保持了幂等性
- 支持离线环境使用，而且必须自行搭建 yum 源

## repo role 说明

repo 模块用于配置操作系统 yum 源，它不具备通用性，它只适用于满足以下目录设计的 yum 源结构，完整结构请查看 [repo-structure.txt](repo-structure.txt)

```sh
$ tree /data/mirror -L 4
/data/mirror
└── os
    └── linux
        ├── common-addons
        │   ├── aarch64
        │   └── x86_64
        ├── common-loopholes
        │   ├── aarch64
        │   ├── repodata
        │   └── x86_64
        ├── common-updates
        │   ├── aarch64
        │   ├── repodata
        │   └── x86_64
        ├── kylin
        │   ├── common-addons
        │   ├── common-loopholes
        │   ├── common-updates
        │   ├── v10sp1
        │   ├── v10sp2
        │   ├── v7
        │   └── v7update6
        └── rhel
            ├── 5
            ├── 5.3
            ├── 7
            ├── 7.9
            ├── 8
            ├── 8.9
            ├── common-addons
            ├── common-loopholes
            └── common-updates
```

RPM 包按照 `os/linux/[发行版|共享目录]/[版本|共享目录]/[iso|base|updates|addons|loophole]/架构/Packages/*.rpm` 这样的目录结构存放。其中发行版有 kylin 和 rhel 两种，共享目录有 `common-addons`、`common-loopholes` 和 `common-updates`，它们为不同发行版和版本的操作系统共享 rpm 包提供了可能，其中 `common-addons` 是存放第三方软件 rpm 包的位置，`common-loopholes` 是存放漏洞补丁 rpm 包的位置。另外每个版本还划分了 `iso/base/updates/addons/loophole` 5个子目录，`iso` 用于存放从安装介质拷贝出来的 rpm 包，`base` 是同步了官网的 base 源（仅 Kylin 有用），`updates` 是同步了官网的 updates 源（RHEL 存放了与当前主版本相同的最新版本安装介质拷贝出来的 rpm 包，如 RHEL7 就是 RHEL 7.9、RHEL8 就是 8.9（目前最新）），`addons` 存放第三方软件的 rpm 包，`loopholes` 存放漏洞补丁 rpm 包。
