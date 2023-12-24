#!/bin/bash

    echo "这个脚本功能为：使用crontab周期自动下载IP黑名单，并使用IPSET进行封禁"

# 检查是否已安装ipset
    echo "正在检测系统是否安装了IPset"
if ! command -v ipset &> /dev/null; then
    echo "系统未安装ipset，请手动安装ipset后再运行此脚本。"
    exit 1
fi

# 设置默认值
default_script_path="/opt"
default_hours="1"

read -p "这个脚本将下载autoipset.sh并设置权限。请输入autoipset.sh的安装路径[默认是$default_script_path]: " script_path
script_path=${script_path:-$default_script_path}

read -p "请输入每隔多少小时执行一次脚本[默认是$default_hours]: " hours
hours=${hours:-$default_hours}

# 验证用户输入的是一个数字
if [[ ! $hours =~ ^[0-9]+$ ]]; then
    echo "输入无效，请输入一个有效的数字。"
    exit 1
fi

read -p "你确定要将脚本下载到 $script_path，并每隔 $hours 小时执行一次脚本吗？(y/n) " choice
if [[ $choice == "y" || $choice == "Y" || $choice == "" ]]; then
    # 下载autoipset.sh脚本
    wget https://narizgnaw.github.io/needtobebanned/autoipset.sh -O "$script_path/autoipset.sh"

    # 设置脚本权限
	echo "正在设置脚本权限，报错的话一般是没有使用root账户运行"
    chmod +x "$script_path/autoipset.sh"

    # 添加crontab任务
	echo "正在添加定时任务，报错的话一般是没有使用root账户运行"
    (crontab -l ; echo "0 */$hours * * * sh $script_path/autoipset.sh") | crontab -
	# 更新iptables规则
	echo "正在更新iptables规则，首次安装会显示Bad rule正常的"
	iptables -D INPUT -m set --match-set blocked_ips src -j DROP
	iptables -I INPUT -m set --match-set blocked_ips src -j DROP
    echo "已运行完成，如果没有报错，脚本将每隔 $hours 小时自动执行一次，请确认你已经接入互联网"
	echo "可以通过crontab -e命令查看配置的定期任务情况"
    echo "可以通过ipset list命令查看已经封禁的IP"
else
    echo "安装已取消"
fi


