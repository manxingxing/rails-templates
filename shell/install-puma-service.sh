# After installing or making changes to puma.service
systemctl daemon-reload

# Enable so it starts on boot
systemctl enable puma.service

# Initial start up.
systemctl start puma.service

# Check status
systemctl status puma.service

# A normal restart. Warning: listeners sockets will be closed
# while a new puma process initializes.
systemctl restart puma.service
