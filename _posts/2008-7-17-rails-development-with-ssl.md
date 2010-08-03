--- 
layout: post
title: Rails Development with SSL
---
## Big Picture

[Nginx](http://nginx.net/) will accept connection on ports 80 (http) and https (443). Under SSL/TLS nginx will negotiate the encryption and proxy any requests that it cannot serve to our trusty [mongrel](http://mongrel.rubyforge.com/) running on port 3000. Mongrel doesn't handle encrypted traffic, instead we pass a flag (X_FORWARDED_PROTO) that indicates the request came over SSL.

## Prerequisites

You will need a functioning [Macports](http://macports.com/) installation and a functioning development environment (i.e. you can browse your project at localhost:3000).

## Conventions

`$` indicates a standard shell prompt.
`#` indicates the command needs to be run as the root user by assuming root privileges with `sudo`.

### Install nginx with SSL Support

`# port install nginx +ssl`

### Make Your Certs Directory

`# mkdir -p /opt/local/etc/nginx/certs`
`$ cd /opt/local/etc/nginx/certs`

### Make Your Own Certificate

Follow the prompts but **MAKE SURE TO USE *.example.com AS YOUR Common Name!**
[http://pastie.org/234929](http://pastie.org/234929)
`# openssl req -new -x509 -nodes -days 365 -out server.crt -keyout server.key`

### Create an nginx Configuration File

Use [http://pastie.org/234927](http://pastie.org/234927) as an example.
Edit out my locations with yours. (i.e. Replace /Users/Andrew/Projects/macchiato with wherever your code lives.)
`# mate /opt/local/etc/nginx/nginx.conf`

### Fire Up nginx and Your Mongrel

`# /opt/local/sbin/nginx`
`$ script/server`

### Check Your DNS

`# mate /etc/hosts to make sure app.example.com points to localhost`

### Accept Your New Certificate

Open https://app.example.com/ in Safari. Select Show Certificate and accept it permanently.
In Firefox you will have to manually import your certificate.
Firefox => Preferences => Advanced => Encryption => View Certificates => Authorities => Import => /opt/local/etc/nginx/certs/server.crt => Make sure Trust this CA to identify web sites is checked => Ok.

### [ssl_requirement](http://github.com/rails/ssl_requirement/tree/master)

[ssl_requirement](http://github.com/rails/ssl_requirement/tree/master) is the de-facto standard Rails SSL plugin.
