#!/bin/bash

read -p "这个脚本将下载autoipset.sh并设置权限，然后使用crontab每小时运行一次。你确定要继续吗？(y/n) " choice
if [[ $choice == "y" || $choice == "Y" ]]; then
    # 下载autoipset.sh脚本
    wget https://narizgnaw.github.io/needtobebanned/autoipset.sh

    # 设置脚本权限
    chmod +x autoipset.sh

    # 添加crontab任务
    (crontab -l ; echo "0 * * * * /path/to/autoipset.sh") | crontab -
else
    echo "安装已取消"
fi