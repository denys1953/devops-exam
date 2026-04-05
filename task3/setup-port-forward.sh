#!/bin/bash
# Setup port-forwarding via systemd services
# This script runs on the VM as root

set -e

# Stop existing port-forward services
systemctl stop kube-pf-dev.service 2>/dev/null || true
systemctl stop kube-pf-release.service 2>/dev/null || true

# Create systemd service for DEV port-forward
cat > /etc/systemd/system/kube-pf-dev.service << 'EOF'
[Unit]
Description=Kubectl Port-Forward DEV (8002)
After=network.target

[Service]
Type=simple
User=ubuntu
ExecStart=/usr/local/bin/kubectl port-forward svc/django-hello-world-svc 8002:8002 -n dev --address=0.0.0.0
Restart=always
RestartSec=5
Environment=KUBECONFIG=/home/ubuntu/.kube/config

[Install]
WantedBy=multi-user.target
EOF

# Create systemd service for RELEASE port-forward
cat > /etc/systemd/system/kube-pf-release.service << 'EOF'
[Unit]
Description=Kubectl Port-Forward RELEASE (8003)
After=network.target

[Service]
Type=simple
User=ubuntu
ExecStart=/usr/local/bin/kubectl port-forward svc/django-hello-world-svc 8003:8003 -n release --address=0.0.0.0
Restart=always
RestartSec=5
Environment=KUBECONFIG=/home/ubuntu/.kube/config

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable kube-pf-dev.service
systemctl enable kube-pf-release.service
systemctl start kube-pf-dev.service
systemctl start kube-pf-release.service

sleep 3
echo "=== DEV port-forward status ==="
systemctl status kube-pf-dev.service --no-pager || true
echo ""
echo "=== RELEASE port-forward status ==="
systemctl status kube-pf-release.service --no-pager || true
echo ""
echo "✅ Port-forwarding services configured and started"
