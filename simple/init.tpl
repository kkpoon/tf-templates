#!/bin/sh

apt-get update -y
apt-get install -y nginx

rm -rf /var/www/html/*
echo -n "Hello World" > /var/www/html/index.html
