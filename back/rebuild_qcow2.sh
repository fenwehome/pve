#!/bin/bash

if ! command -v virt-customize &> /dev/null
then
    echo "virt-customize not found, installing libguestfs-tools"
    sudo apt-get update
    sudo apt-get install -y libguestfs-tools
fi

if ! command -v rngd &> /dev/null
then
    echo "rng-tools not found, installing rng-tools"
    sudo apt-get update
    sudo apt-get install -y rng-tools
fi

qcow_file=$1
echo "转换文件$qcow_file中......"
echo "启用SSH功能..."
virt-customize -a $qcow_file --run-command "systemctl enable ssh"
virt-customize -a $qcow_file --run-command "systemctl start ssh"
echo "启用root登录..."
virt-customize -a $qcow_file --run-command "sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config"
virt-customize -a $qcow_file --run-command "sed -i 's/#Port 22/Port 22/g; s/#AddressFamily any/AddressFamily any/g; s/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g; s/#ListenAddress ::/ListenAddress ::/g' /etc/ssh/sshd_config"
virt-customize -a $qcow_file --run-command "systemctl restart sshd"
echo "创建备份..."
cp $qcow_file ${qcow_file}.bak
echo "复制新文件..."
cp $qcow_file ${qcow_file}.tmp
echo "覆盖原文件..."
mv ${qcow_file}.tmp $qcow_file
rm -rf *.bak
echo "$qcow_file修改完成"