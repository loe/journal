--- 
layout: post
title: ssh + pv + mysql
---
This is a good one courtesy of <a href="http://wuputah.com/">Jonathan Dance</a>.

`ssh -C gateway ssh -C database-server mysqldump -u root -pPASSWORD database | pv | mysql -u root database`

The `-C` flag does ssh compression.
