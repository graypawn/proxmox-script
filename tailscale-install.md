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

### tailscale
``` bash
curl -fsSL https://tailscale.com/install.sh | sh && systemctl enable --now tailscaled
```

### 서브넷을 위한 수정
``` bash
echo -e "net.ipv4.ip_forward=1\nnet.ipv6.conf.all.forwarding=1" > /etc/sysctl.d/99-custom.conf && sysctl --system
```

### 
반드시 호스트에서 실행하시오

``` bash
command -v pveversion >/dev/null 2>&1 || { echo "This script must be run on the Proxmox VE host, not inside a container."; exit 1; }; sed -i '/^unprivileged/ a lxc.cgroup2.devices.allow: c 10:200 rwm' /etc/pve/lxc/1000.conf && sed -i '/^lxc.cgroup2.devices.allow: c 10:200 rwm/ a lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file' /etc/pve/lxc/1000.conf && echo "LXC config updated successfully."
```

### 드디어 실행
``` bash
tailscale up --advertise-routes=$(ip -o -4 addr show scope global | awk 'NR==1{split($4,a,"/"); split(a[1],b,"."); b[4]=0; print b[1]"."b[2]"."b[3]".0/24"}')
```
