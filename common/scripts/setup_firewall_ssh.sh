#!/bin/bash

# Firewall setting
sudo ufw app list
sudo ufw allow OpenSSH
sudo ufw enable
sudo ufw status
