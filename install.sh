#!/bin/bash

# 检查是否已安装ipset
if ! command -v ipset &> /dev/null; then
    echo "系统未安装ipset，请手动安装ipset后再运行此脚本。"
    exit 1
fi

# 设置默认值
default_script_path="/opt"
default_hours="1"

read -p "这个脚本将下载autoipset.sh并设置权限。请输入autoipset.sh的安装路径[$default_script_path]: " script_path
script_path=${script_path:-$default_script_path}

read -p "请输入每隔多少小时执行一次脚本[$default_hours]: " hours
hours=${hours:-$default_hours}

# 验证用户输入的是一个数字
if [[ ! $hours =~ ^[0-9]+$ ]]; then
    echo "输入无效，请输入一个有效的数字。"
    exit 1
fi

read -p "你确定要将autoipset.sh安装到 $script_path，并每隔 $hours 小时执行一次脚本吗？(y/n) " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    # 下载autoipset.sh脚本
    wget https://narizgnaw.github.io/needtobebanned/autoipset.sh -O "$script_path/autoipset.sh"

    # 设置脚本权限
    chmod +x "$script_path/autoipset.sh"

    # 添加crontab任务
    (crontab -l ; echo "0 */$hours * * * sh $script_path/autoipset.sh") | crontab -
else
    echo "安装已取消"
fi