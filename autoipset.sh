#!/bin/bash

# ����IP�б��ļ�·��
IP_LIST_FILE="/opt/iplist.txt"

# ����ipset������
IPSET_NAME="blocked_ips"

# ���ipset�Ƿ��Ѵ��ڣ�����������򴴽�
if ! ipset list | grep -q "$IPSET_NAME"; then
    ipset create $IPSET_NAME hash:ip
fi

# ����IP�б��ļ�
wget -O "$IP_LIST_FILE" "https://narizgnaw.github.io/needtobebanned/iplist.txt"

# ����ļ��Ƿ����سɹ�
if [ -s "$IP_LIST_FILE" ]; then
    # ���ipset�еľ�IP
    ipset flush $IPSET_NAME

    # ��ȡIP�б��ļ�����ӵ�ipset
    while IFS= read -r ip; do
        ipset add $IPSET_NAME $ip
    done < "$IP_LIST_FILE"

    echo "IP�б���³ɹ����ѷ������IP��"
    ipset list $IPSET_NAME
else
    echo "�޷�����IP�б��ļ�"
fi

# ɾ����ʱ�ļ�
rm -f "$IP_LIST_FILE"