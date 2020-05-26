#!/bin/bash

# install Nginx
sudo apt update
sudo apt install nginx -y

# Replace HTML FILE
EC2IDENTITY="$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document)"

sudo tee -a /var/www/html/index.nginx-debian.html >/dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width">
  <style>
    textarea {
      width: 100%;
      height: 250px;
    }
  </style>
</head>
<body>
  <textarea name="" id="myTextarea" readonly>${EC2IDENTITY}</textarea>
</body>
</html>
EOF

# Enable Firewall
sudo ufw app list
sudo ufw allow 'Nginx HTTP'
sudo ufw status
