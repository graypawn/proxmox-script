#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

SSHD_CONFIG="/etc/ssh/sshd_config"

# 백업 먼저 만들기
cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"
echo "[INFO] Backup created at ${SSHD_CONFIG}.bak"

# PermitRootLogin 설정 변경
if grep -q "^#PermitRootLogin" "$SSHD_CONFIG"; then
    # 주석된 라인 제거 후 yes로 변경
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
elif grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then
    # 이미 있는 라인 yes로 변경
    sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"
else
    # 없는 경우 마지막 줄에 추가
    echo "PermitRootLogin yes" >> "$SSHD_CONFIG"
fi

echo "[INFO] PermitRootLogin set to yes"

# SSH 서비스 재시작
if systemctl is-active --quiet sshd; then
    sudo systemctl restart sshd
    echo "[INFO] SSH service restarted"
else
    sudo systemctl start sshd
    echo "[INFO] SSH service started"
fi
