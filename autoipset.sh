#!/bin/bash

# 设置IP列表文件路径
IP_LIST_FILE="/opt/iplist.txt"

# 设置ipset的名称
IPSET_NAME="blocked_ips"

# 检查ipset是否已存在，如果不存在则创建
if ! ipset list | grep -q "$IPSET_NAME"; then
    ipset create $IPSET_NAME hash:ip
fi

# 下载IP列表文件
wget -O "$IP_LIST_FILE" "https://narizgnaw.github.io/needtobebanned/iplist.txt"

# 检查文件是否下载成功
if [ -s "$IP_LIST_FILE" ]; then
    # 清空ipset中的旧IP
    ipset flush $IPSET_NAME

    # 读取IP列表文件并添加到ipset
    while IFS= read -r ip; do
        ipset add $IPSET_NAME $ip
    done < "$IP_LIST_FILE"

    echo "IP列表更新成功，已封禁以下IP："
    ipset list $IPSET_NAME
else
    echo "无法下载IP列表文件"
fi

# 删除临时文件
rm -f "$IP_LIST_FILE"