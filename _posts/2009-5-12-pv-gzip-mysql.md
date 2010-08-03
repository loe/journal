--- 
layout: post
title: pv + gzip + mysql
---
I am writing this down for my own benefit:

Dumping with on-the-fly gzip and speed indicator.

`$ mysqldump -u root -p database | pv | gzip -c > database.sql.gz`

Loading with on-the-fly gunzip and speed indicator.

`$ pv database.sql.gz | gunzip | mysql -u root -p database`
