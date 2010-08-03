--- 
layout: post
title: SASL over TLS
---
So I'm an insomniac and a huge nerd... I just spent the majority of the night getting SASL to work with Postfix so I can Authenticate with my mail server over TLS (SSL is the old name for TLS). This enables anyone who uses my mail server to relay using their system account and password - the catch is you have to do it over TLS, or you'll get ingnored! This means that its just as safe as logging in via SSH or SFTP. Cool stuff IMHO. 

On to a global LDAP server for a master contacts list.
