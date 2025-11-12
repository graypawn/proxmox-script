# proxmox-script
proxmox의 LXC, VM의 설치를 자동화 하기 위한 스크립트 모음

### curl install
``` bash
apt-get update && apt-get upgrade -y && apt-get install curl -y
```

### sshd 원라인
``` bash
bash -c 'set -euo pipefail; SSHD_CONFIG="/etc/ssh/sshd_config"; cp "$SSHD_CONFIG" "${SSHD_CONFIG}.bak"; echo "[INFO] Backup created at ${SSHD_CONFIG}.bak"; if grep -q "^#PermitRootLogin" "$SSHD_CONFIG"; then sed -i "s/^#PermitRootLogin.*/PermitRootLogin yes/" "$SSHD_CONFIG"; elif grep -q "^PermitRootLogin" "$SSHD_CONFIG"; then sed -i "s/^PermitRootLogin.*/PermitRootLogin yes/" "$SSHD_CONFIG"; else echo "PermitRootLogin yes" >> "$SSHD_CONFIG"; fi; echo "[INFO] PermitRootLogin set to yes"; systemctl restart sshd; echo "[INFO] SSH service restarted"'
```

